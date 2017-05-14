---
layout: post
title:  "Thread synchronization of non-atomic invariants in .NET 4.5"
redirect_from: "/2012/09/11/thread-synchronization-of-non-atomic-invariants-in-net-4-5/"
date:   2012-09-10 12:00:00 -0600
categories: ['.NET 4.5', '.NET Development', 'C#', 'Concurrency', 'Design/Coding Guidance', 'DevCenterPost', 'Multithreaded', 'Software Development Guidance', 'Visual Studio 2012']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2012/09/11/thread-synchronization-of-non-atomic-invariants-in-net-4-5/ "Permalink to Thread synchronization of non-atomic invariants in .NET 4.5")

# Thread synchronization of non-atomic invariants in .NET 4.5

Now that we've seen how a singular x86-x64 focus [might affect how we can synchronize atomic invariants][1], let's look at non-atomic invariants.

While an atomic invariant really doesn't need much in the way of _guarding_, non-atomic invariants often do.  The rules by which the invariant is correct are often much more complex.  Ensuring an atomic invariant like int, for example is pretty easy: you can't set it to an invalid value, you just need to make sure the value is visible.  Non-atomic invariants involve data that can't natively be modified atomically.  The typical case is more than one variable, but can include intrinsic types that are not guaranteed to be modified atomically (like long and decimal).  There is also the fact that not all operations on an atomic type are performed atomically.

For example, let's say I want to deal with a latitude longitude pair.  That pair of floating-point values is an invariant, I need to model accesses to that pair as an atomic operation.  If I write to latitude, that value shouldn't be "seen" until I also write to longitude.  The following code does not guard that invariant in a concurrent context:
    
    
    latitude = 39.73;
    
    
    longitude = -86.27;

If somewhere else I changed these values, for example I wanted to change from the location of Indianapolis, IN to Ottawa, ON:
    
    
       1: latitude = 45.4112;
    
    
       2: longitude = -75.6981;

Another thread reading latitude/longitude if the thread was executing the above code was between line 1 and 2, would read a lat/long for some place near Newark instead of Ottawa or Indianapolis (the two lat/longs being written).  Making these write operations volatile does nothing to help make the operation atomic and thread-safe.  For example, the following is still not thread-safe:
    
    
       1: Thread.VolatileWrite(ref latitude, 45.4112);
    
    
       2: Thread.VolatileWrite(ref longitude, -75.6981);

A thread can still read latitude or longitude after line 1 executes on another thread and before line 2.  Given two variables that are publicly visible, the only way to make an operation on both "atomic" is to use lock or use a synchronization class like Monitor, Semaphore, Mutex, etc.  For example:
    
    
    lock(latLongLock)
    
    
    {
    
    
        latitude = 45.4112;
    
    
        longitude = -75.6981;
    
    
    }

Considering latitude and longitude "volatile", doesn't help us at all in this situation—we have to use lock.  And once we use lock, there's no need to consider the variables volatile, no two threads can be in the same critical region at the same time, and any side-effect resulting from executing that critical region are guaranteed to be visible as soon as the lock is released. (as well any potentially visible side-effects from other threads are guaranteed to be visible as soon as the lock is acquired).

There are circumstances where you can have loads/stores to different addresses that get reordered in relation to each other (a load can be reordered with older stores to a different memory address).  So, conceptually given two threads executing on different cores/CPUS executing the following code at the same time:
    
    

    x = 1;    |    y = 1;
    
    
    r1 = y;   |    r2 = x;

This could result in r1 == 0 and r2 == 0 (as described in section 8.2.3.2 of [Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 3A][2]) assuming r1 and r2 access was optimized by the compiler to be an register access.  The only way to avoid this would be to force a memory barrier.  The use of volatile, as we've seen the prior post, is not enough to ensure a memory fence is invoked under all circumstances.  This can be done manually through the use of Thread.MemoryBarrier, or through the use of lock.  Thread.MemoryBarrier is less understood by a wide variety of developers, so using lock is almost always what should be used prior to any micro-optimizations.  For example:
    
    
    lock(lockObject)
    
    
    {
    
    
      x = 1;
    
    
      r1 = y;
    
    
    }

and
    
    
     
    
    
    lock(lockObject)
    
    
    {
    
    
      y = 1;
    
    
      r2 = x;
    
    
    }

