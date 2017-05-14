---
layout: post
title: More Windows SDK Functions That Are Not Safe
categories: ['Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2006/09/27/more-windows-sdk-functions-that-are-not-safe/ "Permalink to More Windows SDK Functions That Are Not Safe")

# More Windows SDK Functions That Are Not Safe

Raymond Chen recently [blogged][1] that IsBadWritePtr, IsBadCodePtr, IsBadHugeReadPtr, IsBadHugeWritePtr, IsBadReadPtr, IsBadStringPtr, and IsBadWritePtr have side effects that basically render then useless.

Unlike methods like TerminateThread–when used to terminate any thread other than itself–that was never safe, the IsBadXXXPtr functions seem to not have evolved with the rest of the system and have had no attempt to deprecate them.

[1]: http://blogs.msdn.com/oldnewthing/archive/2006/09/27/773741.aspx

