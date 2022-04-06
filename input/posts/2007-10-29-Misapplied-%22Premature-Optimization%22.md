---
layout: post
title: 'Misapplied "Premature Optimization"'
tags: ['Uncategorized', 'msmvps', 'October 2007']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/10/29/misapplied-quot-premature-optimization-quot/ "Permalink to Misapplied "Premature Optimization"")

# Misapplied "Premature Optimization"

First of all, let's get some definitions out of the way.

**Optimisation**  
"…the process of modifying a system to make some aspect of it work more efficiently or use fewer resources." 1

**Premature Optimisation**  
"Optimization on the basis of insufficient information." 2

In other words, premature optimisation is making a modification to some aspect of a system without sufficient information to gauge whether it will make the system more efficient or use fewer resources.

The key point I'm emphasising is "modification". Other's have blogged about this in the past; but I still see far too often that "Premature Optimisation" is used as a crutch for programmers and designers to avoid having to think during the design and development phases.

What premature optimisation is not:

  

  

* Choosing one design over another because of speed.
  

* Changing a design to use fewer resources.
  

* Researching the fastest algorithm to implement a new feature.
  

* Analysing alternative algorithms to collect resource usage metrics during the analysis phase.
  

* Changing code that does not work.

Premature optimisation is making changes to existing, working, code either without knowing it will make the code faster or use less resources or not having a requirement to make the code faster or use less resources.

In other words, if the code works as required, don't change it.

I often see questions like "is using _method one_ more efficient than _method two_?" with answers like "if one is more efficient than the other its onlya matter of several hundred milliseconds; picking on over the other is a _premature optimisation_." No, it is not a premature optimisation. You should always know what performance/resource footprint you need to fulfill when designing and writing code. If you have no specific requirement, simply pick the fastest. But, you have to know what is the fastest of a set of alternatives. Asking/testing what is faster than other is not premature optimisation. It's just proper design and implementation.

Sometimes you mustcompromise performance and resource usage to maintainability or compatibility. But, making concessions like this are also not premature optimisations. Making design choices should always include all aspects of a system: maintainability (readability, coupling, cohesion, etc.), regulatory compliance, performance, resource usage, requirements, etc. Choice of an algorithm or a faster or less resource intensive method of performing some action should always consider these aspects.

1<http://en.wikipedia.org/wiki/Optimization_%28computer_science%29>  
2<http://en.wikipedia.org/wiki/Anti-pattern>  




