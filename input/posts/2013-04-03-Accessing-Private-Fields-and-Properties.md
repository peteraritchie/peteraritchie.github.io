---
layout: post
title: 'Accessing Private Fields and Properties'
tags: ['.NET 4.0', '.NET Development', 'C#', 'Productivity Extensions', 'msmvps', 'April 2013']
---
[Source](http://pr-blog.azurewebsites.net/2013/04/03/accessing-private-fields-and-properties/ "Permalink to Accessing Private Fields and Properties")

# Accessing Private Fields and Properties

In Visual Studio 2010 there used to be the ability to generate a test from a class or method. This process would generate some magic classes that would allow you to access private members of the class under test. There was some apparent controversy to doing this with regard to how much work goes into support in (or some other reasons) so it wasn't included from the default context menu in Visual Studio 2012.

I rarely want to test classes' private members for various reasons, so I never really made a habit of using this feature (in fact, I don't think I remember using it once)—I tend to design for composition (and get testability for _free_). But, there are times when it's useful. But, having Visual Studio generate some magic assembly that facilitates this (e.g. do you know how to regenerate this assembly if you want to test another, new, private member?) doesn't give me a warm and fuzzy feeling, I prefer to be explicit.

I had an instance where it was more logical for me to test a private member than it was for me to make that private member public. It's no big surprise _how_ to get at private members in the instance of at class: **reflection**. Privates are private for a reason, so there's nothing in the framework that directly facilitates this. To explicitly do what I needed to do I added a few methods to [Productivity Extensions][1] (available on NuGet: Install-Package ProductivityExtensions): GetPrivateFieldValue, SetPrivateFieldValue, GetPrivatePropertyValue, and SetPrivatePropertyValue. (The setters were just for completeness, use at your own risk).

For example, I was creating an IAsyncResult implementation that lazily-created the WaitHandle. For this lazy-creation to occur, the create had to occur when the IAsyncResult.AsyncWaitHandle property getter was first called. For me to write a test to verify that if I hadn't called AsyncWaitHandle and that the WaitHandle wasn't created (or was null), I needed something other than using the property getter. It would be unwise to create another public property or field to get at the WaitHandle because that could cause the implementation to get incorrectly used and lead to bugs. This is effectively the test I wrote:



In the then_unobserved_waithandle_field_is_null test I use the GetPrivateFieldValue<WaitHandle> extension method (which you can get by adding (using PRI.ProductivityExtensions.ReflectionExtensions;after adding a reference to ProductivityExtensions) telling it that I'm asking for a field type of WaitHandle and that the name of the field is "asyncWaitHandle". This test verifies that the field is null without causing the side effect of calling the property getter.

Use at you own risk. I recommend limiting only to unit tests.

[1]: http://bit.ly/PDsKcs


