---
layout: post
title:  "Long Paths and .NET"
redirect_from: "/2014/07/23/long-paths-and-net/"
date:   2014-07-22 12:00:00 -0600
categories: ['.NET 4.5', '.NET Development', 'C#', 'LongPath', 'Open Source', 'Software Development']
tags:
- msmvps
disqus_id: "2121 http://blog.peterritchie.com/?p=2121"
---
[Source](http://pr-blog.azurewebsites.net/2014/07/23/long-paths-and-net/ "Permalink to Long Paths and .NET")

# Long Paths and .NET

If you've been following me on Twitter the last little while you might have noticed a few tweets bemoaning long paths in .NET code.  This hasn't been something new to me, but I decided to attempt to do something about it in the last little while.

Supporting files and directories with a long path is fairly easy with Windows. Unfortunately, other aspects of Windows haven't supported long paths in their entirely. The file system (NTFS), for example, supports long paths quite well; but other things like Command Prompt and Explorer don't. This makes it hard to entirely support long paths in _any_ application, let alone in .NET.x  

## What is "long path"?

Some of you (and I envy you) probably don't know what a "long path" is.  It's different from "long names"—which is a filename long than the archaic 8.3 filenames and support spaces.  Windows, for the longest time (and still does, for that matter) supported _paths_ (drive specifier, directory, subdirectories, filename, extension) *up to* about 260 chars.  There are multiple ways to _get around_ that (which actually create long paths and lead you down a path of anguish) but to support paths larger that 260 chars you have to use the long path support in Windows (and NTFS).  This support (which is essentially Unicode paths) supports up to 32,000 characters in a path.  (don't talk to me if you reach **that** limit).  This still has its limits in that a *directory* is still limited to 256 characters (which is really a feature of the driver for that file system—but NTFS, last time I checked, supports up to to 256 characters per directory (which stems from 260: 256 chars for a directory, 3 chars for the drive specifier and one char for the null).  But, 256 chars for a directory name ought to be enough for everyone :).  

## 

## Supporting a Long Path in .NET

This has been a bit tricky in .NET. Several attempts like [longpaths.codeplex.com][1] (a more up to date version has made its way into .NET in classes like [LongPath][2] [LongPathFile][3] and [LongPathDirectory][4]. But, these libraries do not seem to support the entire original API (`Path`, `File`, `Directory`) and not all file-related APSs (including `FileInfo`, `DirectoryInfo`, `FileSystemInfo`). 

Often times long path support is an after thought. Usually after you've released something and someone logs bug (e.g. "When I use a path like c:users_300 chars removed_Document.docx your software gives me an error". You can likely support long paths with the above-mentioned libraries, but you end up having to scrub your existing code that works with regular paths and re-design it to suit these new APIs (causing full re-tests, potential new errors, potential regressions, etc.). 

**So, I'm announcing an open-source library that I've created: [**LongPath][5]****** (or [**Pri.LongPath][6]****** on nuget).**

LongPath is a .NET 4.5 library that attempts to make dealing with long paths *much* easier.  LongPath originally started as a fork of LongPaths on Codeplex; but after initial usage it was clear that much more work was involved to better support long paths. So, I drastically expanded the API scope to include `FileInfo`, `DirectoryInfo`, `FileSystemInfo` to get 100% API coverage supporting long paths. (with one caveat: `Directory.SetCurrentDirectory`, Windows does not support long paths for a current directory). 

LongPaths allows your code to support long paths by providing a drop-in replacement for the following `System.IO` types: `FileInfo`, `DirectoryInfo`, `FileSystemInfo`, `FileInfo`, `DirectoryInfo`, `FileSystemInfo`. You simply reference the Pri.LongPath types you need and you don't need to change your code. 

Obviously to replace only 6 types in a namespaces (`System.IO`) and not the rest is problematic because you're going to need to use some of those other types (`FileNotFoundException`, `FileMode`, etc.)–which means referencing `System.IO` and re-introducing the original 6 types back into your scope. I feft that not having to modify your code was the greater of the two evils. Resolving this conflict is easily solved through aliases.  So, if you're used to one of the System.IO classes `FileInfo`, `DirectoryInfo`, `FileSystemInfo`, `FileInfo`, `DirectoryInfo`, `FileSystemInfo`, you simply add the following aliases to your C# file and go on about your business. 

I think there's currently 300 test that exercise the library pretty well; but if you find any issues, let me know via an issue on github, or a push request with a failing test.  Or, fix it and send me a push request with the fix and a new passing test. 

I'm going to add support for prior versions of .NET (and future then they're available) in the next little while (and over time); but if you're interested in contributing, see the issues list on github, or add a new issue, or fork and start making changes. 

Enjoy!

[1]: http://longpaths.codeplex.com/
[2]: http://referencesource.microsoft.com/#mscorlib/system/io/longpath.cs
[3]: http://referencesource.microsoft.com/#mscorlib/system/io/longpath.cs#734b3020e7ff04fe#references
[4]: http://referencesource.microsoft.com/#mscorlib/system/io/longpath.cs#ed4ae27b0c89bf61#references
[5]: http://bitly.com/UrdLZq
[6]: http://bitly.com/1qAplAD

