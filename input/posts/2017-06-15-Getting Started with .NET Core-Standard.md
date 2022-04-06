---
layout: post
title: 'Getting Started with .NET Core/Standard'
categories: ['Intro', '.NET Core', '.NET Standard']
comments: true
excerpt: "Some useful tidbits to migrating to .NET Core/Standard from the trenches"
---
With Visual Studio 2017 recently being released, I felt it was time to start looking into converting some of the OSS projects I work on to Core/Standard.  I think Core/Standard won't be mainstream until .NET Core 2.0; but we're already looking at a .NET Core 2.0 Preview 1; so it's not too far off.

I think it's important to start looking into moving foundational libraries early to avoid friction getting code onto the latest platform/framework when you actually need to.  Fortunately .NET Core and Standard make it possible to release libraries in .NET Code/Standard without affecting existing client code (for the most part).  I thought I'd detail some of the things I've run into and some guidance to hopefully get you going faster.

### tl;dr
.NET Core and .NET Standard are the next major advancements ("versions"?) in .NET.  It's like .NET going from .NET 3.5. to .NET 4.0 (which was an upgrade to the CLR rather than an in-place update).  .NET Core is effectively the next edition of the runtime which supports more platforms (Windows, OSX, Linux, without a 3rd party technology like Mono) and .NET Standard is really the next level for .NET Portability (replacement/improvement of PCL).  In order support a broad range of portability, you need to be writing .NET Standard libraries.  To support portable apps, you need to be writing .NET Core applications (that use .NET Standard or .NET Core class libraries).

### What *Version* of .NET Standard should I use?
I wouldn't be an architect if I didn't respond with "it depends".  Luckily [docs.microsoft.com] does a fine job of explaining things with the lifted table:

>| .NET Standard                             | [1.0] | [1.1]  | [1.2] | [1.3] | [1.4] | [1.5]  | [1.6]  | [2.0] |
>|-------------------------------------------|-------|--------|-------|-------|-------|--------|--------|-------|
>| .NET Core                                 | 1.0   | 1.0    | 1.0   | 1.0   | 1.0   | 1.0    | 1.0    | 2.0   |
>| .NET Framework (with tooling 1.0)         | 4.5   | 4.5    | 4.5.1 | 4.6   | 4.6.1 | 4.6.2  |        |       |
>| .NET Framework (with tooling 2.0 preview) | 4.5   | 4.5    | 4.5.1 | 4.6   | 4.6.1 | 4.6.1  | 4.6.1  | 4.6.1 |
>| Mono                                      | 4.6   | 4.6    | 4.6   | 4.6   | 4.6   | 4.6    | 4.6    | vNext |
>| Xamarin.iOS                               | 10.0  | 10.0   | 10.0  | 10.0  | 10.0  | 10.0   | 10.0   | vNext |
>| Xamarin.Android                           | 7.0   | 7.0    | 7.0   | 7.0   | 7.0   | 7.0    | 7.0    | vNext |
>| Universal Windows Platform                | 10.0  | 10.0   | 10.0  | 10.0  | 10.0  | vNext  | vNext  | vNext |
>| Windows                                   | 8.0   | 8.0    | 8.1   |       |       |        |        |       |
>| Windows Phone                             | 8.1   | 8.1    | 8.1   |       |       |        |        |       |
>| Windows Phone Silverlight                 | 8.0   |        |       |       |       |        |        |       |
>
>- The columns represent .NET Standard versions. Each header cell is a link to a document that shows which APIs got added in that version of .NET Standard.
>- The rows represent the different .NET platforms.
>- The version number in each cell indicates the *minimum* version of the platform you'll need to implement that .NET Standard version.

