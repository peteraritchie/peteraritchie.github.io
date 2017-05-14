---
layout: post
title: async/await Tips
categories: ['.NET 4.5', 'async', 'C#', 'C# 5', 'Visual Studio 2012']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2013/02/13/async-await-gotchas/ "Permalink to async/await Tips")

# async/await Tips

There's been some really good guidance about async/await in the past week or two.  I've been tinkering away at this post for a while now—based on presentations I've been doing, discussions I've had with folks at Microsoft, etc.  Now seems like a good idea to post it.

First, it's important to understand what the "async" keyword really mean.  At face value async doesn't make a method (anonymous or member) "asynchronous"—the body of the method does that.  What it does mean is that there's a strong possibility that the body of the method won't entirely be evaluated when the method returns to the caller.  i.e. it "might" be asynchronous.  What the compiler does is create a state machine that manages the various "awaits" that occur within an async method to manage the results and invoking continuations when results _are_ available.  I'm not going to get into too much detail about the state machine, other than to say the entry to the method is now the creation of that state machine and the initialization of moving from state to state (much like the creation of an enumerable and moving from one element—the state—to the next).  The important part to remember here is that when an async method returns, there can be some code that will be evaluated in the future.

If you've ever done any work with HttpWebRequest and working with responses (e.g. disposal), you'll appreciate being able to do this:

## Parallelism

await is great to declare asynchronous operations in a sequential way.  This allows you to use other sequential syntax like using and try/catch to deal with common .NET axioms in the axiomatic way.  await, in my opinion, is really about allowing user interfaces to support asynchronous operations in an easy way with intuitive code. But, you can also use await to wait for parallel operations to complete.  For example, on a two core computer I can start up two tasks in parallel then await on both of them (one at a time) to complete:

If you run this code you should see the elapsed values (on a two or more core/cpu computer) will be very similar (not 1 second apart).  Contrast the subtle differences to:

While you **can** use await with parallel operations, the subtlety in the differences between sequential asynchronous operations can lead to incorrect code due to misunderstandings.  I suggest paying close attention to how you structure your code so it is in fact doing what you expect it to do.  In most cases, I simply recommend not doing anything "parallel" with await.

## async void

The overwhelming [recommendation][1] is to** avoid async methods that return void**.  Caveat: the reason async void was made possible by the language teams was the fact that most event handlers return void; but it is sometimes useful for an event handler to be asynchronous (e.g. await another asynchronous method).  If you want to have a method that uses await but doesn't return anything (e.g. would otherwise be void) you can simply change the void to Task.  e.g.:

This tells the compiler that the method doesn't asynchronously return a value, but can now be awaited:

## Main

Main can't be async. As we described above an async method can return with code that will be evaluated in the future Main returns, the application exits. If you *could* have an async Main, it would be similar to doing this:

This, depending on the platform, the hardware, and the current load, would mean that the Console.WriteLine *might* get executed.

Fortunately, this is easily fixed by creating a new method (that _can_ be modified with async) then call it from Main.

## Exceptions

One of the biggest advantages of async/await is the ability to write sequential code with multiple asynchronous operations.  Previously this required methods for each continuation (actual methods prior to .NET 2.0 and anonymous methods and lambdas in .NET 2.0 and  .NET 3.5).  Having code span multiple methods (whether they be anonymous or not) meant we couldn't use axiomatic patterns like try/catch (not to mention using) very effectively—we'd have to check for exceptions in multiple places for the same reason.

There are some subtle ways exceptions can flow back from async methods, but fortunately the sequential nature of programming with await, you may not care.  But, with most things, it' depends.  Most of the time exceptions are caught in the continuation.  This usually means on a thread different from the main (UI) thread.  So, you have to be careful what you do when you process the exception.  For example, given the following two methods.

And if we wrapped calls to each in try/catch:

In the first case (calling DoSomething1) the exception is caught on the same thread that called Start (i.e. before the await occurred).  *But*, in the second case (calling DoSomething2) the exception is not caught on the same thread as the caller.  So, if you wanted to present information via the UI then you'd have to check to see if you're on the right thread to display information on the UI (i.e. marshal back to the UI thread, if needed).

Of course, any method can throw exceptions in the any of the places of the above two methods, so if you need to do something with thread affinity (like work with the UI) you'll have to check to see if you need to marshal back to the UI thread (Control.BeginInvoke or Dispatcher.Invoke).

## Unit testing

Unit testing asynchronous code can get a bit hairy.  For the most part, _testing_ asynchronously is really just testing the compiler and runtime—not something that is recommended (i.e. it doesn't buy you anything, it's not your code).  So, for the most part, I recommend people test the **units** they intend to test.  e.g. test synchronous code.  For example, I could write an asynchronous method that calculates Pi as follows:

…which is fairly typical.  Asynchronous code is often the act of running something on a background thread/task.  I *could* then write a test for this that executes code like this:

But, what I really want to test is that Pi is calculated correctly, not that it occurred asynchronously. __In certain circumstances something may *not* executed asynchronously anyway.  So, I generally recommend in cases like this the test actually be:

Of course, that may not always be possible.  You may only have an asynchronous way of invoking code, and if you can't decompose into asynchronous and synchronous parts for testability then using await is likely the easiest option.  But, there's some things to watch out for.  When writing a test for this asynchronous method you might intuitively write something like this:

But, the problem with this method is that the Assert may not occur before the test runner exits.  This method doesn't tell the runner that it should wait for a result.  It's effectively async void (another area not to use it).  This can easily be fixed by changing the return from void to Task:

A *very* subtle change; but this lets the runner know that the test method is "awaitable" and that it should wait for the Task to complete before exiting the runner.  [Apparently][2] many test runners recognize this and act accordingly so that your tests will actually run and your asynchronous code will be tested.

[1]: http://bit.ly/157pMEb
[2]: http://www.srtsolutions.com/testing-async-methods-in-c-5

