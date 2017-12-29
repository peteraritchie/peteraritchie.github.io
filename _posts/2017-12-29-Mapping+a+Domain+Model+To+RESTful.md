—-
layout: post
title: Mapping a Domain Model to RESTful
date: 2017-12-29 23:32:00 -0500
categories: ['Design', 'API', 'Guidance', 'RESTful']
comments: true
excerpt: "Looking into one technique to provide access to a domain model (behavior) via a RESTful API."
—-
# Mapping a Domain Model to RESTful

In the Object-Oriented discipline, an *object* **is the bundling of data and behavior**.  Martin Fowler defined the First Law of Distributed Objects.  That law states "**Don't distribute your objects**".

A *domain model* is a conceptual **object model of a domain's behavior and structure (entities, data, relationships)**.  It is considered an anti-pattern if a domain model is *anemic*: if it has hardly any behavior.

RESTful APIs have become the de facto standard for distributed applications that provides **stateless access to and manipulate textual representations of *resources***.  i.e. the textual representation is a document or file.  A resource is a mapping to a concept or concepts; a resource is not the implementation details that may have been used during the request for the resource.

We're in an industry with a complexity that requires distributing domain behavior across multiple processes.  So, if RESTful APIs are about providing access to documents or files, yet we need to distribute behavior, what do we do?

> This post is about making a *domain model* accessible by RESTful API, and not just making your data (entities) available to the outside world.  That doesn't mean there's no need to provide access to your data a resources, but providing data only by way of your domain model (that is also supposed to abstract *behavior* is kinda pointless).  

