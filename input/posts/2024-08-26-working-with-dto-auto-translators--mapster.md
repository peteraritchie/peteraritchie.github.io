---
layout: post
title: 'Working With DTO Auto Translators -- Mapster'
categories: ['.NET', 'C#', 'DTOs', 'Mapping/Translation']
comments: true
excerpt: 
tags: ['Aug 2024', '.NET', 'C#', 'Mapster', 'Mapping', 'Translation']
---

<!-- Mapping/Translation series intro boilerplate -->
Modern software applications heavily rely on external services, making data transfer a crucial aspect of application functionality. Invariably, data transfer involves translating an internal representation of information to data compatible with a particular communication channel. High-level programming languages empower programmers to model abstractions in high-level types independent of lower-level implementation details. This internal representation of data is sometimes called _abstract syntax_, which is purposely devoid of the specifics (_concrete syntax_) required by the channel and, or the receiver. Translation from one syntax to another must first map source data elements to target data elements. That mapping includes the necessary conversion method.

<!-- Data Transfer Object boilerplate pull quote/box copy -->
|Data Transfer Objects|
|---|
|Defining concrete syntax in high-level languages is so essential that a design pattern is devoted to it. The Data Transfer Object<sup>\[[ppoe]\]</sup> design pattern describes declaring high-level types to describe aspects of concrete syntax.|

This installment details the mapping and translation of Data Transfer Objects with a package named [Mapster][mapster-git] ([`Mapster.DependencyInjection`][mapster-nuget]).

## Translation

Mapster makes translation available in several ways. Because this post details a solution with dependency injection, I'll be focusing on injecting an `IMapper` (`MapsterMapper.IMapper`) object where translation is required rather than the generated `TDestination Adapt<TSource, TDestination>(this TSource source)` methods.

|Opinion|
|---|
|I don't like thinking of this type of translation as an adaptation (i.e., as an Adapter Pattern implementation) because this isn't adapting one interface to another; it's raw data translation. As "`Adapt`" alludes to mapping and translation being two different actions, I don't like the method that performs translation being named "`Map`." But [Naming is Hard][naming-things].|

Mapster generates classes with `Adapt` methods at compile-time, so they're as fast as coding them by hand. The above method of invoking `Adapt` doesn't generate code you can browse to in the IDE, but it's still pre-generated.

Given a domain object of `Account` and a Data Transfer Object `AccountDto`:

```csharp
public class Account(Guid id, DateOnly creationDate, string name)
{
	public Guid Id { get; } = id;
	public string Name { get; private set; } = name;
	public DateOnly CreationDate { get; } = creationDate;

	public void ChangeName(string name)
	{
		Name = name;
	}
}
```
```csharp
public class AccountDto
{
	public Guid Id { get; set; }
	public string Name { get; set; }
	public DateOnly CreationDate { get; set; }
}
```

Mapster generates code to translate to/from `Account`/`AccountDto` so that you just need to inject an `IMapper` and invoke the `IMapper.Map<TSource, TDestination>` method. `AddMapster(this IServiceCollection serviceCollection)` is used to add `IMapper` to services.

## Mapping by Convention

The raison d'etre of mapping/translation frameworks is to make translating one data type to another as simple as possible. A key feature of these frameworks is to map by convention, which automatically maps fields or properties based on criteria like name and data type. Mapster does an excellent job of mapping by convention. In the above example, you don't have to tell Mapster anything. It knows that `Account.Id` maps to `AccountDto.Id`, and `Account.Name` maps to `AccountDto.Name`, and `Account.CreationDate` maps to `AccountDto.CreationDate` because the properties have the same name and type.

Explicit mapping isn't necessary. Simply injecting an `IMapper` instance and invoking `IMapper.Map<TSource, TDestination>` is enough to map th two type's properties by convention

```csharp
public class CreateAccountCommandHandler(IMapper mapper, INotificationService notificationService)
	: IRequestHandler<CreateAccountCommand>
{
	private readonly IMapper mapper = mapper;

	public async Task Handle(CreateAccountCommand request, CancellationToken cancellationToken)
	{
		Guid accountId = Guid.NewGuid();
		Account account = CreateAccount(accountId);

		var dto = mapper.Map<Account, AccountDto>(account);

		await notificationService.PublishAsync(new AccountCreated(dto), cancellationToken);
	}
    // ...
}
```

