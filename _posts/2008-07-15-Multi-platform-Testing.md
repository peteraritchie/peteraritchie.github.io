---
layout: post
title: Multi-platform Testing
date: 2008-07-14 20:00:00 -0400
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/07/15/multi-platform-testing/ "Permalink to Multi-platform Testing")

# Multi-platform Testing

Sometimes in the testing of our code we need to ensure what we've written works in various environments.  Sometimes that's pre-XP Windows, low-resolution computers, etc.

One way is to have a group of computers on hand with various versions of Windows and configurations installed for testing.  Another is to have a series of virtual PCs on your computer that can be run.  Sometimes you can use your running version of Windows…

There are compatiblity settings in XP and greater that allow you to tell Windows to ignore certain features when running an application.

Windows XP and greater as a concept of Visual Styles.  There lots of .NET APIs you can use that use Visual Styles, like ComboBoxRenderer.  Unforunately, if you run the code on a Pre-XP version of Windows or an XP or greater version of Windows with Visual Styles disabled, then you'll get an InvalidOperationException.  Testing in XP with Visual Styles enabled won't let you find these bugs.  But, you can test without Visual Styles without having to change your display settings or deploy to another computer (physical or virtual) and run.  In the compatibility settings for an application you can tell it to disable Visual Styles.

 ![][1]

Compatibility is a very helpful little feature, it also lets you test what you application will lool link in minimum display situations like 640×480 and 256 colours without having to endure those settings during development.

[1]: http://blogs.msmvps.com/cfs-filesystemfile.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie/Compatibility-_2800_visual-themes_2900_.JPG

