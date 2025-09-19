---
layout: post
title: 'On performance of immutable collections'
tags: ['Multithreaded', '.NET', 'msmvps']
---
[Source](http://pr-blog.azurewebsites.net/2014/04/20/on-performance-of-immutable-collections/ "Permalink to On performance of immutable collections")

# On performance of immutable collections

Immutability is important in many aspects of developing software systems. Scalability, for example, uses immutability in many patterns and techniques (See actors, queues, etc.). Many of these techniques rely on copies of data instead of immutable types, but imagine the boost if guaranteed immutable types were used proactively?

There are examples of types that act immutable in .NET that have been there a long time. `String` for example–it acts as if it were immutable. (There are no truly immutable types, unfortunately, yet in .NET–just types that provide an interface that does not allow changes to data). Despite being immutable there are methods that give the appearance "modifying" data by making a copy of it. `Insert` is one example, `var newText = "Strng".Insert(3, "I")` creates a new string with the "modified" value. `ImmutableDictionary` is another example of a type that acts as if it were immutable.

You need to know you need immutable types before you use them. Once you know you need them it's important to know the performance implications of using them. But, it's important to make accurate comparisons. One naïve comparison of using a type like `ImmutableDictionary` might be:
    
    
    {
        var dic = new Dictionary<object, object>();
        var sp = Stopwatch.StartNew();
        for (int i = 0; i < 10 * 1000 * 1000; i++)
        {
            var obj = new object();
            dic[obj] = obj;
        }
    
        Console.WriteLine(sp.Elapsed);
    }
    
    {
        var dic = ImmutableDictionary<object, object>.Empty;
        var sp = Stopwatch.StartNew();
        for (int i = 0; i < 10 * 1000 * 1000; i++)
        {
            var obj = new object();
            dic = dic.SetItem(obj, obj);
        }
    
        Console.WriteLine(sp.Elapsed);
    }

But it's a apples-orange comparison because the second performance test is gathering performance metrics on _making copies_ of the collection, not performance metrics on _modifying_ the collection (as you _can't_ with `ImmutableCollection`. As a result you get a skewed comparison (something like 30 times slower, depending on your systems).

A more accurate comparison might be something like:
    
    
    {
        var dic = new Dictionary<object, object>();
        var sp = Stopwatch.StartNew();
        for (int i = 0; i < 10 * 1000 * 1000; i++)
        {
            var obj = new object();
            dic = new Dictionary<object, object>(dic);
            dic[obj] = obj;
        }
        Console.WriteLine(sp.Elapsed);
    }
    
    {
        var dic = ImmutableDictionary<object, object>.Empty;
        var sp = Stopwatch.StartNew();
        for (int i = 0; i < 10 * 1000 * 1000; i++)
        {
            var obj = new object();
            dic = dic.SetItem(obj, obj);
        }
    
        Console.WriteLine(sp.Elapsed);
    }

Now we're comparing apples and apples! And what do we see? Well, actually `ImmutableDictionary` is actually considerably _faster_ than `Dictionary`! If you run the above test, you'll see that the `Dictionary` test will actually take _hours_, if not more than a day. So, it's either a verynaïve comparision or really shows how much faster `ImmutableDictionary` is.

Sure, making copies of a collection _is slower_ than _not_ making copies of a collection, but the comparison is naïve in another way, why would you use an _immutable_ collection if you are using it as if you are_mutating it_ that frequently?


