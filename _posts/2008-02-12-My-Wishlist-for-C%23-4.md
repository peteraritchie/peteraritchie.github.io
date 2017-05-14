---
layout: post
title:  "My Wishlist for C# 4"
date:   2008-02-11 19:00:00 -0500
categories: ['C#', 'C# 4', 'Pontification']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/02/12/my-wishlist-for-c-4/ "Permalink to My Wishlist for C# 4")

# My Wishlist for C# 4

[Edit: fixed the not-ready-for-publication problems] 

There seems to be more than few people blogging about what they hope C# 4 will do for them.  I haven't seen one that really synchronizes with my thoughts, so I'd thought I'd post my own list.

**Variance**

A good story with regard to variance with generics is vital for upcoming versions of C# 4.  You could argue that this should have been done in 3, but, unfortunately, that wasn't the focus.  I think this really needs to be done for 4; and if [Eric Lippert's blog][1] is any indication, that may come true.

**Design By Contract** 

Design by Contract (DbC) means programmers can define verifiable interfaces.  This explicit intention information is then used by the compiler to greatly increase the compile-time checking it can do.  In most cases this means no checking need be done at run-time because the compiler has verified the that condition cannot occur at run-time, increasing reliability and improving performance.  There's hint of this in the framework already with the internal classes ImmutableAttribute and InvariantMethodAttribute.  First-class language support for DbC would go a long way to being able to write more reliable software.

**Concurrency**

Various leaders in the industry (Microsoft included) are recognizing the processor speed improvements will essentially stop being vertical and continue to be horizontal (i.e. instead of increases in processor speed, increases in processors or cores will be the norm).  This means that in order for applications to utilize that type of system processing throughput concurrency will become more mainstream.  Microsoft has various concurrency initiatives going on (like the Parallel Framework Extensions).  It's only logical that lessons learned from this project not long will make their way into the BCL and the .NET Framework but also into the respective languages (C# included, I hope).  In this respect I hope that concurrency issues become first-class citizens in the library.  This would include things like immutability.  In the spirit of Agile development, the sooner this gets into the language the sooner it can be embraced and evolve.

**Object-Oriented Programming**

Much like [Jon Skeet][2], I believe the language designers should recognize that C# is an object-oriented language first and foremost.  This fact should continue to focus what, if any, aspects of other programming paradigms are added to the language. Paradigms like Aspect-Oriented Programming, Functional Programming, etc.

**infoof, memberof, propertyof, eventof, methodof Operators**

The information these operators require is so easy for the compiler to simply dump in the IL stream.  For users to do the same thing requires that they have a string containing the name of the member in question–which can't be checked at compile time and leads to maintenance nightmares.  Imagine what life would be like without the typeof operator forcing use to use code like this:

  

    Type type = Type.GetType("MyNamespace.MyClass");

Instead of:

  

    Type type = typeof(MyNamespace.MyClass);

…if I rename MyClass to UsefulClass no refactorying tool I've see will modify the "MyNamespace.MyClass" string and compilation will succeed and lead to a runtime-error.

**Cleanup Some Long-standing Issues**.

The above and variance could be viewed as a long-standing issues; but, I think they deserves to be called-out on they're own, they would be huge improvements.  Detection of recursive properties, for example.  The C# team have a backlog of a few things like this; now's the time.

**Extensible Compiler**

Years back my original idea for this was to have an IDE that automatically corrects mistakes.  e.g. if an "; expected" error was spit out, the IDE could intercept it, correct the code, and recompile.  But, this extensibility idea can be so much more than that.  This sort of extensibility could introduce Aspect-Oriented Programming fundamentals or Domain-Specific Language abilities without the language really understanding the concepts at all.  This extensibility would be very powerful for programmers and would give them the ability to evolve their language without being tied to the release schedule of the C# team.

**Thinking Out Loud**

Class-scoped aliases: Aliases in C# are a bit of a pariah, they're at global, file scope; making them not all that useful.  In C++, for example, it's quite common to declare type aliases within a class declaration (usually based on a templated type).  It would be nice to be able to create an instance of a type based on an alias within a class.  E.g. MyType.MyAlias o = new MyType.MyAlias;

 

![kick it on DotNetKicks.com][3]

[1]: http://blogs.msdn.com/ericlippert/archive/tags/Covariance+and+Contravariance/default.aspx
[2]: http://msmvps.com/blogs/jon.skeet/archive/2008/02/10/c-4-part-4-my-manifesto-and-wishlist.aspx?CommentPosted=true#commentmessage
[3]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f02%2f06%2funit-testing-the-units.aspx

