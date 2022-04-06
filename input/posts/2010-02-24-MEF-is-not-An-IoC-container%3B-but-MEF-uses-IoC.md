---
layout: post
title: 'MEF is not An IoC container; but MEF uses IoC'
tags: ['Uncategorized', 'msmvps', 'February 2010']
---
[Source](http://blogs.msmvps.com/peterritchie/2010/02/24/mef-is-not-an-ioc-container-but-mef-uses-ioc/ "Permalink to MEF is not An IoC container; but MEF uses IoC")

# MEF is not An IoC container; but MEF uses IoC

Somehow I got on the conversion of MEF while chatting with Glenn Block. IoC came up in that conversion. I believe, at some point, I said something along the lines of MEF is not an IoC container; but MEF uses IoC. Someone else asked me to clarify that after the conversation. It's a common misconception that MEF *is an* IoC container. I thought it might be useful to summarize those conversations for others.

Part of what gives MEF the ability to do what it does is most certainly IoC. Traditional dependencies (control) are inverted so that something (the host) doesn't depend on a concretion (the extension, in the case of MEF) but an abstraction. The abstraction with MEF and IoC is an interface.

MEF manages extensions—dependencies—that may or may not exist at run-time but are rarely known/exist at compile-time. This needs to occur because you want 3rd parties to extend your application (of course, conceivably you must produce and publish your application before a 3rd party can even conceive of extending it). For any one dependency, MEF may be managing multiple extensions.

The difference with an IoC container is that it's managing static dependencies: dependencies that must exist at compile-time in order for the application to correctly run at run-time. The impetus of IoC is different than MEF in that you don't want to offer the ability to "extend" your application, but ensure that a particular class doesn't have a direct coupling (or dependency) on another class. IoC doesn't remove the dependency entirely, it just means the code can evolve independently. For the application to run correctly when deployed, it depends on ClassA being injected into ClassB at some point for that to happen. But, ClassA can compile without ClassB. This is always a one-to-one dependency.

If MEF were truly an IoC container then you'd expect be able to use an IoC container to extend an application at runtime—which is not the case.


