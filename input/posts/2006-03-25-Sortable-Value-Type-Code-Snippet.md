---
layout: post
title: 'Sortable Value Type Code Snippet'
tags: ['.NET Development', 'C#', '.NET', 'Software Development', 'msmvps']
---
$&
I was reading [Krzysztof Cwalina][1] and [Brad Abrams'][2] book [_Framework Design Guidelines : Conventions, Idioms, and Patterns for Reusable .NET Libraries_][3] (Guidelines) the other day. I was reading through the value type design guidelines and thought I should review some of the code I was currently working on to make sure my value types were complete.

My value types had no violations, but I did make note of a few things. First, usually each of my type's requisite methods were in a different order from all the others and usually interspersed between other methods; making it hard to validate to any particular guidelines. Second, any particular method was often implemented slightly differently than other implementations. And, third, some of my types had also implemented `IComparable` in addition to `IComparable<T>`. I decided I would try and come up with reference implementation of the `IComparable<T>` and `IEquatble<T>` advice in Guidelines for study.

I pulled together the disparate method implementations in the book–cleaning up a couple of guideline violations–into a pedantic example struct. I quickly noticed one thing: of the 11 methods and operators only two need be distinct: `IComparable<T>`.CompareTo(T) and Object.GetHashCode(). I thought this would be a perfect case for templated code, so I decided to write a code snippet.

After reviewing the example type, the topic of whether CompareTo(object) is necessary came up. I had mistakenly assumed `IComparable` should be implemented when implementing `IComparable<T>`, so I had included CompareTo(Object) in my example. I re-read Guidelines and found there wasn't any advice on `IComparable` after all. My example had no backwards compatibility requirements and no requirements to compare with other object types, so I dropped the `IComparable` implementation.

The resulting code snippet can be found [here][4].

[Edit 18-Jul-06: Irena Kennedy has a [relavent blog post][5] relating to `IEquatable<T>` and `IComparable<T>`]  

Technorati tags:  
[Visual Studio 2005][6]  
[Code Snippet][7]  
[Csharp][8]

[1]: http://blogs.msdn.com/kcwalina/
[2]: http://blogs.msdn.com/brada/
[3]: http://www.amazon.com/exec/obidos/ASIN/0321246756/bradabramsblo-20
[4]: http://www.peterritchie.com/Hamlet/Downloads/Downloads_GetFile.aspx?id=77
[5]: http://blogs.msdn.com/irenak/archive/2006/07/18/669586.aspx
[6]: http://technorati.com/tag/Visual%20Studio%202005
[7]: http://technorati.com/tag/Code%20Snippet
[8]: http://technorati.com/tag/Csharp


