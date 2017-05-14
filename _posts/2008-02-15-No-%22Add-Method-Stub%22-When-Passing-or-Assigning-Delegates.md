---
layout: post
title:  "No "Add Method Stub" When Passing or Assigning Delegates"
date:   2008-02-14 19:00:00 -0500
categories: ['.NET Development', 'Product Bugs', 'Visual Studio 2005', 'Visual Studio 2008']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/02/15/no-quot-add-method-stub-quot-when-passing-or-assigning-delegates/ "Permalink to No "Add Method Stub" When Passing or Assigning Delegates")

# No "Add Method Stub" When Passing or Assigning Delegates

I finally noticed the other day the "Add method stub" SmartTag wasn't appearing for a new method name I type in.  I decided I'd have a closer look…

When you're practicing Test-Driven Development (TDD) you want to write a test for methods before you write the methods.  This means you write a test method that calls several other methods that don't exist yet.  The Visual Studio IDE, in an effort to promote TDD, recognizes this and when you have your caret over a call to one of these methods a SmartTag shows up and you can select _Generate method stub for 'SomeMethod' in 'SomeNamespace.SomeClass'_.  For example, if you have the following:

  

    static void Main(string[] args)

    {

        SomeMethod();

    }

…if you place the caret (e.g. click on "SomeMethod") somewhere on "SomeMethod" (and it doesn't exist in the current class) the SmartTag rectangle under the 'S' in SometMethod appears and you can hover your mouse over the word "SomeMethod" and the options icon appears that you can click and select _Generate method stub for 'SomeMethod' in 'SomeNamespace.SomeClass'_, and it will generate a method like the following:

  

    private static void SomeMethod()

    {

        throw new NotImplementedException();

    }

Well, I figured this would also happen when I tried to assign a non-existent method to a delegate.  For example, if I had the following:

  

    static void Main(string[] args)

    {

        Action action = SomeOtherMethod;

    }

…I would expect that placing the caret over "SomeOtherMethod" that the SmartTag would show up and I would be able to select _'SomeOtherMethod' in 'SomeNamespace.SomeClass'_ and it would generate a method like the following:

  

    private static void SomeOtherMethod()

    {

        throw new NotImplementedException();

    }

Alas, the IDE doesn't recognize use of an undeclared method when used with delegates.  i.e. it doesn't appear in these circumstances either:

  

    static void ProcessDelegate(Action action)

    {

        //…

    }

    static void Main(string[] args)

    {

        ProcessDelegate(SomeOtherMethod);

        ProcessDelegate(new Action(SomeOtherMethod));

    }

I thought "Add method stub" would be more useful in these circumstances because you're not explicitly passing arguments to the method so it's more likely that you don't know what signature you need to declare.  So, I logged a suggestion for it: <https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=328782>

By the way, the non-generic Action delegate (System.Core.Delegate) is new to .NET 3.5.

