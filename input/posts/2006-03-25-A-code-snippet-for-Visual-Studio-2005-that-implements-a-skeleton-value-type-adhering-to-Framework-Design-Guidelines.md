---
layout: post
title: 'A code snippet for Visual Studio 2005 that implements a skeleton value type adhering to Framework Design Guidelines'
tags: ['.NET Development', 'C#', 'Patterns', 'msmvps', 'March 2006', 'Visual Studio 2005']
---
[Source](http://blogs.msmvps.com/peterritchie/2006/03/25/a-code-snippet-for-visual-studio-2005-that-implements-a-skeleton-value-type-adhering-to-framework-design-guidelines/ "Permalink to A code snippet for Visual Studio 2005 that implements a skeleton value type adhering to Framework Design Guidelines")


I was reading [Krzysztof Cwalina][1] and [Brad Abrams'][2] book [_Framework Design Guidelines : Conventions, Idioms, and Patterns for Reusable .NET Libraries][3]_ (Guidelines) the other day. I was reading through the value type design guidelines and thought I should review some of the code I was currently working on to make sure my value types were complete.

My value types had no violations, but I did make note of a few things. First, usually each types requisite methods were in a different order from all the others and usually interspersed between other methods, making it hard to validate to any particular guidelines. Second, any particular method was often implemented slightly differently than other implementations. And, third, some of my types had also implemented `IComparable` in addition to `IComparable<T>`. I decided I would try and come up with reference implmentation of the `IComparable<T>` and `IEquatble<T>` advice in Guidelines for study.

I pulled together the disparate method implementations in the book–cleaning up a couple of guideline violiations–into a pedantic example struct. I quickly noticed one thing: of the 11 methods and operators only two need be distinct: `IComparable<T>`.CompareTo(T) and Object.GetHashCode(). I thought this would be a perfect case for templated code, so I decided the write a code snippet.

After reviewing the example type, the topic of whether CompareTo(object) is necessary came up. I had mistakingly assumed `IComparable` should be implemented when implementing `IComparable<T>`, so I had included CompareTo(Object) in my example. I re-read Guidelines and found there wasn't any advice on `IComparable` after all. My example had no backwards compatibility requirements and no requirements to compare with other object types, so I dropped the `IComparable` implementation.

The resulting snippet is attached to this post.

[1]: http://web.archive.org/web/20080525221946/http://blogs.msdn.com/kcwalina/
[2]: http://web.archive.org/web/20080525221946/http://blogs.msdn.com/brada
[3]: http://web.archive.org/web/20080525221946/http://www.amazon.com/exec/obidos/ASIN/0321246756/bradabramsblo-20


