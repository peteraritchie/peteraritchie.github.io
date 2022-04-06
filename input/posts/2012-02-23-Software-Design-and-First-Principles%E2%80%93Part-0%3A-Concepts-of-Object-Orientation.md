---
layout: post
title: 'Software Design and First Principles–Part 0: Concepts of Object Orientation'
tags: ['.NET Development', 'C#', 'Software Development Guidance', 'Software Development Principles', 'Visual Studio 2010 Best Practices', 'msmvps', 'February 2012']
---
[Source](http://blogs.msmvps.com/peterritchie/2012/02/23/software-design-and-first-principles-part-0-concepts-of-object-orientation/ "Permalink to Software Design and First Principles–Part 0: Concepts of Object Orientation")

# Software Design and First Principles–Part 0: Concepts of Object Orientation

I often compare software development with building houses or woodworking. I sometimes even compare software development with the vocation of electrician. In each of these other vocations, craftspeople need to go through a period of apprenticeship and mentoring before being "allowed" to practice their craft. In each of these vocations there are a series of rules that apply to a lot of the basics of what what they do. With building houses there are techniques and principles that are regulated by building codes; with electricians there's techniques and fundamentals that are effectively regulated by electrical codes and standards. It's one thing to learn the techniques, principles, and fundamental laws of physics; but, it's another thing to be able to call yourself an electrician or a carpenter.

Now, don't get me wrong; I'm not advocating that software development be a licensed trade—that's an entirely different conversation. But, I do believe that many of the techniques and principles around software development take a lot of mentorship in order to get right. Just like electricity, they're not the most intuitive of techniques and principles. But, just like electricity, it's really good to know why you're doing something so you can know its limits an better judge "correctness" in different scenarios.

To that effect, in order to understand many of the software development design techniques and patterns, I think the principles behind them are being ignored somewhat in a rush to get hands-on experience with certain techniques. I think it's important that we remember and understand what—I'm deeming—"first principles".

A **First Principle** is a foundational principle about what it applies to. Some of the principles I'm going to talk about may not all be foundational; but, I view then as almost as important as foundational, so I'm including them in First Principles.

From an object-oriented standpoint, there's lots of principles that we can apply. Before I get too deeply into these principles, I think it's useful to remind ourselves what object-orientation is. I'm not going to get too deep into OO here; I'll assume you've got some experience writing and designing object-oriented programs. But, I want to associate the principles to the OO concepts that guide them; so, It's important you as the reader are on the same page as me.

OO really involves various concepts. These concepts are typically outlined by: Encapsulation, abstraction, inheritance, Polymorphism (at least subtype, but usually parametric and ad-hoc as well), and "message passing". I'm going to ignore message passing in this part; other than to say this is typically implemented as method calls…

You don't have to use all the OO concepts when you're using an OO language; but, you could argue that **encapsulation** is one concept that is fundamental. Encapsulation is sometimes referred to information hiding; but, I don't think that term does it justice. Sure, an object with private fields and methods "hides" information; but, the fact that it hides the privates of the type through a public interface of methods isn't even alluded to in "information hiding". Encapsulation is, thus, a means to keep privates private and to provide a consistent public interface to act upon or access those privates. The interface is an abstraction of the implementation details (the private data) of the class.

The next biggest part of OO is **abstraction**. As we've seen, encapsulation is a form of abstraction (data abstraction); but the abstraction we're focusing on now is one that decouples other implementation details. Abstraction can be implemented with inheritance in many languages (e.g. code can know now to deal with a Shape, and not care that it's given a Rectangle) and that inheritance can use abstract types. Some OO languages expand abstraction abilities to include things like interfaces—although you could technically do the same thing with an abstract type that had no implementation.

**Inheritance** is key to many of other concepts in OO—abstraction, subtype polymorphism, interfaces, etc. (if we view an interface as an abstract type with no code, then something that "implements" an interface is really just inheriting from an abstract type; but, my focus isn't these semantics). We often let our zeal to model artefacts in our design and run into problems with the degree and the depth of our inheritance; a point I hope to revisit in a future post in this series.

Although you could technically use an OO language and not use polymorphism in any way, I think OO languages' greatest features is polymorphism. **Subtype polymorphism**, as I've noted, is a form of abstraction (Shape, Rectangle…). But all other types of polymorphism are also abstractions—they're replacing something concrete (implementation details) with something less concrete (abstract). With subtype polymorphism that abstraction is an abstract type or a base type; with **parametric polymorphism** we generally create an algorithm abstraction that is decoupled from the data involved (Generics in .NET); and ad-hoc polymorphism is overloading—a decoupling of one particular method to one of many.

I quickly realized the scope of this topic is fairly large and that one post on the topic would be too much like drinking from a firehose as well as potentially to be protracted (and risking never getting done at all :). So, I've split up what I wanted to talk about into chunks. I'm not entirely sure what the scope actually is yet; I'll kind of figure that out as a I go or let feedback guide me. Now that we've got most of the OO concepts in our head, the next post will begin detailing the principles I wanted to talk about.


