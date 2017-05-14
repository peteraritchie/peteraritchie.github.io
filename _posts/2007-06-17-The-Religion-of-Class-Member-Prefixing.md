---
layout: post
title: The Religion of Class Member Prefixing
date: 2007-06-16 20:00:00 -0400
categories: ['C#', 'Design/Coding Guidance', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/06/17/the-religion-of-class-member-prefixing/ "Permalink to The Religion of Class Member Prefixing")

# The Religion of Class Member Prefixing

The periodic identifier naming/prefixing/Hungarian-notation religious discussion [reared][1] its head recently on[ Eric Gunnerson's blog][2].  

This particular discussion revolves around the Microsoft-based guideline/anti-guidance of prefixing class member names with "m_" to denote that they are members.  I've contributed to many of these discussions over the years and thought it about time to encapsulate my separate remarks to which I and others can refer to.

For the most part I accept this habit with my programmers for a variety of reasons: isn't guaranteed to do any harm, it's habit, refactoring tools make it easy to remove "m_", etc.

When I switched from C++ to C#, I too brought along the "m_" prefix baggage where members can't be scoped by "this" everywhere (see intializer lists).  I quickly realized it was unnecessary in C#, and haven't turned back.

Kent Beck's and Martin Fowler's Refactoring principles brought us the concept of "Code Smell".  Code smells are hints (I'm a pragmatist) that something might be wrong with code.  "m_" to me is a bad smell.

When I ask a programmer why "m_" is used the practical answer is invariably "well, the code is too hard to understand without it" (the non-practical answers are usually "Because of the coding guidelines", or "It's just habit", but those don't answer the "But, why?").  And this, to me, is a bad code smell.

How complex does a class need to be in order for "m_" to make a difference?  Clearly too complex.  Is the class cohesive?  Does the class and it's methods follow generally accepted cohesiveness design principles like [Law of Demeter][3] or [Single Responsibility Principle][4]?  Is the class in inappropriately coupled to other classes?  Have the meaningful-names guidelines been followed?  I've never seen a class implementation where a member needed to be so complex (without violating one of the previously mentioned principles) to warrant the need for "m_".  Occasionally the need to scope a member with "this." is required; but that's usually very infrequent, much less frequent than having to type "m_" on _every_ member.

If a class _is_ simple, why should complexity idioms be forced upon it?  "m_" only works if you use it everywhere; if you don't use it in some places it makes it pointless.  If I'm not sure the programmer just didn't forget "m_", and I still have to refer to the class–the task that "m_" is supposed to ensure isn't needed.  Similar in principle to using [const-correctness][5], something missing from C# programming for the lack of enforcing it consistently.

The topic of consistency is one of the main reasons why I'm not a proponent of "m_".  There's no way to enforce use of "m_", which leaves it up to the programmer.  I've dealt with thousands of lines of code from hundreds of other programmers, more often than not inconsistent use of "m_" actually cuased "m_" to make the code much _harder to read_.  Even the birthplace of "m_" has inconsistent usage of the idiom.  Abram's and Cwalina's _Framework Design Guidelines_ (the tome by which all Microsoft code is supposed to abide), as enforced by FxCop and Code Analysis (CA), suggests not using underscore or prefixes (other than "I" for interfaces); yet Eric is a proponent of "m_".  Much code that comes out of Microsoft (including the .NET Framework) occasionally uses "m_", often inconsistently.  Using "m_" can cause as many as 4 CA different warnings if the complex rules of "m_" are not followed.  Porting code is a great source for that.

I call it a religious discussion because those who religiously follow the "m_" habit will not be swayed by logic or reason and invariably counter with some edge/corner case that could have made "m_" equally as useful as "this.", or some logical fallacy, or an _appeal to authority_ they've convinced themselves proves their case.

_"m_" is less typing than "this."_ is a great logical fallacy.  This is a fallacy because it's only true in _that_ sentence.  Yes, if you have to type "m_" once instead of typing "this." once, you've saved 3 keystrokes (at my typing speed that works out to saving about 300ms).  With the "m_" prefix, that's now part of the name of the identifier, you **_must _type it _every_ time you type the name of that identifier**.  With "this.", its necessity is based on context, or scope, so its use is optional in most cases and mandatory in some (backed-up with a compiler error, to which you should all agree compile-time checks should be used whenever possible).  An identifier's un-obviousness of being a member doesn't occur with every instance of it.  With an effective IDE it can infer the context in which you are typing and suggest what you're likely typing (Intellisense in Visual Studio).  When using the "m_" prefix you must type at least 3 characters for every single private member of a class  (assuming that's the guideline) for the suggested completion to be useful.  In cases where "this." isn't necessary, you only need to type one character for it to be equally useful.  If you took the average class and analyzed how many keystrokes would be required for "m_" compared to no prefix and "this." when needed, you'd find that using "m_" is actually _more _typing.  Ironically, any time that could have been saved using or not using "m_" has been _far less_ than the time spent discussing it.

Other reasons why "m_" isn't a solution every time it's used:

  

  

* It's English-centric.  As such, it becomes more and more arbitrary with speakers of other languages.

  

* It's typically C++-based.  VB programmers have a whole different set of prefixing rules.

  

* It's usage ends up being very contextual.  In C++ "m_" could be mandated all member fields, in C# it could be mandated on only private instance members that aren't const (and I've never seen a clear description of the mandate for example Juval Lowy's IDesign C# Coding standard is seeminly contradictory: "Use Pascal Case for … constants" providing a example of a private member const named _DefaultSize_ and "prefix private member variables with m_".    
Yes, it's clear that DefaultSize is not _variable_ in nature but the junior programmers to which these guidelines are directed usually don't pick up on that nuance).

Some discussions on the topic often sway between the "m_" prefix and just an underscore ("_") prefix.  Some argue that "m_" stands out more than "_".  Another great logical fallacy because a "Member" suffix should be preferred because it stands out even more.

Regardless of whether prefixing is used, most guidelines mandate that identifiers have meaningful names.  If meaningful names are used, it's highly unlikely that it will be unclear in the code that a particular identifier is or is not a member of the class.  More meaningful names [help in more areas][6] that just distinquishing members from non-members.

For me, my general idioms are: use meaningful identifier names, prefer suffixes to prefixes, don't use underscores, use Camel Case for field members, and Pascal Case for non-field members (methods, types, constants, namespaces, etc.).  Easy to understand, easy to follow, easy to qualify and enforce…

[1]: http://blogs.msdn.com/ericgu/archive/2007/06/15/to-m-or-no-to-m-that-is-the-question.aspx
[2]: http://blogs.msdn.com/ericgu/default.aspx
[3]: http://en.wikipedia.org/wiki/Law_of_Demeter
[4]: http://en.wikipedia.org/wiki/Single_responsibility_principle
[5]: http://en.wikipedia.org/wiki/Const
[6]: http://blogs.msdn.com/ericlippert/archive/2007/06/12/bad-names.aspx

