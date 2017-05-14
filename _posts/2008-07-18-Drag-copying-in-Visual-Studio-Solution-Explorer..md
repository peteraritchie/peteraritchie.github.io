---
layout: post
title: Drag-copying in Visual Studio Solution Explorer.
categories: ['.NET 3.5', '.NET Development', 'Poor UI', 'Product Bugs', 'Software Development', 'Visual Studio 2008']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/07/18/drag-copying-in-visual-studio-solution-explorer/ "Permalink to Drag-copying in Visual Studio Solution Explorer.")

# Drag-copying in Visual Studio Solution Explorer.

NOTE: I've tried this in Visual Studio 2008 (VS2k8), I'm assuming the same thing happens in Visual Studio 2005 (VS2k5).

In the process of refactoring, it's *very* common for me to rename a type.  This is most easily done by renaming the file in the Solution Explorer (SE)–which renames the file, the type, and and any uses of the type in the entire solution.

Occasionally, I need to create a new type based on another.  Copying an abstract type in order to implement the abstract type is often handy–I just fill in the abstract members (and delete "abstract") in the copied type after renaming it.

Drag-copy in the SE seems like it would take care of a couple of steps at once for me: make a copy and rename it.  Unfortunately it doesn't do that.  It makes a copy of the file (as "Copy of typename.xx") but doesn't rename any types in the class that match the file name.

This might seem somewhat trivial… I can simply rename the file name then refactor rename the type in the file so that the type and all it's constructors are renamed in one fell swoop.  Alas, this simply opens a can of worms that can completely confound a newcomer and annoy an expert.

That simple, intuitive method of renaming a copy of a file then the type within the file actually renames *all* types of that name.  Since we've just made a copy of the type, that means it's always going rename types in two files.  The side-effect of drag-copy in SE means you *must* manually rename the type in the file you just copied.  You can do this with search-replace; but that's friction I don't want and really makes SE drag-copy unusable.

I've [logged a bug about it on Connect][1]; but the olde "by design" card was played… 

[1]: https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=355239

