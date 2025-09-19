---
layout: post
title: 'Resharper Isn’t Always Smart'
tags: ['C#', 'Product Bugs', 'Resharper', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/03/31/resharper-isn-t-always-smart/ "Permalink to Resharper Isn’t Always Smart")

# Resharper Isn’t Always Smart

I was writing some code today, essentially like this:

  

public class MyClass

{

 private int value;

 public MyClass(int value)

 {

  this.value = value;

 }

 public static bool operator==(MyClass left, MyClass right)

 {

  return left.value == right.value;

 }



 public static bool operator !=(MyClass left, MyClass right)

 {

  return !(left == right);

 }

}

  

 //…

 MyClass myClass1 = new MyClass(1);

 MyClass myClass2 = new MyClass(1);

 if((Object)myClass1 != (Object)myClass2) // "Type cast is reundant"

 {

  Console.WriteLine("not equal");

 }

 else

 {

  Console.WriteLine("equal");

 }

…whereResharper warned that both the casts to Object were redundant and offered a "Quick-fix" (red light bulb) to "Remove cast". Well, doing that to one of the casts results in a compile error so you have to manually change the other; but what it's suggesting is this:

  

 if(myClass1 != myClass2)

This completely changes the output of my application from "not equal" to"equal". WhatResharperdoesn't know (or doesn't care to check)is that removing those casts switches from a reference comparison to a value comparisonand mayhave different results. What I wrote with the original code was to test if the two referencesreferenced the same object. The default behaviour of a class is to do a reference check; but I've overloadedoperator== (and operator!=) to perform a value comparison (I've left out the lovelybits that trulygives MyClass value semantics for clarity).

So, when Resharper offers to change your code, be sure you know side-effects of that change before you let it do it. You could introduce a nasty bug.

![kick it on DotNetKicks.com][1]

[1]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f03%2f31%2fresharper-isn-t-always-smart.aspx


