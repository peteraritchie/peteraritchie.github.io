---
layout: post
title: 'Announcing ConsoleApplicationBuilder, DI in console applications, simply'
categories: ['.NET', 'C#', 'ConsoleApplicationBuilder', 'Jan 2025']
comments: true
excerpt: A recent interaction reminded me that using things like IServiceCollection to get dependency injection or ConfigurationManager to use appsettings.json and IOptions<T> in a .NET console application is a lot of work, so I created ConsoleApplicationBuilder.
tags: ['.NET', 'C#', 'ConsoleApplicationBuilder']
---
![Configurable Console Application](../assets/announcing-ConsoleApplicationBuilder.png)

A recent interaction reminded me that using things like `IServiceCollection` to get dependency injection or `ConfigurationManager` to use appsettings.json and `IOptions<T>` in a .NET console application is a lot of work. You can use things like [console worker project][worker-template], but if you're implementing a simple console application, a background process seems over the top and unnatural.

I've added DI and configuration to console applications in the past, but it has always been troublesome and problematic. I had considered just documenting that process but thought the amount of work to simply create a NuGet package to do it for me seemed like it was about the same amount of work. A couple of weeks ago I started creating `ConsoleApplicationBuilder`&mdash;a type that implements similar functionality to `WebApplicationBuilder` and `HostApplicationBuilder` (that `WebApplicationBuilder` leverages). This post announces the result of that effort.

TL;DR: `ConsoleApplicationBuilder` and the associated `dotnet new` project template enable the use of DI in console applications simply and succinctly:

```csharp
class Program(ILogger<Program> logger)
{
    static void Main(string[] args)
    {
        var builder = ConsoleApplication.CreateBuilder(args);
        var program = builder.Build<Program>();
        program.Run();
    }

    private void Run()
    {
        logger.LogInformation("Hello, World!");
    }
}
```

`ConsoleApplicationBuilder` is open-source and available on [GitHub][ConsoleApplicationBuilder-repo]; you can find similar details there.

What prompted my latest foray into DI in a non-background console application was to inject a configured `HttpClient` into the application. `ConsoleApplicationBuilder` supports this easily and naturally:

```csharp
class Program(ILogger<Program> logger, HttpClient httpClient)
{
    static async Task Main(string[] args)
    {
        var builder = ConsoleApplication.CreateBuilder(args);
        builder.Services.AddHttpClient<Program>(httpClient =>
        {
            httpClient.BaseAddress = new Uri("https://jsonplaceholder.typicode.com");
        });
        var program = builder.Build<Program>();
        await program.Run();
    }

    private async Task Run()
    {
        logger.LogInformation("Hello, World!");
        logger.LogInformation(await httpClient.GetStringAsync("todos/3"));
    }
}

## `dotnet new` Project Template

The `dotnet new consoleapp` project template supports appsettings out of the box and is installed like other `dotnet new` project templates:

```powershell
dotnet new install PRI.ConsoleApplicationBuilder.Templates
```

And to create a new console application that supports DI, Configuration, appsettings, etc., is as simple as:

```powershell
dotnet new consoleapp -o Peter.ConsoleApp
```

## `ConsoleApplicationBuilder` Without `dotnet new consoleapp` Project Template

When I implemented the `dotnet new consoleapp` project template, I wanted to make the created `Program` class as simple as possible, so I chose to re-use the Program class and build an instance of that class to inject services like `ILogger<Program>`. However, you don't need to use the template to use `ConsoleApplicationBuilder`, and you don't need to re-use `Program` as the type that it will build. You can add a reference to the `PRI.ConsoleApplicationBuilder` NuGet package and build a different type. For example:

```csharp
class Program
{
    static async Task Main(string[] args)
    {
        var builder = ConsoleApplication.CreateBuilder(args);
        builder.Services.AddHttpClient<ToDoAdapter>(httpClient =>
        {
	        httpClient.BaseAddress = new Uri("https://jsonplaceholder.typicode.com");
        });
        var adapter = builder.Build<ToDoAdapter>();
		var todoText = await adapter.GetToDo(1);
	}
}

internal sealed class ToDoAdapter(ILogger<ToDoAdapter> logger, HttpClient httpClient)
{
	public async Task<string> GetToDo(int id)
	{
		if(logger.IsEnabled(LogLevel.Information))
		{
			logger.LogInformation("Getting todo with id {Id}", id);
		}
		var response = await httpClient.GetAsync($"todos/{id}");
		response.EnsureSuccessStatusCode();
		string responseText = await response.Content.ReadAsStringAsync();
		if (logger.IsEnabled(LogLevel.Information))
		{
			logger.LogInformation("Got response {ResponseText}", responseText);
		}
		return responseText;
	}
}
```

Here, instead of building a `Program` instance, we're building a `ToDoAdapter` instance that is injected with a configured logger and an specific HTTP client. Be sure to also add a reference to `Microsoft.Extensions.Http` if you want to use that code. 

So, as you can see, `ConsoleApplicationBuilder` is very flexible.

## Feedback

I'd love to hear your feedback, good or bad. I've modeled `ConsoleApplicationBuilder` as closely as possible to `WebApplicationBuilder` and `HostApplicationBuilder` so it follows their conventions, and usage should feel natural. But I'm open to suggestions on how to improve it. You can log questions and issues on [GitHub][issues].

[worker-template]: https://learn.microsoft.com/en-us/dotnet/core/extensions/workers
[ConsoleApplicationBuilder-repo]: https://github.com/peteraritchie/ConsoleApplicationBuilder
[issues]: https://github.com/peteraritchie/ConsoleApplicationBuilder/issues