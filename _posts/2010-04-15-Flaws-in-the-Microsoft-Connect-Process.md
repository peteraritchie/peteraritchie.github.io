---
layout: post
title:  "Flaws in the Microsoft Connect Process"
date:   2010-04-14 12:00:00 -0600
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/04/15/flaws-in-the-microsoft-connect-process/ "Permalink to Flaws in the Microsoft Connect Process")

# Flaws in the Microsoft Connect Process

The way Microsoft Connect works in terms of how a bug goes from being submitted to someone working on it (or closing it without working on it), is basically flawed. 

From a customer's point of view, we post an "issue" that we've encountered and leave it up to Microsoft to fix the issue.  The problem is, most of the time, this isn't what happens.  For the most part, the issue has no merit unto itself.  It's a popularity game with Connect.  You have to campaign for people to vote for your issue if you think it should be fixed. 

I'm not talking about suggestions here, I'm talking about bugs.  Suggestions are what they are.  Suggestions suffer the same problem as bugs: unless the suggestion you report is already on the roadmap, it has to get enough upvotes for it to get any attention.

This is inherently flawed because popularity is not directly related to importance, priority, or impact.  If I do manage to campaign successfully for a particular bug, that doesn't make it an more important than another.

I only use Connect to post issues.  I don't browse around looking at other people's issues.  I feel that the majority of people registered on Connect work with it in that way.  And therein lies the problem.  No one looks at bugs, so why would they arbitrarily upvote them?  The basic flaw in this usability means that many people have simply given up on Connect—which  leaves that much less potential people to upvote defects. 

It's clear that if I feel a bug is worth fixing I have to campaign for people to upvote it.  So, I'm going to periodically pick a bug (maybe one of mine) and blog about it. 

The first has to do with the way right-click menus work in Visual Studio 2010.  The issue was first raised in CTP; but, effectively if you bring up a right-click menu when your mouse is around the vertical centre of the screen, the menu either pops-up or pops-down from the current mouse position–with not enough space to display all menu items.  This results in a menu that takes up little more than half the screen that you have to scroll.  It's fairly easy to duplicate, just open a C# file and right click near the vertical centre of the code window and you'll likely see a scrollbar.  It's a departure from the way VS 2008 worked, and it's annoying all on it's own.  Now, there's a reason for it; but, that doesn't matter.  Having a menu that uses little more than half the potential real estate _and_ scrolls is poor usability. 

There may be more that one issue logged for this, but I'm picking this particular issue logged by Josip Medved: <http://bit.ly/aeZCJh>

