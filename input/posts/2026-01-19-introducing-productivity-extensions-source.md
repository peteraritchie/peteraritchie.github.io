---
layout: post
title: 'Introducing Pri.ProductivityExtensions.Source - A .NET Standard Package to Enable Modern Language Features'
categories: ['January 2026']
comments: true
excerpt: '.'
tags: ['Software Development', 'Pri.ProductivityExtensions', 'Pri.ProductivityExtensions.Source', '.NET']
---
There are a few reasons developers need to work in .NET Standard. One is for writing PowerShell modules in C#, another is writing Roslyn Analyzers. .NET Standard is a formal specification of .NET APIs that are available on multiple .NET implementations. It's like a definition of a slice of APIs that are implemented across .NET versions. Designing for a slice of APIs allows you to design and deploy class libraries that will work across .NET implementations. The last updated .NET Standard version (2.1) was released in September 2020.

Targeting .NET Standard for a class library means that the library will be compatible applications designed for past versions of .NET. e.g. an application targeting .NET Framework 4.8 or .NET Core 2.1 will be able to load a class library targeting .NET Standard 2.0 because it can only rely on the same APIs that the application does.

.NET languages depend on base-class libraries for aspects of their implementation. For example, the C# language feature `foreach` depends on the types `IEnumerable`, `IEnumerable<T>`, `IEnumerator`, and `IEnumerator<T>`. Specifications like .NET Standard enable C# language features across .NET implementations by specifying a minimum set of APIs that are be implemented (including `IEnumerable`, `IEnumerable<T>`, `IEnumerator`, and `IEnumerator<T>`). But, languages evolve and improve over time similarly to base class libraries.

Since .NET Standard hasn't been updated since 2020, some new language features dependent upon types in a base class library aren't supported, despite the ability to use the latest version of the compiler when building .NET Standard class libraries. For example, Ranges and Indices are a feature added to C# 8.0, released in September 2019. Ranges and Indices depend upon the `Range` and `Index` types. But to write a Powershell library that supports Windows Powershell and Powershell 7 you have to target .NET Standard whose API service was specified around August 2017--roughly two years before `Range` and `Index` existed. This means Ranges and Indices aren't supported out of the box in C# code targeting .NET Standard 2.0. `var lastWord = words[^1]` or `var firstFourWords = words[0..3]` will cause an errors (`Predefined type 'System.Index' is not defined or imported` and `Predefined type 'System.Range' is not defined or imported`, respectively).

Fortunately the compiler is a bit flexible with where those predefined types exist. We can't simply create a .NET Standard 2.0 library with Range and Index as public types because they will end up clashing if a modern version of .NET is used (e.g. in an XUnit test project). But, the .NET Standard 2.0 library can create internal versions of those classes that the compiler is happy to resolve to. But, everyone who authors a .NET Standard 2.0 library having to write their own Range and Index classes (as well as any other class that modern c# syntax requires, like `CallerArgumentExpressionAttribute`, `DoesNotReturnAttribute`, etc.) is _problematic_, to say the least.

Fortunately .NET and NuGet packages support the concept of content- or source-only packages. Source-only packages are nuget packages that instead of packaging binaries like DLLs, they package source code. That's where Pri.ProductivityExtensions.Source comes in.

Pri.ProductivityExtensions.Source is a source-only NuGet package that includes the source code for various types created after .NET Standard 2.x to support C# language features (and maybe some helper extensions like `ArgumentException.ThrowIfNull`).

.NET release | date
--- | ---
.NET 10 | November 11, 2025
.NET 9 | November 12, 2024
.NET 8 | November 14, 2023
.NET 7 | November 8, 2022
.NET 6 | November 8, 2021
.NET 5 | November 10, 2020 
<!-- from https://learn.microsoft.com/en-us/lifecycle/products/microsoft-net-and-net-core -->

.NET Core release | date
--- | ---
.NET Core 3.1 | December 3, 2019
.NET Core 3.0 | September 23, 2019
.NET Core 2.2 | December 4, 2018
.NET Core 2.1 | May 30, 2018
.NET Core 2.0 | August 14, 2017
.NET Core 1.1 | November 16, 2016
.NET Core 1.0 | June 27, 2016 
<!-- from https://learn.microsoft.com/en-us/lifecycle/products/microsoft-net-and-net-core -->

