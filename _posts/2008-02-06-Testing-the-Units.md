---
layout: post
title:  "Testing the Units"
date:   2008-02-05 19:00:00 -0500
categories: ['Software Development', 'Unit Testing']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/02/06/unit-testing-the-units/ "Permalink to Testing the Units")

# Testing the Units

In OO there's levels of abstraction.  A class, for example, abstracts a read-world concept into a encapsulated bit of code.  A class is autonomous.  That class lives in world with other classes and interacts with them, but is autonomous.

I believe development testing should account for these abstractions, not just the interactions or behaviour of the system.  One problem I see with Test-Driven Development (TDD) and Behaviour-Driven Development (BDD) is that practitioners simply just center on interaction of the parts of the system and really don't do any "unit testing".  They get caught up in the mantras that are TDD and BDD and fail to see the trees for the forest and fall into testing by rote.  Unit testing tests individual units, the smallest testable part of an application[1].

Let's look at the the [BDD example on Wikipedia][1], where it tests the EratosthenesPrimesCalculator.  The behaviour that is tested in this example is basically the first prime number (which should be 2) the first prime number after 100 (which should be 101), the first prime number after 683 (which should be 691), and that the first 11 primes are correct.

The EratosthenesPrimesCalculator constructor interface accepts (or seems to) a signed integer.  The tests detailed only test 13 of 4,294,967,296 possibilities.  These tests may very well test the expected behaviour of one system, but don't really test EratosthenesPrimesCalculator as a unit.  If the system only allows that behaviour, then these tests prove that it will work.  But, if at some point EratosthenesPrimesCalculator is used outside that behaviour (and that's really the purpose of encapsulating code into classes: reuse) not much about EratosthenesPrimesCalculator has been validated.  At the very least the edge cases of EratosthenesPrimesCalculator() should be tested.  If there is a explicit contract that EratosthenesPrimesCalculator() it is to ensure, boundary cases should be included in that "very least".  If they apply, corner cases should be pivotal to good unit testing.

I believe development testing should also be object-oriented as well, testing that individual objects work "as advertised".  Testing interaction of classes is important, and TDD and BDD do that; but your system must have a solid foundation: it's classes.

In relation to TDD and BDD, this testing will be done once the concrete implementations are done.  Depending on how you've designed your system; you could do this testing on an interface, then when concrete implementations are done, throw them at the test via the interface.

[1] <http://en.wikipedia.org/wiki/Unit_Testing>

[1]: http://en.wikipedia.org/wiki/Behavior_Driven_Development

