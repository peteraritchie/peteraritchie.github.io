---
layout: post
title:  "Thread synchronization of atomic invariants in .NET 4.5 clarifications"
redirect_from: "/2012/09/10/thread-synchronization-of-atomic-invariants-in-net-4-5-clarifications/"
date:   2012-09-09 12:00:00 -0600
categories: ['.NET 4.5', '.NET Development', 'Concurrency', 'DevCenterPost', 'Multithreaded', 'Software Development Guidance']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2012/09/10/thread-synchronization-of-atomic-invariants-in-net-4-5-clarifications/ "Permalink to Thread synchronization of atomic invariants in .NET 4.5 clarifications")

# Thread synchronization of atomic invariants in .NET 4.5 clarifications

In [Thread synchronization of atomic invariants in .NET 4.5][1] I'm presenting my observations of what the compiler does in very narrow context of only on Intel x86 and Intel x64 with a particular version of .NET.  You can install SDKs that give you access to compilers to other processors.  For example, if you write something for Windows Phone or Windows Store, you'll get compilers for other processors (e.g. ARM) with memory models looser than x86 and x64.  That post was only observations in the context of x86 and x64.  

I believe more knowledge is always better; but you have to use that knowledge responsibly.  If you know you're only ever going to target x86 or x64 (and you don't if you use AnyCPU even in VS 2012 because some yet-to-be-created processor might be supported in a future version or update to .NET) and you _do want to micro-optimize your code_, then that post might give you enough knowledge to do that.  Otherwise, take it with a grain of salt.  I'll get into a little bit more detail in part 2: Thread synchronization of non-atomic invariants in .NET 4.5 at a future date—which will include more specific guidance and recommendations.

In the case were I used a _really awkwardly placed_ lock:
    
    
       1: var lockObject = new object();
    
    
       2: while (!complete)
    
    
       3: {
    
    
       4:     lock(lockObject)
    
    
       5:     {
    
    
       6:         toggle = !toggle;
    
    
       7:     }
    
    
       8: }

It's important to point out the degree of implicit side-effects that this code depends on.  One, it assumes that the compiler is smart enough to know that a while loop is the equivalent of a series of sequential statements.  e.g. this is effectively equivalent to:
    
    
       1: var lockObject = new object();
    
    
       2: if (complete == false) return;
    
    
       3: lock (lockObject)
    
    
       4: {
    
    
       5:     toggle = !toggle;
    
    
       6: }
    
    
       7: if (complete == false) return;
    
    
       8: lock (lockObject)
    
    
       9: {
    
    
      10:     toggle = !toggle;
    
    
      11: }
    
    
      12: //...

That is, there is the implicit volatile read (e.g. a memory fence, from the Monitor.Enter implementation detail) at the start of the lock block and an implicit volatile write (e.g. a memory fence, from the Monitor.Exit implementation detail).

In case it wasn't obvious, you should **never write code like** this, it's simply an example—and as I pointed out in the original post, it's confusing to anyone else reading it: lockObject can't be shared amongst threads and the lock block really isn't protecting toggle and can/likely to get "maintained" into something that no longer works.

In the same grain, the same can be said for the original example of this code:
    
    
       1: static void Main()
    
    
       2: {
    
    
       3:   bool complete = false; 
    
    
       4:   var t = new Thread (() =>
    
    
       5:   {
    
    
       6:     bool toggle = false;
    
    
       7:     while (!complete)
    
    
       8:     {
    
    
       9:         Thread.MemoryBarrier();
    
    
      10:         toggle = !toggle;
    
    
      11:     }
    
    
      12:   });
    
    
      13:   t.Start();
    
    
      14:   Thread.Sleep (1000);
    
    
      15:   complete = true;
    
    
      16:   t.Join();
    
    
      17: }

While this code works, it's not apparently clear that the Thread.MemoryBarrier() is there so that our read of complete (and not toggle) isn't optimized into a registry read.  Regardless of the degree you might be able to depend on the compiler continuing to do this is up to you.  The code is equally as valid and more clear if written to use Thread.VolatileRead, except for the fact that Thread.VolatileRead does not support the Boolean type.  It can be re-written using Int32 instead.  For example:
    
    
       1: static void Main(string[] args)
    
    
       2: {
    
    
       3:   int complete = 0; 
    
    
       4:   var t = new Thread (() =>
    
    
       5:   {
    
    
       6:     bool toggle = false;
    
    
       7:     while (Thread.VolatileRead(ref complete) == 0)
    
    
       8:     {
    
    
       9:         toggle = !toggle;
    
    
      10:     }
    
    
      11:   });
    
    
      12:   t.Start();
    
    
      13:   Thread.Sleep (1000);
    
    
      14:   complete = 1; // CORRECTION from 0
    
    
      15:   t.Join();
    
    
      16: }

Which is more clear and shows your intent more explicitly.

[1]: http://blogs.msmvps.com/blogs/peterritchie/archive/2012/09/09/thread-synchronization-of-atomic-invariants-in-net-4-5.aspx

