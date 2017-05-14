---
layout: post
title:  "Visual Studio 2010, Enhance your Jedi Skillz"
date:   2010-06-14 12:00:00 -0600
categories: ['.NET Development', 'DevCenterPost', 'Software Development', 'Visual Studio 2010']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/06/15/visual-studio-2010-enhance-your-jedi-skillz/ "Permalink to Visual Studio 2010, Enhance your Jedi Skillz")

# Visual Studio 2010, Enhance your Jedi Skillz

I've blogged about becoming a Jedi in Visual Studio 2008 [before][1].  Being a Jedi in Visual Studio means you focus more on adding value to the software you're working with and less on the process of the IDE you're doing your work in.

Visual Studio 2010 has some great features to allow you to do just that.  So much so, in fact, that I can't possibly do them justice in a single post.  I'll start with a few here and continue with a few posts on ways to get Visual Studio 2010 to let you write software faster.

All of what I've posted about VS 2010 still applies, like Auto Hide Solution Explorer, Toolbox, etc, single custom toolbar, etc.

**Use multiple monitors**.  VS 2010 has inherent support for multiple monitors.  You could previously get VS to display on multiple monitors; but now the tool windows in VS 2010 can be moved outside the main VS window, and dragged onto another monitor.  This is particularly handy (in my opinion) with debugging.  You can have your watch window on one monitor, the main editor on another monitor ( and if you're lucky enough to have a 3rd monitor) the application you're debugging on another monitor.

**Use Navigate To**.  I've been a user of Resharper for many years.  One of it's features is the ability to Go To Declaration—which allows you to navigate to the declaration of a type (if it's in your solution, metadata if it isn't).  Now Visual Studio 2010 has a very similar feature: Navigate To.  This feature can be invoked with Ctrl+, and will pre-populate the form with the type at the caret.  The form lists all the project files and types within the solution that match the text, including config files, CS files, classes, interfaces, etc.  Previously you had to to perform a Find In Files and wade through the false-positives to go right to the declaration of a type.  For example, if I press Ctrl+, and type "Main", I'll see the following Navigate To form:

![NavigateTo][2]

I can then simply press return to go to the declaration of the Main method.

If you are a TDD practitioner, **switch to Suggestion Mode**.  Pressing Ctrl+Alt+Space toggles between Suggestion mode and Completion mode.  Completion mode is the IntelliSense mode that was in version 2008 and prior.  2010 has a new Suggestion mode that doesn't auto-complete types when you press space, period, semicolon, etc.  They same types show up in the IntelliSense drop-down; but you can still auto-complete the type it suggested by pressing the down arrow then space, period, semicolon, etc.  For example, if I'm typing test code to test a type named Text, in Completion mode it may auto-complete with "TextBox" when I press space.  In Suggestion mode it will simply accept what I typed when I press space and not auto complete.  What's nice in 2010 is that IntelliSense now knows about "Text" as a type even though I haven't declared it, so when I continue and type "text = new T", "Text" now shows up in the IntelliSense drop-down.  I can have it complete it with "Text" by pressing down-arrow and continue typing.

Use Call Hierarchy to see what code is calling a particular method.  Call Hierarchy is new feature in Visual Studio 2010 that shows you in a tree structure what methods call a particular method as well as what methods a method calls.  For example, if I right-click a call to the UnityContainer constructor and select View Call Hierarchy, the Call Hierarchy form is displayed which shows what calls UnityContainer and what UnityContainer calls.  For each item in a node, you can expand to see what that method calls and what method calls it.  For example, InitializeContainer calls the UnityContainer constructor, if I expand the InitializeContainer entry in the tree I can see what it calls and where it is called from.  If I expand it's Calls From 'InitializeContainer' I can see what other methods InitializeContainer calls.  For example:

![CallHierarchy][3]

Since I last blogged on improving your Visual Studio skills, Scott Cate and Steve Andrews have taken up the Visual Studio Tips and Tricks torch from Sara Ford and are hosting [vstricks.com][4] and [vstips.com][5], respectively.

![kick it on DotNetKicks.com][6]

[1]: http://blogs.msmvps.com/blogs/peterritchie/archive/2008/09/02/becoming-a-visual-studio-jedi.aspx
[2]: http://blogs.msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie.metablogapi/8037.NavigateTo_5F00_thumb_5F00_6580D58D.png "NavigateTo"
[3]: http://blogs.msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie.metablogapi/8424.CallHierarchy_5F00_thumb_5F00_04B35694.png "CallHierarchy"
[4]: http://vstricks.com
[5]: http://vstips.com
[6]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2010%2f06%2f15%2fvisual-studio-2010-enhance-your-jedi-skillz.aspx

