---
layout: post
title: Comparing CodeRush Refactor! Pro and Resharper 4, part 1 or N — first glance.
date: 2008-06-24 20:00:00 -0400
categories: ['.NET Development', 'C#', 'CodeRush Refactor! Pro', 'EffectiveIoC', 'Resharper', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/06/25/comparing-coderush-refactor-pro-and-resharper-4-part-1-or-n-first-glance/ "Permalink to Comparing CodeRush Refactor! Pro and Resharper 4, part 1 or N — first glance.")

# Comparing CodeRush Refactor! Pro and Resharper 4, part 1 or N — first glance.

**Metadata view of code in referenced assemblies  
**This is a big one for me.  For whatever reason, Refactor 4 (and prior) completely disables this and sends you to the Object Browser instead.   You get metadata view with CodeRush Refactor! Pro.  

**Keyboard layout  
**As you might imagine, CodeRush Refactor! Pro and Resharper had completely different keyboard layouts.  So, if you're used to R# then Refactor! Pro will take a bit of getting used to.

One thing I don't like with the default Refactor! Pro keyboard layout, is they've replaced Ctrl-. with Quick Navigation.  I use Ctrl-. (instead of Shift-Alt-F10 to get at the smart-tag menu).  Shift-Alt-F10 for smart-tag menu seems more common; so I'll have to get use to Shift-Alt-F10.

**Refactor! Pro's Editor enhancements  
**R# doesn't change to how the editor looks as much as CodeRush Refactor! Pro.  It has the Marker Bar, error/warning/info colouring, and action light-bulbs.  Refactor! Pro with CodeRush has many more, like region painting, flow-break evaluation, Visibility Icons, structural highlighting, etc. 

**Real-time analysis  
**Both R# and CodeRush Refactor! Pro do real-time code analysis.  R# has text colouring and the right-hand marker bar.  CodeRush Refactor Pro has a marker bar on both the left and the right.  The left marker bar in CodeRush Refactor! Pro highlights issues for each line, and the right (as does R#) shows a file-wide view of issues.  I find the R# marker bar sometimes doesn't align with the scroll bar so that an issue may be beside the scroll-bar in the marker bar but is actually scrolled off the screen.  CodeRush Refactor Pro doesn't do that and in fact shows the visible portion of the document in its marker bar.  i.e. the marker bar is beside the Visual Studio Indicator Margin (where the breakpoint bullets appear).

**Refactorings  
**They both have many of the same refactorings.  When it comes to non-refactorings the two sometimes approach things differently.  For example R# deals with adding members to a class through "Generate Code" list; whereas CodeRush Refactor Pro uses templates.  E.g. in R#, to add a constructor you hit Alt-Ins and select Constructor.  With Refactor you simply enter "cc "(that 'c', 'c', space).

**Smart-Tags**  
Both approach smart-tags slightly differently.  With R# they use the actions light-bulb at the left margin.  This includes fixes for warnings, errors, plus refactorings, but doesn't include code generation options.  CodeRush Refactor Pro uses an ellipsis-like icon that appears right at the site of the potential refactoring. Code Refactor Pro is a richer experience.  It will show you the result of a refactoring with arrows showing where things will move, red strike-out showing what will be removed, and highlights for things that will be changed/renamed.   

