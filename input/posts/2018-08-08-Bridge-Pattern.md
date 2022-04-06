---
layout: post
title: 'Deeper Understanding of The Bridge Pattern'
categories: ['Patterns', 'Bridge', 'Design', 'Provider Model', 'Provider']
comments: true
excerpt: "Loosely coupled and abstractions are hard enough to grok for many people.  The Bridge Pattern takes it to the next level by abstacting abstractions from other abstractions.  Let's dig deeper to help make it more consumable and less academic."
tags: ['August 2018']
---
One of the biggest roadblocks in creating software that stands the test of time is the trouble many people have separating concept from actuality.  To some degree this is a basic human trait.  Shopping for a new house for example, it's common for someone not to buy a house simply because of the colors of the walls despite the triviality of re-painting (or the fact you probably will regardless).  In software, it's common for the separation between abstractions and implementation details to end up bleeding across.  So, it's no surprise that some patterns (or patterns in general?) are hard to truly understand and commonly mis-implemented.  The [Bridge Pattern][Bridge Pattern] is one of the prime examples, from my experience.

## The Bridge Pattern
A pattern where the one abstractions uses another abstraction for the two to be loosely coupled (and promote independent evolution of the implementations), it's no wonder I've witnessed misunderstanding.  That, and with diagramming of the pattern from the Gang of Four:
<div>
<div style="position: relative; background-repeat: no-repeat; background-image: url(http://web.archive.org/web/2017071708651im_/https://www.dofactory.com/images/diagrams/net/bridge.gif);">
  <span id="overlay" style="position: relative; top: -20px; left: -105px;">
    <img src="/assets/yelllow%20highlighter%20rectangle%20thick.png" 
        style="opacity: 0.5; background-color: transparent;"/>
  </span>
</div>
</div>

(...where the highlighted area is the [GoF][Design Patterns] pattern).  It's UML, how could that *not* convey information effectively?  ;) I'm not a big fan of UML, although it has a place.  In this case, I think it falls short in helping people understand new concepts.  And I honestly think this diagram has contributed to the misunderstanding of Bridge.

So *what does it mean to implement a bridge*?  The name, fortunately, isn't far off: it is intended to act as a bridge between two independent things so those two things remain separate (independent and autonomous) and that the bridge is loosely coupled from the implementation details of what it's bridging.  Although easily confounded with [Adapter Pattern][Adapter Pattern], Bridge is *different*; or more than just adapting one thing to another. Avoiding UML, let's jump right into in a different way of diagramming Adapter's structure.

## But First, Adapter
![Adapter Pattern Diagram](/assets/Adapter%20Pattern.png)

This diagramming technique uses some recognizable components, although maybe with some unconventional organization/style.  There is some sort of **Client** that uses an **Adapter** component.  That usage is via an interface *owned* by the Adapter component (*within Adapter's rectangle, and within the same compile-time and/or deploy-time context*) and is implemented by an internal component of **Adapter** (*Implementation*).  What is being adapted, the **Service**, is then accessed by **Adapter** in *some way*.  The connections and containment of **Service** are intentionally vague ("some way"): it could be accessed as an internal component via compile-time linkage, via a HTTP request, etc.  The important part of the pattern is that the **Adapter** is providing an single interface to **Client** that wraps *implementation details* being *adapted* to another interface.  **Adapter** is not loosely coupled from the thing it's adapting--**Service** (adapter's intention *is* to use an implementation directly, rather than an abstraction (i.e. one abstraction instead of two).

**Bridge** is similar to **Adapter**, but instead of being tightly-coupled to the **Service**, it controls that interaction through an interface (or other abstraction).  One view of the Bridge Pattern is to simply access an interface instead of the **Service** directly.  And that technically gives us a Bridge implementation by adding an interface to an Adapter; but the Bridge is still overly coupled to the evolution of **Service**.  A more loosely-coupled Bridge accesses **Service** via an interface (or other abstraction) but *owns* that interface (shares a compile-time context or deploy-time context).  That gives us loosely-coupled benefits temporally: an implementor or that interface can be developed independently, or new implementors can be added later.

When would something like that be needed?  Well **driver** is often a term associated with Bridge, but I think **provider** is a much better context (a "driver" is really a type of provider) so I'm going to focus on *provider*.  This lets a Bridge facilitate a *late-binding* (or at run-time) of a service that provides some functionality (i.e. *provider*).  Hopefully diagramming it will make it more clear:

![Bridge Pattern Diagram](/assets/Bridge%20Pattern.png)

Notice that the service (**Provider**) now implements an interface *owned* by the **Bridge** (within the Bridge component in the diagram).  Now, anything that implements that interface can be utilized by **Bridge**.  Depending on your language/framework, that can be late-bound at runtime.  (*Dependency Injection* is your friend here).  To annotate the end-to-end relationship in prose:

![Bridge Pattern Annotated Diagram](/assets/Bridge%20Pattern%20Prose.png)

## Service Orientation ##
This is an effective means of achieving [Service Orientation][Service Orientation].  Related to but different than *Service-Oriented Architecture* (SOA), Service Orientation aligns with most SOA principles: Loose Coupling, Abstraction, Encapsulation, Statelessness, Autonomy, Discoverability, Reusability, and Composability.  This is accomplished through principles like explicit boundaries, separation of functional context and state by contract.  This is re-enforced by its capability to support a provider model.  Bridge makes it possible to provide and consume a *service* (based on principles of Service-Orientation).  

## Speaking Of Composition ##
Since there is some level of adaption in a Bridge implementation, it may very well utilize the Adapter pattern, which may be diagrammed like this.  

![Bridge Pattern with Adapter](/assets/Bridge%20Pattern%20Detail.png)

Where the implementation of the service remains autonomous but made reusable and composable, through encapsulation and abstraction within an Adapter implementation.

## Being Successful

Keeping a Service-Orientation mindset over a Object-Oriented mindset is key to successfully recognizing where Bridge is most suitable making it more likely to succeed.  Remember also that the degree of independence of the *bridgees* keeps an implementation being successful and not just needless structure.  e.g. if a client is required to be compile-time bound to any implementation of a provider interface, the two truly cannot evolve independently.

## References
- [Design Patterns][Design Patterns]
- [Bridge Pattern][Bridge Pattern]
- [Adapter Pattern][Adapter Pattern]
- [Service Orientation][Service Orientation]

[Design Patterns]: http://a.co/9ld8Er3
[Bridge Pattern]: https://en.wikipedia.org/wiki/Bridge_pattern
[Adapter Pattern]: https://en.wikipedia.org/wiki/Adaptere_pattern
[Service Orientation]: https://en.wikipedia.org/wiki/Service-orientation
