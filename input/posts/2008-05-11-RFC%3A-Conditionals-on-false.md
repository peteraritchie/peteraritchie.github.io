---
layout: post
title: 'RFC: Conditionals on false'
tags: ['C#', 'Reader Questions', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/05/11/rfc-conditionals-on-false/ "Permalink to RFC: Conditionals on false")

# RFC: Conditionals on false

Just a small request for comments. [Oren prefers][1]

  

 if (GetTrueOrFalse() == false)

…instead of 

  

 if (!GetTrueOrFalse())

Coming from 18+ years of C/C++ based language programming, I find either equally readable; but, I'm not always the one reading my code.

What are you thoughts? Do you prefer the negation operator (!) or explicitly comparing with the false keyword?

[1]: http://tech.groups.yahoo.com/group/altdotnet/message/6138


