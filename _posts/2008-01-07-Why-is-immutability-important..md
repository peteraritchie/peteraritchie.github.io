---
layout: post
title: Why is immutability important.
date:   2008-01-06 19:00:00 -0500
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/01/07/why-is-immutability-important/ "Permalink to Why is immutability important.")

# Why is immutability important.

There's been some discussion about the adding the ability for immutable types in a future CLR and C# (I assume other .NET languages in the same timeframe would follow suit; but, to be honest, I don't follow the other popular ones).  But, some of you are wondering, "why?"

Is this simply just an off-shoot of C++'s "const"?  Not really.  The proposed immutabilities would be compile and run-time enforced.  C++'s const can be casted-away.

There's a few techniques to writing thread-safe/concurrent/parallel code, amongst them: messenging and locking/synchronization.  Messenging works because each thread is supposed operate on a copy of the data or each thread is part of a work-flow waiting on a message from another to do its work.  This works in two parts: one no thread is operating with same data at the same time as another, and dependant threads awaken/start another thread as they sleep/stop via a message.  Unless your programming language supports/implements this method of threading, you have to write a large and complex framework for it to work.  The other technique, which is most prevalent with C#, is locking/synchronization.  Each thread let's other thread know that it's working on specific data by taking a lock.  No other threads can take the lock, so whatever that lock is guarding (yes, that assumes both threads do anything with that data lock the same lock) causes data access to be "synchronized" amongst the threads.  This works; but locking is really slow.  .NET includes the Monitor class specifically to get a user-mode synchronization primitive.  Using the Windows synchronization objects (like mutexes) require a kernal mode round-trip which is really expestive.  This is why you see other techniques like "low-lock".  Locking is more diffuclt than messenging because any thread is free to have multiple locks.  "Lock-leveling" is a way to compensate for this, but it's still very difficult and time-consuming to get right.

I'm a big fan of being explicit when I'm designing and programming.  In C#, If I haven't designed a class to be a base class, I declare sealed and the compiler will raise an error if someone tries to derive from that class.  In C++, if I don't modify the value of a parameter I declare it const; if the code was changed to modify the value, the compiler will raise an error.  If I've designed a class to be immutable, it would be nice to be able to declare it immutable and be enforced.

There are a few benefits to being able to declare a class immutable.  One is that I can then be free not to worry about using an instance of that type by multipe threads–it is thread-safe.  You can write code /now/ to create a type that exhibits immutability; but if you work with many different developers like I do, you have no way to enforce that (to the point where the compiler will raise an error and poke the person who made the change and reenforce my design constraints).  Another is the ability to embrace functional programming paradigms.  Much of the functional programming space hinges on immutable data.  And yet another is the ability to declare a type with true value semantics.  

There are other benefits, but they mostly relate to being able to enforce a design constraint, like implementing temporal object pattern, etc.

Could immutability simply be another contract in an ability to enforce design contracts?  Sure, that's one way of doing it.  It requires a contract framework to support it (Spec#) but it could be part of that.  Could it live all on it's own?  Of course, you could do something similar to other run-time and compile-time features (get a reference)

