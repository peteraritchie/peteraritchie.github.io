---
layout: post
title: Oww, my brain hurts.  Extension methods *will* cause me grief.
date:   2007-05-30 12:00:00 -0600
categories: ['.NET 3.x', '.NET Development', 'C#']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/05/31/oww-my-brain-hurts-extension-methods-will-cause-me-grief/ "Permalink to Oww, my brain hurts. Extension methods *will* cause me grief.")

# Oww, my brain hurts. Extension methods *will* cause me grief.

As a consultant, a task that I'm commonly asked to perform is to troubleshoot applications in need of repair.  The underlying source code and architecture for many applications in need of repair has, let's say, "problems".  One of the issues I run into with circumstances like this is the source code was not well organized, not well thought out, or not well managed as it evolved.  This type of code has poor style, poor coding habits, and often the programmers have code stepping all over other code through lack of cohesion and excessive coupling.  

Believe me, as Visual Studio codenamed "Orcas" is released and proceeds into production development environments, I fully expect my life to get worse with increased fragility of code bases.  I ran into a lovely compile error today with the most recent .NET Framework 3.5 that confirms my fears. Essentially, the code has two extension methods with the same name and the same number of arguments in two different namespaces.  The first argument is the same in each, but the second is different; and, in fact, one is a reference type while the other is a value type.  In code that uses one extension method (the one with the second argument of reference type), simply by adding a using statement for the other namespace, caused the following error to occur:

test.cs(14,26): error CS1928: 'string' does not contain a definition for  
        'IsPlural' and the best extension method overload  
        'Peter.Extensions.IsPlural(string, int)' has some invalid arguments  
test.cs(14,40): error CS1503: Argument '2': cannot convert from '<null>' to  
        'int'

Hmm, this error confirms that there is more than one IsPlural extension method and goes on to tell me that the "best" override has invalid arguments.  Huh?  How is it the best if it has invalid arguments?  Why would it consider passing null where a value type is expected the "best" override?  I really hope this doesn't make it into RTM.

Oww, by brain hurts.

