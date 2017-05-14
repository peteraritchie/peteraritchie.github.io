---
layout: post
title: Protecting intellectual properties in .NET, Part 1.
date:   2006-09-08 12:00:00 -0600
categories: ['.NET 2.0', '.NET Development', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2006/09/09/protecting-intellectual-properties-in-net/ "Permalink to Protecting intellectual properties in .NET, Part 1.")

# Protecting intellectual properties in .NET, Part 1.

One thing that bothers many people and organizations about .NET is the ease of which IL code can be re-hydrated into source code (C#/VB/etc.).  While this has always been a problem with binaries, IL code is a much smaller set of instructions compared to the instruction sets of today's processors and is designed around accommodating high-level-language usage patterns–making it easier to translate into high-level source code.  Native binaries could always be disassembled and the assembler code be reassembled into another, new, application.  But, it was assembler code, and optimized–nearly impossible to translate into a high-level-language, let alone similar to the original code .  Everyone seems fine with this because it doesn't really look like the original code.  .NET IL an be re-hydrated into source that is almost identical to the original–sans comments.

One thing you can do with .NET is to force a method to be precompiled to native code.  This can be done by attributing the method with a little-known, not well documented attribute: System.Runtime.CompilerServices.MethodImpl and setting the MethodCodeType property to System.Runtime.CompilerServices.MethodCodeType.Native.

Some caveats

* Seems to only work in a FullTrust environment.
* Since native methods can't be reflected these methods cannot be uses as event handlers
* May cause some grief for many debuggers.
* The Runtime severely restricts where methods tagged as Native can be loaded. 

