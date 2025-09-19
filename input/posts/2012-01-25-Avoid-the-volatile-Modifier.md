---
layout: post
title: 'Avoid the volatile Modifier'
tags: ['.NET Development', 'C#', '.NET', 'Multithreaded', 'Software Development', 'Software Development Guidance', 'Visual Studio', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2012/01/25/avoid-the-volatile-modifier/ "Permalink to Avoid the volatile Modifier")

# Avoid the volatile Modifier

[Update:   25-Jan-12 5:45 pm; fixed typo]

I was reminded recently of the misconceptions of the volatile modifier in C#, and I'd thought I'd pass along the recommendations of other's that is tantamount to "avoid the volatile modifier". The volatile modifier in C# "indicates that a field might be modified by multiple threads that are executing at the same time" [1].

The first problem is that documentation. What does that really mean to someone developing code that uses multiple threads? Does that make the code "thread-safe"? The answer is "maybe"; the real answer is "rarely". Most people just stick volatile on a field because they _think_ that's what they need to do.

What volatile modifier _does_ do to a field in C# is make all reads to the field use "acquire semantics" and all readswrites use "release semantics". Much clearer, right? Acquire semantics means access is "guaranteed to occur prior to any references to memory that occur after it in the instruction sequence" and release semantics means access is "guaranteed to happen after any memory references prior to the write instruction in the instruction sequence" [6,2]

One of the problems with modern compilers [3] and processers and multithreaded code is optimization. Within a block of code with no externally visible side effects the compiler is free to re-order instructions and remove instructions to result in the same visible side-effect. "x+=1;x+=1;" can be freely optimized to "x+=2;" and "x+=1;y+=2;" can be reordered so that order of execution is effectively "y+=2;x+=1;", for example. The processor doesn't optimize multiple instructions into one; but can re-order instructions and make the results of executed instructions visible to other cores/processors visible well after the instructions were executed (processor caching). With fields, the compiler[3] has less freedom to optimize because side-effects to fields have more visibility—but the processor doesn't discern between C# fields and any other bit of memory.

So, what does volatile really do for a field? Realistically it prevents processor re-ordering and caching. It tells the processor that all accesses to the value of that variable should come from or be made directly to memory, not the cache.

Not having a value cached by the processor so all other processors (and thus all other threads) can see what happens to the value of a variable seems like a really good thing though, doesn't it? In that respect, yes, it is a good thing. But, let's look at some of the drawbacks of volatile.

The syntax of volatile is that it just annotates a memory location. In reality it really modifies the operations that occur on that memory location. Code that operates on that memory location looks the same, regardless of whether it's modified by volatile or not. i.e. it's unclear the code has different side-effects for multithreaded scenarios. Another problem is that "volatile" is a very overridden word. It's used in C++ and Java; but it means something different (sometimes slightly) in each. Moving back and forth from C++ to C# to Java could lead to using volatile incorrectly. Volatile also assumes that all accesses to the field need to be protected from re-ordering. Most of the time, there's very specific times you want to force side-effects to a field to be made "visible" and, effectively, flush the processors cache to/from memory. Flushing to the cache on every access is not very performant if you don't need side-effects truly visible until specific times. Plus, the volatile modifier means nothing if you pass the field by reference somewhere else. [4,5] There's also limitations to what you can apply volatile to (e.g. you can't have a volatile long).

What does volatile really mean from a code perspective? Well, when you read from a volatile field effectively the following code is executed:
    
    
    Thread.VolatileRead(ref field);
    

And when you write to a volatile field effectively the following code is executed:
    
    
    Thread.VolatileWrite(ref field, newValue);
    

Both of these methods really just translate to a memory access and a call to Thread.MemoryBarrier (before the memory access for read, and after for write). What MemoryBarrier does for is is ensure that all cached writes are flushed to memory at the call to MemoryBarrier (i.e after MemoryBarrier, any cached writes that occurred prior to MemoryBarrier are flushed and any cached reads are abandoned). So, if you've noticed there's nothing field-specific about Volatile[Read|Write], it makes everything flush, not just the field in question. The performance aspect of the volatile modifier comes into play when you have multiple volatile fields within a class, it's really only the last one that needs to use VolatileWrite when writing and the first one to use VolatileRead when reading. To steal some code from Jeffery Richter:
    
    
    m_value = 5;
    Thread.VolatileWrite(ref m_flag, 1);
    

is just as thread-safe as:
    
    
    m_value = 5;
    m_flag = 1;
    

if m_value and m_flag were volatile.

Same holds true for VolatileRead:
    
    
    if(Thread.VolatileRead(ref m_flag) == 1)
    	Display(m_value);
    

is just as thread-safe as the following with volatile fields:
    
    
    if(m_flag == 1)
    	Display(m_value);
    

I feel compelled to bring up invariants here. When you're dealing with modifications or accesses of multiple things that can't operate atomically (i.e. the "validity" of m_value depends on the value of m_flag, making the two fields an "invariant" that can be accessed by a single instruction—i.e. not atomically). While the above example ensures that changes to m_flag and m_value are made visible to other threads "at the same time" it doesn't do anything to stop another thread from accessing the m_value before m_flag has been updated. This may or many not be "correct". If it's not correct, using lock or Monitor to model atomic access to such an "invariant" that isn't natively atomic is a better choice.

On the topic of lock/Monitor. It's important to note that the end of a lock or the call to Monitor.Exit has release semantics and the start of the lock or Monitor.Enter (and variants) have acquire semantics. So, if all access to a field is guarded with lock or Monitor, there's no need for volatile or Thread.Volatile[Read|Write].

Using Monitor, lock, volatile, VolatileRead and VolatileWrite correctly shows that you understand what it means to be thread-safe and that you understand what it means to be externally visible and when in the context of your fields and invariants.

There have apparently been some discussions about the usefulness and applicability of volatile in C# as well as VB (and I assume C++11); but, I'm was not privy to those discussions and haven't been able to find much in the way of reference to those discussions other than third-hand information… Needless to say, VB doesn't have anything similar to "volatile", apparently for a reason.

I'm not saying there aren't perfectly valid scenarios for volatile; but, look carefully at what you need; you probably could make better use of VolatileRead or VolatileWrite. Just understand your needs and use what is correct—code on purpose.

[1] [volatile (C# Reference)][1]

[2] [Acquire and Release Semantics][2]

[3] CSC and JIT compilers.

[4] [Sayonara volatile][3]

[5] [Aug 2011 Getting Started with Threading webcast with Jeffrey Richter (45MB)][4]

[6] [C# Language Specification (ECMA-334)][5]

[1]: http://bit.ly/wGztj8 "http://bit.ly/wGztj8"
[2]: http://bit.ly/ynNgqf "http://bit.ly/ynNgqf"
[3]: http://bit.ly/zOmQI7 "http://bit.ly/zOmQI7"
[4]: http://www.lidnug.org/Files/Recordings/Aug%2015,%202011%20-%20Getting%20Started%20with%20Threading.zip
[5]: http://bit.ly/xNTlua "http://bit.ly/xNTlua"


