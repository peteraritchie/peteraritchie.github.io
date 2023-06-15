---
layout: post
title: 'HTTP and ETag Header Fields'
categories: ['ASP.NET', 'HTTP', 'Azure', 'Cosmos DB']
comments: true
excerpt: An ETag addresses accidental overwrite by versioning the resource with an entity-tag (a hash of the representation, a version, etc.).
tags: ['June 2023', 'ASP.NET', 'HTTP', 'Azure', 'Cosmos DB', 'Optimistic Concurrency']
---
![A stuffed tiger corrupted appearance due to accidental overwrite](../assets/accidental-overwrite.jpg)

Update: corrected mention of `412` in the context of `GET` and `If-Modified-Since` to `304`.

Over the last four-plus years, I have been almost exclusively working on some sort of *-as-a-Service (*aaS)—for example, Mortgage Origination as a Service, Insurance Claims as a Service. I always see a couple of things when implementing Web (HTTP) services: the _reinvention of the wheel_ and recognizing the problem ETags solves after publishing a specification (sometimes both).

With *aaS as a Web API, the intention is to have multiple API clients providing access to representations of shared resources. Early in projects like this involves an initial (single) client, so the chances of a client having a stale resource representation are slim. When another client starts to use the API and an update gets accidentally overwritten, things get needlessly complicated.

I've seen teams address this problem in a number of ways, often involving a date-time stamp. With multiple clients on an API, scalability is an issue, and a date-time stamp can mean different things to different servers (as we'll see below). You need a single authority for a resource's last modified date-time to avoid exchanging one problem for another. See [Last-Modified/Comparison] for more details.

