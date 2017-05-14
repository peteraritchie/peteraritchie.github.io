---
layout: post
title:  "Book Review: WCF 4.0 multi-tier services development with LINQ-to-Entities"
date:   2010-08-19 12:00:00 -0600
categories: ['.NET 4.0', 'Book Review', 'C#', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/08/20/book-review-wcf-4-0-multi-tier-services-development-with-linq-to-entities/ "Permalink to Book Review: WCF 4.0 multi-tier services development with LINQ-to-Entities")

# Book Review: WCF 4.0 multi-tier services development with LINQ-to-Entities

WCF  
4.0 Multi-Tier services development with LINQ-to-Entities is about  
about using LINQ with Entity Framework to create a data layer in a WCF  
web service.  The book approaches the content from the point of view of a  
junior developer–one that is not necessarily familiar with Visual  
Studio.  The book generally approaches the topic from a useful  
lowest-level to highest-level evolution–starting with how to create a  
WCF service from scratch and working up to creating a WCF service with  
the built-in Visual Studio templates.  The book follows the important  
contract-first design model for web services.

I like the book's  
approach to layering, it's a refreshing change to see purposeful  
decoupling of layers and not something that simply pushes entity classes  
from the data layer all the way to the interface layer–each layer has  
it's own concept of the domain entity in use.  This is very important  
with web services because what can be implemented in a web service is a  
subset of what can be implemented in .NET; and to a certain extent, what  
can be modeled in the database and the data access layer is also a  
subset of what can be implemented in .NET.  So, it's important that the  
business logic layer be free to implement the domain entities how it  
needs to without being limited to what cannot be implemented in a web  
service message or in what cannot be implemented in a particular  
database.  That is, in the examples, the entities created by the Entity Framework are  
restricted to the Data Access Layer and they are not used in the web  
service's requests and responses.

The book generally shows a  
consistent example that evolves from single layer to multi-layer,  
starting with the service layer.  This form of description is useful for  
people who are not familiar with layering.  This also has a similar  
flow to Test-Driven Design (TDD).

This book covers, in detail,  
use of much of the new C# 4 syntax, including LINQ (really LINQ syntax,  
plus anything that LINQ depends on in the new C# syntax; which is most  
of it).  Two chapters are devoted to this new C# syntax.  This book also  
covers in detail how to create WCF services with and without the  
built-in Visual Studio templates.  For advanced developers, much of this  
book might be a bit beneath them–if you're already familiar with  
Visual Studio, layering, C# 4, and debugging in Visual Studio, you may  
find half the book details information you already know.  If you are  
already familiar with WCF and Entity Framework, you probably won't get  
much out of this book–as expected.

There are a few points that I find are  
slightly off in terms of correctness; but none that apply to LINQ to  
Entities or WCF.  Unfortunately, "multi-tier" really isn't detailed.   
The examples are strictly multi-layer, not multi-tier (assuming the  
client to the web service must always be considered its own tier–i.e. I  
infer more than two tiers from "multi-tier services").  The  
implementation of the web service (the interface layer, the business  
logic layer, and the data access layer) is a single tier in every  
example.  The concepts of the book could easily be expanded to the  
business logic layer and the data access layer to wrap them in a WCF web  
service to truly implement a multi-tier service.  There are several  
examples of performing automated tests (coded tests) within the book.  I  
was a little disappointed that these weren't approached as unit tests  
and either implemented with Visual Studio testing framework or another  
common unit testing framework like NUnit.

The book uses a few  
well-known patterns in its implementations; but, doesn't go into too  
much detail other than their implementation.  For example, it uses the  
Data Access Object (DAO) pattern but doesn't use the term "Data Access  
Object".  This isn't unexpected, since the book isn't about patterns.  If you're the target audience of this book, I would suggest  
following up with some reading on patterns.  The book generally  
implements the patterns it uses correctly, but I find the choice of some  
of the patterns to be somewhat academic.  For example, the author  
chooses the typical Microsoft 3-layer architecture: interface layer  
(service layer), business logic layer, and data access layer.  The  
typical problems of mixing business logic within the business logic  
entities and outside these entities occurs.  I'll leave it as an  
exercise for the reader to research how to approach this problem.   
(hint, check out my blog archive and keep reading my blog).  
The book also doesn't really go into much detail about WCF configuration even with  
regard to web services.  There's no detail of switching bindings like  
from HTTP to HTTPS, to TCP, etc.  And there's no mention of  
SvcConfigEditor–an essential tool in the arsenal of every WCF  
developer.

If it wasn't obvious, I'd recommend this book to junior developers who  
need to get up to speed and be productive in WCF and Entity Framework in a short amount of time.

A sample chapter can be found at <https://www.packtpub.com/sites/default/files/sample_chapters/wcf-multi-tier-services-development-with-linq-sample-chapter-5-implementing-a-wcf-service-in-the-real-world.pdf> and the publisher's landing page for the book can be found here: <https://www.packtpub.com/wcf-multi-tier-services-development-with-linq/book>

