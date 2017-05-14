---
layout: post
title: Working with Subversion, Part 1
categories: ['General', 'SCC', 'Software Development', 'Software Development Workflow', 'Subversion', 'SVN']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2011/11/11/working-with-subversion-part-1/ "Permalink to Working with Subversion, Part 1")

# Working with Subversion, Part 1

Working with multiple client projects and keeping abreast of the industry through browsing and committing to open source and other people's libraries means working with multiple source code control (SCC) systems.  One of the systems I use is Subversion (SVN).  It's no longer one of the SCCs I use most often so I tend to come back to it after long pauses and my SVN _fu_ is no longer what it used to be.  I'm sure my brain is damaged from this form of "task switching", not to mention the time I spend trying to figure out the less common actions I need to perform on a repository (repo).  I usually spend more than few minutes digging up the commands I need for the once-in-a-decade actions I need to perform.  

I don't foresee getting away from SVN in the near future; so, I'd thought I'd aggregate some of these commands into one place.  My blog is the perfect place to do that (because it's just for me, right? 🙂

### Backing Up

Outside of adding/committing, the most common action to be performed is backing up the repository.  Unfortunately for my brain this is automated and I don't **see** it for months at a time. To back up an SVN repository that you're not hosting or being hosted by third-party software (like [VisualSVN Server][1]) then I like dump/load:

svnadmin dump _repo-local-path_ > _repo-bkp-path _

This let's you restore to the host that contains all the configuration data like permissions, users, and hooks.

If the repository is completely autonomous (i.e, just a directory on your hard drive and _maybe_ an SVN daemon) then hotcopy is better:

svnadmin hotcopy _local-path_ _destination-path _

### Restoring

If you used the dump method of backing up, you need to use the load command to put the backup into an existing repository.  If you're not using a hosted repository, you'll first need to create the repository (svn create repo-local-path) to run load (in which case I'd recommend using hotcopy instead).  To load the dump into the existing repository:

svnadmin load _repo-local-path_ < _repo-bkp-path _

If you've used hotcopy then the backup is the fully functional repository; just make it available to users (i.e. put it where you want it :).

### Migrating

Migrating is basically just a backup and restore.  If you're backing up one repository and putting into an existing repository, use dump/load.  On System A

svnadmin dump _repo-local-path_ > _repo-bkp-path _

On System B after copying repo-bkp-path from System A

svnadmin load repo_-local-path_ < _repo-bkp-path _

Even if you weren't migrating to an existing repo, you could use this method; just add svnadmin create repo-local-path before svnadmin load.  The dump/load method has the added benefit of upgrading the data from one format to another if both systems don't have the same version of SVN running.  The drawback of migrating with dump/load is that you'll have to configure manually (or manually copy from the old repo) to get permissions, hooks, etc…

Now you've migrated your repo to another computer, existing working copies will be referencing the old URL.  To switch them to the new URL perform the following:

svn switch –relocate _repo-remote-URL _

### Creating Working Copy

If you don't already have a local copy of the repo to work with, the following command 

svn checkout _repo-remote-URL_ _working-copy-path _

### Committing Changes

I added this section because I've become used to GIT.  GIT has a working directory and staging area model; so you tag files in the working directory for staging before committing.  This allows you to selectively commit modifications/additions.  SVN is different in that the working directory is the staging area so you effectively have to commit all modifications at once.  (you can _stage_ adds because you manually tell SVN which files to start controlling).

svn status will tell you what's modified (M) and what's untracked (?).  To commit all modified 

svn commit –m "description of changings included in the commit"

### Undoing Add

Sometimes you a schedule something to add on commit by mistake or it's easier to add by wildcard and remove the files that you don't want to commit on your next commit.  To remove them from the next commit:

svn revert _file-path _   

Be careful with revert because if the file is already controlled this will revert your local modifications.

### Undoing Modifications

To revert the modifications you've made locally and restore a file to current revision in the repo:

svn revert _file-path _

### Resources

    <http://svnbook.org/>

 

What's your favourite SVN workflow?

[1]: http://www.visualsvn.com/server/

