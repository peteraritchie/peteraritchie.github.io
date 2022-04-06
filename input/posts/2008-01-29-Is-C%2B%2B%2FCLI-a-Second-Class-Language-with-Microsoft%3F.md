---
layout: post
title: 'Is C++/CLI a Second Class Language with Microsoft?'
tags: ['C++/CLI', 'Pontification', 'Software Development', 'Visual Studio 2008', 'msmvps', 'January 2008']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/01/29/is-c-cli-a-second-class-language-with-microsoft/ "Permalink to Is C++/CLI a Second Class Language with Microsoft?")

# Is C++/CLI a Second Class Language with Microsoft?

The post frequency on the [Visual C++ team blog][1] is reasonably high.Some posts deal with new features that were added to VC++ 2008.

But, is Visual C++ a second-class citizen in the Visual Studio product group? Recently the [Visual Studio 2008 Product Comparison][2] was released (don't ask me why it wasn't released at the same time as the products…). In the product comparisons VC++ Express has an inordinatenumber of features that only it doesn't have. When you look at the Visual C++ 2008 Express Edition [product][3] [sites][4], it seems pretty clear that it's geared towards native-only software development. Despite this the product comparison shows VC++ Express has Managed Debugging, Mixed-Mode Debugging andCompiler Support for any CPU (which details "…compile your managed application…"). But, VC++ 2008 Express is the only edition that doesn't support adding reference to WCF services ("Service Reference"), Code Snipped Manager, Code Snippets, Rename Refactoring, Text File (you can't create a plain text file with VC++ 2008 Express?), and one of two editionsthat doesn't include support for XML File (create a blank XML file), and SQL Server 2005 Compact Edition. As well, only VC++ 2008 doesn't include managed-only features likeObject Browser, Object Relational Designer, and SQLMetal (the last two deal with .NET-only LINQ-to-SQL.

C++ has stagnated as a language for quite some time, but Visual C++ 2008 includes new language features like C++0x and TR1 that help evolve the language for the parallel future. But, despite assurances that [native development is still a focus][5] at Microsoft, there is the appearance that VC++ just isn't getting the same resources as the other editions. Makes you wonder how much longer will Microsoft keep it in the Visual Studio family…

[1]: http://blogs.msdn.com/vcblog/
[2]: http://blogs.msdn.com/robcaron/archive/2008/01/27/7278319.aspx
[3]: http://www.microsoft.com/express/product/default.aspx
[4]: http://www.microsoft.com/express/vc/
[5]: http://channel9.msdn.com/ShowPost.aspx?PostID=281987


