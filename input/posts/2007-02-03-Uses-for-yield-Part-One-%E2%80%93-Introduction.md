---
layout: post
title: 'Uses for yield Part One – Introduction'
tags: ['Uncategorized', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/02/03/uses-for-yield-part-one-introduction/ "Permalink to Uses for yield Part One – Introduction")

# Uses for yield Part One – Introduction

.NET has strong support for collections. Even the built-in Array type implements `ICollection`. The `ICollection` interface derives from the `IEnumerable` interface to allow easy enumeration of all elements in a collection. In C#, the foreach statement uses the `GetEnumerator` member of `IEnumerable` (a class need not implement `IEnumerable`, it just needs a public `GetEnumerator` method that returns an `IEnumerator` object) to begin enumeration.

Previous to C# 2.0 foreach required the existence of the collection and all the elements contained therein, or a custom implementation of IEnumerator.`MoveNext()` and IEnumerator.Current. Not an entirely unexpected demand, when you think of it. If you wanted to provide the ability to enumerate all the elements of a particular set of data then that data would have to be calculated at the time of the set's creation. C# 2.0 introduced the yield keyword that meant you could implement an enumerable set that doesn't require all its elements to exist at the beginning of the enumeration or creating an IEnumerator-derived class.

What does this do you for, the designer? Well, you can employ lazy evaluation to distribute processing throughout several different points in time. This is handy if you want to maintain a responsive UI, or you have to deal with high-latency resources like a web connection to a remote server or a connection to a remote database. This is especially beneficial if you know your clients aren't always going to enumerate all elements in your set (i.e. you don't have to perform processing to create all elements in order to use the foreach pattern). This effectively means the creation of your set can be O(1).

The documentation for yield provides a pragmatic example of creating an enumerable set of powers of a number up to a specific exponent. A slight modification of the example shows that indeed the calculation of each power is in fact lazy, and distributed across time:

  

> calculating 2^1  
2^1 = 2   
calculating 2^2  
2^2 = 4   
calculating 2^3  
2^3 = 8   
calculating 2^4  
2^4 = 16   
calculating 2^5  
2^5 = 32   
calculating 2^6  
2^6 = 64   
calculating 2^7  
2^7 = 128   
calculating 2^8  
2^8 = 256

The yield statement has a couple of variations. To provide the value at the current position, use yield return _value_. Use yield break to signal the end of the set and to stop the enumeration loop. For example, to implement an enumerator of a set whose limit is notknown at the start of an enumeration:

  

 /// <summary>

 /// Get an enumerator for all the keys pressed until Esc

 /// </summary>

 /// <returns>IEnumerator object.</returns>

 public static System.Collections.IEnumerable GetPressedKeysUntilEscape()

 {

  do

  {

   ConsoleKeyInfo character = Console.ReadKey(true);

   if (character.Key == ConsoleKey.Escape)

   {

    yield break;

   }

   yield return character.Key;

  }

  while (true);

 }

 // …

 foreach (ConsoleKey key in GetPressedKeysUntilEscape())

 {

  Debug.WriteLine(key.ToString());

 }