.NET Framework release | Date
--- | ---
.NET Framework 4.8.1 | August 9, 2022
.NET Framework 4.8 | April 18, 2019
.NET Framework 4.7.2 | April 30, 2018
.NET Framework 4.7.1 | October 17, 2017
.NET Framework 4.7 | April 11, 2017
.NET Framework 4.6.2 | August 2, 2016
.NET Framework 4.6.1 | November 30, 2015
.NET Framework 4.6 | July 29, 2015
.NET Framework 4.5.2 | May 5, 2014
.NET Framework 4.5.1 | January 15, 2014
.NET Framework 4.5 | October 9, 2012
.NET Framework 4.0 | April 12, 2010
.NET Framework 3.5 SP1 | November 19, 2007
.NET Framework 3.0 | November 21, 2006
.NET Framework 2.0 | February 17, 2006
.NET Framework 1.1 | April 9, 2003
.NET Framework 1.0 | January 15, 2002
<!-- from https://learn.microsoft.com/en-us/lifecycle/products/microsoft-net-framework -->

Date | .NET Implementation (minimum) | C# Version | Language Feature | Most Reason .NET Standard
--- | --- |--- | --- | ---
... | .NET Core 1.0, Framework 4.5 | ... | ... | .NET Standard 1.0 (August, 2016)
... | .NET Core 1.1 | ... | ... | .NET Standard 1.1 (November, 2016)
... | Framework 4.5.1 | ... | ... | .NET Standard 1.2 (December, 2016)
... | Framework 4.6 | ... | ... | .NET Standard 1.3 (December, 2016)
... | Framework 4.6.1 | ... | ... | .NET Standard 1.4 (May, 2017)
... | .NET Core 2.0, Framework 4.6.1&sup2; | ... | ... | .NET Standard 1.5 (August, 2017)
... | ? | ... | ... | .NET Standard 1.6 (June, 2016)
... | .NET Core 2.0 | ... | ... | .NET Standard 2.0 (August, 2017)
... | ... | ... | ... | .NET Standard 2.1 (November 2018)
&sup2;: 4.7.2 is recommended instead of 4.6.1

.NET Standard Version | Date | Coinciding .NET Implementation | Coinciding C# Version | Language Feature
--- | --- | --- | --- | ---
.NET Standard 1.0 | August, 2016 | .NET Core 1.0 | ... | ... | 
.NET Standard 1.1 | November, 2016 | .NET Core 1.1 | ... | ... | 
.NET Standard 1.2 | December, 2016 | ... | ... | ... | 
.NET Standard 1.3 | December, 2016 | ... | ... | ... | 
.NET Standard 1.4 | May, 2017 | ... | ... | 
.NET Standard 1.5 | August, 2017 | .NET Core 2.0 | ... | ... | 
.NET Standard 1.6 | June, 2016 | ... | ... | ... | 
.NET Standard 2.0 | August, 2017 | ... | ... | ... | 
.NET Standard 2.1 | November, 2018 | ... | ... | ... | 

