---
layout: post
title: 'Seam expansion'
tags: ['Architecture', 'Design/Coding Guidance', 'Patterns', 'Software Development', 'Software Development Guidance', 'Software Development Practices', 'Software Development Principles', 'msmvps', 'February 2015']
---
[Source](http://pr-blog.azurewebsites.net/2015/02/17/seam-expansion/ "Permalink to Seam expansion")

# Seam expansion

No, this isn't a post about gaining weight: busting at the seams. It's about expanding on the concept of "seams".

My first introduction to "seams" was with Michael Feathers' book _Working Effectively with Legacy Code_. In which he defined a seam as:

> A seam is a place where you can alter behaviour in your program without editing that place.

He also detailed some _types_ of seams: _Preprocessing Seams_, _Object Seams_, and _Link Seams_. As well as detailing _Enabling Point_, or the thing that represents the choice of which behaviour to enable at that seam.

Feathers described seams and their use in the context of testing. I think the concept of seams can be used for other places we want to reason about code, design, or architecture. Before I get into that, let's have a quick overview of the types of seams that Feathers detailed.

This seam is fairly straightforward. It's a point where a compiler's preprocessor lets you enable or disable behaviour based on preprocessor directives (.NET, C++, etc) or preprocessor logic (C++, etc.). I'm sure we're all familiar with using #if DEBUG to enable/disable behaviour.

This seam is also straight-forward, it basically details the abstraction behind OOD and that through polymorphism and an object's published API (or behaviour) we can facilitate enabling or disabling behaviour at compile-time.

The final seam (although, the second in _Working Effectively With Legacy Code_) basically details all the other possibilities (at least in the context of object-oriented languages) in that they are seams not related to the compiler. I think this type of seam offers a wonderful ability to facilitate abstraction at so many other levels and allows us to reason about code, design, and architecture in very powerful way. The rest of this post will be about expanding this seam concept (link-level or link-time) into other areas to allow us to reason about software design more powerfully.

One place where we can get immediate value from seams is to view them as an independent attribute of a design or architecture. We could view seams as just a side effect of integrating components in a system, but by viewing them as independent artefacts we can reason better about software and its design and architecture. Much like a directed graph that has nodes and edges, a dependency diagram details components and dependencies or relationships. In most cases, we can view these dependencies and relationships as seams that we can reason about over-and-above testing, regardless of _how_ they are dependant.

Seams are effectively recognizing APIs (or subsets of APIS) and allowing them to be independent of the elements on either side of the seam. When we do that, either side of the dependency is really dependant on the _seam_, not on the other side. If we take that point of view, we can then modify one side to modify the behaviour of the other without directly modifying that other side. We're really just thinking about abstraction in a different way.

The link seam that Feathers details encompasses link-time resolutions (in terms of .NET: _references_) but also includes dynamic resolution (run-time linking done either by the runtime, or by the application code—e.g. Double Dispatch, the dynamic keyword, etc.). Feathers' _Link Seam_ is effectively a run-time resolution seam but can be expanded to allow reasoning about much more of a system's design. For example, in many contemporary systems we use web APIs to communicate between components. This really isn't the "link" operation that which Feathers details; but equally as useful when viewed as a seam. A web API is a much more understandable API front-end to implementation—we can view all APIs this way when we use seams. We can even view a logical grouping of components in a design and their API as a seam. There may be no unique physical separation between a logical group and the things that depend on it, but again, equally as useful to view its seams.

Some readers may be thinking, these are just _views_. While this is a very good analogy and it shows you're grasping the concept, seams are not views. Views are different in that the view is an implementation detail _behind_ a physically componentized API, the seam is an outward representation of a grouping of APIs (physically componentized or logically grouped). Any particular component with an API may, of course, implement that API with a view behind it; but that's orthogonal to seams. e.g. a seam exists whether or not the View pattern is used.

Once we can reason about seams we can then reason about the rest of the design around those seems. As I've mentioned, we can view a logical grouping of APIs as a logical component that publishes a specific API. If we maintain that specific API over time, we can change the implementation behind that API without having to modify that rest of system that depends on it. We, of course, will likely have to re-compile or re-build and re-deploy; but if we have maintained that _seam_, that re-compile our re-build will not fail.

Recognizing, defining, and reasoning about seams at these levels provides a lot of flexibility in software design and architecture. This post serves as an introduction to this expanded seam concept that will be shown in my next post.


