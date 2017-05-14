---
layout: post
title: It’s More Than Syntax
date: 2009-01-28 19:00:00 -0500
categories: ['Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2009/01/29/it-s-more-than-syntax/ "Permalink to It’s More Than Syntax")

# It’s More Than Syntax

Writing good software is not just about adhering to a programming language's syntax.  No programming language syntax enforces good design nor does it enforce good programming in all circumstances.

I've seen many systems that compiled perfectly fine; but they weren't good systems.  Some exhibited reliability problems.  Some exhibited maintainability problems.  Some exhibited performance issues.  Some exhibited resistance to change.  All eventually failed at some point; either the system could not change at the required pace, or could never attain an acceptable reliability, etc.

What was wrong with these systems?  The programmers didn't look beyond the syntax of the language.  They didn't accept that programming was about correctly constructing software, not simply writing syntactically correct code.  In almost all cases, the projects didn't have design experience to guide the programming.  The lack of leadership meant that other factors like time-to-market completely dominated the quality of code written.

Now, I'm not saying that big-design-up-front makes for better software.  Big-design-up-front may help with some of the problems of these systems; but it doesn't help with others and it introduces more problems.

Any good software system needs a certain amount of design, up front–you need to know what you're going to be working on both from a requirements point of view and an architectural point of view.  The lowest common denominator is generally some architectural vision based upon established wisdom.  With some systems, this doesn't even need to be complex.  Just enough to guide everything the programmers do.

With any system, its goal is to fulfill the requirements of the stakeholders.  Some requirements (often many) are known at the onset of the project; but some are elicited throughout the evolution of the system.  I say system instead of project because a successful system generally consists of more than one project.  A project could be as granular as a particular iteration, or may be as wide as a project release.  In either case a system changes over time for as long as the system is in use.  To ignore that is to doom the system to failure.  Ignoring the fact that the system must change over the life of the system usually results in things like "requirements sign-off", lack of iterations, big-design-up-front, etc.

In any case, gauging the correctness of a system based on errors/warnings from the compiler is a mistake.  The architecture of the system must utilize established patterns for it to be maintainable and for it to be able to evolve over time.  The development of the system must employ unit testing to ensure the correctness of the system in light of its evolution.  The system must be monitored over its evolution to ensure it's following the architectural design.  If it's not following the architectural design, find out why; and re-evaluate the architecture if need be.

In short, good programmers know much more than simply the syntax of the language they're using.

 

Technorati Tags: [software design architecture][1]

[1]: http://technorati.com/tags/software+design+architecture

