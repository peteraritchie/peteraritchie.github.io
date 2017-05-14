---
layout: post
title: Visual Studio 2005 Service Pack 1 Beta
date: 2006-10-09 20:00:00 -0400
categories: ['Visual Studio 2005', 'Visual Studio 2005 Service Pack 1 Beta']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2006/10/10/visual-studio-2005-service-pack-1-beta/ "Permalink to Visual Studio 2005 Service Pack 1 Beta")

# Visual Studio 2005 Service Pack 1 Beta

As with any Beta, it's not wise to think of it as "stable" and expect it to work as reliably, or be as tested as an RTM version.

But, I've found the second of what I consider blocking issues with SP1 that leads me to think it's time to test the uninstallation.  I independently found that enabling Code Analysis for C/C++ spits out what seems like verbose tracing information that causes Visual C++ to view building with Code Analysis turn on to fail a Build.  I found that someone else had found this already and logged it on Connect: <https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=218742>.  Breaking a major like Code Analysis for C/C++ seems a little disconcerting.

The second blocking issue is the inability to step through code running in a second thread create via an asynchronous delegate: <https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=223081>  Again, a reasonably fundamental feature gone.