| .NET Implementation    | Date               | Coinciding .NET Standard      | Matching C# Version |
|------------------------|--------------------|-----------------------------  |---------------------|
| .NET 10                | November 11, 2025  | ---                           | C# 14.0 Nov 2025    |
| .NET 9                 | November 12, 2024  | ---                           | C# 13.0 Nov 2024    |
| .NET 8                 | November 14, 2023  | ---                           | C# 12.0 Nov 2023    |
| .NET 7                 | November 8, 2022   | ---                           | C# 11.0 Nov 2022    |
| .NET 6                 | November 8, 2021   | ---                           | C# 10.0 Nov 2021    |
| .NET 5                 | November 10, 2020  | ---                           | C# 9.0 Nov 2020     |
| .NET Core 3.1          | December 3, 2019   | ---                           | C# 8.0 Sep 2019     |
| .NET Core 3.0          | September 23, 2019 | .NET Standard 2.1 (May 2019)? | C# 8.0 Sep 2019     |
| .NET Core 2.2          | December 4, 2018   | ---                           | C# 7.3 May 2018     |
| .NET Core 2.1          | May 30, 2018       | .NET Standard 2.0 (2018)?     | C# 7.3 May 2018     |
| .NET Core 2.0          | August 14, 2017    | .NET Standard 2.0 (2017)?     | C# 7.1 Aug 2017     |
| .NET Core 1.1          | November 16, 2016  | ---                           | C# 7.0 Mar 2017     |
| .NET Core 1.0          | June 27, 2016      | ---                           | C# 7.0 Mar 2017     |
| .NET Framework 4.8.1   | August 9, 2022     | ---                           |  N/A                |
| .NET Framework 4.8     | April 18, 2019     | .NET Standard 2.0 (2018)?     | C# 7.3 May 2018     |
| .NET Framework 4.7.2   | April 30, 2018     | ---                           | C# 7.2 Nov 2017     |
| .NET Framework 4.7.1   | October 17, 2017   | ---                           | C# 7.1 Aug 2017     |
| .NET Framework 4.7     | April 11, 2017     | ---                           | C# 7.0 Mar 2017     |
| .NET Framework 4.6.2   | August 2, 2016     | ---                           |  N/A                |
| .NET Framework 4.6.1   | November 30, 2015  | ---                           |  N/A                |
| .NET Framework 4.6     | July 29, 2015      | ---                           | C# 6.0 Jul 2015     |
| .NET Framework 4.5.2   | May 5, 2014        | ---                           |  N/A                |
| .NET Framework 4.5.1   | January 15, 2014   | ---                           |  N/A                |
| .NET Framework 4.5     | October 9, 2012    | ---                           | C# 5.0 Aug 2012     |
| .NET Framework 4.0     | April 12, 2010     | ---                           | C# 4.0 Apr 2010     |
| .NET Framework 3.5 SP1 | November 19, 2007  | ---                           | C# 3.0 Nov 2007     |
| .NET Framework 3.0     | November 21, 2006  | ---                           | C# 2.0 Nov 2005     |
| .NET Framework 2.0     | February 17, 2006  | ---                           | C# 2.0 Nov 2005     |
| .NET Framework 1.1     | April 9, 2003      | ---                           | C# 1.1/1.2 Apr 2003 |
| .NET Framework 1.0     | January 15, 2002   | ---                           | C# 1.0 Jan 2002     |

The last version .NET Standard release (2.1) was released in 2020. Since 2020, C# versions 10, 11, 12, 13, and 14 have been released. A lot has changed in 5 versions of C#, including the use of a multitude of APIs to enable various features. For example, in November 2020 `CallerArgumentExpressionAttribute` was added to .NET 6 to enable the C# 10 compiler to pass along text symbolizing the expression used to calculate the value of an method parameter. Without a base class library that contains `CallerArgumentExpressionAttribute`, C# can't generate intermediate language instructions to call methods that use it.

You may not have noticed in the above description but .NET Standard 2.1, .NET 5, and C# 10 were part of the same release, which means C# 10 features like `CallerArgumentExpressionAttribute` cannot be used prior versions of .NET Standard (notably .NET Standard 2.0)

 I detailed .NET Standard 2.1 was the last specification of common types that can be depended upon  across .NET implementations in September 2020 and C# 10 and .NET was released 

While what can be considered common across multiple implementations of .NET, 
Since 2020 what could be considered common across multiple implementations of .NET has been frozen. 
With specifications of subsets of .NET APIs deemed immutable 

> **If you find this useful**  
> I'm a freelance software architect. If you find this post useful and think I can provide value to your team, please reach out to see how I can help. See [About](/about) for information about the services I provide.
<!-- Calendly inline widget begin -->
<div class="calendly-inline-widget" data-url="https://calendly.com/peterritchie/client-meet-greet-zoom" style="min-width:320px;height:700px;"></div>
<script type="text/javascript" src="https://assets.calendly.com/assets/external/widget.js" async></script>
<!-- Calendly inline widget end -->