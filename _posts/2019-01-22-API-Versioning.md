---
layout: post
title: 
date: 2019-01-23
categories: ['.NET', 'ASP.NET', '.NET Core', 'ASP.NET Core', 'REST']
comments: true
excerpt: "Thought experiment about REST and versioning."
---
# Versioning APIs
As Roy Fielding says in response to _What are the best practices for versioning a REST API?_
> DON'T

You may think it's pedantic; and maybe not as helpful as you were hoping for but it's true.  Let's do a little thought experiement.

## What is REST?
But first, let's recap REST, which is a software architectural _style_ that defines several constraints to designing, creating, and maintaining Web Services.  The constraints don't apply to every situation (which isn't the same as they are all optional), so the term _RESTful_ is often used because people what to view REST as a pattern rather than a _style_.  The constraints:

### Client-Server Architectural Style
REST is a hybrid of the Client-Server Architectural Style.  And as Fielding details, this constraint is based on Separation of Concersn principle that "allows the **components to evolve independently**, thus supporting the Internet-scale requirement of multiple organizational domains".

### Stateless
This constraint details that a request _cannot take advantage of any stored context on the server_, which means the request contains all the information to respond to the request.  Another way of thinking of this is that a request must be considered idemponent, in that two **identical requests must have the same result** (the same end-state; for queries: same response, for commands, the same representation of the resource). 

### Cache
Given the stateless nature of REST, the web service should be explicit about cachability.  Stateless doesn't mean the same response every time but does mean the same end state.  For requests that are intended to change state but can't should not be cachable (DELETE for example).  Other **requests should be cachable**.

### Uniform Interface

### Layered System
This constraint affirms that REST should be a fundamentally layered system.  This basically asserts that a given web sevice should encapsulate its implementation details.  that is a client should not be aware of any details (layers) used by the server thus not being able to _see_ beyond the immediate service (layer) being interacted with.  I.e. _layered_.

### Code on Demand
The only optional constraint, this constraint recognizes the fundamental independence of the client and the server such that the server can provide code to the client to support types of functionality.

### Data Elements
HTTP and the above constraints result in well known set of data elements.  The fundamental data element is the _resource_ which is the target of a hyptertext reference.  This means a resource identifier takes the form of an URL or a URN.  The default representation of a resource is HTML, but HTTP protocols support media-type specific requests to provide different types of representation.  Other aspects of HTTP support different levels of control of the response (like `if-modified-since`, `cache-control`, query strings, etc.) and metadata about the resource (like link elements, `Alternates`, `Vary`, etc.).

## HATEOS
(pronounce _Hate iOS_, just kidding: _hate O-A-S_ or _hate E oss_) is details of supporting the REST constraints to better detail what that means for a request to represent state and keeping the server statelessness.  HATEOS stands for Hypertext As The Engine Of Application State.  Which means the way an application maintains state in interactions with a stateless server is through the **use of hypertext in metadata**.

## Why Version?
Things change, that's a fact.  And that's really the only reason to version anything; becuase you may publish in the past based on a old version of data.  Semantics.  The actual result we're looking for is that we maintain the REST constraints.  Client-Server and Uniform Interface in particular (but, you can't really have one without the other, except Code on Demand).

### The Experiment
A REST service is one that hides the implementation details (layered) and responds to a consistent identifier for a particular resource instance to ensure clients are not impacted by changes to servers.  So, "http://example.com/sales/invoices/1" always results in a response that represents invoice #1.

In order for a requester (or client) to represent state at the time of the request is via HATEOS and metadata hypertext references to related resources.  So, the XML response for "http://example.com/sales/invoices/1" may look like this:
```json
{
   "accountIdentifier": "12345",
   "total": 100.00,
   "_links": {
        "self": 
        {
            "href": "/sales/invoices/1",
            "type": "application/json"
        },
        "last": { "href": "/sales/invoices/1999" },
        "next": { "href": "/sales/invoices/2" },
        "lineItems": [{
                "href": "/sales/invoices/1/line-items/1"
            }, {
                "href": "/sales/invoices/1/line-items/2"
            }]
    }
}
```
So, the client application knows that the last invoice at the time of the request has the id 1999, the next resource at the time of the request is 2, and that there are two line items in the invoice.

This allows each application to know about application-specific state in relation to the server (Client-Server, Stateless, Data Elements).  It also makes use of Uniform Interface in that later the client can re-connect to get at /sales/invoices/1/line-items/1 and be assure that it exists (Uniform Interface).  Since we're dealing with URLs, we're isolated from server implementation details.  Or is it isolated?  Let's look at the two ways proposed to implement versioning.  The first way is by url, lets say a new version was deployed since the above response was received. To maintain Stateless and Client Server. the response (the body) must be identical (assuming no updates to that invoice).  For example:
```json
{
   "accountIdentifier": "12345",
   "total": 100.00,
   "_links": {
        "self": 
        {
            "href": "/sales/invoices/1",
            "type": "application/json"
        },
        "last": { "href": "/sales/invoices/2070" },
        "next": { "href": "/sales/invoices/2" },
        "lineItems": [{
                "href": "/sales/invoices/1/line-items/1"
            }, {
                "href": "/sales/invoices/1/line-items/2"
            }]
    }
}
```


# Tradeoffs
The choice of any one style over another means accepting tradeoffs.  There are tradeoffs with REST, that's a fact.  But the tradeoffs are decisions to gain a benefit in a certain context.  If you find any one tradeoff of a given style is not acceptable; that style may not be right for you.  That's life, find another.  Face facts, doing _part_ of a style is not _the style_ (the only thing wrong with that is mistakingly calling it that style).
