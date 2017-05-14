---
layout: post
title: Developing with Source Code Control Best Practices Part 1
date: 2008-10-17 20:00:00 -0400
categories: ['Software Development', 'Software Development Guidance', 'Visual Studio 2010 Best Practices']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/10/18/developing-with-source-code-control-best-practices-part-1/ "Permalink to Developing with Source Code Control Best Practices Part 1")

# Developing with Source Code Control Best Practices Part 1

This post will detail some first principles about source code control (SCC) and provide what I consider the most basic of practices that every dev should follow.

**What is SCC?**  
SCC provides developers the ability to keep a history of their changes.  SCC allows developers the ability to group file changes together with an annotation. SCC allows developers the ability to get back to the state the project was in at any given point in time, arbitrary or specific (Beta 1, RTM, etc.).  SCC provides development teams the ability to more easily work on the same files at the same time.  SCC allows developers to see who did what, when, and usually why.  SCC allows development on more than one branch of the code at a time.  Depending on the SCC, SCC allows developers to link changes to tasks, work items, etc.

**Basic practices**  
**Never check in changes that cannot be built.  
**This is pretty self-explanatory.  Referring back to what is SCC: "SCC allows developers the ability to get back to the state the project was in at any given point in time".  This means anyone can get back to a state where the project won't build if you check in changes that cannot be built.  This causes undue friction at points temporally distant from the changes–which means there lots of work (time) involved to find and implement a solution (e.g. is the state 5 seconds before better, is the state 5 seconds after better, etc?  All things that need to be researched and tested before continuing–wasting time and resources).

**Check in related changes atomically.  
**This builds on the first practice, if all related changes are checked in as a unit the likelihood of that check-in breaking the build is highly improbable.  Atomically means all related changes are checked in at the same time.  With most SCC systems this is extremely simple, and usually means selecting all the files you have edited (or all the subfolders you have modified folders in–or the one subfolder if you have unrelated changes, see part 2).  This might mean avoiding SCC IDE integration if your changes span several solutions. If you can't check in changes atomically (really question this if you think you can't.  If you honestly can't, I'd suggest changing SCC systems) order the check ins to avoid build problems.  For example, if you added an enum to somefile.cs, then used that new enum in someotherfile.cs, check-in somefile.cs before checking-in someotherfile.cs.  Checking in somefile.cs first will not put the source code in a state where it cannot be compiled.  You're working on a team, anyone on the team can get the state of the project at any time, like between non-atomic file check ins.  This means they get code that doesn't compile and they won't know why or how to fix it–blocking them from doing their work and wasting time and impacting the project schedule.

**Make use of shelving.**  
If what you've coded needs to be given to someone else to get the source code to build properly, don't check it in in order to give it to that other person.  On cases like this, if your SCC has shelving or shelvsets, shelve the changes and inform the other person of the shelvset instead of checking in.  Let them check in the working changes as an atomic unit.  If shelving isn't an option (consider or petition for an SCC system that does, then), send them the files for them to check in after modifications.  See next practice.

**Get all current code and build before checking in.**  
Someone may have made changes between when you got the code you working on and when you want to check in.  If you don't get the latest code (and potentially merge it with yours), what you check-in may leave the controlled code in a state where it cannot be built.  Get all the current code to make sure you have what will be the state of the code when you check in and that it builds first.  If your build process is long, this may require several tries.  You should address build times if this is a common problem.  Communicate to the rest of the team that you need to check in changes and that they hold off on checking in related components if necessary.

![kick it on DotNetKicks.com][1]

[1]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f10%2f18%2fdeveloping-with-source-code-control-best-practices-part-1.aspx

