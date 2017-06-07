---
layout: post
title: Rethinking the Liskov Substitution  Principle
date: 2017-06-07 14:32:00 -0500
categories: ['SOLID', 'Principles', 'Distributed Computing']
comments: true
excerpt: "Liskov Substitution isn't just about object-oriented design."
---
# Rethinking the Liskov Substituion Principle
Barbara Liskov's famous principle (named Liskov Substitution Principle by Robert Martin) came out of the area of [data abstraction][] as it applies to a hierarchy of data types.  At the time (around 1987-1994) the idea was someone absorbed by software language advancements of the day, primarily object-orientation.  The principle got heavily associated with OOD and OOP and many people left it at that. But, I suggest that Liskov Substitution Principle (LSP) is wider appeal than just in the design of objects/classes.

I recently had a conversation about LSP within the SOLID principles as they apply to distributed architecture (Service-Oriented Architecture at the time) where in the back of my head I had discounted LSP and said something along the lines of "SOLID applies, except for maybe Liskov".  We proceeded to talk about what we should call SOLID with out 'L' and came up with the "I DOS".

The more I thought about it, the more I could reconcile LSP with various principles that apply to distributed software design and architecture.  So, I changed my mind.

As I detailed above, the original idea was around data abstraction and it was absorbed as an *OOD principle*.  The original principle is:

>*Subtype Requirement*: Let &Phi;(&#x1d501;) be a property provable about objects &#x1d501; of type &#x1d683;. Then &Phi;(&#x1d502;) should be true for objects &#x1d502; of type &#x1d682; where &#x1d682; is a subtype of &#x1d683;.

Or, as Robert Martin simplifies:
>objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.

Martin goes on to show the strong resemblance between LSP and Bertrand Meyer's *Design by Contract*.  And this is where I think LSP can really be applied to distributed architecture.  For completeness, Meyer associated that contract with human contracts by defining them as:
>* Each party expects some benefits
from the contract and is prepared to
incur some obligations to obtain them.
>* These benefits and obligations are
documented in a contract document. [1]


By definition, components in a distributed system at some level communicate with other components via the network.  In order for those components to communicate effectively and repeatedly there needs to be a known API or a "contract".  This "contract" defines the inputs, the outputs, their structure and their constraints (or the obligations and benefits).  Therefore, *given two distributed components with the same contract, one should be replaceable with other components with the same contract without altering the correctness of the system*.

So, I believe LSP to be a very important part of distributed computing as it provides the governor to Dependency Inversion Principle so that no only should things depend upon abstractions, but different implementations of those abstractions should not affect the correctness of the system.

[data abstraction]: http://dl.acm.org/citation.cfm?id=62141
[1]: B.Meyer, "Applying Design by Contract", IEEE Computer, Oct.1992, 40-51.
