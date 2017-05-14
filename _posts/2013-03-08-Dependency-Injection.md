---
layout: post
title:  "Dependency Injection"
redirect_from: "/2013/03/08/dependency-injection/"
date:   2013-03-07 19:00:00 -0500
categories: ['.NET Development', 'C#', 'Design/Coding Guidance', 'Patterns', 'Software Development']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2013/03/08/dependency-injection/ "Permalink to Dependency Injection")

# Dependency Injection

Dependency Injection (DI) is a form of Inversion of Control where the instances that one class need are instantiated outside of the class an "injected" into it.  The most common injection is constructor injection.  This is called inversion of control because the control of the dependencies have been inverted from the dependant class instantiating them to another class instantiating them.  e.g. I could write class like this:

 

Which is perfectly functional, but MyClass is now directly dependant on List<T> and this type has become an implementation detail of MyClass.  If I wanted to use some other implementation of IList<T>, I'd have to re-write MyClass and fix the tests that broke because of it.  I may want to use another IList<T> implementation because I want to test MyClass.  As it stands, I have no way of telling if the class does anything successfully.  I could write an IList<T> implementation that I can spy on in a test to verify that MyClass does what it supposed to do.  The way MyClass is written at the moment, I can't do that.

Bear in mind, this is a stupid example.  But, it shows inversion of control with types commonly recognizable.

So, I could invert the control on IList<T> and refactor MyClass to be DI-friendly.  In this case, it's fairly simple:

 

Now MyClass does not have a direct dependency on List<T> and I can give it anything I want.  In production I'd create an instance like this:

 

Not a whole lot more complex than before.  If I wanted to test MyClass in some way, I could give it a spy:

 

This is considered _Poor Man's IoC_, in that you're not making use of a framework or a library specifically devoted to IoC.

Yes, you'd never really do this in real life; but it's a fairly clear example—with commonly-used types.

## IoC Containers

There's a plethora of IoC containers for .NET.  They're all great tools, like StructureMap, Autofac, Ninject, Unity, etc.  Don't get me wrong, they're powerful and they do a lot of things.  But, they do a lot of things.

What do I mean by "they do a lot of things"?  Well, they're all effectively designed to work with codebases that are not DI-friendly.  They go out of their way to provide features to support DI in any imaginable design.  "What's wrong with that" you say?  If you've got a brownfield project, that's great—you can likely get testability with code not designed to be testable—which is a good thing.  But, these abilities make us lazy.  We stop designing DI-friendly classes because we know how to use a particular IoC container to get a known level of IoC and/or testability.  We've stopped striving for a simpler design, we've stopped striving for DI-friendly code.

If you're finding that you're generally using much more than just constructor injection, having reams and reams of config to set up the various instances or lifecycles then you're probably letting your IoC container do too much for you and your design is suffering.  If someone has to spend days understanding your IoC container and it's config for you project, you may have defeated the purpose.

For lots of good advice on DI in .NET, check out [http://blog.ploeh.dk/tags.html#Dependency Injection-ref][1].  Some of my favourites: <http://blog.ploeh.dk/2010/02/03/ServiceLocatorisanAnti-Pattern/>, <http://blog.ploeh.dk/2011/07/28/CompositionRoot/>, and <http://blog.ploeh.dk/2012/11/06/WhentouseaDIContainer/>

![][2]

[1]: http://blog.ploeh.dk/tags.html#Dependency%20Injection-ref
[2]: http://msmvps.com/aggbug.aspx?PostID=1824852

