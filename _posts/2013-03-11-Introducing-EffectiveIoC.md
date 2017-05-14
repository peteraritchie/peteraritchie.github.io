---
layout: post
title: Introducing EffectiveIoC
categories: ['.NET 4.0', '.NET 4.5', '.NET Development', 'C#', 'EffectiveIoC']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2013/03/11/introducing-effectiveioc/ "Permalink to Introducing EffectiveIoC")

# Introducing EffectiveIoC

Last week I [tweeted][1] a few times about writing an IoC container in less than 60 lines of code.  I also [blogged][2] about how I thought the average IoC container was overly complex and didn't promote DI-friendliness.

Well, EffectiveIoC is the result of that short spike.  The core ended up being about 60 lines of code (supported type mappings—including open and closed generics—and app.config mappings).  I felt a minimum viable IoC container needed a little more than that, so I've also included programmatic configuration and support for instances (effectively singletons).  I've also thrown in the ability to map an action to a type to do whatever you want when the type is resolved.  Without all the friendly API, it works out to be about 80-90 lines of code.

## Why?

Well, the project page sums this up nicely.  For the most part, I wanted something that promoted DI-friendly design—which, from my point of view, is constructor injection.  So, EffectiveIoC is very simple.  It supports mapping one type to another (the _from_ type must be assignable to the _to_ type) and registering of instances by name (key).  Registering type mappings can be done in app.config:

or in code:

And type instances can be resolved like this:

Instances can also be registered.  In config this can be done like this:

Or in code, like this:

Instances can be resolved by name as follows:

For more information and to view the source, see the GitHub project site: [https://github.com/peteraritchie/effectiveioc][3]

[1]: https://twitter.com/peterritchie
[2]: http://bit.ly/Zm1vIM
[3]: http://bit.ly/WEo1xY "https://github.com/peteraritchie/effectiveioc"