The creators of HTTP encountered this issue and added features to HTTP to deal with this (I assume that's why they added these features). I don't know when these features were devised, but they proposed them in 1997. So, they've been in the wild for at least 25 years with the entire web as a test bed. So, many brilliant people either created or scrutinized the solution. i.e., it's a wheel.

The HTTP features are _ETags_ and _conditional requests_ and enable _optimistic concurrency_.

## ETags

An [ETag] (AKA entity-tag) addresses the "lost update" problem where there are two clients of an API that have received the representation of a version of an entity. Still, another client updates the entity before the other: the second update causes the first the be "lost." See the following diagram for a visualization:

![Lost-update](./assets/lost-update-sequence.png)

An ETag addresses accidental overwrite by _versioning_ the resource with an entity-tag (a hash of the representation, a version, etc.). When a client requests a resource, the server may include an ETag validator header field with an entity-tag value in the response. The URI of the resource, along with that entity-tag, constitutes an identifier for a particular version of an entity. 

When a client requests a change to the entity, it includes the entity-tag as a basis version with a conditional header field (like `If-Match`.)  The server responds with `412 (Precondition Failed)`, and the client can retrieve the latest version, re-apply their change, and re-send. See the following diagram for a visualization:

![Lost-update](./assets/lost-update-solution-sequence.png)

## Falling back to date and time

Even if you use date and time, **HTTP also covers you with other precondition header fields involving modification date**. The `If-Unmodified-Since` and `If-Modified-Since` precondition header fields allow you to pass modification date preconditions to make a request conditional. When the precondition isn't met, a `412 (Precondition Failed)` status code will be in the response, or for `GET` or `HEAD`, a `304 (Not Modified)` status code will be in the response.

The initial GET of a resource that supports modification dates in conditional requests will include a `Last-Modified` header field validator. The `Last-Modified` validator is in the form of an [HTTP-date].

## Being Successful

RFC 7232, the HTTP 1.1 specification, section 2.3 describes the _entity-tag_:

> An entity-tag is an opaque validator for differentiating between multiple representations of the same resource, regardless of whether those multiple representations are due to resource state changes over time, content negotiation resulting in multiple representations being valid at the same time, or both.

This means that the ETag value depends on the content-type, so two **different representations of the same resource should have different ETag values** (e.g., one gzip encoded, one not.)

This also means that the ETag value is opaque to requestors but does point out that one of the intents of ETags to be **an alternative to using a date-time stamp due to lack of accuracy**.

### PATCH

Using `PATCH` with something like [JSONPatch] may seem to help alleviate conflicts by providing more granularity in what is changing. Technically true, to implement this would be non-trivial. The ETag specifics a tag of that edition of the entire resource, not any one field. While comparing a change against a delta between two editions of a resource (keeping in mind those editions may not be adjacent) might be one technique for dealing with that, **creating deltas between arbitrary versions of the same resource is non-trivial**. You could introduce that sort of thing. Something like event-sourcing might enable that. But remember that there may be interdependencies between properties of a resource, and just because the current request changes a property that hasn't changed since the resource was retrieved doesn't mean there isn't still a conflict.

### Last-Modified

Remember that `Last-Modified` uses [HTTP-date] format, so **`Last-Modified` only supports second granularity**. With multiple origin servers, more than second granularity may be needed to be accurate 100% of the time.

#### If-Unmodified-Since

`If-Unmodified-Since` is used with state-changing methods like PUT, POST, DELETE, and PATCH to avoid accidental overrides (lost updates). `If-Unmodified-Since` imposes the precondition _update this entity only if it hasn't changed since the provided date-time_. **Use `If-Unmodified-Since` to avoid lost update problems when second granularity is not a problem**.

#### If-Modified-Since

When used with `GET` or `HEAD`, the `If-Modified-Since` header field imposes the precondition _respond with `304 (Not Modified)` and not with an entity representation if the modification date of the identified resource is not more recent than the date provided_. **Use `If-Modified-Since` to avoid re-transferring the same data**.

### `409 (Conflict)`

`409 (Conflict)` may sound like an appropriate response to a conditional PUT/POST/PATCH request, except that `412 (Precondition Failed)` is expected. **Response status code [`409`][409] should be used when something about the current state of the resource means that the server cannot change it**. Also, if you have chosen not to use HTTP precondition features and have included something _in the representation of the entity_ for versioning (like last-modified-date, see above), then `409 (Conflict)` is appropriate to signify a potential accidental overwrite or lost update.

### Leveraging Existing Implementations

Azure Cosmos DB implements ETags and `Last-Modified` to be leveraged to support the versioning of resources in your Web API. Technically the ETag is a version of the representation that Cosmos DB provides, so consider generating a new ETag based on what Cosmos DB provides, especially if you support more than one content-type (like XML). Suppose you have the concept of a database DTO or database models different from your MVC models. In that case, you should consider custom entity-tag generation based on the Cosmos-supplied entity-tag.

To leverage the Cosmos-supplied entity-tag, retain it and re-send it in any state-changing requests to Cosmos in the `If-Match` header field. If the entity-tags do not match, Cosmos DB will respond with `412`, and the Cosmos DB library will throw a `CosmosException` with `StatusCode` == `HttpStatusCode.PreconditionFailed`.


<!--
title Lost Update Problem

participant "Client 1" as Client1
participant "Client 2" as Client2
participant API

Client1->API:""GET /resource/123""
activate Client1
Client1<--API:""200 OK""\n//resource v1 representation//

create Client2
Client2->API:""GET /resource/123""
activate Client2
Client2<--API:""200 OK""\n//resource v1 representation//
Client1->API:""PUT /resource/123""
Client1<--API:""200 OK""\n//resource v2 representation//
deactivateafter Client1
destroyafter Client1

Client2-#red>API:""PUT /resource/123""
note over Client1,API#pink:Client 2 is updating the resource based from **v1**, not **v2**:\n<align:center>the v2 update is "lost" to //Client 2//</align>
Client2<--API:""200 OK""\n//resource v3 representation//

-->

<!--
title Lost Update Solution

participant "Client 1" as Client1
participant "Client 2" as Client2
participant API

Client1->API:""GET /resource/123""
activate Client1
Client1<--API:""200 OK""\n//resource v1 representation//

create Client2
Client2->API:""GET /resource/123""
activate Client2
Client2<--API:""200 OK""\n//resource v1 representation//
Client1->API:""PUT /resource/123\nIf-Match: v1""
Client1<--API:""200 OK""\n//resource v2 representation//
deactivateafter Client1
destroyafter Client1

Client2->API:""PUT /resource/123\nIf-Match: v1""

Client2<--API:<color:#red>""412 Precondition Failed\nBasis version of resource is out of date""</color>
-->

## References

[409]: https://datatracker.ietf.org/doc/html/rfc7231#section-6.5.8
[412]: https://datatracker.ietf.org/doc/html/rfc7232#section-4.2
[If-Match]: https://datatracker.ietf.org/doc/html/rfc7232#section-3.1
[If-None-Match]: https://datatracker.ietf.org/doc/html/rfc7232#section-3.2
[If-Modified-Since]: https://datatracker.ietf.org/doc/html/rfc7232#section-3.3
[If-Unmodified-Since]: https://datatracker.ietf.org/doc/html/rfc7232#section-3.4
[Last-Modified/Comparison]: https://datatracker.ietf.org/doc/html/rfc7232#section-2.2.2
[ETag]: https://datatracker.ietf.org/doc/html/rfc7232#section-2.3
[JSONPatch]: https://jsonpatch.com/
[HTTP-date]: https://datatracker.ietf.org/doc/html/rfc7231#section-7.1.1.1