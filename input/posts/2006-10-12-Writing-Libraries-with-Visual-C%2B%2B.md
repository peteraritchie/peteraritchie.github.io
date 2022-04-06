---
layout: post
title: 'Writing Libraries with Visual C++'
tags: ['Uncategorized', 'msmvps', 'October 2006']
---
[Source](http://blogs.msmvps.com/peterritchie/2006/10/12/writing-libraries-with-visual-c/ "Permalink to Writing Libraries with Visual C++")

# Writing Libraries with Visual C++

Writing libraries of APIs is a very diffcult task on any platform. There are many things you have to consider during the design of that API, especially with an unmanaged run-time.

Visual C++ actually makes it more complicated to build and use libraries.

Some rules to evaluate an API you're thinking of using or to help design your APIs:

## Use the same run-time

This may seem obvious just reading it; but it's very complex to use the same run-time. With Visual C++ 6 there are 6 different versions of the run-time that you have to be careful to match. There are DEBUG and RELEASE versions of the following: Single-Threaded, Multithreaded, and Multithreaded DLL. Multithreaded-DLL is used when you want to create a DLL that needs a run-time that supports multithreading (either in a multithreaded host or a single-threaded host). Unfortunatly Visual C++ doesn't make your life easy if you happen link to a LIBusing the wrong run-time threading and just spits out a LNK4098 warning and you must infer from that that you've just built an unsupported configuration.

One problem I often see is the use of a 3rd party library compiled with a different version of Visual C++. The Linker and the Librarian think they're being smart by trying their hardest to link the library, only raising warnings/errors when there's enough difference between the run-times used that it can't resolve everything. Under some circumstances you get no warnings when linking a static library built with a different version of Visual C++ despite the resulting configuration being unsafe and entirely unsupported. Even when you geterrors there's lots of things you can do to resolve them; but that's just 

If at any time the vender of the 3rd party library s

## Allocate memory and free memory with the same module

Memory management routines are a common and plentiful thing with programming. Memory allocated with a particular memory management system must be deallocated with the same memory management system. With the C/C++ run-time most allocations end up going thro

## Provide Ability to Pass Along State

If an API uses callbacks at all, or ever plans to, it's essential that the callback be able to figure out the context in switch it is called. If the callback is being called with any sort of data that can be overridden or tagged by the application this may not be necessary. Otherewise the callback should include a void * that was supplied by the application upon some initialization. This type of pattern can be seen with "application-defined data" of type LPARAMwith many Windows function calls or structures. VB design use it extensively as the "Tag" property.


