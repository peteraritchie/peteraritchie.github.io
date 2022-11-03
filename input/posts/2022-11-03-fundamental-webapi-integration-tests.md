---
layout: post
title: 'Fundamental ASP.Net Minimal API Integration Tests'
categories: ['C#', 'ASP.NET 6', 'Minimal APIs', 'Integration Testing']
comments: true
excerpt: "ASP.NET integration tests are a common way of verifying the pipeline and how it is used. We can create integration tests that process the OpenAPI spec and verify operations are working as expected in various ways."
tags: ['November 2022']
---
![Robotic computing testing](/assets/robotic%20computing%20testing.png)

I've been involved with some fairly large projects that involved RESTful APIs. When dealing with multiple team members, multiple teams, and OpenAPI specs, there can be many risks. Even when an OpenAPI specification is generated from source code, what the code does can easily be unaligned with the spec. Luckily the spec is a machine-readable contract of the _intent and purpose_ of the API.

Automated testing to the rescue! With ASP.NET, you can inject into and observe the middleware pipeline. ASP.NET integration tests are a common way of verifying the pipeline and how it is used. We can create integration tests that process the OpenAPI spec and verify operations are working as expected in various ways. This article dives into a couple of these ways.

## Fundamental API Integration Tests

With a functioning Web API and an OpenAPI specification that describes it there are some fundamental things we can verify:

- The generated OpenAPI document is valid
- The paths have endpoints implemented
- The operations respond with the correct type of response

First, let's set up our solution, projects, and integration testing scaffolding.

## Setting Up the Solution and Projects

