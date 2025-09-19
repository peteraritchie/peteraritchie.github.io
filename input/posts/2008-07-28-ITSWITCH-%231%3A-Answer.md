---
layout: post
title: 'ITSWITCH #1: Answer'
tags: ['.NET 2.0', '.NET Development', 'C#', '.NET', 'Design/Coding Guidance', 'ITSWITCH Answer', 'Pop Quiz', 'Software Development', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/07/28/itswitch-1-answer/ "Permalink to ITSWITCH #1: Answer")

# ITSWITCH #1: Answer

[Last post][1] I detailed some code that may or may not have something wrong in it. If you thought InitializeOne and IntializeTwo are semantically identical (e.g. they differ only by performance), you'd be wrong.

If you simply ran the code, you'd be able to guess where the problem is. To understand what's causing the problem. Let's look at how C# effectively implements the two loops.

InitializeOne is essentially equivalent to
    
    
     private class PrivateDelegateHelper
    
    
     {
    
    
     public String Value { get; set; }
    
    
     public void Method()
    
    
     {
    
    
     TestClass.ProcessText(Value);
    
    
     }
    
    
     }
    
    
    
    
    
     public void InitializeThree(String[] strings)
    
    
     {
    
    
     delegates = new List<MethodInvoker>(strings.Length);
    
    
     MethodInvoker cachedAnonymousDelegate = null;
    
    
     PrivateDelegateHelper privateDelegateHelper = new PrivateDelegateHelper();
    
    
     String[] copyOfStrings = strings;
    
    
     for(int i = 0; i < copyOfStrings.Length; ++i)
    
    
     {
    
    
     privateDelegateHelper.Value = copyOfStrings[i];
    
    
     if (cachedAnonymousDelegate == null)
    
    
     {
    
    
     cachedAnonymousDelegate = new MethodInvoker(privateDelegateHelper.Method);
    
    
     }
    
    
     delegates.Add(cachedAnonymousDelegate);
    
    
     }
    
    
     }

Now it's obvious, right?

For those you don't want to read all the code, the problem is that only one PrivateDelegateHelper object is instantiated and its value property is set in each iteration of the loop. Because the delegates aren't run until sometime after the loop, they're all run with the last value of the string array as their argument.

The technical term for what we've implemented here is a [closure][2]. If you're using Resharper 4.x, you would have noticed a warning "Access to modified closure":

![][3]

…which is attempting to tell you that the closure (the delegate and cached bound variables) has changed (in this case one of the bound variables has changed between the creation of a closure and another and out expected output is effected).

By the way, you can get the same thing with C# 3+ with lambdas (i.e. you can also write closures with lambdas):
    
    
     public void InitializeOne(String[] strings)
    
    
     {
    
    
     delegates = new List<MethodInvoker>(strings.Length);
    
    
     for (int i = 0; i < strings.Length; ++i)
    
    
     {
    
    
     String value = strings[i];
    
    
     delegates.Add(() => ProcessText(value));
    
    
     }
    
    
     }
    
    
    
    
    
     public void InitializeTwo(String[] strings)
    
    
     {
    
    
     delegates = new List<MethodInvoker>(strings.Length);
    
    
     foreach(String value in strings)
    
    
     {
    
    
     delegates.Add(() => ProcessText(value));
    
    
     }
    
    
     }

[1]: http://blogs.msmvps.com/blogs/peterritchie/archive/2008/07/25/itswitch-1.aspx
[2]: http://en.wikipedia.org/wiki/Closure_(computer_science)
[3]: http://blogs.msmvps.com/cfs-filesystemfile.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie/modified-closure.JPG


