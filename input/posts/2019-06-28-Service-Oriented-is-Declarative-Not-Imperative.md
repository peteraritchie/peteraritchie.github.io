---
layout: post
title: 'Service-Oriented is Declarative, not Imperative'
categories: ['SOA', 'declarative', 'guidance']
comments: true
RedirectFrom:
    - Service-Oriented-is-Declarative-Not-Imperative/
excerpt: "The subtleness of service-orientation, how it can be undermined and how to recognize and address it."
tags: ['SOA', 'declarative', 'guidance']
---
In this post, I'd like to address a challenge that I've witnessed in the understanding of service-oriented and implementations of it.  
The issue I've seen in the design approach of services and service-oriented systems.  Programmers and engineers can easily view each service as a function.  Services are perceived as being composed together within a set of functions commanding specific state changes to achieve one of a smaller set of final states.  
This is really describing the totality of _how_ a system does what it does.  At some point, the _how_ must exist but in order to have a system that isn't one-off and can evolve by responding to change, we need the _how_ to be encapsulated from one another.  
Composition of a system in this way is an _imperative_ model.  Ideal service-orientation works within a _declarative_ model.

im&#xB7;per&#xB7;a&#xB7;tive  
&nbsp;&nbsp;&nbsp;/&#x259;m&#x2C8;per&#x259;div/
> uses statements that change a program's state.

de&#xB7;clar&#xB7;a&#xB7;tive  
&nbsp;&nbsp;&nbsp;/d&#x259;&#x2C8;kler&#x259;div/

> denoting high-level programming languages which can be used to solve problems without requiring the programmer to specify an exact procedure to be followed

In other words, declarative is declaring the outcomes required and imperative is supplying the commands to change state in order to achieve the outcome required.

Both are useful and both have benefits.  They're merely different.  One isn't better than the other.  But, they don't work well together.  Supplying a command to something that understands outcomes or supplying outcomes to something that expects command 

Service-orientation involves many things but in the context, it involves the principles of abstraction and autonomy.  Something that is self-contained and is a black box to consumers, represents a repeatable activity with a specific outcome. <sup>[OG1][OG1]</sup>

This is different from what most programmers seem to understand, which is to provide an order list of commands or statements to change state.

Patterns are a good example of this, and the iterator pattern is one of my favorites.  That pattern details that to traverse the elements of a container an iterator object should be used to start at an initial element and progress through the rest through the use of a "`next`" method.  This allows any type of sequences, collections, etc. to be iterated over regardless of their implementation.  i.e. _give me _next_, whatever _next_ means_.  C# has this built into the language with iterators:
```csharp
foreach( var element in theContainer)
{
   Do.Something.With(element);
}
```

In other languages/scenarios, the type of the container needs to be known and the unique way to enumerate all elements.  Typically reserved for collection/sequence structures, an array example may look like this:
```csharp
for(int i = 0; i < anArray.Length; ++i)
{
   var element = theContainer[i];
   Do.Something.With(element);
}
```
and
```vb
For i = 1 to aList.Count
   Dim element = theContainer.Item(i)
Next i
```

Both of these blocks of code show *imperative* commands: *get array element* i or *get list element* i.

With C# and the iterator syntax, it's a better description to say _give me the outcome of each iteration of a container_.  What the container does to iterate is encapsulated, the container is a black box to the caller.  We can use it the same if that container implementation used an array, a list, or just had hard-coded values.

Services in Service-Orientation should take this form.  A service is a location where an outcome can be retrieved, usually with parameters.  Thinking in this way allows us to think of the outcomes we want to work with, rather than the details of how those outcomes are produced.  I allow us to (and is recommended) to think about things in our problem domain (or higher-level abstractions).  If we're thinking about a conference, we can think of a session as a container of registered attendees.  I can then model that I want to perform an activity with the information from each registered attendee before I implement something and decide *how* that will be implemented.

In a service, we should not have a contract that details *how* an activity should be performed. A service contract should only detail the outcome and what parameters are required to get that outcome.

Almost all design patterns (that aren't structural patterns) effectively do this: to abstract away implementation details in favor of declaring the outcome desired.  "Declarative" can also be considered "composable": you're declaring how to compose things rather than the flow of logic.  The messaging library I published, you can effectively declare a producer, a consumer, and a channel/pipe between them.  Once composed like that, the type of channel/pipe used hides how the messages move between the producer and the consumer (in-memory, queue, HTTP endpoint, etc.).  You don't have imperatively create a queue (or a topic, etc) and imperatively connect the consumer and producer to the queue.

I realize this is very subtle and, in particular, the iterator example. And maybe some advice on naming may help to bring it over the line. What also makes these concepts complex is that they're not digital; i.e. nothing is entirely declarative or entirely imperative, there are degrees of declartiveness/imperativeness.

Service names should generally be nouns (e.g. the name of the "outcome" of the activity).  REST describes these as resources, which should also be nouns.  Verbs and a dead giveaway that something is imperative (if that wasn't obvious by the use of *imperative* :) ).  Inputs in contracts should not contain verbs as well, consider the input/output as resources.

Additionally, this doesn't mean everything using the outcomes of declarative statements must be declarative.  You can certainly program a set of statements to change state based on what that outcome was.

### Traits and Smells
One of the traits of services that are not imperative is that they can be viewed as stateless.  If the need arises to store per-session state or state that shouldn't be available to other consumers of the service, that's a smell to tell you that you're probably more imperative than declarative.  The solution to this is to ensure anything required for the activity to be performed should be supplied in the input.  REST services facilitate this through HATEOS.  There was _state_ when an activity was requested, and it should be passed back in one or more hyperlinks for stateless services.  e.g. The current total number of resources at an endpoint at that point in time.  You may be paging through resources a page at a time and something could change between requests.  To avoid problems with that the state is effectively _stored_ in the response via links.  At the time of a request, a service may have 20 resources, if paging 10 at a time the "next" page for page one would be 2. If something changed before page 2 was retrieved, the response for page 2 may include page 3 for "next".

Next time, I'll talk about how "declarative" doesn't mean always up front.

## References
[Service-Oriented Architecture Ontology Version 2.0 - The Open Group][OG1]

[OG1]: https://www.opengroup.org/soa/source-book/ontologyv2/index.htm
