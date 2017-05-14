---
layout: post
title: Working with Subversion Part 2 (or Subversion for the Less Subversive)
categories: ['General', 'SCC', 'Software Development', 'Software Development Workflow', 'Subversion', 'SVN']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2011/11/17/working-with-subversion-part-2-or-subversion-for-the-less-subversive/ "Permalink to Working with Subversion Part 2 (or Subversion for the Less Subversive)")

# Working with Subversion Part 2 (or Subversion for the Less Subversive)

In my previous Subversion (SVN) post I detailed some basic commands for using SVN for source code control.  If you're working alone you could get by with [Part 1][1].  But, much of the time you're working in a team of developers working on versioned software that will be deployed to multiple places.  This post will detail some more advanced commands for systematically using SVN to simultaneously work on multiple editions and versions of a software project. (hence the "less subversive").

### Practices

The basic concept of working on two editions or two versions of a software project at the same time is considered "branching".  Simultaneous work is each done on it's own "branch" (or "fork") of the project.  Branch can be considered "copy"; but that's generally only true at the very start of the branch.  With any project you can add and remove files from it; at which point a branch ceases to become a "copy".  Semantics aside, SVN doesn't really have a concept of a "branch".  This is a _practice_ used by SVN users.  SVN really only knows how to "copy" and "merge".  The practice is the create a standard location to control branches, copy existing files and directories to a branch location, and merge changes from a branch to another location (like the trunk).  To support branching many repositories (repos) have a "trunk" and "branches" folder in the project root.  Trunk work is obviously done in the "trunk" folder and branches are recreated in the "branches" folder.

### Branching Strategies

Before getting too much farther taking about things like "trunk"; it's a good idea to briefly talk about branching strategies.  The overwhelming branching strategy for SVN users has been the "trunk" or "main line" branching strategy.  This strategy basically assumes there is really one "main" software product that evolves over time and that work may spawn off from this main line every so often to work independently and potentially merge back in later.  In this strategy the "current" project is in the "trunk".

Another strategy is sometimes called the Branch per Release strategy which means there's a branch that represents the current version of the project and when that version is "released" most work transitions to a different branch.  Work can always more from one branch to another; but there's no consistent location that project files are located over time.  This a perfectly acceptable strategy and almost all Source Code Control (SCC) systems support it.  The lack of a consistent location of files makes discovery difficult and it really forces the concept of branching onto a team.  I've never really found this strategy to be very successful with the teams I've worked on, so I prefer the trunk strategy.

### Branching

Branching is fairly easy in SVN.  The recommended practice is the perform a copy on the server then pull down a working copy of that branch to perform work on.  This can be done with the svn copy command, for example:

svn copy http://svnserver/repos/projectum/trunk http://svnserver/repos/projectum/branches/v1.0 -m "Created v1.0 branch" 

…which makes a copy of the trunk into the branches/v1.0 folder.

