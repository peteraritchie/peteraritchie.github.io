---
layout: post
title: 'Thread synchronization of atomic invariants in .NET 4.5'
tags: ['.NET 4.5', '.NET Development', '.NET', 'C#', 'Concurrency', 'DevCenterPost', 'Multithreaded', 'Software Development Guidance', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2012/09/09/thread-synchronization-of-atomic-invariants-in-net-4-5/ "Permalink to Thread synchronization of atomic invariants in .NET 4.5")

# Thread synchronization of atomic invariants in .NET 4.5

I've written before about multi-threaded programming in .NET (C#). Spinning up threads and executing code on another thread isn't really the hard part. The hard part is synchronization of data between threads.

Most of what I've written about is from a processor agnostic point of view. It's written from the historical point of view: that .NET supports many processors with varying memory models. The stance has generally been that you're programming for the .NET memory model and not a particular processor memory model.

But, that's no longer entirely true. In 2010 Microsoft basically dropped support for Itanium in both Windows Server and in Visual Studio ([http://blogs.technet.com/b/windowsserver/archive/2010/04/02/windows-server-2008-r2-to-phase-out-itanium.aspx)][1]. In VS 2012 there is no "Itanium" choice in the project Build options. As far as I can tell, Windows 2008 R2 is the only Windows operating system, still in support, that supports Itanium. And even Windows 2008 R2 for Itanium is not supported for .NET 4.5 ([http://msdn.microsoft.com/en-us/library/8z6watww.aspx)][2]

