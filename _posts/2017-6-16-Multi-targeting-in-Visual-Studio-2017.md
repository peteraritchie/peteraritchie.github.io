---
layout: post
title: Multi-targeting in Visual Studio 2017
date: 2017-06-16 23:32:00 -0500
categories: ['Multi-targeting', '.NET Core', '.NET Standard', 'Visual Studio 2017']
comments: true
excerpt: "An effective way to target multiple platforms in Visual Studio 2017 and easily generate a Nuget package."
---
# Multi-targeting in Visual Studio 2017
I've got a few OSS projects on the go that have evolved over time enough that some target more than one version of .NET.  Recently I started adding support to some of those projects for .NET Standard and .NET Core. Traditionally I've attempted to support multiple targets with multiple projects: since there's a single target framework in a project.  This has served me well over the years.  Here's some details:
Once you've got a project on the go and a Nuget package being used, a new framework shows up.  Eventually there may be something you need to support but can't just drop the assembly that only supports the previous version, so you you create new project targeting the new framework.  Usually a new framework is backwards compatible with the version you're already deploying for, so all the code you currently have should work fine with the new framework.  The best way I've found so far is to simply link to all the existing files in the new project.  In Solution Explorer, right-click the new project and click **Add&blacktriangleright;Existing File&hellip;** and select the files you want to add as a link and click the &blacktriangledown; in the **Add &blacktriangledown;** button and click **Add Link**. This adds links to the files from another projetc so each file is shared across the two projects.  If you edit one, you edit for both (or all projects).  If you have a lot of files across more than few directories, you'll quickly notice that using the **Add&blacktriangleright;Existing File&hellip;** dialog will be a huge chore.  An easier way is to select the files in Solution Explorer and drag and drop the files you want to share while holding the Alt key
