---
layout: post
title: 'API-Driven Architecture'
date: 2017-12-02 23:32:00 -0500
categories: ['Design', 'API', 'Guidance']
comments: true
excerpt: ""
---
# API-Driven Architecture
I kinda fell into X-Driven Design *all the things* when I started thinking of this practice.  It's obvious I landed on API-Driven Architecture, but let me comment a bit on that first.  I chose "architecture" here because I believe supporting composition via APIs should not fundamentally change the low-level implementation, and shouldn't depend on being object-oriented, procedural, etc.  I believe correctly supporting APIs is really about the connections or relationships to the outside and while supporting APIs may increase the granularity of modules in the code, those modules should have been designed around principles, patterns, and practices anyway.

The next thing to touch on is what I mean by "API".  Lately "API" seems to equate to Web APIs or RESTful APIs.  Those aren't the APIs I'm talking about here, although those Web APIs should just be a view into domain and supported by the APIs I am talking about.  I'm talking about using lower-level APIs as drivers of the implementation of connections/relationships between components.

I talk a lot about the SOLID design principles and most recently how other principles are just realizations of SOLID (like much in SOA, DDD, etc.).

A big chunk of what SOLID buys you (as well as the other types of principles) is loose coupling. *X* is more loosely coupled from *Y* in areas of *A*, *B*, *C*, etc. (Maybe the *Principle of Loosest Coupling*?).  That loose coupling is generally realized by abstractions.  Those abstratcions at the component relationship level should be domain concepts--i.e. the concepts about the business and it's processes before a technical solution is described or before logical design.  You should expect an *impedence mismatch* between those concepts and the implementation--with the abstractions the first step towards addressing that mismatch.



This is a type of contract-first design.  So, it's not really new.  You can take contract-first design down as many levels as you feel like.  You'll get diminishing returns if you're trying to do contract-first on logical (i.e. not conceptual) details simply because it's not really contract-first at that point.

this is also a type of layering or domain layer abstraction

API
Types/Messages
Functions
Expectations
Validation
Errors
Commitments

Type
RPC
REST
 Resources
 Commands
Message-oriented