So, what does this mean to really only have the context of running only x86/x64? Well, if you really read the documentation and research the Intel x86 and x64 memory model this could have an impact in how you write multi-threaded code with regard to shared data synchronization. x86 and x64 memory models include guarantees like "In a multiple-processor system…Writes by a single processor are observed in the same order by all processors." but doesand also includes guarantees like "Loads May Be Reordered with Earlier Stores to Different Locations". What this really means is that a store or a load to a single location won't be reordered with regard to a load or a store to the same location across processors. That is we don't _need_ fences to ensure a store to a single memory location is "seen" by all threads or that a load from memory loads the "most recent" value stored. But, it does mean that in order for _multiple stores_ to _multiple locations_ to be viewed by other threads _in the same order_, a fence is necessary (or the group of store operations is invoked as an atomic action through the user of synchronization primitives like Monitor.Enter/Exit, lock, Semaphore, etc.) (See section 8.2 Memory Ordering of the [Intel Software Developer's Manual Volume 3A][3] found [here][4]). But, that deals with non-atomic invariants which I'll detail in another post.

To be clear, you could develop to just x86 or just x64 prior to .NET 4.5 and have all the issues I'm about to detail.

Prior to .NET 4.5 you really programmed to the .NET memory model. This has changed over time since ECMA defined it around .NET 2.0; but that model was meant to be a "supermodel" to deal with the fact that .NET could be deployed to different CPUs with disparate memory models. Most notably was the Itanium memory model. This model is much looser than the Intel x86 memory model and allowed things like a store without a release fence and a load without an acquire fence. This meant that a load or a store might be done only in one CPU's memory cache and wouldn't be flushed to memory until a fence. This also meant that other CPUs (e.g. other threads) may not see the store or may not get the "latest" value with a load. You can explicitly cause release and acquire fences with .NET with things like Monitor.Enter/Exit (lock), Interlocked methods, Thread.MemoryBarrier, Thread.VolatileRead/VolatileWrite, etc. So, it wasn't a big issue for .NET programmers to write code that would work on an Itanium. For the most part, if you simply guarded all your shared data with a lock, you were fine. lock is expensive, so you could optimize things with Thread.VolatileRead/VolatileWriter if your shared data was inherently atomic (like a single int, a single Object, etc) or you could use the volatile keyword (in C#). The conventional wisdom has been to use Thread.VolatileRead/VolatileWrite rather than decorate a field with volatile because you may not need _every_ access to be volatile and you don't want to take the performance hit when it doesn't _need_ to be volatile.

For example (borrowed from [Jeffrey Richter][5], but slightly modified) shows synchronizing a static member variable with Thread.VolatileRead/VolatileWrite:
    
    
       1: public static class Program {
    
    
       2:   private static int s_stopworker;
    
    
       3:   public static void Main() {
    
    
       4:     Console.WriteLine("Main: letting worker run for 5 seconds");
    
    
       5:     Thread t = new Thread(Worker);
    
    
       6:     t.Start();
    
    
       7:     Thread.Sleep(5000);
    
    
       8:     Thread.VolatileWrite(ref s_stopworker, 1);
    
    
       9:     Console.WriteLine("Main: waiting for worker to stop");
    
    
      10:     t.Join();
    
    
      11:   }
    
    
      12:  
    
    
      13:   public static void Worker(object o) {
    
    
      14:     Int32 x = 0;
    
    
      15:     while(Thread.VolatileRead(ref s_stopworker) == 0)
    
    
      16:     {
    
    
      17:       x++;
    
    
      18:     }
    
    
      19:   }
    
    
      20: }



Without the call to Thread.VolatileWrite the processor could reorder the write of 1 to s_stopworker to after the read (assuming we're not developing to on particular processor memory model and we're including Itanium). In terms of the compiler, without Thread.VolatileRead it could cache the value being read from s_stopworker in to a register. For example, removing the Thread.VolatileRead, the compiler optimizes the comparison of s_stopworker to 0 in the while to single register (on x86):


    
    
    00000000  push        ebp 
    
    
    00000001  mov         ebp,esp 
    
    
    00000003  mov         eax,dword ptr ds:[00213360h] 
    
    
    00000008  test        eax,eax 
    
    
    0000000a  jne         00000010 
    
    
    0000000c  test        eax,eax 
    
    
    0000000e  je          0000000C 
    
    
    00000010  pop         ebp 
    
    
    00000011  ret 

The loop is 0000000c to 0000000e (really just testing that the eax register is 0). Using Thread.VolatileRead, we'd always get a value from a physical memory location:
    
    
    00000000  push        ebp 
    
    
    00000001  mov         ebp,esp 
    
    
    00000003  lea         ecx,ds:[00193360h] 
    
    
    00000009  call        71070480 
    
    
    0000000e  test        eax,eax 
    
    
    00000010  jne         00000021 
    
    
    00000012  lea         ecx,ds:[00193360h] 
    
    
    00000018  call        71070480 
    
    
    0000001d  test        eax,eax 
    
    
    0000001f  je          00000012 
    
    
    00000021  pop         ebp 
    
    
    00000022  ret 

The loop is now 00000012 to 0000001f, which shows calling Thread.VolatileRead each iteration (location 00000018). But, as we've seen from the Intel documentation and guidance, we don't really need to call VolatileRead, we just don't want the compiler to optimize the memory access away into a register access. This code _works_, but we take the hit of calling VolatileRead which forces a memory fence through a call to Thread.MemoryBarrier after reading the value. For example, the following code is equivalent:
    
    
    while(s_stopworker == 0)
    
    
    {
    
    
      Thread.MemoryBarrier();
    
    
      x++;
    
    
    }

And this works equally as well as using Thread.VolatileRead, and compiles down to:
    
    
    00000000  push        ebp 
    
    
    00000001  mov         ebp,esp 
    
    
    00000003  cmp         dword ptr ds:[002A3360h],0 
    
    
    0000000a  jne         0000001A 
    
    
    0000000c  lock or     dword ptr [esp],0 
    
    
    00000011  cmp         dword ptr ds:[002A3360h],0 
    
    
    00000018  je          0000000C 
    
    
    0000001a  pop         ebp 
    
    
    0000001b  ret 

The loop is now is 0000000c to 00000018. As we can see at 0000000c we have an extra "lock or" instruction—which is what the compiler optimizes a call to Thread.MemoryBarrier to. This instruction really just or's 0 with what esp is pointing to (i.e. "nothing", zero or'ed with something else does not change the value). But the lock prefix forces a fence and is less expensive than instructions like mfence. But, based on what we know of the x86/x64 memory model, we're only dealing with a single memory location and we don't _need_ that lock prefix—the inherent memory guarantees of the processor means that our thread can see any and all writes to that memory location without this extra fence. So, what can we do to get rid of it? Well, using volatile actually results in code that doesn't generate that lock or instruction. For example, if we change our code to make s_stopworker volatile:
    
    
       1: public static class Program {
    
    
       2:   private static volatile int s_stopworker;
    
    
       3:   public static void Main() {
    
    
       4:     Console.WriteLine("Main: letting worker run for 5 seconds");
    
    
       5:     Thread t = new Thread(Worker);
    
    
       6:     t.Start();
    
    
       7:     Thread.Sleep(5000);
    
    
       8:     s_stopworker = 1;
    
    
       9:     Console.WriteLine("Main: waiting for worker to stop");
    
    
      10:     t.Join();
    
    
      11:   }
    
    
      12:  
    
    
      13:   public static void Worker(object o) {
    
    
      14:     Int32 x = 0;
    
    
      15:     while(s_stopworker == 0)
    
    
      16:     {
    
    
      17:       x++;
    
    
      18:     }
    
    
      19:   }
    
    
      20: }

We tell the compiler that we don't want accesses to s_stopworker optimized. This then compiles down to:
    
    
    00000000  push        ebp 
    
    
    00000001  mov         ebp,esp 
    
    
    00000003  cmp         dword ptr ds:[00163360h],0 
    
    
    0000000a  jne         00000015 
    
    
    0000000c  cmp         dword ptr ds:[00163360h],0 
    
    
    00000013  je          0000000C 
    
    
    00000015  pop         ebp 
    
    
    00000016  ret 

The loop is now 0000000c to 00000013. Notice that we're simply getting the value from memory on each iteration and comparing it to 0. There's no lock or. One less instruction and no extra memory fence. Although in many cases it doesn't matter (i.e. you might only do this once, in which case an extra few milliseconds won't hurt and this might be a premature optimization), but using lock or with the register optimization is about 992% slower when measured on my computer (or volatile is 91% faster than using Thread.MemoryBarrier and probably a bit faster still than use Thread.VolatileRead). This is actually contradictory to conventional wisdom with respect to a .NET memory model that supports Itanium. If you want to support Itanium, every access to a volatile field would be tantamount to Thread.VolatileRead or Thread.VolatileWrite, in which case, yes, in scenarios where you don't really need the field to be volatile, you take a performance hit.