But, see [A Note on Composability](#a-note-on-composability) for some guidance on decomposing your types by the minimal footprint they need as well as functional context (i.e. keeping libraries cohesive).
### Notable Areas of Change
#### Type&#x2192;TypeInfo
Within `System.Reflection` there exists several classes to get meta-information about various identifiers in .NET (like `MethodInfo`, `EventInfo`, `FieldInfo`, `PropertyInfo`, `ConstructorInfo`, and `ParameterInfo`).  The type of information these classes provide (like attributes, names, assembly, access modifiers, etc.), when pertaining to types, have historically been found on `System.Type` (which derives from `Reflection.MemberInfo`, oddly enough). With .NET Core that is technically corrected for a subset of the platforms by moving the reflection-like members into a new `Reflection.TypeInfo` class that is available in all version of .NET Standard and thus available in .NET 4.5 and above.  `Type` is still available in all versions of .NET Standard, but the reflection-like members are generally available only in .NET Standard 2.0 (which means .NET Framework and .NET Core 2.0).  I believe there are extension methods to provide that reflection-type functionality off of `Type`, but I generally recommend just biting the bullet and use `TypeInfo` directly, it's our new overlord (and quite frankly, more sensible).
#### Configuration
.NET has typically been associated with XML configuration when it comes to configuration.  As handy as that may have been, it was a narrow view of how configuration information can be stored and accessed by an application.  While configuration can certainly be stored in *app.config*, other configuration information may be provided via the command line, by environment variables, by INI files, etc.  Not to mention, what if you didn't want XML, but JSON config?  And I won't get into what you had to do if you wanted structured information in app.config.

With .NET Core, all that changes.  Configuration is handled with the *Microsoft.Extensions.Configuration* Nuget package.  This basically provides the `IConfiguration`, `IConfigurationRoot`, and `IConfigurationBuilder` interfaces along with a `ConfigurationBuilder` implementation that can be extended to support various providers like `InMemoryConfigurationProvider`, `JsonFileConfigurationProvider`, `EnvironmentVariableConfigurationProvider, CommandLineConfigurationProvider`, `XmlConfigurationProvider`, and `IniConfigurationProvider`; that allow you to build up a single application configuration from various, prioritized, sources.  Your code simply needs to compose the configuration (usually in a *composition root*) and depend on the `IConfiguration` interface.  `IConfiguration` basically provides dictionary-like access (key/value) to configuration information, but provides convention-based mapping to classes to provide structured configuration data (no more writing `ConfigurationSection` implementations and the corresponding `configSection` element--although .NET Standard brings support for *old style* configuration sections).

Configuration change notification and reloading is also supported.  But, saving updated values is not implemented out of the box (is anyone surprised?); but custom providers can be written to support persistence.

I recommend reading Mark Michaelis' *Essential .NET* column [Configuration in .NET Core] for a deeper dive.
#### Remoting/Serialization/Workflow/Serial Ports/Win Forms
.NET Core also admits that .NET Remoting worked as well as the *[First Rule of Distributed Object Design]* suggested.  Which means technologies that depend on, or designed to support, .NET Remoting are collateral damage: AppDomains, sandboxing, and binary serialization.  I have to admit that I tried several times to get sandboxing to work and it was either too hard get to work or too hard to keep working as types changed and other people made changes.  You might be thinking *but why binary serialization!?*  Unfortunately binary serialization is designed around supporting .NET Remoting, and as such opens some [security holes] and is deprecated in favor of other "binary" serialization options like [protobuf] (or just use JSON or XML serialization).

Also support for Serial Ports hasn't been migrated.  WinForms is obviously Windows-specific and hasn't has the same level of attention in .NET Core.  But, UI hasn't been the focus for .NET Core. WinForms is probably the least portable framework; but conceivably Universal Windows Platform (UWP) support could make its way into .NET Core in the future.  At this time, I'd recommend .NET Standard or Core for code that is loosely coupled and can be composed into multiple applictions via libraries (and thus multiple platforms).

#### Web API/WCF
I think the remoting issues, support for named pipes, etc. lead to not much priority for WCF in .NET Core.  Recently there has been a bit of work to support it on .NET Core, but only as much as it is supported in Windows Store apps.  With adoption for RESTful APIs and deprecation of .NET Remoting, many parts of WCF fall to the wayside too.  The adoption of RESTful APIs has lead to less support for Web APIs in favor of using ASP.NET MVC and RESTful APIs.  There are *compatibility* shims to help you port code over; but let's face facts: it's deprecated in favor of MVC (RESTful>Web Services).  And "Web Services" seem to have colapsed under their own bloat; which leaves not a lot of impetus to migrate WCF to .NET Core.

### Builds
Although you can build in much the same way in Visual Studio, the convention in the command-line has been to use the `dotnet` command to `build`, `restore` Nuget references, perform Nuget `pack`ing, etc. 

### A Note on Composability
Each new technology seems to simply re-enforce SOLID principles at a broader level.  Take microservices for example.  A microservice is just a service with a narrower functional context to support performance and scalability.  You get that performance and scalability of systems using microservices because of the composability of microservices (and services, for that matter).  That functional context is very much like Single Responsibility and the ability to compose systems from multiple services and microserivces is a combination of Open Closed, Interface Segregation, Dependency Inversion, and even [Liskov]({{ site.baseurl }}{% post_url 2017-06-06-Rethinking Liskov Substitution Principle %}).  Software can support change better when it is more composable. I can re-compose a system with cohesive services in it more than I can with a monolithic system.  The same principle applies to how we design the class libraries that make up our services that make up our applications that make up our systems.  The more composable your class libraries, the more they will be able to accommodate change.  If you put all your code into one class library the more reasons it has to change (Single Responsibility) and affect everything that uses it.

So, I recommend putting in an equal amount of thought/design to the functional context granularity of your class libraries as you would to your classes and your services.  And like code smells like *Long Method* or *Large Class*, class libraries that pull in more and more disparate/unrelated dependencies have probably taken on too much *responsibility* and should be broken up into smaller libraries.

So, what's that got to do with .NET Core and Standard?  The "versions" of .NET Standard: each version increment of .NET Standard means it takes on more responsibility.  If you find that in order to migrate your class library to .NET Standard to support .NET Core, you *must* support a high .NET Standard version, the library likely has taken on too much responsibility.  POCOs (*Plain Old CLR Objects*) (or should that be POSO: Plain Old Standard Object) for example should live in a .NET Standard 1.0 library.  And you should try to break libraries up so that more of code can be put into cohesive .NET Standard libraries closer to version 1.0.

As 2.0 rolls out it will have the greatest parity with frameworks like .NET Framework 4.6.x, but I still think it's important to design your libraries to be composable and group things in a functional context that allows you to have lower versions of .NET Standard.  This better supports portability, but also better supports change.

[1.0]: https://github.com/dotnet/standard/blob/master/docs/versions/netstandard1.0.md
[1.1]: https://github.com/dotnet/standard/blob/master/docs/versions/netstandard1.1.md
[1.2]: https://github.com/dotnet/standard/blob/master/docs/versions/netstandard1.2.md
[1.3]: https://github.com/dotnet/standard/blob/master/docs/versions/netstandard1.3.md
[1.4]: https://github.com/dotnet/standard/blob/master/docs/versions/netstandard1.4.md
[1.5]: https://github.com/dotnet/standard/blob/master/docs/versions/netstandard1.5.md
[1.6]: https://github.com/dotnet/standard/blob/master/docs/versions/netstandard1.6.md
[2.0]: https://github.com/dotnet/standard/blob/master/docs/versions/netstandard2.0.md
[docs.microsoft.com]: https://docs.microsoft.com/en-us/dotnet/standard/library
[Configuration in .NET Core]: https://msdn.microsoft.com/en-us/magazine/mt632279.aspx
[First Rule of Distributed Object Design]: https://martinfowler.com/bliki/FirstLaw.html
[security holes]: https://technet.microsoft.com/library/security/ms14-026
[protobuf]: https://github.com/mgravell/protobuf-net <!-- 2017, June-->
