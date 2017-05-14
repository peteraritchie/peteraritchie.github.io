---
layout: post
title: Maxim’s of Object-Oriented Design – Layers
date: 2008-02-05 19:00:00 -0500
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/02/06/good-object-oriented-design-layers/ "Permalink to Maxim’s of Object-Oriented Design – Layers")

# Maxim’s of Object-Oriented Design – Layers

Good object oriented design is much more than simply modeling real-world concepts as classes (and when I say classes I mean "types" which could include "struct"), methods, and attributes.  Object-oriented design involves the interaction of the entire system, that interaction should also follow sound object-oriented principles and influence the design of the individual parts of the system.

There's various OO design principles for classes, like the single responsibility principle, high cohesion, low coupling, acyclic dependencies principle, separation of concerns, etc.  All of these principles build on and enhance either encapsulation or abstraction.

There's many design patterns for making easier to maintain (translating to more reliable) systems.  One such pattern is the layer.  The layer is a logical (usually also physical) grouping of types that perform related tasks.  A layer is a level of abstraction of those related tasks.  Data Access or Persistence Layers deal strictly with the task of read/writing data to a data store, for example.  A layer, is much like a class: its members must relate to a single responsibility (although a more abstract responsibility than a class), they must be cohesive, and they must have concerns only relating to the single responsibility of the layer.

Types in a layer, if property cohesive, should have very little coupling to types outside the layer.  It's rare that a layer is completely autonomous and often makes use of another layer.  Generally layers are implemented as packages (physical grouping of code).  Packages must follow the acyclic dependencies principle, otherwise you get build-ordering nightmares. Follow the acyclic dependency principle menas that a layer that depends upon (uses) another layer should not also be depended upon by that layer. In other words, dependancies between layers should only be one way.   If you find you are getting a cyclic dependency between two layers, you're likely mixing concerns and you should think about merging them or refactoring the cyclic dependencies into a third layer.

 

