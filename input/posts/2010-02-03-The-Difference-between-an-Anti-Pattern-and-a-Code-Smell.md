---
layout: post
title: 'The Difference between an Anti-Pattern and a Code Smell'
tags: ['AntiPattern', 'Design/Coding Guidance', 'Patterns', 'Software Development', 'Software Development Guidance', 'msmvps', 'February 2010']
---
[Source](http://blogs.msmvps.com/peterritchie/2010/02/03/the-difference-between-an-anti-pattern-and-a-code-smell/ "Permalink to The Difference between an Anti-Pattern and a Code Smell")

# The Difference between an Anti-Pattern and a Code Smell

I think the term "Anti-Pattern" is being over used. There's various definitions for Anti-Pattern like "obvious but wrong, solutions to recurring problems" and "common approaches to solving recurring problems that prove to be ineffective". All definitions have a common thread: they're recognizable solutions (pattern) that don't work in at least one way and should never be used.

This means that anything that does work, when used correctly, isn't an Anti-Pattern. Transitively, that doesn't make incorrectly used Patterns Anti-Patterns.

Code Smells, on the other hand, are defined as "…a hint that something might be wrong, not a certainty.".

I've seen the term Anti-Pattern used in a couple of places lately that describe scenarios where patterns are used incorrectly. Each and every pattern has a time and a place (a context). Outside of that context, it is not an anti-pattern.

The term Code Smell is much better to describe inappropriate uses of patterns.

For example, Mark Seemann recently blogged that [Service Locator is an Anti-Pattern][1]. I disagree. I argue that there is a time and a place for Service Locator. Incorrect use of Service Locator is definitely a code smell—it's an indication (a hint, not a certainty) that there's something wrong with the design. The fact that you're using Service Locator instead of Dependency Injection is, indeed, a design issue. But, dependency injection may not be possible. WebForms, for example. I can't inject dependencies into a web form because I have no control over it's construction. I'm forced to either use a Service Locator or a Factory to aid in my decoupling efforts.





![kick it on DotNetKicks.com][2]

[1]: http://blog.ploeh.dk/2010/02/03/ServiceLocatorIsAnAntiPattern.aspx
[2]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2010%2f02%2f03%2fthe-difference-between-an-anti-pattern-and-a-code-smell.aspx