This basically assumes x and y are involved in a particular invariant and that invariant needs to be guaranteed through atomic access to the pair of variables—which is done by creating a critical regions of code where only one region can be executing at a time across threads.

### Revisiting the volatile keyword

The first post in this series could have came of as suggesting that volatile is always a good thing.  As we've seen in the above, that's not true.  Let me be clear: using volatile in what I described previously is an optimization.  It should be a micro-optimization that should be used very, very carefully.  What is an isn't an atomic invariant isn't always cut and dry.  Not every operation on an atomic type is an atomic operation.

Let's look at some of the problems of volatile:

The first, and arguably the most discussed problem, is that volatile decorates a variable not the use of that variable.  With non-atomic operations on an atomic variable, volatile can give you a false sense of security.  You may _think_ volatile gives you thread-safe code in all accesses to that variable, but it does not.  For example:
    
    
    private volatile int counter;
    
    
    private void DoSomething()
    
    
    {
    
    
        //...
    
    
        counter++;
    
    
        //...
    
    
    }

Although many processors have a single instruction to increment an integer, "there is no guarantee of atomic read-modify-write, such as in the case of increment or decrement" [1].  Despite counter being volatile, there's no guarantee this operation will be atomic and thus there's no guarantee that it will be thread-safe.  In the general case, not every type you can use operator++ on is atomic—looking strictly at "counter++;", you can't tell if that's thread-safe..  If counter were of type long, access to counter is no longer atomic and a single instruction to increment it is only possible on some processors (regardless of lock of guarantees that it will be used). If counter were an atomic type, you'd have to check the declaration of the variable to see if it was volatile or not before deciding if it's potentially thread-safe.   To make incrementing a variable thread-safe, the Interlocked class should be used for supported types:
    
    
    private int counter;
    
    
    private void DoSomething()
    
    
    {
    
    
        //...
    
    
        System.Threading.Interlocked.Increment(ref counter);
    
    
        //...
    
    
    }

Non-atomic types like long, ulong (i.e. not supported by volatile) are supported by Interlocked.  For non-atomic types not supported by Interlocked, lock is recommended until you've verified another method is "better" and works:
    
    
    private decimal counter;
    
    
    private readonly object lockObject = new object();
    
    
    private void DoSomething()
    
    
    {
    
    
        //...
    
    
        lock(lockObject)
    
    
        {
    
    
            counter++;
    
    
        }
    
    
        //...
    
    
    }

That is volatile is problematic because it can only be applied to member fields and only to certain types of member fields.  

The general consensus is that because volatile doesn't decorate the _operations_ that are potentially performed in a concurrent context, and doesn't consistently lead to more efficient code in all circumstances, and passing a volatile field by ref circumvents the fields volatility, and would fail if used with non-atomic invariants, and lack of consistency with correctly guarded non-atomic operations, etc.; that the volatile operations should be explicit through the use of Interlocked, Thread.VolatileRead, Thread.VolatileWrite, or the use of lock and not through the use of the volatile keyword.

### Conclusion

Concurrent and multithreaded programming is not trivial.  It involves dealing with non-sequential operations through the writing of sequential code.  It's prone to error and you really have to know the intent of your code in order to decide not only what might be used in a concurrent context as well as what is thread-safe.  i.e. "thread-safe" is application specific.  

Despite only really having support for x86/x64 "out of the box" in .NET 4.5 (i.e. Visual Studio 2012), the **potential side-effects of assuming an x86/x64 memory model just muddies the waters**.  I don't think there is any benefit to writing to a x86/x64 memory model over writing to the .NET memory model.  Nothing I've shown really affects existing guidance on writing thread-safe and concurrent code—some of which are detailed in [Visual Studio 2010 Best Practices][3].

Knowing what's going on at lower levels in any particular situation is good, and anything you do in light of any side-effects should be considered micro-optimizations that should be well scrutinized.

[1] C# Language Specification § 5.5 Atomicity of variable references

[1]: http://msmvps.com/blogs/peterritchie/archive/2012/09/09/thread-synchronization-of-atomic-invariants-in-net-4-5.aspx
[2]: http://download.intel.com/products/processor/manual/253668.pdf
[3]: http://bit.ly/Px43Pw