## Custom Mapping
When we start (greenfield) development, our DTOs are usually closely aligned with our domain objects, so by-convention mapping is our friend. However, an important reason for having two abstractions is that they can evolve independently. Eventually, as we gain a better understanding of the domain or clients of the communication channel, we will need to make changes that cause our DTO and Domain Objects to diverge. We can manage that divergence by extending the by-convention mapping to include custom mapping. Mapster supports this through what it calls registers or via `Register` methods. Mapster can be told to scan for Register methods and perform custom mapping automatically.

For example, we've gained a better understanding of the domain, and an Account doesn't necessarily have a "name" but has an associated account holder with a given and family name. That understanding may make its way into the domain like this:

```csharp
public class Account(Guid id, DateOnly creationDate, string accountHolderGivenName, string accountHolderFamilyName)
{
	public Guid Id { get; } = id;
	public string AccountHolderGivenName { get; private set; } = accountHolderGivenName;
	public string AccountHolderFamilyName { get; private set; } = accountHolderFamilyName;
	public DateOnly CreationDate { get; } = creationDate;

	public void ChangeName(string accountHolderGivenName, string accountHolderFamilyName)
	{
		AccountHolderGivenName = accountHolderGivenName;
		AccountHolderFamilyName = accountHolderFamilyName;
	}
}
```

Receivers of our `AccountDto` might be unable to accommodate that change immediately, so we may deal with that by mapping properties differently. Instead of including FamilyName and GivenName in AccountDto, we may concatenate the given and family name and assign it to `AccountDto.Name`. (A Strategy Pattern implementation that deals with whether a given name appears before a family name for a particular culture/customer is a topic for another time.)

```csharp
public class MappingRegister : IRegister
{
	public void Register(TypeAdapterConfig config)
	{
		config.NewConfig<Account, AccountDto>()
			.Map(dest => dest.Name, src=> $"{src.AccountHolderGivenName} {src.AccountHolderFamilyName}");
	}
}
```

During startup/service configuration, Mapster can be to told to scan for implementations of `IRegister`:

```csharp
	TypeAdapterConfig.GlobalSettings.Scan(Assembly.GetExecutingAssembly());
```

## Where Does Mapping and Translation Occur?
****
Data transfer can occur in different layers. Data transfer triggers a website or API (presentation layer); the application layer requests external services via an infrastructure layer to transfer data to and from. I'm often asked where that mapping and translation source code should exist and in which project in the solution. It's important to remember that we're dealing with multiple layers. While a presentation layer is the most common layer for initialization (DI container configuration), the translation method must be visible in the layer where the data transfer occurs.

Translation of web/API models can exist in the presentation layer because that's where _that_ data transfer occurs. However, invoking a service from the application layer can mean the translation method can't live in the presentation layer because the application layer cannot take a direct dependency on the presentation layer (it is the other way around.)

When a build boundary separates a layer (e.g., separate projects and or binaries), both assemblies can't be dependent on each other&mdash;the initialization/DI can't both access the types in the different assembly **and** be referenced by the other assembly to invoke `Map`/`Adapt`. So, the mapping configuration that accesses the source and target types involved in the translation must exist in the assembly referenced by the initialization/DI. This is typically done by creating the familiar [`Add{GROUP_NAME}` extension method pattern][register-service-groups] for example, given an application layer implemented in a separate project, an extension method (sometimes in the `Microsoft.Extensions.Hosting` namespace, [but not recommended](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection-usage#:~:text=don't%20place%20extension%20methods%20in%20the%20microsoft.extensions.dependencyinjection%20namespace%20unless%20you're%20authoring%20an%20official%20microsoft%20package.)) 

```csharp
public static class ApplicationExtensions
{
	public static IServiceCollection AddApplicationServices(this IServiceCollection services)
	{
		ArgumentNullException.ThrowIfNull(services);
		TypeAdapterConfig.GlobalSettings.Scan(typeof(ApplicationExtensions).Assembly);

		services.AddMapster();
		return services;
	}
}
```

## References
- [Mapster - Custom Mapping][mapster-custom-mapping]
- [Mapster repo][mapster-git]
- [Mapster Nuget][mapster-nuget]

[dto]: https://martinfowler.com/eaaCatalog/dataTransferObject.html
[ppoe]: https://amzn.to/3SR8c73
[mapster-git]: https://github.com/MapsterMapper/Mapster
[mapster-nuget]: https://www.nuget.org/packages/Mapster.DependencyInjection
[mapster-custom-mapping]: https://github.com/MapsterMapper/Mapster/wiki/Custom-mapping
[register-service-groups]: https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection#register-groups-of-services-with-extension-methods
[naming-things]: https://bit.ly/naming-things-repo