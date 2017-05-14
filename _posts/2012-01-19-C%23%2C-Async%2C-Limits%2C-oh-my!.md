---
layout: post
title: C#, Async, Limits, oh my!
date: 2012-01-18 19:00:00 -0500
categories: ['.NET Development', 'Async Functions', 'C#', 'Visual Studio']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2012/01/19/c-async-limits-oh-my/ "Permalink to C#, Async, Limits, oh my!")

# C#, Async, Limits, oh my!

One of the great sessions at [Codemash][1] was a dual-speaker session with Bill Wagner and Jon Skeet—[_Async from the Inside][2]_.

In that session Bill and Jon describe (in great detail) the state machine that the C# compiler generates when it compiles async code involving the await keyword.  When the Async CTP was released this state machine was one of the first things I noticed when I was reflecting through some generated code.  I too noticed the type of the state variable (int) and wondered, at the time, if that would be an issue.  All the information Bill, Jon and I portray is what we've learned from reflection, none of this is "insider information".

Some background: a state machine is generated for each method that uses the await keyword.  It manages weaving back-together the asynchronous calls that you so lovingly linearly describe in an async method.  The state machine not only weaves together the various "callbacks" that it generates, but it also (now) manages the state changes of the data being modified between and by asynchronous calls.  Wonderfully complex stuff.

The state variable is basically an enum of the various states between async calls that the generated code can be in.  I won't get into too much detail about that (you should have gone Codemash like all the other cool people 🙂 but needless to say having a "limit" on the number of states a method can be in sounds a bit scary.

Of course Jon, at one point, brought the same thing up in the session about the "int" state variable.  This reminded me that I wanted to look into it further—not because I wanted to break the compiler (directly) but to know what the limits are, if any.

A couple of days later while I had some time waiting around at airports on my way home.  I thought I'd test my theory.  If you follow me on [Twitter][3] you probably saw some of my discoveries in real time.  For those of you who didn't, here's an aggregation of what I found.

First of all, the state machine represents the async states a single method can be in.  This is represented by a signed int.  the only negative value that seems [1] to mean anything is –1, leaving 2,147,483,647 states (or, roughly, await invocations) that can occur in an async method.

First glance, this seems disconcerting.  I quickly wrote some code to generate a method with 2,147,483,648 await invocations in it (that's Int32.MaxValue + 1 for those without OCD).  Needless to say, that took a few minutes to generate on my laptop, and I have an SSD (which I've clocked at increasing my IO by about 7 times on average).  That generated a 45 gigabyte file (one class, one method).

Problems with the type int for the state variable started to seem ridiculous.  But, I didn't stop there.

Now I'm doing everything outside of Visual Studio (VS) from this point on.  I'm running the app to generate the code from within VS; but everything else is from the command-line.  So, I run CSC on the 45 gig file honestly expecting and internal compiler error.  But, what happens is that I get a CS1504 error _'file.cs' could not be opened ('Arithmetic result exceeded 32-bits. ')._  Now, the state variable is 32-bits so, it sounds like that could be the culprit.  But, if you look at the error message, it can't even open the file.  I tried opening the file in VS and it told me the file couldn't be found…

Okay, at this point it's seeming even more unlikely that a type of int for the state variable is even remotely going to be an issue.  But, now I'm curious about what 32-bit value has been exceeded.  My theory is now the number of lines in the file…  The compiler has to keep track of each line in the file in case it has to dump an error about it, maybe that's the 32-bit value? I modify my code generation to limit the the number of await invocations so the number of lines in the file is 2,147,483,647 (kind of a binary search, if this works then I know it still could be the number of lines in the file). Same error.

The error isn't from the # of lines.  Now my theory is that the overflow is from trying to allocate enough memory load the file (keep in mind, I've got 8 GB of RAM and I'm trying to load a 45GB file; but, I have yet to get an out of memory error).  So, I modify my code to generate a file that is approaching 2,147,483,647 bytes in size.  Things are much faster now…  I try again. Now I get the same CS1504 error but the message is _'file.cs' could not be opened ('Not enough storage available to complete this operation')_ (I've got 100 GB free space on the drive…).  Interesting.  I've lessened the data requirement and only now effectively getting "out of memory" errors.

Now I'm just looking for a file that the compiler will load—I've given up on some super-large number of await statements…  Longer story, short, I kept halving the size of the file until I reached about 270 megabytes in size then the compiler finally succeeded (meaning ~540 Megabytes failed).

At this point, I've successfully proven that a type of int for the state variable is not an issue.  _If_ the compiler _could_ load the 540 megabyte file _and_ I somehow _could_ use 8 bytes per await invocation ("await x;" for example) then I could never reach more than about 70,778,880 await calls in a single method.  Of course, I'm way off here; that number is even much lower; but 70,778,880 is about 3% of 2,147,483,647.  Clearly int is the smallest type that could store anything close to 70,778,880 or less…

Of course, I'm completely ignoring the fact that a 540 MB cs file is completely unmanageable in VS or a project in general; but, why get caught up in silly realities like that.

This state machine is almost identical to those generated by enumerator methods (yield return).  If we assumed that the async state machine generation code is "inherited" (by pragmatic reuse) from the enumerator method state machine generator, we can assume it has very similar limits (but even smaller)—meaning you'd never get close to overflowing its int state variable.

HTMYL.

[1] Again, this all observed; I'm surmising the compiler never uses any other negative value.

[1]: http://codemash.org
[2]: http://codemash.org/Sessions/Technology/.NET#Async+From+the+Inside
[3]: http://twitter.com/peterritchie

