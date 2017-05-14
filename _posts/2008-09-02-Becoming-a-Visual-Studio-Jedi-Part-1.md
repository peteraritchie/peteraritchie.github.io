---
layout: post
title: Becoming a Visual Studio Jedi Part 1
categories: ['.NET Development', 'C#', 'Design/Coding Guidance', 'DevCenterPost', 'Software Development', 'Visual Studio 2008']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/09/02/becoming-a-visual-studio-jedi/ "Permalink to Becoming a Visual Studio Jedi Part 1")

# Becoming a Visual Studio Jedi Part 1

Becoming a Visual Studio 2008 (and often Visual Studio 2005) Jedi

In much the same grain as James' [Resharper Jedi][1] posts, I'm beginning a series of posts on becoming a Visual Studio Jedi.  It involves getting the most out of Visual Studio off-the-shelf, doing things as quickly as possible and with as little friction as possible.  I think it's useful for all users; but especially useful for those who are in situations where they can't install refactoring tools like Refactor Pro! or Resharper.

First, familiarize yourself with [Sara's Visual Studio Tips][2] blog; then subscribe to her blog.

I'll attempt to provide detail at a less granular level than Sara's blog (i.e. using a series of commands to perform a specific task); but I may overlap here and there

Take advantage of Auto-Hide   
Like Jimmy Bogard and Jeffery Palermo, I have my Visual Studio UI very lean. 99% of the time, I'm working in code.  The Solution Explorer (SE), Properties, Output, etc are auto-hide panes.  When I need to use them I hover the mouse over the tab to make them visible, do what I need to do with them, then get back to the code.  The Code Editor is the only window that isn't auto-hide or floating.   
![][3]

Navigate find results via keyboard   
Whenever anything is displayed in a find results window, you can iterate each item in the list via a keystroke.  The default C# keyboard map had F8 and Shift+F8 as the shortcuts for next and previous.

For example:

1. Press Ctrl+Shift+F to bring up the Find in Files form. 
2. Enter "TODO:.*refactor" in the "Find what" text box. 
3. Ensure Match case, Match whole word are unchecked. 
4. Ensure Use is checked and has Regular expressions selected. 
5. Press Alt+F to search.   
![][4]

A Find Results window is displayed that shows the results of the search.   
![][5]

* **F8** goes to the first result.
* Pressing **F8** again goes to the next. 
* Pressing **Shift+F8** goes to the previous result.

See also:   
<http://blogs.msdn.com/saraford/archive/2008/04/18/did-you-know-you-can-use-f8-and-shift-f8-to-navigate-among-errors-in-the-output-window.aspx>   
<http://blogs.msdn.com/saraford/archive/2007/11/08/did-you-know-how-to-use-f8-to-navigate-the-find-results-window.aspx>   
<http://blogs.msdn.com/saraford/archive/2005/03/30/403887.aspx>

F8 and Shift+F8 work for most lists like Find Results 1, Find Results 2, Error List, Output:Build, etc.

File name extensions when adding classes   
Do you find your self selecting text in the file name when you use the Add Class wizard?  Or, do you always type ".cs" at the end of your file name?  You may be happy to know you don't have to do that.  Simply invoke the Add Class wizard and type the name of the class.  The wizard adds the missing .cs for you.  For example:   
Press Alt+P, C   
Enter "MyNewClass"   
Press Enter   
A file MyNewClass.cs is added to your project and it contains class named "MyNewClass".

Consider a Custom toolbar

There's generally only handful of toolbar buttons that you might need, especially if you're a keyboard user like me.  There's some things that simply don't have a default keyboard mapping.  Another good reason for having a custom toolbar item with only the buttons you use is if you often change the size of your Visual Studio window.  The default layout has two or more toolbars (depending on the edition and any add-ins you have installed).  You can carefully position those toolbars so they may take up one or two lines; but when you then shrink the size of your window the get wrapped and they won't restore if you expand the size of your window.  Having a single toolbar means this wrapping of toolbars can never happen.

Export Settings

Once you get your UI the way you want it, you can actually save the layout.  

1. Click on ToolsImport and Export Settings.
2. Select Export selected environment settings.

This is really handy if you get into low-resource situations (like the application you're developing or its framework uses up too many GDI handles and Visual Studio can't allocate a handle to display a toolbar or a frame.  When this happens Visual Studio actually turns off those GUI elements; when you close and restart those panes/frames are no longer displayed by default.)

[1]: http://www.jameskovacs.com/blog/BecomingAJediPart1OfN.aspx
[2]: http://blogs.msdn.com/saraford/archive/tags/Visual+Studio+2008+Tip+of+the+Day/default.aspx
[3]: http://blogs.msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie/lean-VS2k8.JPG
[4]: http://blogs.msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie/Find-in-Files.JPG
[5]: http://blogs.msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie/Find-Results.JPG

