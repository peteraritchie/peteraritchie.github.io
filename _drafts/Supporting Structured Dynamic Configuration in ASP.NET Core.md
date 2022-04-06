---
layout: post
title: 'Supporting Structured Dynamic Configuration in ASP.NET Core appsettings'
categories: ['.NET', 'ASP.NET', '.NET Core', 'ASP.NET Core', 'Guidance', 'Visual Studio']
comments: true
excerpt: ""
---
# Supporting Dynamic Configuration with Binding in ASP.NET Core appsettings

## Configuration in ASP.NET Core, a Brief Retrospection
Let's look at a couple of isolated examples of ASP.NET Core configuration, options, and appsettings to set a scope:

ASP.NET Core is very flexible and powerful with regard to configuration and options.  One of the features is the ability to bind configuration (textual information) to a concrete type and support strongly-typed configuration.  For example, with the following appsettings:
```JSON
{
  "option1": "value1_from_json",
  "option2": -1,
}
```
A class can be created to structurally contain that data:
```csharp
public class MyOptions
{
	public string Option1 { get; set; }
	public int Option2 { get; set; } = 5;
}
```
And in your startup, you can either directly bind the data to an instance of the class:
```csharp
var myOptions = new MyOptions();
Configuration.Bind(myOptions);
```
or indirectly bind the data via the *Options Pattern*:
```csharp
services.Configure<MyOptions>(Configuration);
```
...to be injected into other services that have a constructor parameter of type `IOptions<MyOptions>`:
```csharp
	public ValuesController(IOptions<MyOptions> myOptions)
	{
		//...
	}
```

## What is *Dynamic Configuration*?
Dynamic configuration is really about how the configuration data is handled.  The structure of the configuration is the same, but with a looser "schema".

Given the following JSON:
```json
{
  "ConnectionStrings":
  {
    "BloggingDatabase": "Server=(localdb)\\mssqllocaldb;Database=EFGetStarted.ConsoleApp.NewDb;Trusted_Connection=True;"
  }
}
```
...and much like above, you *can* bind it to classes like this:
```csharp
public class ConnectionStrings
{
	public string BloggingDatabase {get;set;}
}

public class MyConfiguration
{
	public ConnectionStrings ConnectionStrings {get;set;}
}
```
With familiar but specific binding code like this:
```csharp
var myConfiguration = new MyConfiguration();
Configuration.Bind(myConfiguration)
```
or:
```csharp
services.Configure<MyConfiguration>(Configuration);
// ...and use the type IOptions<MyConfiguration> in constructor
// parameters for the options to be injected.
```
For that `Bind` or `Configure` (which does the `Bind` for you) to work, the `ConnectionStrngs` class requires the `BloggingDatabase` property so it can match the name in the config.

The "dynamic" part is when you want to support user-supplied key names and/or variable quantities of key/value pairs. If a user added another connection string, we'd be unable to support it without a redeployment, for example another connection string in the config:
```json
{
  "ConnectionStrings":
  {
    "BloggingDatabase": "Server=(localdb)\\mssqllocaldb;Database=EFGetStarted.ConsoleApp.NewDb;Trusted_Connection=True;",
    "AuditingDatabase": "Server=(localdb)\\mssqllocaldb;Database=EFGetStarted.ConsoleApp.AuditDb;Trusted_Connection=True;"
  }
}
```

We'd have to update our ConnectionStrings class to support the new connection string value.  You can imagine that connection strings are unique to each app, so there's no way to create one class to handle every scenario.

But, in the end, ASP.NET Core configuration/options are really just a set of key/value pairs, you **can support user-supplied names like this using a dictionary**.  For example:
```csharp
public class MyConfiguration
{
	public Dictionary<string, string> ConnectionStrings {get;set;}
}
```

And rather than `myConfiguration.ConnectionStrings.BloggingDatabase` to access the value, it would be `myConfiguration.ConnectionStrings["BloggingDatabase"]`.

Binding would be the same:
```csharp
var myConfiguration = new MyConfiguration();
Configuration.Bind(myConfiguration)
```
or:
```csharp
services.Configure<MyConfiguration>(Configuration);
```
This technique also supports the ability to more easily reference keys as values of other configuration keys.  Let's say that I want to have my connection strings in one place and configure other things to use those connection string (e.g. shared).  You might consider a JSON config that looks like this:
```json
{
  "ConnectionStrings": {
    "BloggingDatabase": "Server=(localdb)\\mssqllocaldb;Database=EFGetStarted.ConsoleApp.NewDb;Trusted_Connection=True;",
    "AuditingDatabase": "Server=(localdb)\\mssqllocaldb;Database=EFGetStarted.ConsoleApp.AuditDb;Trusted_Connection=True;"
  },
  "Repositories": {
    "BlogEntryController" : {
      "Type": "Infrastructure.Persistence.SqlServer.SqlServerRepository, aipss, Version=1.7.1.0, Culture=neutral, PublicKeyToken=80e841a370b13835",
      "Argument": "BloggingDatabase"
    },
    "BlogEntryControllerAudit" : {
      "Type": "Infrastructure.Persistence.SqlServer.SqlServerRepository, aipss, Version=1.7.1.0, Culture=neutral, PublicKeyToken=80e841a370b13835",
      "Argument": "AuditDatabase"
    },
    "AdminControllerAudit" : {
      "Type": "Infrastructure.Persistence.SqlServer.SqlServerRepository, aipss, Version=1.7.1.0, Culture=neutral, PublicKeyToken=80e841a370b13835",
      "Argument": "AuditDatabase"
    }
  }
}
```

# References
- [MSDN Magazine - Essential .NET - Configuration in .NET Core](https://msdn.microsoft.com/en-us/magazine/mt632279.aspx)
- [Microsoft Docs - Options pattern in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/options?view=aspnetcore-2.1)

