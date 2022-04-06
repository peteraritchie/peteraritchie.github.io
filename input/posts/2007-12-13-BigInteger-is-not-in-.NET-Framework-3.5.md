---
layout: post
title: 'BigInteger is not in .NET Framework 3.5'
tags: ['.NET 3.5', 'msmvps', 'December 2007']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/12/13/biginteger-is-not-in-net-framework-3-5/ "Permalink to BigInteger is not in .NET Framework 3.5")

# BigInteger is not in .NET Framework 3.5

A while back [Inbar Gazit blogged][1] about a new (at the time) Orcas type System.Numeric.BigInteger. BitInteger is intended to represent an integer of "arbitrary" precision–from 1 digit to 2,147,483,647 digits. "Arbitrary" because realisitically approaching2,147,483,647 will not have enough memory to store the integer.

For whatever reason, this type didn't make it into the RTM version of .NET 3.5–it's actually internal, not public. I don't know why, Inbar didn't follow up.

[1]: http://blogs.msdn.com/bclteam/archive/2007/01/16/introducing-system-numeric-biginteger-inbar-gazit.aspx


