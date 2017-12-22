---
layout: post
title: What Is Architecture
date: 2017-12-21 23:32:00 -0500
categories: ['Odds', 'Hacks', 'Markdown']
comments: true
excerpt: "Hacks for putting comments into markdown that won't appear when rendered."
---
# What Is Architecture
Getting someone to explain architecture is sometimes like asking them what *disinterested* means or whether *irregardless* is a word. The number of answers you get from people has a complexity O(n log n) to the number of people you ask.
 
Architecture is defined as:
>The fundamental organization of a system, embodied in its components, their relationships to each other and the environment, and the principles governing its design and evolution. ([ANSI/IEEE 1471-2000](http://standards.ieee.org/findstds/standard/1471-2000.html)) 
 
or
>The structure of components, their interrelationships, and the principles and guidelines governing their design and evolution over time. ([TOGAF](http://www.opengroup.org/public/arch/p1/togaf_faq.htm))
 
One thing that is very subtle about these definitions is the aspect about "design and evolution" especially regarding "over time".
 
Architecture is the fundamental component granularity of a system and the component structure, the interrelationships of those components, and the principles governing the lower-level design and evolution from initiation or conception of a system.
 
This means the architecture applies before many of the *logical* design decisions can be made. Architecture considers the high-level *concepts*, *philosophies*, and *principles* (e.g. domain topics, vision, patterns) that would go into the lower-level design.  The subtlety here is that these are the basis of the logical decisions (which type of database, what format data might be in, algorithms, which language is most appropriate, etc.).

> Before getting too much further, we should dig into *Conceptual v Logical*.

> Generally accepted design principles involve understanding the concepts of the real-world domain (or "business"), it's processes, what decisions are made, the workflow, expectations, results, etc.  Those are the *concepts* of the domain.  i.e. that is *conceptual information* as it relates to an implementation.  That conceptual information allows us (through analysis) to discover and evaluate *logical* solutions or automation techniques.  The logical information builds a potential model to guide the logical implementation.  That logical model would not be possible (or would not be accurate) without collecting and understanding the concepts and formulating/describing a conceptual model.

If architecture is that much before those logical decisions can be made, what goes into deciding upon an architecture?  Over-and-above the principles, philosophies, and generally acceptable practices; much of what governs how something is architected involves the quality attributes required of the solution.  Quality attributes are often called non-functional requirements (you may be able to guess my preference).  There are lots of quality attributes that impact an architecture.  Also, many of these attributes can be (or have been) decided upon before lower-level functional details.  I could go on about each attribute like availability, disaster recovery, fault tolerance, performance, reporting, maintainability, etc.; but that’s an entire series of posts.  Many of these attributes are necessary or known *despite* the functional requirements.  An architecture needs to take these things into consideration to be correct. (A design realizes those considerations, or should)
 
Some of the confusion of what architecture is may come from the fact that not all software is written from the very beginning.  Iterative changes to software also mean iterative changes to architecture.  Those changes to architecture are done with a greater knowledge of logical and implementation details and thus a higher risk of becoming influenced by logical details, or have them leak into the architecture such that they may be hard to differentiate between the two.
 
So, in terms of software that changes iteratively (is there any other kind?), how can we ensure the vision of the architecture remains visionary and influences the iterative changes of software from a high-level aspect? Now that we have a clearer understanding of the level and point of view of the architecture we can better keep conceptual concerns in the architecture and logical concerns lower in the design and implementation. Also knowing that architecture componentizes conceptually and makes many decisions on relationships between components based on quality attributes, we can make informed determinations between architectural changes and design/implementation changes.
 
Sometimes the architecture cannot be finalized until a great amount of understanding of a solution.  Even though the software may not be implemented (and thus incrementing) that understanding can negatively influence what should be architectural decisions.  For example, what does a REST API *actually* model?  With a deep understanding of a solution (like data may be stored in a relational database with specific table names) that understanding can result in interfaces overly-coupled to the implementation.  This can manifest in interfaces that are not based on conceptual information but on logical information.  For example, when we know there's really a database implementation detail and a "resource" may be a row in the database, it can become hard to differentiate POST/GET/PUT/PATCH/DELETE from CREATE/READ/UPDATE/DELETE because those are the logical details of the database.
 
A related area, and a personal peeve, is when "MVC" applications are really "C" applications.  In these applications there is *really* no distinct conceptual information (i.e. a model) and everything is effectively muddled together in the controller (or *big ball of mud*).  In an MVC application the model is conceptual to *model* the domain (i.e. the domain we need to understand to initiate or conceive of a project/product) and the view is a *view* of that model based on the behavioral concepts the application is solving for or UI technical details.
 
## Being Successful
### Understand Architectural Boundaries
It's important to understand from a general point of view, where architecture can start (what it more-or-less depends upon) and end (or when it influences other things).  Much of software development is imperial, so also an understanding of what architecture means in a product/project context also contributes a better understanding of where things do and do not fit into "architecture".

### Understand Boundaries Should Involve Only Concepts
An architecture (a.k.a. a *good* architecture) considers the *conceptual* to discover the *logical*.  It's important to understand that despite architectural evolution in-step with software evolution that only conceptual information should live in the "architecture" and that there isn't one description/specification to fit architecture *and* design (describing the concepts is different from specifying the logical details).

### Understand Conceptual from Logical
 An architecture describes those conceptual details, how they're componentized, and their type of relationships.  That should ultimately influence the design, not the other way around.  If you're evolving a complex system over time, make sure you understand the conceptual information (i.e. the domain, its vocabulary, processes--independent of whether it's automated within software) and the logical (how it is or may be automated with software).
 
## References
- [TOGAF® Version 9.1](http://www.opengroup.org/subjectareas/enterprise/togaf)
- [The Zachman Framework 3.0](http://www.zachman.com/about-the-zachman-framework)

