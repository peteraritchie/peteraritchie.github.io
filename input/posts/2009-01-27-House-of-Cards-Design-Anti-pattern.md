---
layout: post
title: 'House of Cards Design Anti-pattern'
tags: ['AntiPattern', 'Design/Coding Guidance', 'Software Development', 'msmvps', 'January 2009']
---
[Source](http://blogs.msmvps.com/peterritchie/2009/01/27/house-of-cards-design-anti-pattern/ "Permalink to House of Cards Design Anti-pattern")

# House of Cards Design Anti-pattern

I've had this anti-pattern in my head for years. It's an observance of some projects and methodologies that I've witnessed over the years. I believe it's a form of [Voodoo Programming][1], [Programming by coincidence][2], and is often a side effect of [Cargo Cult Programming][3].

Anti-Pattern Name   
House of Cards Anti-pattern

Problem   
A problem occurs when software is written that works in a specific observed scenario but no one knows why it works in that scenario. Observation of "working" is taken as enough evidence of completeness. It is very often not enough to observe something working in one scenario for the software to be considered "correct".

This is often a result of continual hacks in sole response to correcting bugs without consequence to design or maintainability. Repeated hacks (cards) are are placed on top of other hacks until something has the appearance of "working" then all development on it stops and no one wants to go near the code again for fear of breaking it.

At the very least, House of Cards design is fragile, hard to maintain, un-agile. Worst case it's is of low quality and prone to error and data lose.

This is a general sign of [cowboy coding][4]. I means there is no acceptable methodology, and no real management. There's little development direction, and likely no development leadership (at least none with any meaningful experience). Features are generally driven solely by an external source that communicates directly with developers.

Symptoms

When reviewing code or questioned about code, developers respond with comments like "don't touch it, it works", or "we don't want to change it because it works". There's a reluctance to change the code because no one really knows _why_ it works. The code stagnates, new features are slow to be implemented, and there's a general un-assuredness about the code.

The code is generally procedural, although following object-oriented syntax. 

Establish experienced development leadership. Establish a development methodology that separates the stakeholders from the developers.

Invoke Agile methodologies to manage the requirements of the project and begin Agile redesign of the code employing unit testing, refactoring, patterns, etc. Aggressively refactor the code adding unit tests to test for specific problems as they arise, until the code is robust and reliable. Mandate adherence to SOLID principles: classes adhere to Single Responsibility Principle, Open-Closed Principles, Liskov Substitution Principle, Interface Segregation Principle, and uses the Dependency Inversion Principle

[1]: http://en.wikipedia.org/wiki/Voodoo_programming
[2]: http://www.pragprog.com/the-pragmatic-programmer/extracts/coincidence
[3]: http://en.wikipedia.org/wiki/Cargo_cult_programming
[4]: http://en.wikipedia.org/wiki/Cowboy_coding "cowboy coding"


