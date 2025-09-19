---
layout: post
title: 'Unable to resolve reference refs/remotes/origin/master'
tags: ['GIT', 'Software Development', 'msmvps']
disqus_id: "1431 http://blog.peterritchie.com/?p=1431"
---
[Source](http://pr-blog.azurewebsites.net/2014/02/27/unable-to-resolve-reference-refsremotesoriginmaster/ "Permalink to Unable to resolve reference refs/remotes/origin/master")

# Unable to resolve reference refs/remotes/origin/master

### Post navigation

[← Previous][1] [Next →][2]

I had just rebooted from a BSOD the other day and started up GitHub after making some changes to code. Much to my chagrin Github complained it was unable to load the commits (or some such thing) and suggested I go to a shell to to debug.

I went PowerShell to see what was going on. git status didn't show me anything out of the ordinary, so I simply performed the git adds I wanted, git commit, then git push. And that's when I got a complaint about "Unable to resolve reference refs/remotes/origin/master…".

I'm not sure why it would be confused about this, it's not as if the master had changed or anything. So, I opened up the master file and it was full of spaces! Well, that's no good. In order to fix it, I did this:

Et viola, Github is happy again.

This entry was posted in [GIT][3], [Software Development][4] by [PeterRitchie][5]. Bookmark the [permalink][6]. 

[1]: http://pr-blog.azurewebsites.net/2014/02/24/generating-windows-phone-and-windows-store-application-imagesthe-vector-version/
[2]: http://pr-blog.azurewebsites.net/2014/03/23/the-case-of-the-not-so-useful-xbf-error/
[3]: http://pr-blog.azurewebsites.net/category/git/
[4]: http://pr-blog.azurewebsites.net/category/softdev/
[5]: http://pr-blog.azurewebsites.net/author/peterritchie/
[6]: http://pr-blog.azurewebsites.net/2014/02/27/unable-to-resolve-reference-refsremotesoriginmaster/ "Permalink to Unable to resolve reference refs/remotes/origin/master"


