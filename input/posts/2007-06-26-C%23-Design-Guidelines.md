---
layout: post
title: 'C# Design Guidelines'
tags: ['Uncategorized', 'msmvps', 'June 2007']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/06/26/c-design-guidelines/ "Permalink to C# Design Guidelines")

# C# Design Guidelines

**Principles**

Prefer explicit declarations to implicit declarations. If you're expecting something from a declaration, explicitly state it.

Never depend on implicit side-effects.

Never design cyclic dependancies, always design ascyclic dependancies.

Prefer readability over complexity.

Never optimize 

Always prefer the 

**Prefer** always implementing an empty constructor instead of no public constructor.

  

> There is a side-effect to not implementing any constructors: you get a public general constructor for free. The drawback to that is if you add a non-general constructor your interface changes. If something is already constructing your class that will introduce a compile error.

**Prefer** internal on class declarations rather than no access.

**Prefer** public on member declarations rather than on access.

**Prefer** sealed on class declarations unless the class is designed to be derived from.


