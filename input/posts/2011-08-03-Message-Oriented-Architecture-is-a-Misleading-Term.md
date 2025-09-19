---
layout: post
title: 'Message-Oriented Architecture is a Misleading Term'
tags: ['Architecture', 'Distributed Systems', 'Message-Oriented Architectures', 'MOM', 'Software Development', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2011/08/03/message-oriented-architecture-is-a-misleading-term/ "Permalink to Message-Oriented Architecture is a Misleading Term")

# Message-Oriented Architecture is a Misleading Term

I recently blogged about Message-Oriented Architecture (and Message-Oriented Middleware, MOM). The technology leads to extremely flexible and scalable applications; but it really distracts from the system. It's like calling a _standard_ single-process application as Control-Unit Oriented Architecture. Sure, the application is divided into instructions that eventually make their way to the control unit of the CPU; but that's not only a implementation detail of the application; it's an essential implementation detail. It's pretty hard to write an application that doesn't eventually distil down to instructions given to a control unit of a CPU.

And that's kind of the problem with Message-Oriented Architecture. Messaging facilitates distributed systems; but you can't implement a distributed system without some sort of messaging. MOM comes into play when you don't want to have to implement your own layer or code to broker communications. MOM is middleware that you acquire the distribute messages from producers to consumers. You don't have to use MOM to do messaging; but, you can't do distributed without messaging—at least in some form.

What, you say? If that's the case then why are things like MOM and message-oriented architectures just now coming into focus? Well, it's true, MOM is a fairly recent technology on the software scene. Mostly because we've been simply accepting Moore's law as a way of scaling our applications. Now that Moore's law is slowing down, we have to scale our applications much more differently. Technologies like Map/Reduce, cloud, etc. are mechanisms for horizontally scaling our systems rather than upgrading a computer to make our software go faster (vertical scaling). Technologies like cloud and map/reduce give us ways to break up the work and execute it elastically on multiple computers; but it doesn't give us a way for our individual components of our system to communicate between each other.

I think message-orientation, although not really _new_, has come to the forefront simply because it's so inherent to designing and implementing distributed systems.

A distributed system is composed of many processes—it's a composite system. Writing distributed systems is the art of creating composable systems.

I'm going to continue with my series of posts relating to messaging between processes in a distributed system with a focus on message-oriented middleware; but, keep _implementation details_ in mind.


