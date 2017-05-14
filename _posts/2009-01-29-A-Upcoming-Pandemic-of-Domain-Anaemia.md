---
layout: post
title:  "A Upcoming Pandemic of Domain Anaemia"
date:   2009-01-28 19:00:00 -0500
categories: ['.NET Development', 'ALT.NET', 'AntiPattern', 'DDD', 'Design/Coding Guidance', 'Microsoft', 'Microsoft Patterns and Practices', 'OOD', 'Patterns', 'Software Development', 'Software Development Guidance', 'Visual Studio 2010 Best Practices']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2009/01/29/a-upcoming-pandemic-of-domain-anaemia/ "Permalink to A Upcoming Pandemic of Domain Anaemia")

# A Upcoming Pandemic of Domain Anaemia

There's a well-known anti-pattern called the anaemic domain model[1][2].  This anti-pattern basically says domain entities, chronically, have little or no behaviour (remember, object-oriented design is about attributes **and** behaviour).

It should be obvious that a domain model that isn't truly object oriented is a domain model with a problem.  But, let's look at other reasons why the Anaemic Domain Model is an anti-pattern.  Your Domain is the nexus, the essence, of your system.

An anaemic domain model is basically a reporting system.  Each "Entity" becomes, essentially, a query.  This is fine, reporting systems are necessary and prevalent.  But, to shoe-horn a domain model on top of this leads away from good reporting patterns that could add value and increases complexity, needlessly.  The designers spend most of their time trying to force entities on the system, without recognizing the basic reporting nature of the system.  This usually leads to "reports" that have to pull in multiple domain "entities" to generate the report–rehydringing data into an entity (usually through some sort of ORM) with no value added.  i.e. an ORM that will manage the child-parent relationship (and either pre-load or lazy-load aggregates) doesn't provide much value here.

The worst case scenario with an anaemic domain model is that there really is behaviour there; but it's not handled in the domain entities; it's handled in a different layer.  This is a problem because this circumvents the whole point of a domain model and layering.  

One indication of anaemia is that most of the domain classes  simply contain attributes.  Anyone familiar with patterns should recognize this as a Data Transfer Object, not a Domain Entity.  There's nothing wrong with DTOs, they're very important in almost all systems with any sort of complexity; but they're not Domain Entities.  Let's be truthful, there are systems with little or no behaviour in the domain; and that's not a bad thing.  Systems like this likely don't need a Domain Model and may not need techniques like Domain Driven Design.  The quicker people recognize that, the quicker they can be using a more appropriate architecture and design.  In some extreme cases the anaemic-domain-entity-DTOs service other DTOs

Now, where am I going with this?  Well, there's been a series of guidance out of Microsoft Patterns and Practice about some application "patterns".

First, let me describe what a pattern is.  A pattern is a way of "documenting a solution to a design problem" [3].  First, for it to be a pattern, it needs to detail the problem and it's context, then provide a solution.  The latest "patterns" from P&P do not detail the problem or a context.  They're simply architectural descriptions.

Now the association between the Anaemic Domain Model and the latest P&P guidance.  In 3 of the 5 recently publish "patterns" the following is detail is included: "A Domain Entity pattern is used to define business entities that contain data only."  This is the very definition of an Anaemic Domain Model.  Plus, in the RIA pattern the following, contradictory, detail is included: "Domain entities are responsible for implementing business rules.  Entities from the domain model represent business objects that contain data and implement behavior [sic]. In other words, the business objects are responsible for implementing business operations and interacting with other business objects."

This is disconcerting because historically sample code and guidance from Microsoft is simply reused without thought.  This leads to poorly designed and architected applications, and the .NET community as a whole is seen as one that produces poor-quality code and design.  Without context about the problems these patterns try to solve, they will be misused—likely forced upon contexts and situations where they don't fit, simply because "they're from Microsoft".

[1] [MF Bliki- AnemicDomainModel][1]

[2] [Anemic Domain Model – Wikipedia, the free encyclopedia][2]

[3] [Design pattern (computer science) – Wikipedia, the free encyclopedia][3]

[1]: http://www.martinfowler.com/bliki/AnemicDomainModel.html "MF Bliki- AnemicDomainModel"
[2]: http://en.wikipedia.org/wiki/Anemic_Domain_Model "Anemic Domain Model - Wikipedia, the free encyclopedia"
[3]: http://en.wikipedia.org/wiki/Design_pattern_(computer_science) "Design pattern (computer science) - Wikipedia, the free encyclopedia"

