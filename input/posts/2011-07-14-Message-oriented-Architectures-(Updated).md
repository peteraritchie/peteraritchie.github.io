---
layout: post
title: 'Message-oriented Architectures (Updated)'
tags: ['Architecture', 'Distributed Systems', 'Message-Oriented Architectures', 'MOM', 'Software Development', 'msmvps', 'July 2011']
---
[Source](http://blogs.msmvps.com/peterritchie/2011/07/14/message-oriented-architectures/ "Permalink to Message-oriented Architectures (Updated)")

# Message-oriented Architectures (Updated)

I've had a few people ask me about message-oriented architectures and my knowledge and experience of it has evolved over time; so, I figured it would be a good idea to collect and publish some information about it. It's not one of those topics on the Internet that has gotten a lot of content, so I'll try and change that.

A Message-Oriented Architecture is sometimes called Message-Oriented Middleware or MOM because there's a middle tier or middleware that acts as the broker to relay messages from producers to consumers. At the most succinct definition MOM is simply an architecture that supports sending and receiving messages. That's an extreme simplification and when implementing MOM many more facets of it's design come into play, so I'm going to expand out into some of the common ways of implementing a message-oriented architecture over time. So, I may go outside of _MOM_ from a purists point of view.

This will be the first post in a series of posts so it will attempt to be very introductory. To have a stable base on which to discuss this topic, let me first outline some terms relating to messaging.

**Producer**

Something that produces a message. A message could be a command sent to a single command handler or an event published to zero or more event handlers.

**Consumer**

Something that consumes a message

**Handler**

Synonym for consumer

**Message Broker**

A component, often in an ESB, that transforms/translates and/or routes messages from one subsystem to another.

**Queue**

A storage mechanism for messages. Depending in the implementation, a queue may be where messages are received from. Generally a separate process that receives messages through a known protocol like HTTP or TCP. Generally used to implement load balancing semantics.

**Aggregator**

Something that consumes messages and contains them in some way and directs the message to another consumers. Used, partially, to decouple producers from consumers. A Queue is a form of aggregator. Often lives within the a process. Sometimes used to to merge pipelines.

**Topic**

Metadata associated with one or more messages that is generally used for publish and subscribe semantics. Something publishes to or subscribes to topics rather than having to process all messages.

**Exchange**

In messaging systems that implement exchanges, exchanges are where messages are sent (compared to a queue, which is technically where messages are received from).

**Service Bus**

A integration platform that generally combines web services, messaging, transformations, and routing, to transactionally integrate many disparagedisparate applications or systems. Often referred to an Enterprise Service Bus or ESB.

**Pipeline**

Often used in the context of messaging to describe a particular stream of messages or the fact that messages arrive or are processed one-by-one in a particular order.

**Event**

A message that informs subscribers of something that occurred in the past (albeit possibly not in the very distant past).

**Command**

A message that requests a change in state or data.

**Saga**

A series of related long-lived transactions that are executed as a non-atomic unit.

**Idempotent**

A operation that when repeated gives the same result. This concept is used in mathematics as well; but becomes an important concept in messaging when we deal with things like guaranteed delivery.

**Guaranteed delivery**

Reliable messaging that guarantees a message is delivered to its intended recipients. This often involves store-and-forward techniques to ensure message are not lost before delivery. 

**A least once delivery**

A form of delivery reliability that involves concessions which may mean a message is delivered more than once. See Idempotent.

**Pub/Sub**

AKA Publish/Subscribe. A form of messaging where a publish publishes an event that is subscribed to by zero or more subscribers. Publishers don't can who, if anything, subscribes to events because an event is a representation of something that occurred in the past and requires no response.

**Publisher**

A producer that produces messages that are considered events. A producer could produce events and commands.

**Subscriber**

A consumer that consumes message that are considered events. There nothing stopping someone from implementing a consumer that subscribes to events and handlers commands; but they are generally kept separate, ala CQRS.



There's all sorts of examples of messaging that have been around quite a while. Sockets, HTTP, Web Services, WCF, etc are all examples of messaging techniques or technologies. I'm going to discuss things at a slightly higher level where we deal with some of the application-level details of a message-oriented system. i.e. things like Sockets, HTTP, Web Services, WCF, etc are implementation details—they may facilitate our messaging, but I'm not really going to get into that level of detail.

Messages are sent by producers asynchronously. This means the producer is decoupled from consumers in every way except the fact that they share knowledge of one or more messages. This also means that producers don't know whether or not consumers have or will consume a message that it sends. This sounds a bit scary at first; but it opens up a world of possibilities through this decoupling. You have to account for the fact that producers don't know about what consumers are up to.

**Very loosely coupled**

Consumers and produces are separated by messages. These messages are simply data. They could be a binary serialized blob of data that a producer needs to be able to understand how to deserialize (often limiting producer/consumer to the same platform), or the message could be in the form of XML; where the consumer need only know how to process XML (not limiting consumer/producer to the same platform).

**Platform agnostic**

Messages can be sent and received on any platform. Much in the same way an HTML page can be downloaded and viewed on any platform. There are degrees to which a message-oriented system can support multiplatform (see above w.r.t. binary serialization); but the architecture itself imposes no real platform specifics.

**Asynchronous**

Consumers give messages to a broker, aggregator, or queue of some sort and that message is processed and delivered asynchronous. The consumer is free to go about its business before effectively before the message has even left the broker. Of course when consumer and producer and living in the same memory space using certain types of aggregators, this may not be the case; but typical message-oriented architectures use middleware that processes messages asynchronously.

Flexibility is one of the important benefits of message-oriented architectures. A message-oriented architecture is limited only by the coupling you impose. If you some sort of middleware and don't impose any requirements on how your message needs to be processes, you messages can be processed on any platform and at any point in time. Need to publish a message from Windows and have it consumed in a Windows 7 Phone? No problem. Need that processing to occur almost instantly? It's entirely up to the consumer how quickly they need to consume a message. Message doesn't need to be processed right away? Again, no problem the consumer can take as long as it needs to process the message.

The flexibility of the system results in many indirect benefits. The producer doesn't know anything about the consumer of a message (or how many consumers there are, if any) which means the message is free to be routed, aggregated and delivered completely independently of the producer.

One of the most important aspect, in my opinion, of message-oriented architectures is scalability. By separating producers and consumers at the process level from one another by way of a message you introduce the ability to horizontally scale almost infinitely. Because a producer asynchronously produces a message and one or more consumers may process the messages of a consumer, the broker is free to load balance or scale out to multiple consumers. This is not without purposeful, and correct, design; but offers a system-level scalability the supports vertical and horizontal scaling. For example, multiple consumers can be running on a computer to take advantage of each processor on that computer (vertical) or multiple consumers can be running on multiple computers to take advantage of any number or type of computers (horizontal) resulting in an architecture that supports near infinite scalability.

One of the biggest drawbacks of a message-oriented architecture is the topology. You're generally looking at least at a publishing computer, a computer to house the messaging middleware, and another computer handle the consuming. Each of these computers needs to be configured and publishers/consumers/middleware needs to be deployed and working correctly. This can be cost prohibitive on smaller systems and implies much management.

If a message-oriented architecture is used in a situation it is not intended, there can be drawbacks to using it. If a producer needs to synchronously produce a message (i.e, now when the consumer handles the message before it continues on with anything else), this can be a difficult scenario to implement. If the producer needs to know about the consumer or consumers, this can also be a difficult scenario to implement. Both of the scenarios can cause various headaches in a particular deployment. I don't really consider these drawbacks because MOM is not truly being used correctly; but the technology is not widely understood and the concepts it requires are often misunderstood so I mention it here because an implementation of MOM may encounter them early in the implementation.

Standards have come a long way recently, but—depending on your choice of implementation—there may be no real messaging standard. This could mean you end up being tied to a particular vendor or even a particular platform with no means of extending to other platforms or other components using another messaging mechanism.

[Wikipedia's Message-oriented Middleware][1]

[CQRS][2]

[1]: http://bitly.com/jwpzkl
[2]: http://cqrsinfo.com/


