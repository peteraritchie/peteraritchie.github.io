---
layout: post
title: volatile–You Keep Using That Word, But I Do Not Think You Know What It Means
date: 2013-10-14 20:00:00 -0400
categories: ['C/C++', 'Design/Coding Guidance', 'Software Development', 'Software Development Guidance', 'Win32']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2013/10/15/volatileyou-keep-using-that-word-but-i-do-not-think-you-know-what-it-means/ "Permalink to volatile–You Keep Using That Word, But I Do Not Think You Know What It Means")

# volatile–You Keep Using That Word, But I Do Not Think You Know What It Means

Princess Bride has some of the best quotes…  But, more to the topic; I've been bitten by people using volatile in code that I've had to work with.  In fact, I think I've been bitten by every single use of volatile at least once.  Why?  As Inigo Montoya says "You keep using that word.  But I do not think you know what it means".  Computer languages have their unique misunderstandings, but volatile seems global.  I'm mentioned it before in a narrower context, but I keep having to fix its usage and felt there to be benefit to mentioning it again in a different context—despite inviting criticisms that will likely result.

volatile stems from C.  It was added well before multi-core processors were affordable or even prevalent.  It was also added well before multi-threading became realistically available in C.  Simple induction should quickly bring you to the conclusion that volatile has nothing to do with multi-threading and concurrency.  And while "volatile" might not have been the best choice of words given what we know now, hindsight is 20/20.

Unfortunately there is a lot (and I mean **a lot**) of misinformation about volatile and concurrency.  Almost every venue you look you'll see comments like

> [volatile is] intended to be used in conjunction with variables that are accessed and modified in different threads.

In terms of C/C++, volatile has some specific mandates.  As detailed by the standards committee [1]:

* Consistency of memory mapped devices, 
* Consistency of variables used between setjmp and longjmp
* Consistency of sig_atomic_t variables in signal handlers

All of these mandates apply to single-thread scenarios and the second two deal with asynchronous execution (i.e. the order of execution is not determined at compile-time).  volatile only tells the compiler not to optimize use of a particular variable—it does not make its access atomic and it does not make its access any more thread-safe than any other access to memory the compiler generates.  It only tells the compiler that a read to, or a write from, that variable should always results in a memory access, in the order in which it was written.  This prevents _reordering_, but only by the compiler.

## But, Strong Memory Models!

This has to be the biggest logical fallacy in software engineering.  The fact that on a strong memory model architecture (like x86) that volatile *fixes* bugs in multi-threaded code is simply an accident.  Yes, you want variable accesses to be deterministic memory accesses when that variable is shared across threads, but you also want to ensure atomicity as well as cache coherency.  volatile does neither of these things (the variable access **was already atomic** and some level of cache coherency already existed).  So, in effect, use of volatile to "fix" this bugs really only fixed one of three potential bugs—that is, you're getting beneficial side-effects for an unintended reason.

The fact that volatile gives you beneficial side-effects only under certain memory model is more proof that volatile does not mean what you think it means.

## Deterministic Memory Access

"memory" is a funny thing with multi-core processors.  Direct memory access is expensive and if a processor can avoid it (i.e. use a cache) and thus improves the effective speed of the processor).  While a "write" to memory on one core really does mean a write to memory, another core may not see it because it reads from its cache.  This is especially true of re-ordering.  I know of no multi-core processor that does not have re-ordering gotchas with regard to memory access (even x86[1]).

Deterministic memory access should be, well, deterministic right?  You need to know that a read/write to a variable is really a memory access.  But, do you need it **all the time**?  Likely not.  You are not accessing a piece of mapped memory that must **always** occur, you want to make sure that what you do to a variable is visible to other threads—when it _needs_ to be visible.  That is, the result of the use of any variable is a multi-step process (e.g. it's read and an action is performed based on the value it had _in the past_). You almost always need the value to be visible only at specific times—"communicating" across threads is collaborative and deterministic.  volatile doesn't do this for you, it makes it _visible_ (caveat is that it might be reordered even on x86) _all the time_.  We use compilers for a reason, let them do what they're good at.

## Atomicity

You can't apply volatile on types that aren't already atomically accessed (another hint that volatile does not mean what you think it means).  So, what do you do for atomicity?  This, of course is platform dependant (yet another hint).  On Windows, this likely depends on what you're doing.  You can only really share variables within a single memory space (process), so using intra-process synchronization is your best bet here (despite all inter-process synchronization having the same side-effect).  For example:

Other intra-process synchronization techniques can also be used, like Interlocked*, reader/writer locks, etc.  But, they're generally optimizations and should be used only after analysis and critical thinking.

## volatile and C/C++

In fact, the standards committee's position on whether volatile should _expand_ to include atomicity and thread visibility (because, hint, it doesn't) is that volatile will **not expand** to include atomicity and thread visibility[2].

## volatile outside of C/C++

In terms of managed languages like C+ and Java, volatile suffers from these past mandates.  In C# volatile does actually mean acquire and release semantics—which really just pushes a strong memory model regardless of platform that runs the application.  This results, effectively, in making C# volatile the same as C volatile.  Not that that is a bad thing, but there's no such thing as setjmp/longjmp, sig_atomic_t/signals, or memory mapping (at least in the device context) in .NET.  In fact, the more I have to deal with volatile in any context  the more I truly believe volatile should never had been added to C#—it's addition was clearly based on the misconception that volatile in C relates to thread-safety/concurrency (even if that misconception might be indirect via Java).

[1] <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n2016.html>

[2] <http://bartoszmilewski.com/2008/11/05/who-ordered-memory-fences-on-an-x86/>

