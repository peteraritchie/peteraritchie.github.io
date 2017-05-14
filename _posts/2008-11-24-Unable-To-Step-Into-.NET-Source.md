---
layout: post
title: Unable To Step Into .NET Source
categories: ['.NET Development', 'Visual Studio 2008', 'Visual Studio 2008 SP1']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/11/24/unable-to-step-into-net-source/ "Permalink to Unable To Step Into .NET Source")

# Unable To Step Into .NET Source

I began getting a problem a while ago that I was unable to step into the .NET source in Visual Studio 2008.  It happened suddenly, and I noticed it shortly after installing SP1.  Given my observation it appears to be due to upgrading the SP1; but I couldn't find anyone else not having the same problem.  I had another computer where it worked, so I basically put it aside.

Today I had a chance to have a closer look.  I had configured 2008 (RTM, not SP1) to get the .NET source based on Shawn Burke's blog and had not encountered any problems.  Once I upgraded to SP1 and checked "enabled .Net source stepping", I all I ever got when trying to step through source is a dialog asking me for the location of the CS file.

What I had configured was to place the debug symbols into a folder in the Visual Studio 2008 user directory (c:Documents and SettingsPRitchieMy DocumentsVisual Studio 2008Symbols, for example).

Despite creating a new subdirectory for SP1, I still could not step through the source.

It wasn't until I moved the directory down the hierarchy that I finally got some joy.  I first tried it on the root and it worked fine.  I then tried it as a sub directory within my documents and it worked fine.  I imagine that the path was longer that 260 and rather than present the user with an error with that detail it assumed it couldn't find the file it was looking for and asked the user for the location of it.  But, I'm guessing.

Hope this helps someone else.