We're dealing with a Web API and integration tests, so let's create a Web API project and make the `Program` class `public`. You can do that manually in Visual Studio; but for consistency, the CLI is powerful (I'm being intentional with framework versions and some configuration options--appending `public partial class Program { }` to Program.cs to make the class public):

```PowerShell
dotnet new solution
dotnet new webapi -o WebApi --use-minimal-apis true --framework net6.0 --use-program-main false
echo public partial class Program { } >> WebApi\Program.cs
dotnet sln add WebApi\WebApi.csproj
```

Next, we want to add a test project. xUnit is my go-to, so we'll use that and add a reference to the Web API project. Again, in the CLI:

```PowerShell
dotnet new xunit -o IntegrationTests --framework net6.0
del IntegrationTests\UnitTest1.cs
dotnet add IntegrationTests\IntegrationTests.csproj reference WebApi\WebApi.csproj
dotnet sln add IntegrationTests\IntegrationTests.csproj
```

For ASP.Net integration tests, we will use `WebApplicationFactory<T>`, which requires a reference to `Microsoft.AspNetCore.Mvc.Testing`. In addition, to process OpenAPI documents, we'll need the `Microsoft.OpenApi.Readers` package. Again, via the CLI:

```PowerShell
dotnet add IntegrationTests\IntegrationTests.csproj package Microsoft.OpenApi.Readers
dotnet add IntegrationTests\IntegrationTests.csproj package Microsoft.AspNetCore.Mvc.Testing
``` 

## Integration Test Scaffolding

I got into some of the scaffolding of ASP.NET 6 integration tests in [Setting Up the Solution and Projects](#setting-up-the-solution-and-projects) concerning the required package references. the `Microsoft.AspNetCore.Mvc.Testing` package is required so that we may use the [`WebApplicationFactory<TEntryPoint>`](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.mvc.testing.webapplicationfactory-1?view=aspnetcore-6.0) class--which allows us to bootstrap a web application in memory, specifically for testing.

We'll use `WebApplicationFactory` to create an instance of an `HttpClient` test fake that works with our in-memory host. In addition, we'll override `WebApplicationFactory` to get at some of the Swashbuckle details from the pipeline. We're interested in the generated OpenAPI document for processing and the name of that document to generate the OpenAPI specification URI for verification. Here's an example of a `WebApplicationFactory` implementation that does what we need:

```csharp
public class MyWebApplicationFactory : WebApplicationFactory<Program>
{
	public OpenApiDocument? OpenApiDocument { get; private set; }
	public string OpenApiDocumentName { get; private set; } = string.Empty;

	protected override IHost CreateHost(IHostBuilder builder)
	{
		var host = base.CreateHost(builder);
		using var scope = host.Services.CreateScope();
		var sp = scope.ServiceProvider;
		var swaggerGeneratorOptions = sp.GetRequiredService<IOptions<SwaggerGeneratorOptions>>().Value;
		OpenApiDocumentName = swaggerGeneratorOptions.SwaggerDocs.First().Key ?? string.Empty;
		var swaggerProvider = sp.GetRequiredService<ISwaggerProvider>();
		OpenApiDocument = swaggerProvider.GetSwagger(OpenApiDocumentName);

		return host;
	}
}
```

The important parts are the `OpenApiDocument` and `OpenApiDocumentName` properties.

Now that we've got integration testing scaffolded let's create a test base class to make creating multiple integration tests clean and tidy.

## Some Test Conventions

Automated testing classes and methods offer an opportunity to isolate and categorize tests to reduce work and clarify what is being tested (more importantly, what isn't passing). I tend towards a given/when/then structure when designing tests. The test class encapsulates the given/when (as well as the _arrange_ from arrange/act/assert) whose name is suffixed with "Should." Each test method in the class is then given a name that describes the _then_ condition. I try to ensure that there is one condition and thus one assert per method. YMMV.

For the tests I want to describe in this article, I've created a base class to encapsulate related given/when scenarios (or _shoulds_) that require the details we're accessing with the `WebApplicationFactory<Program>` implementation. Naming is hard, so I'm starting simple with a `WebApiShouldBase` class that encapsulates the parts we're getting with `MyWebApplicationFactory` and an ability to get a stream to the "live" OpenAPI spec document (JSON). It also deals with the responsibility of owning those things (e.g., disposal):

```csharp
public class WebApiShouldBase : IDisposable
{
	private readonly string openApiSpecUriText;

	protected readonly HttpClient WebApiClient;
	protected OpenApiDocument? OpenApiDocument { get; }
	protected Task<Stream> GetOpenApiDocumentStreamAsync() => WebApiClient.GetStreamAsync(openApiSpecUriText);

	protected WebApiShouldBase()
	{
		var factory = new MyWebApplicationFactory();
		WebApiClient = factory.CreateClient();
		OpenApiDocument = factory.OpenApiDocument;
		this.openApiSpecUriText = $"/swagger/{factory.OpenApiDocumentName}/swagger.json";
	}

	protected virtual void Dispose(bool isDisposing)
	{
		if (isDisposing)
		{
			Dispose();
		}
	}

	public void Dispose() => WebApiClient.Dispose();

}
```

The important parts are the `OpenApiDocument` property which re-surfaces the `MyWebApplicationFactory.OpenApiDocument` to implementors, the `WebApiClient` property to access the API, and the `GetOpenApiDocumentStreamAsync` method that holds the OpenAPI spec document that the API provides. This class hides things like the URI to the swagger.json, the use of `MyWebApplicationFactory`, disposal, etc.

With that, let's start doing some tests!

## Verifying The Generated OpenAPI Is Valid

"Valid" is subjective with OpenAPI. An OpenAPI spec is very _forgiving_ in allowing for many opinions on what a _good_ API looks like. I'm not going to go deep on what _good_ might mean; just dive into facilitating validation of that generated document. The fact that there is an OpenApiDocument instance, and a raw OpenAPI specification, is an implementation detail. We'll use that OpenApiDocument instance shortly, but I want to ensure that the raw document meets some minimum requirements. For this example, the OpenAPI document is processed, not errors we detected, and there _are_ paths. Very simple:

```csharp
	[Fact]
	public async Task ProduceValidOpenApi()
	{
		var readerResult = await new OpenApiStreamReader()
			.ReadAsync(await GetOpenApiDocumentStreamAsync().ConfigureAwait(false)).ConfigureAwait(false);
		Assert.NotNull(OpenApiDocument);
		Assert.NotEmpty(readerResult.OpenApiDocument.Paths);
		Assert.Empty(readerResult.OpenApiDiagnostic.Errors);
	}
```

Client requirements can be less strict than development requirements (development objectives), and there may be different subsets of requirements in the case of multiple clients. This example doesn't implement that specifically but does provide the means to do it (by adding distinct test methods.)

OpenAPI.Net has can do very complex verification and validation, but I expect that sort of testing to be performed at a different level--I want to make sure client-oriented tests are handled here.

## Verifying The Paths Have Endpoints Implemented

Publishing an API with paths and operations, and hosting an API that hasn't implemented those operations is silly. So the next test verifies they are implemented (at least the GET operations) as specified:

```csharp
	[Fact]
	public async Task EndpointsRespondOkToGet()
	{
		Assert.NotNull(OpenApiDocument);
		var pathsWithGetOperations = OpenApiDocument.Paths.Where(w => w.Value.Operations.ContainsKey(OperationType.Get));

		foreach (var (requestUriText, _) in pathsWithGetOperations)
		{
			var response = await WebApiClient.GetAsync(requestUriText).ConfigureAwait(false);
			Assert.True(response.IsSuccessStatusCode);
		}
	}
```

GET operations are _easy_; they shouldn't have a request body and almost always have a success response specified. In the future, I can dive into other types of operations like POST, how to extract samples from the OpenAPI specification, and how to verify operations with request data and or error responses.

## Verifying The Operations Respond With The Correct Type Of Response

HTTP, and thus OpenAPI, don't enforce that any operation responds with anything in particular. But, if you're reading _this_ blog, you are probably of the opinion that given the opportunity to specify behavior, you should be at least as detailed in specifying the type and schema of the responses.  I'll leave out validating response schema in this article, but I will show verifying that each request responds with the correct media type. For example:

```csharp
	[Fact]
	public async Task EndpointsRespondWithCorrectMediaTypeToGet()
	{
		Assert.NotNull(OpenApiDocument);
		var pathsWithGetOperations = OpenApiDocument.Paths.Where(w => w.Value.Operations.ContainsKey(OperationType.Get));

		foreach (var (requestUriText, pathItem) in pathsWithGetOperations)
		{
			var responseContentType = pathItem.Operations[OperationType.Get]
				.Responses[OkResponseCodeText]
				.Content
				.Single().Key;

			var request = new HttpRequestMessage
			{
				Method = HttpMethod.Get,
				RequestUri = new Uri(requestUriText, UriKind.Relative),
				Headers =
				{
					{
						HttpRequestHeader.Accept.ToString(),
						responseContentType
					}
				}
			};
			var response = await WebApiClient.SendAsync(request).ConfigureAwait(false);
			Assert.True(response.Content.Headers.ContentType?.MediaType ==
			            responseContentType);
		}
	}
```

## Caveats

Of course, you can have or create an OpenAPI that does little more than document an endpoint and ignore that there are operations and those operations do specific things.

This article is an overview. I recognize that Swashbuckle and ~~Swagger~~OpenAPI support in ASP.NET is powerful, but this article doesn't take into account many things you can do with it (like multiple OpenAPI documents.)

I also recognize that operations that take no parameters are rare, but I trust that my readers are good with taking on that as an exercise. Or, at least let me know if that's detail I should post in the future.

## Summary

This article provides a very high-level overview of integration testing ASP.NET minimal APIs. We then got into some details of general Web API integration tests that focus on OpenAPI specification aspects of the Web API middleware.

What sort of automated testing of an API specification do you see as beneficial to your projects?

## References

- [Integration tests in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-6.0)
- [`WebApplicationFactory<TEntryPoint>`](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.mvc.testing.webapplicationfactory-1?view=aspnetcore-6.0)

The source for the examples, including the creation scripts can be found at <https://github.com/peteraritchie/fundamental-webapi-integration-testing>
