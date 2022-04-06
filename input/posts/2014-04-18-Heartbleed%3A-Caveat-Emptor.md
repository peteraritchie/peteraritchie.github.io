---
layout: post
title: 'Heartbleed: Caveat Emptor'
tags: ['Heartbleed', 'Security', 'msmvps', 'April 2014']
---
[Source](http://pr-blog.azurewebsites.net/2014/04/18/heartbleed-caveat-emptor/ "Permalink to Heartbleed: Caveat Emptor")

# Heartbleed: Caveat Emptor

### Post navigation

[← Previous][1] [Next →][2]

The news sounds relatively good about Heartbleed: the problem is known, a patch as been made to OpenSSL and that's being applied in many places.

So, emails are rolling out from affected sites saying "change your password". But, you should be leery, and here's why:

## Was the site patched!?

I have seen too many emails that don't point out that they've actually patched the problem on their site! The downshot of that is that changing a password is going to be done over TLS (https) and require username/password information over that "encrypted" pipe. If they haven't patched their site, you're guaranteeing you're putting your account on that site at risk! You may not have entered a password on that site since the heartbleed bug was created (or before it was known and exploitable) and may not have been at risk before now. Changing your password on an unpatched site guarantees you'll be at risk!

## Have your admins been compromised!?

Admins of a site go through the same https security as the rest of us—who's to say they haven't been compromised? Given the previous section, if they have been compromised (and a patch hasn't been installed yet) then it would seem (from a bad-guy's point of view) that sending out an email to change passwords is an excellent idea to get *more* passwords!

## Caveat Emptor

Beware! You can't *really* trust some email you get. Make sure that you use one or more trusted ways **of detecting heartbleed (or lack thereof) before you change your password**!

All the security pundits saying _rush out and change your password_ isn't really helping either.

This entry was posted in [Heartbleed][3], [Security][4] by [PeterRitchie][5]. Bookmark the [permalink][6]. 

[1]: http://pr-blog.azurewebsites.net/2014/04/17/ssl-is-not-the-basis-of-mission-critical-security/
[2]: http://pr-blog.azurewebsites.net/2014/04/20/on-performance-of-immutable-collections/
[3]: http://pr-blog.azurewebsites.net/category/heartbleed/
[4]: http://pr-blog.azurewebsites.net/category/security/
[5]: http://pr-blog.azurewebsites.net/author/peterritchie/
[6]: http://pr-blog.azurewebsites.net/2014/04/18/heartbleed-caveat-emptor/ "Permalink to Heartbleed: Caveat Emptor"


