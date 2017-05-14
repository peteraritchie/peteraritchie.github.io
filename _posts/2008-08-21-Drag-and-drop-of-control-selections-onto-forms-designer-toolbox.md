---
layout: post
title: Drag and drop of control selections onto forms designer toolbox
date: 2008-08-20 20:00:00 -0400
categories: ['Connect Suggestion', 'Visual Studio 2005', 'Visual Studio 2008', 'Visual Studio vNext']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/08/21/drag-and-drop-of-control-selections-onto-forms-designer-toolbox/ "Permalink to Drag and drop of control selections onto forms designer toolbox")

# Drag and drop of control selections onto forms designer toolbox

A while back I blogged about the ability we have in Visual Studio to select text in a text editor and drag it onto the toolbox.  Once on the toolbox you could drag those items back into the text editor to effectively "paste" frequently needed snippets of code into other text files.

Imagine my surprise when we didn't have this ability in the forms designer.  When writing code, it's a bit specious to want to have multiple copies of hard-coded snippets of code (DRY should come to mind).  But, for forms, the only alternative is to create user controls to contain commonly-used control groups.  User controls is very heavy weight and basically becomes unusable when talking about simple groups of buttons.  For example, "OK" and "Cancel" buttons.

So, as a result, I've [logged a suggestion][1] on Microsoft Connect suggesting this ability be added to Visual Studio.

If you want to see the potential of a feature like this, see <http://machine.nukeation.com/preview.html>

[1]: https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=362827

