---
layout: post
title: 'Enterprise Service Buses, Brokers, Message Queues, Oh My!'
tags: ['Architecture', 'Distributed Systems', 'Message-Oriented Architectures', 'MOM', 'Software Development', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2011/09/18/enterprise-service-buses-brokers-message-queues-oh-my/ "Permalink to Enterprise Service Buses, Brokers, Message Queues, Oh My!")

# Enterprise Service Buses, Brokers, Message Queues, Oh My!

Continuing on my theme of _message-oriented_, I thought I'd get into a bit of detail about the various middleware options and some details about these options.

Regardless of what type of middleware is chosen, one thing is common to all types of message-oriented middleware—the fact that they broker messages from producers to consumers.

## Impetus

Before I get too far into the options, let's look at a couple of the common reasons behind moving to a message-oriented architecture.

One impetus towards MOM is to integrate various legacy or third-party systems into a new or exiting enterprise system. This type of MOM has been know as Enterprise Application Integration (or EAI). There's all sorts of information about this architectural style.

The other major impetus towards MOM is to facilitate distribution.

Technically EAI is also distributed; but that's more because the individual components are completely independent of one another and thus executing on different computers. The purpose of EAI isn't to get distribution but to integrate distributed components. 

## Enterprise Application Integration

### Enterprise Service Bus

The technology-du-jour in the MOM world seems to be Enterprise Service Buses (ESB). Enterprise Service Buses, by definition are are horizontally scalable MOM that integrate disparate (including legacy) loosely coupled SOA components using web services. Not only do ESBs technically broker communication between producers and consumers, they also deal with routing, transformation and translation. It's hard for ESBs to do what they're good at without that specific loose coupling you get from web services, where interface definition is discoverable and service-oriented (web services, over http, etc. etc.).

From a .NET standpoint there's a few options out there calling themselves ESBs like NServiceBus and MassTransit.

### Brokers

One form of EAI is a _Broker_. "Broker" is considered an anti-pattern by more than a few people in the industry given what we now know because of it's inherent hub-and-spoke _shape_. A broker is a single component (hub) that brokers messages from producers to consumers (spokes). It's frowned upon because of its inherent scalability problems. A single broker is constricted to a single computer and to gain scalability it's forced to scale vertically so it has finite and expensive scalability options. It's unfortunate that this architecture is frowned upon because it's still more than adequate when used where appropriate and technically a subset of all the other MOM options.

There isn't technically a whole lot of options in NET for hub-and-spoke integration. .NET became popular just as the many of the problems with hub-and-spoke were coming to light. But, the closest thing to hub-and-spoke seems to be BizTalk. It's message box would technically be the hub and components integrated into BizTalk be spokes. But BizTalk is a bit of hybrid of sorts (it supports translation, SOA, etc) so it's a bit of a matter of opinion.

## Distribution

### Message Queues

Almost all EAI middleware uses some form of queue BizTalk: MSMQ, MassTransit: MSMQ, RabbitMQ, ActiveMQ, etc, NServiceBus MSMQ, Azure Queue, etc.

### Other

Technically the other options are considered message queues; but they're not message queues in and of themselves; they just operate like a message queue. Like databases, RPC, web services, etc.

## When to use which option

So now that I've confused the horizon with a bunch more terminology and a fair share of technobabble, why would you choose one over another?

The reason I divided the options in to two is because the choice on which to use should really be based on the impetus behind the composition of the system. 

If you need to integrate legacy or disparate 3rd party services together, enterprise service buses are definitely the way to go. If you're dealing with integrating many components together with much routing and translation requirements, and a high number of messages, ESBs will help you immensely. If your scalability requirements are very low, going the broker route is probably more than adequate. The impetus here is the integration; but you don't want to make a system completely unusable because it can't scale.

But, if you have control over all the components in your system and your overall impetus is the distribution of work and horizontal scalability, then your focus is on performance not integration. You want your endpoints to communicate in the most efficient manner and not be bogged down by unnecessary translations and routing. In which case you most likely want to avoid ESBs.

ESBs are kind of a Golden Hammer at the moment. ESB implies a SOA, web services, certain discoverability, lack of control of some or all components, etc. If you *do* have control over all the components and don't specifically require SOA, Web Services, and discoverability; implementing specifically to work with an ESB seems overkill. If your have control over all components in your system and every message coming from a producer can be directly accepted by the consumer, you don't need any of the translation aspects of ESBs. You end up really only gaining in the routing aspect of ESB—which if you control all the components in your system, should be fairly static.


