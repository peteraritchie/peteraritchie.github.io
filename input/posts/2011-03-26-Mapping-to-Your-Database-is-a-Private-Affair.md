---
layout: post
title: 'Mapping to Your Database is a Private Affair'
tags: ['Design/Coding Guidance', 'Patterns', 'Software Development', 'Software Development Guidance', 'WCF', 'msmvps', 'March 2011']
---
[Source](http://blogs.msmvps.com/peterritchie/2011/03/26/mapping-to-your-database-is-a-private-affair/ "Permalink to Mapping to Your Database is a Private Affair")

# Mapping to Your Database is a Private Affair

Your mapping to your database is generally coupled to the design of the data and the mapping provider's ability to implement a relational or non-relational model. This means your ORM influences the design of your mapped classes and/or the design of system that uses these mapped classes. i.e. your design can be limited in certain aspects by how the mapper is implemented.

Because of these idiosyncrasies, your choice of ORM becomes an implementation detail; so, you want to keep any of its details and generated classes out of your interfaces. You want to keep your ORM's classes and the classes it generates private.

This may sound inconsequential, but there are some very real examples of how the limits of your choice of mapping framework can adversely affect your external interfaces. Let's look at some specific cases of this. 

WCF supports data contracts and collection types. But, because of the nature of WCF and SOAP, [it deals with serializing collections in a specific way][1]. If you have an entity class with a collection property on it, it may be perfectly acceptable to be able to add objects to that collection and expect them to make their way back into the database. But, what does that mean for some entity that's been serialized over the wire to another remote computer that doesn't have access to your database? It means the entity you publish over WCF has a different behaviour that those local to (presumably) the server. But, you don't want to modify your entity to work in a different way _just for your WCF interface_. You've published an interface to the outside world, clients are using it and you realise you need to make a change to your database. Opps, can't it's tightly coupled to your WCF interface; if you change your database and regenerate your entities you interface will change; breaking all your clients.

It works the other way around too. If you want to publish types over WCF, you have to annotate them, potentially, with all sorts of things to get them to serialize the way you want them to. The simplest is DataContractAttribute and DataMemberAttribute; but, could get more complex with things like IExtensibleObject, things like DataContractSerializer versus XmlSerializer, etc. Then there's things like versioning… Do you really want to add all these annotations to code generated by your mapper? In some cases you can't annotate them.

So, classes that map to/from the data effectively should be implementation details of your system; they should be private to your data layer; but, then how do we detail transferring data from our domain to the outside world? The Facade pattern and the Data Transfer Object pattern are a perfect solution to this. Your WCF interface is effectively a facade—an interface (usually simplified) to a different body of code—or a type of view to your model. When you have to provide complex data structures in your interface (i.e., other than base types) use Data Transfer Objects (DTOs) to wrap them in. Should the body of code that the facade wraps needs to change, simply modify the code that generates the DTOs. (I almost always get this question next: "What if the change means I can no longer produce the same DTO?". Well, then you'll have to decide if you should violate your contract and break all your clients, or find a way to make it work.)

I find it amusing to see all the examples of things like using your LINQ to SQL or LINQ to Entities classes in WCF interfaces. The examples are simple and often work; but once you try to do that in a complex system quickly realize you're down a rat hole with really only one way out. Do yourself a favour and completely abstract your implementation details from your internally accessible interfaces; you'll thank yourself.

[1]: http://bitly.com/gd9MfW


