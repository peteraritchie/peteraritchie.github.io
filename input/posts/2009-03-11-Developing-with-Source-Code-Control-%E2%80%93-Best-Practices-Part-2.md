---
layout: post
title: 'Developing with Source Code Control – Best Practices Part 2'
tags: ['Software Development', 'Software Development Guidance', 'Visual Studio 2010 Best Practices', 'msmvps', 'March 2009']
---
[Source](http://blogs.msmvps.com/peterritchie/2009/03/11/developing-with-source-code-control-best-practices-part-2/ "Permalink to Developing with Source Code Control – Best Practices Part 2")

# Developing with Source Code Control – Best Practices Part 2

[Edited 14-Mar-09: clarified generated code SCC practice]

This edition provides SCC vocabulary and some more practices that make development life easier.

**Vocabulary**  
**Trunk**  
The root of the project or database. Sometimes called mainline or baseline; depending on the SCC structure, this is where most of the development occurs.  
**Mainline**  
The root of the project or database. Sometimes called trunk or baseline; depending on the SCC structure, this is where most of the development occurs.  
**Baseline**  
The root of the project or database. Sometimes called mainline or trunk; depending on the SCC structure, this is where most of the development occurs.  
**Tag**  
A snapshot in time of the system or a project/subfolder in the system. Usually also associated with an annotation explaining the significance of that point of time. Also known as label.  
**Label**  
A snapshot in time of the system or a project/subfolder in the system. Usually also associated with an annotation explaining the significance of that point of time. Also known as tag.  
**Branch**  
A "copy" of subfolders and files that are controlled separately from the trunk with an intention to eventually merge back into the trunk.  
**Merge**  
Unifies two independant changes into one. Often the process of merging requires manual resolution of conflicts.  
**Merge Conflict  
**When two independant changes cannot be automatically merged.  
**Commit**  
Same as check in  
**Check in**  
When changes are written to the repository.  
**Head**  
The most recent version of code in the system.  
**Fork**  
For the most part, same as branch–depending on the SCC system. More fun to use than branch, "I forked the code".  
**Copy-modify-merge  
**Under this SCC model the SCC always merges changes back into the database (trunk or branch, depending on what you're editing).This model assumes a team model where there is the likely posibility of more than one person working on the same file at the same time. This model rarely precludes the ability to lock a file before modification if changes to the file cannot be merged). This is the preferred SCC model.  
**Lock-modify-unlock**  
Under this SCC model the SCC forces devs to lock files they wish to edit before modifying them. (with IDE integration this is often transparent).  
**ALM**  
Application lifecycle management.

**Practices  
****Don't use Visual SourceSafe for your SCC system.**  
Believe me, I've been there and have the scars to prove it. Visual SourceSafe (VSS) has a unique process that isn't mirrored by many majorcontemporary SCC systems. VSS is a distributed file-based SCC system and as such is prone to data corruption–not really something that is acceptable in any sort of "Control" system. Branching is really difficult in VSS. If you're one person and you have your VSS database on the same computer; you're likely fine. Otherwise, do yourself a huge favour and consider another SCC system, like Subversion (it's free). VSS doesn't scale well; as time goes on and the database increases in size, developers are added to the project, VSS gets slower and slower.

**Don't put generated code in SCC  
**SCC provides the ability to rollback to a state in the past that allows compilation of the solution. Code that is generated [edit start] as part of the/a build process [edit end] can be generated at any time; there's no need to put that code into SCC. With lock-modify-unlock SCC systems, generated code that is checked-in will be locked and cause errors during build unless you lock it on every build. This will cause conflicts in lock-modify-unlock systems in that you end up not being able to build while somone else is building (yes, you likely build serveral times a day).

**Make sure unit tests pass before checking in.**  
This means *all* unit tests. If you check in a change that causes a unit test to fail, someone else won't know where to start to make that unit test pass. You're wasting your time and setting the project schedule back by not ensuring unit tests pass before checking in changes. If your team allows it, use some sort of continuous integration suite. This allows you to get feedback upon every check-in that tells you whether all the unit tests pass. If you have an SCC or ALM that supports it, enable guards that force the unit tests to pass before changes are allowed into SCC.

**Work on one set of related changes at a time.**  
It's more efficient to work on one thing at a time. Switching back and forth from task to task means wasting time getting into a different frame of mind and sometimes a different configuration. This also causes issues with SCC in that you've now got modified files that you're not currently working on. The longer they're kept unmerged, the more likely there will be issues during merge (someone else made a changed that conflicts with yours, and if everyone else is checking in often, you're the one that has to deal with all the conflicts). The more things you're working on at once, the more likely that one set of changes becomes dependant on another and you simply can't check your files in until all the changes you're working on are complete. Work on one set of related changes at a time and check those changes in to avoid not merging your changes often.

**Check-in often.**  
SCC provides developers the ability to keep a history of their changes. But, this only works if you check your changes into the SCC system. When you have something that compiles, check it in. The more often you check changes into the SCC system the less likely you'll get into a situation where you have to deal with merge conflicts. The more often you check changes into the SCC system the least complex the changes will be. If the changes are not complex and you do run into a merge conflict, the less work will be involved in resolving the conflict. Do your sanity (and the sanity of your team mates) a favour and check in often. See next practice.

**Avoid leaving changes overnight.**  
Check in your workingchanges before you leave for the day. If it compiles and works (unit tests pass) there's likely no harm to checking in. Leaving work for an extended period of time means it's that much harder to get back into that mindset; if you check in and describe the check in, you now have a history of the day's changes with an annotation making it easier to get back in that mindset. But, since you've checked the files in, you may not need to get back into that mindset (if you didn't check in, you *must* get back in that mindset in order to check in).

**Never destroy SCC content.**  
SCC offers the ability to get back to a project state at any time in the past. If you destroy content from the system, this incapacitates this ability. It goes against keeping any sort of history of a project to destroy content, so don't do it unless you intend never to make use of the history for that project (i.e. you're destroying and entire project and you never intend to work on it again or support it).

**Don't Bypass Copy-modify-Merge**  
Eventually you'll be in a situation where you need to edit a file at the same time as another person. In this case you'll need to merge your changes. The copy-modify-merge model accepts this inevitable fact and makes merging a first-class citizen of your development process; not some nebulous process that occurs only occaisionally. With a properly designed system the need to merge should be minimized. I've seen teams instigate a policy that you must lock the file before you modify it. I've also seen teams configure a SCC provider to automatically lock a file when changes are made to it. This is the wrong thing to do on software development teams. It leads to one of two things: 1) people just stop working when they can't lock the file they need to edit; or 2) they end up forcing copy-modify-merge that isn't supported by the tools they're using, which often leads to human errors and errors in merging.

I hope to continue this series as time goes on, if you have suggested topics, please comment. I expect to keep pretty generic; but could get SCC-system-specific, if there's interest.

![kick it on DotNetKicks.com][1]

[1]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2009%2f03%2f11%2fdeveloping-with-source-code-control-best-practices-part-2.aspx


