---
layout: post
title: Unbind a Visual Studio 2010 Solution from Source Code Control
categories: ['.NET Development', 'DevCenterPost', 'Software Development', 'Visual Studio 2010']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/12/11/unbind-a-visual-studio-2010-solution-from-source-code-control/ "Permalink to Unbind a Visual Studio 2010 Solution from Source Code Control")

# Unbind a Visual Studio 2010 Solution from Source Code Control

I was working with a solution that I got from someone else the other day.  When I loaded it up, Visual Studio 2010 informed me that it could not connect to a TFS server at some URL and will open the solution in offline mode (or something to that effect).  Of course, I have no access to this TFS server, so, I'm going to get this message every time I open this solution.  That's going to get annoying pretty fast.

So, I had a quick search on the Internet about removing source code control from a Visual Studio 2010.  I found all sorts of information about editing the sln file, removing various sections of an sln file and what-not.  None of this information can from Microsoft.  While in theory doing this would likely do what I wanted, manually editing sln or project files never seems like a good idea.  I don't know if there are side-effects from this that Visual Studio will telescope into some future version of the sln file and end up causing me problems.  e.g. Visual Studio 201x is released and I try to upgrade this sln file—what if this future version of VS fails or even worse, corrupts my file.

No, I didn't want to get chicken blood on my keyboard.

I was somewhat surprised that my search didn't immediately show something that wasn't obvious ritualistic magic; so, I went looking in the File menu at the Source Control entry.

In there, when my solution was loaded, I simply selected Change Source Control.  As soon as I try to open that dialog VS told me again that it was working offline and wanted to know if I wanted to completely remove the Source Control bindings from my solution.  I simply chose yes and all the SCC bindings were removed from my solution.

Saving and reloading the SLN file had no source control offline message, and my keyboard is no dirtier than when I started.

The fact that I couldn't readily find this with a web search made me think this information would be useful for someone else; so, I'm posting it here in the hopes it helps someone else.