Now, if you checkout the root of the project (e.g. svn checkout http://svnserver/repos/projectum) you'll have all the files the trunk and all the branches.  You can now go edit a file in branches/v1.0 in your working copy and svn commit will commit that to the branch.  If you want to just work with a branch in your working copy you can checkout just the branch.  For example:

svn checkout http://svnserver/repos/projectum/branches/v1.0 . 

..which makes a copy of all the files/directories in v.1.0 to the current local directory.  So, if you had …/branches/v1.0/readme.txt in the repo, you'd now have readme.txt in the current local directory.

Same holds true for the trunk, if you want to work on files in the trunk independently of any other branches checkout just the trunk, for example:

svn checkout http://svnserver/repos/projectum/trunk . 

It's useful to work just with the trunk or just with a branch because over time you may have many branches.  Pulling down the trunk and all branches will get time-consuming over time.

While SVN doesn't really have the concept of a "branch", it does know about copies of files and tracks changes to those copies.  So, if you shows a log of the changes to a file you'll see the commit comments for all the branches too.  For example, edit readme.txt in the branch directory and commit the change (svn commit –m "changed readme.txt" for example) then go back to the trunk directory and show the log of readme.txt, for example:

svn log –v readme.txt 

…you'll see the commit comments for both trunk/readme.txt and branches/v1.0/readme.txt.  For example":

————————————————————————   
r2 | PRitchie | 2011-11-17 10:23:36 -0500 (Thu, 17 Nov 2011) | 1 line   
Changed paths:   
   A /trunk/readme.txt   
initial commit   
————————————————————————

### Merging

Okay, you've been working in v1.0 for a few days now, committing changes for v1.0.  One of those changes was a bug fix that someone reported in v1.0.  You know that bug is still in the trunk and it's time to fix it in the trunk too.  Rather than go perform the same editing steps in the trunk, you can merge that change from the v1.0 branch into the trunk. For example, a typo fixed in the readme.txt needs to be merged into the trunk, from a clean trunk working copy (no local modifications):

svn merge http://svnserver/repos/projectum/branches/v1.0

This merges the changes from v1.0 into the working copy of trunk.  You can now review the merges to make sure they're want you want, then commit them":

svn commit –m "merged changes from v1.0 into trunk"

### Merge Conflicts

Of course, sometimes changes are made in the trunk and a branch that conflict with each other (same line was changed in both copies).  If that happens SVN will give you a message saying there's a conflict:

Conflict discovered in 'C:/dev/projectum/trunk/readme.txt'.   
Select: (p) postpone, (df) diff-full, (e) edit,   
        (mc) mine-conflict, (tc) theirs-conflict,   
        (s) show all options:

You're presented with several options.  One is to postpone, which means the conflict is recorded and you'll resolve it later.  You can see the differences with diff-full.  Or you can accept the left or the right file as iss with mine-conflict or theirs-conflict—to accept the local file, use mine-conflict.  There's also edit, which will allow you to edit the merged file showing the conflicts.  For example:

one   
<<<<<<< .working   
three=======   
four >>>>>>> .merge-right.r9

This details that your working file has a changed second line "three" but the remote version has a changed second line "four ".  The lines wrapped  with <<<<<<< .working and ======= is the local change, which is followed by the remote change and >>>>>>> .merge-right.r9.  The "merge-right.r9" is diff syntax telling you which side the change came from and which revision (r9 in this case).  You can edit all that diff syntax out and get the file the way you want to merge it, then save it.  SVN will notice the change and present options again:

Select: (p) postpone, (df) diff-full, (e) edit, (r) resolved,   
        (mc) mine-conflict, (tc) theirs-conflict,   
        (s) show all options:

Notice you now have a resolved option.  If your edits fixed the conflict you can choose resolved to tell SVN the conflict is gone.  You can then commit the changes and the merges will be committed into the repo. 

### Merging Without Branches

Of course branches aren't the only source for merges.  You might be working on a file in the trunk that a team member is also working on.  If you want to merge any changes they've committed into your working copy, you can use the update command.  For example:

svn update

This will merge any changes files with your local files.  Any conflicts will appear the same way they did with svn merge.

It's **important** to note that with SVN you can't commit changes if your working copy was out of date with the repo.  (e.g. someone committed a change after you performed checkout).  If this happens you'll be presented with a message similar to:

Transmitting file data .svn: E155011: Commit failed (details follow):   
svn: E155011: File 'C:devprojectumtrunkreadme.txt' is out of date   
svn: E170004: Item '/trunk/readme.txt' is out of date

This basically just means you need to run svn update before you commit to perform a merge and resolve any conflicts.

### Mouse Junkies

If you don't generally work with command-line applications and don't care for the speed increase of not using the mouse, there's some options you can use to work with SVN.

#### TortoiseSVN

TortoiseSVN is a Windows Explorer extension that shows directories/files controlled with SVN differently within Explorer.  It will show directories and files that have been modified or an untracked with different icons (well, icon overlays) within Explorer.  It will also let you perform almost all SVN commands from with explorer (via context menu).

#### VisualSVN

VisualSVN provides much of the same functionality as TortoiseSVN but does it within Visual Studio.  It's not Source Code Control Visual Studio extension; which is interesting because you can use VisualSVN and another source code control extension (like TFS) at the _same time_.  VisualSVN requires TortoiseSVN to work correctly, so install that first.

Both TortoiseSVN and VisualSVN make dealing with merge conflicts easier.  I recommend using these for merging instead of the command-line.

### Resources

<http://svnbook.org/>

[1]: http://bit.ly/tRsITC

