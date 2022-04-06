---
layout: post
title: 'The Add Reference Dialog is the Wrong Scenario'
tags: ['Uncategorized', 'msmvps', 'March 2010']
---
[Source](http://blogs.msmvps.com/peterritchie/2010/03/19/the-add-reference-dialog-is-the-wrong-scenario/ "Permalink to The Add Reference Dialog is the Wrong Scenario")

# The Add Reference Dialog is the Wrong Scenario

There's been complaints, in some for or another, about the Visual Studio Add Reference dialog since it's creation. Some are very well founded. Defaulting to the .NET tab then spending many seconds high-jacking the UI while it loads the list is not a good experience. VS 2010 takes a step forward and puts the work to enumerate the assemblies on a background thread and changes the default tab.

But, there's still complaints about the dialog and the .NET tab. Some complain that assemblies aren't added in alphabetical order so it's difficult to do anything until the list is entirely loaded. Others complain that the list "jumps around" making it hard to read. Some of these complaints might be solved by not sorting the list.

But, I believe, no matter how "good" anyone makes this dialog, a scenario that includes an Add Reference dialog to resolve a type that's contained in a GAC assembly, or in another project in the current solution is inherently flawed in terms of a user experience.

The GAC is essentially a database of assemblies, and an assembly is partially a database of types. Ergo, the GAC is a potential database of types. I shouldn't need to tell Visual Studio what assembly to use for types within the GAC, it should just look it up. I don't care what assembly contains the type, there's no value to me having that knowledge or finding it out, I simply want to use that type.

I propose, rather than spending many resources on the Add Reference dialog, that Visual Studio attempt to automatically find the assembly that hosts types that it doesn't have an assembly reference for. This doesn't have to be automatic; it could be an option for unknown type errors, like a "Find and add reference" smart tag item. When I select that item I would then enumerate types in assemblies in the GAC that apply to the target framework for the project I'm trying to use the type within. If the assembly is found in the GAC or in the current solution, add a reference to it the assembly or the project. This data could be cached (either in memory or on disk) to make subsequence searches faster. If the type can't be found, bring up a browse dialog to browse for the file. 

Essentially, the fact that a type is contained within an assembly is simply an implementation detail that I shouldn't need to deal with to write software in .NET.


