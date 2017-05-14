---
layout: post
title: Performance Implications of try/catch/finally
categories: ['.NET 2.0', '.NET Development', 'C#', 'Design/Coding Guidance']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/06/22/performance-implications-of-try-catch-finally/ "Permalink to Performance Implications of try/catch/finally")

# Performance Implications of try/catch/finally

The accepted wisdom regarding performance of try/catch|finally in C# has normally been: try has no performance side-effects unless an exception is thrown.

A discussion I was involved in recently caused me to discover some performance implications of try/catch blocks. The discussion revolved around protecting the volatility of certain members and the cross-thread memory ordering rules during run-time and during just-in-time compilation.  As it turns out, Microsoft's x86 .NET 2.0 just-in-time compiler disables optimizations that would affect the CIL order of read/writes in protected blocks (AKA "protected regions", "guarded blocks", or "try blocks").  As a result no optimizations are performed in try blocks.

As it turns out, there **are** performance side-effects to try/catch even if no exceptions are thrown.  In the following academic example:

    int count = 1;  
    SomeMethod();  
    count++;  
    SomeOtherMethod();  
    count++;  
    Console.WriteLine(count);

The x86 just-in-time compiler will effectively optimize this as follows:

    SomeMethod();  
    SomeOtherMethod();  
    Console.WriteLine(3);

The end-result is the same but the side-effects (that would normally be only visible in a debugger) are different (e.g. count never has the value 2).  The just-in-time compiler can do this because it knows no other code can see count when it has the value 2.

Now, wrapping this in a try block, as follows:

    int count = 1;  
    try  
    {  
        SomeMethod();  
        count++;  
        SomeOtherMethod();  
        count++;  
    }  
    finally  
    {  
        Console.WriteLine(count);  
    }

…is not optimized.  count will be created, it will have the value 1, it will have the value 2 after the call to SomeMethod, it will have the value 3 after SomeOther method, and will have the value 3 when Console.WriteLine is called.  There are two increments that therefore must be performed that are a waste of cycles.

So, be careful how you write code in try blocks.