Our industry is very dichotomous: only one thing seems to the right thing and any other thing is wrong (more like the other thing is ignored: Shiny New Thing, Maslow's Hammer, etc.).  Those things can be right, but not *on their own*: it's contextual.

But why do these two things (object-oriented and RESTful) seem to conflict with each other?  How are we to maintain a dichotomy if we have two correct things?  It gets back to that *context* I talked about earlier.  We will *always* need to perform activities and tasks.  Sometimes it's all but *required* to distribute that processing.  That doesn't mean Object-Oriented and RESTful are contradictory.  Each provides a scope by which to follow their generally accepted practices, in *that context*.

We don't want to *distribute objects*, but we want to *distribute processing*.  How do we do this with domain models consisting of objects?  With RESTful we're expected to be focused on *resources*.  It sounds very limiting, but the limit is really a thinking error.  Some people seem stuck on a RESTful API being entirely about resources (nouns) and not about behavior (verbs).  But, that is limited only by what we consider the resource to be.

In RESTful, resources effectively need to manifest as *documents*, but that doesn't mean our API can't provide access to execution of behavior.  Even with the narrowest view of a resource that API still provides access to behavior.  In the simplest of scenarios that behavior is one the methods POST, GET, PUT, PATCH, or DELETE (there's also HEAD, OPTIONS, TRACE, and CONNECT; but we don't use those in with REST).  Those methods are sometimes referred to as *verbs*.  Someone unfamiliar with HTTP and REST may simply proclaim "create more methods!".  That's wrong, that's not REST and that's not HTTP (well, *syntactically* it *is* HTTP; just like *`goto`* is syntactically acceptable)—the method is applied to the *resource*, not what the *resource represents*.  What we *can*, and *should*, do is consider that a resource can be a representation of a *request to perform behavior*.  The *document*—or contents of the resource—then becomes the result or outcome of that behavior.  We can realize that objective by in simplistic circumstances by converting the behavior verbs we want to execute to resource nouns.  I don't mean just using a verb like a noun like "What's your *ask*?"  I mean [*nominalizing*](https://en.wikipedia.org/wiki/Nominalization) the verb into a noun.  e.g. "Explain" to "Explanation" or "Generate" to "Generation" or "Calculate" to "Calculation"... I'm sure you can find lists or an [API](https://www.wordsapi.com/) to get the noun form of a verb.

> To be clear: I'm suggesting that RESTful and OO can complement each other.  I'm not suggesting pick one.  I am recommending using each for the right context. Continue to use OO for modeling a domain (behavior and data, organized by object) to implement at the process level and continue to use HTTP and RESTful as the protocol for distributed application APIs.

If you already have a domain model you want to make accessible via a RESTful API, you might think Contract First or Design by Contract is out the window.  I don't think this is true.  I think any interface intended to be used by anything yet-to-be-designed needs to be *Concepts-Oriented*--that is the interface should only present conceptual things (i.e. the concepts that have led to an implementation).  Contract First and Design by Contract are easy ways to get that because they suggest you define that contract up front, prior to solutioning and implementation.  That's fine when you can do it, but it's really hard to get *Concepts-Oriented* within a design that evolves along with the implementation over time with that chicken-and-egg "Contract First" or "Design by Contract" mentality.

So, back to a domain model that you want to make accessible by RESTful APIs... The ideal domain model consists of objects that implement encapsulation and abstraction properly.  That is, they hide implementation details and provide access to behavior.  That behavior needs to be mapped to a "resource" to be made available via the RESTful API.  The details of that mapping have been explained above; but how do we work those nouns into a RESTful API?  It's not just a matter of sticking this new resource as a root path or within any-old path hierarchy.  The resource as an operation request needs to be associated with the concept it applies to.

In RESTful, the concepts we make available are *resources*.  For one resource to be applied within another, we effectively make it a sub-resource.  The parent resource could be completely conceptual, i.e. like a business function: `/accounting/reconciliation`.  But, I'd argue that there might be something missing from the domain if you find something that is unable to be truly modeled as a resource.  e.g. `/accounts/1234/reconciliation`. So, in this case, if we POSTed to this URI we'd be requesting the creation of a *reconciliation* resource (AKA the request to execute the `reconcile` behavior) for `account` 1234.

When modeling behaviors, especially over the network, we shouldn't expect them to be atomic--that is happening effectively instantaneously.  Luckily HTTP accounts for that with status codes like 202 Accepted.  When 202 is used, the response should fulfil the HATEOS constraint of REST and provide a hypermedia link to the new "resource". That new resource can be accessed directly for status of the request or to get the outcome.  That doesn't stop you from *not* using 200 in circumstances where the request could be executed atomically.  Any HTTP-compliant client should handle 200 and 202.  The *request to perform behavior* model fits well with an independence from atomicity because if the behavior isn't atomic, you really are interested in the "request" and whether it's completed.

## Benefits
- Intention-revealing interfaces.  An API that provides an interface that details the intent of the request it's easier to understand what it does--simply building on standard HTTP methods POST, GET, PUT, PATCH, DELETE, any other behavior the API provides is not obvious.
- Makes the implicit explicit.  The implicit waiting for a non-atomic request becomes explicit.
- RESTful: this maintains the *resource* concept without having to deviate from it.
 
## Being Successful
- Recognize a Command-Query Responsibility Segregation (CQRS) point of view of how you're making the resources available in your RESTful APIs.
- Think declaratively rather than imperatively: model a resource on the conceptual operation that needs to be performed (declarative), rather than simply CRUD abilities to data providing the ability to tell the API how to perform an operation (imperative)
- Treat atomicity as the exception, not the rule.

How might this affect the design of Entity Services?  Well, that's a topic of a future post

## References
- [First Law of Distributed Objects](https://martinfowler.com/bliki/FirstLaw.html)
- [Domain Model Pattern](https://martinfowler.com/eaaCatalog/domainModel.html)
- [REST API Design - Resource Modeling](https://www.thoughtworks.com/insights/blog/rest-api-design-resource-modeling)
- [Resources and Resource Identifiers](http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_2_1_1)
- [Nominalization](https://en.wikipedia.org/wiki/Nominalization)
- [Words API](https://www.wordsapi.com/)