---
layout: post
title: 
date: 
categories: ['.NET', 'ASP.NET', '.NET Core', 'ASP.NET Core', 'Guidance', 'Visual Studio']
comments: true
excerpt: ""
---
#  <span title="One of my pet peeves">~~Best~~Recommended</span> Practices
### Compartmentalization: Sections Are Your Friends
### Configuration Isn't Just `appsettings`
### Remember Configuration Source Default Precedence
[//]: # (https://blogs.msdn.microsoft.com/premier_developer/2018/04/15/order-of-precedence-when-configuring-asp-net-core/)
Using the ASP.NET Core `WebHostBuilder`
1. **appsettings.json**
1. **appsettings.*env*.json**
1. **[<span title="Developer">User</span> Secrets]**
1. **Environment Variables**
1. **Command Line**
In reality, the order of precedence mirrors the order the providers are added to the configuration builer.  The above is really just how `WebHostBuilder` implements them.
### Overriding Settings
Configuration supports a variety of providers.  Some inherently support structured, complex data; some don't.  JSON is the quintessential example for ASP.NET:
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "System": "Information",
      "Microsoft": "Information"
    }
```
And command-line arguments are the quintessential example of *unstructured*:

`MyApplication --Verbosity true`

But, configuration providers translate whatever structure they support into the flat structure that ASP.NET Core configuration supports.  To do that, providers simply use a colon `:` as hierarchy level separators.  So, the `Default` key name from the above JSON has a fully-qualified configuration key name of `Logging:LogLevel:Default`.  Which means you can override what is in appsettings via the command line:
`MyApplication --Logging:LogLevel:Default Error`

And to override appsettings values with environment variable values, use a double underscore `__` instead of a colon hiearchy level delimiter:

`SET Logging__LogLevel__Default=Error`

# References
- [MSDN Magazine - Essential .NET - Configuration in .NET Core](https://msdn.microsoft.com/en-us/magazine/mt632279.aspx)
- [Microsoft Docs - Options pattern in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/options?view=aspnetcore-2.1)