In .NET 4.5 where Itanium is out of the picture, you might be thinking "volatile all the time then!". But, hold on a minute, let's look at another example:


    
    
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

This code (borrowed from [Joe Albahari][6]) will block indefinitely at the call to Thread.Join (line 16) without the call to Thread.MemoryBarrier() (at line 9). 

This code blocks indefinitely without Thread.MemoryBarrier() on both x86 and x64; but this is due to compiler optimizations, not because of the processor's memory model. We can see this in the disassembly of what the JIT produces for the thread lambda (on x64):
    
    
    00000000  push        ebp 
    
    
    00000001  mov         ebp,esp 
    
    
    00000003  movzx       eax,byte ptr [ecx+4] 
    
    
    00000007  test        eax,eax 
    
    
    00000009  jne         0000000F 
    
    
    0000000b  test        eax,eax 
    
    
    0000000d  je          0000000B 
    
    
    0000000f  pop         ebp 
    
    
    00000010  ret 

Notice the loop (0000000b to 0000000d), the compiler has optimized access to the variable toggle into a register and doesn't update that register from memory—identical to what we saw with the member field above. If we see the disassembly when using MemoryBarrier:
    
    
    00000000  movzx       eax,byte ptr [rcx+8] 
    
    
    00000004  test        eax,eax 
    
    
    00000006  jne         0000000000000020 
    
    
    00000008  nop         dword ptr [rax+rax+00000000h] 
    
    
    00000010  lock or     dword ptr [rsp],0 
    
    
    00000015  movzx       eax,byte ptr [rcx+8] 
    
    
    00000019  test        eax,eax 
    
    
    0000001b  je          0000000000000010 
    
    
    0000001d  nop         dword ptr [rax] 
    
    
    00000020  rep ret 

We see that loop testing toggle (instructions from 00000010 to 0000001b) grabs the memory value into eax then tests eax until it's true (or non-zero). MemoryBarrier has been optimized to "lock or" here as well.

What we're dealing with here is a **local variable** and **can't use the volatile keyword**. We could use the lock keyword to get a fence, it couldn't be around the comparison (the while) because that would enclose the entire while block and would never exit the lock to get the memory fence and thus the compiler believes reads of toggle aren't guarded by lock's implicit fences. We'd have to wrap _the assignment_ to toggle to get the release fence before and the acquire fence after, ala:
    
    
    var lockObject = new object();
    
    
    while (!complete)
    
    
    {
    
    
        lock(lockObject)
    
    
        {
    
    
            toggle = !toggle;
    
    
        }
    
    
    }

Clearly this lock block isn't really a critical section because the lockObject instance can't be shared amongst threads. Anyone reading this code is likely going to think "WTF?". But, _we do_ get our fences, and the compiler will not optimize access to toggle to only a register and our code will no longer block at the call to Thread.Join. It's apparent that Thread.MemoryBarrier is the better choice in this scenario, it's just more readable and doesn't appear to be poorly written code (i.e. code that only depends on side effects).

But, you still take the performance hit on "lock or". If you want to avoid that, then refactor the local toggle variable to a field and decorate it with volatile.

Although some of this seems like micro-optimizations, but it's not. You have to be careful to "synchronize" shared atomic data with respect to compiler optimizations, so you might as well pick the best way that works.



In the next post I'll get into synchronizing non-atomic invariants shared amongst threads.



[1]: http://blogs.technet.com/b/windowsserver/archive/2010/04/02/windows-server-2008-r2-to-phase-out-itanium.aspx
[2]: http://msdn.microsoft.com/en-us/library/8z6watww.aspx
[3]: http://download.intel.com/products/processor/manual/253668.pdf
[4]: http://www.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html
[5]: http://www.lidnug.org/archives.aspx
[6]: http://www.albahari.com/threading/part4.aspx


