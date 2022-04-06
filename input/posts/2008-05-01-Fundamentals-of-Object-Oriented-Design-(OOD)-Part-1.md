---
layout: post
title: 'Fundamentals of Object-Oriented Design (OOD) Part 1'
tags: ['C#', 'Design/Coding Guidance', 'DevCenterPost', 'Software Development', 'msmvps', 'May 2008']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/05/01/fundamentals-of-object-oriented-design-ood-part-1/ "Permalink to Fundamentals of Object-Oriented Design (OOD) Part 1")

# Fundamentals of Object-Oriented Design (OOD) Part 1

With increased usage of patterns and situationally specific strategies, people sometimes lose sight of the concepts and principles behind these patterns and strategies and fail to follow them when they're not using patterns or strategies. I feel it's good to periodically review the fundamental concepts and first principles.

Object Oriented Design (OOD) attempts to help with the complexity of designing, writing, and maintaining software. It attempts to allow building of software by modeling real-world objects. As with any tool, it can be used improperly, but OOD attempts to facilitate simplicity, robustness, flexibility, etc.. OOD has many fundamental concepts. Some of these concepts include modularity, encapsulation, and abstraction. OOD deals with modeling behaviour and attributes of real-world objects.

Modularity is a technique of composing software from separate parts. At the lowest level of an Object-Oriented Programming Language (OOPL), this is the definition of a type (a class or a struct in C#/C++). Depending on the platform there may be various other levels of modularity. In C#, for example, modularity can occur at other levels like module (source file), namespace, netmodule, assembly, etc. Modularity is a form of encapsulation.

Encapsulation is a technique of hiding implementation details, grouping them together. In OOPL, the lowest level of encapsulation is the type level (again, class/struct in C#/C++). Implementation details (data) is separated from behaviour of a type. In some OOPLs both behaviour and attributes (properties, for example in C#) are separated from behaviour. This allows clients to decouple or to be not dependant on those implementation details. Encapsulation is a form of abstraction.

The ability to encapsulate related behaviour, attributes, and implementation allows programmers to utilize abstraction. Abstraction facilitates separation. OOPLs allows programmers to keep concepts separate by abstracting them from one another. Keeping abstract concepts separate allows these concepts to evolve and be used independently. Properly designed types allow abstraction; a File class can abstract the file system away from a particular file, for example. The file system is part-and-parcel when dealing with files; but while dealing with a File object, it is abstracted away.

Good OOD has as little dependencies between parts as possible. This is called lack of coupling. One part that uses another part means the part depends on that other part. Changes to the second affect the first. Good OOD also has parts that contain related behaviour and attributes. This is called cohesion. If all the behaviour and attributes are generally used together in each scenario, the part has high cohesion. If only some behaviour or attributes are used in each scenario, the part has low cohesion and likely should be split up. Some people only view cohesion and coupling at the class level, I've purposely said "part" because I believe these concepts need to live throughout the modeled system, from class-level details, to modules, to namespace, to assemblies, to layers, to components, to systems, etc.

I will continuethis series with the fundamental OOD principles that all good patterns should enforce.

![kick it on DotNetKicks.com][1]

[1]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f05%2f01%2ffundamentals-of-object-oriented-design-ood-part-1.aspx


