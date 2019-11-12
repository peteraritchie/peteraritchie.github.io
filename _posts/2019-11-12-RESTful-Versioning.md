# RESTful Versioning
Versioning is not new.  Versioning seems to be one of those things that people find hard to do or difficult to fully understand, especially with services and APIs.  RESTful versioning seems to be in the realm of Tabs v Spaces, but I want to detail my related observations (mostly of other's writings, but with some added color).

## What is a Version?
Before going further, I find defining terms so their meaning is explicit and understood. _Version_ is no exception.

A _version_ recognizes a change to _something_ already established and assigns it an unique identity.  That identity serves as a moniker for _what_ changed so that when the _something_ that changed is processed, it can be differentiated from other _somethings_ of different versions.

## Why Do we Need a Version?
Based on what a version _is_, it may seem easy to at least deduce _why_.  That deduction usually _to differentiate different versions of things_.  This is _what_ not _why_. This is the part that many people seem to dismiss or let slip by.  In the context the knee-jerk response is "different version of the API" (API Versioning).  But, this simply restating what versioning is.  It's similar to defining "version" as
> A version is the version of something in relation to other versions of the same thing.

Yeah, using the word you're defining in the definition is _helpful_.  "Version" must provide:

### Support For Past _**Representations**_
The major reason versioning comes into play is because any one _representation_ of something evolves over time.  Needs change, understanding improves, technology evolves, imperfections are found, etc. and how something is stored or communicated needs to change to accommodate that evolution.

"Requirements" are an obvious agent of change, and it would be easy to provide a trivial requirements example but a _fixing imperfection_ example would be more persuasive.  Humans like to be open-minded but inherently we live in our own worlds (our own mental model of the world).  Some of us are empathic and recognize parts of other worlds of the people around us. Or we know about a set of archetypes for which we can optimized interaction.  But in reality there are really 8+ billion other worlds out there and it's simply not humanly possible to know the intricacies of each.  Which means we make assumptions and trade-offs of what is acceptable to all of those other worlds.  Usually our audience isn't all 8+ billion people, so we're generally more correct than incorrect in our assumptions.  But, being incorrect is inevitable and expected. Much like we need to support many personalities, preferences, and needs; we also need to:

### Support Multiple _Representations_ of Concepts
An example of this type of imperfection are date/time representations.  We live in our own _locus_ (which is like a personal _locale_) and take for granted things we use or do in our locus from day-to-day, like Date/Time representations.  Local time has been working for each of us for all our lives, we take that for granted and use it in a representation without thinking.

There are many things that make this problematic and error-prone.  I won't get into detail what  _all of those_ may be (a blog isn't the place for a tome like that).  The _fix_ is, of course, to use a _different representation_. Implementing that fix and supporting existing representations of complex data means we need to be able to tell different representations of the same data from one another.

This allows us to know how to translate each representation to the same in-memory structure when we (i.e. our code) encounter these representations; reinforcing that _representations_ differ from the _conceptual_ resource _and_ from the _implementation_ translation of the representation

We need the ability to translate _multiple representations_ because there will be instances of differing representations _in the wild_ at a time.

### Support Multiple *Active* Representation Versions
Increasingly we work in asynchronous environments where communication of data is off-loaded to asynchronous communication technology (like queues, topics, and even threads).  And with the drive to 100% availability this means that we perform software updates _in situ_ or without taking our systems completely off-line (or unavailable).  e.g. _indirect_ communication through a queue makes communication of the message independent of the processes. Until it reaches and is consumed by the destination, the message can be in a queue with neither process executing. This requires components to support **at least** two versions of a representation _at the same time_.
 
## Attributes of REST
Since we're in the context of **Re**presentational **S**tate **T**ransfer where resource _representation_ is front-and-center as well as _state_ of that resource, the following is a review of main features of RESTful services:
- REST is not a distributed object style [3] <!--(5.2.1-1)-->
- A resource identifier (URI/URN) is a reference to a particular conceptual resource, not to a particular representation of it. [1] <!--(5.2.1.1-4)-->
- A representation of a resource is transfered between REST components. [1] <!--(5.2.1.1-4)-->
- A resource maps to a set of entities that varies over time, not just the representation at the moment [2] <!--(5.2.1.1-2)-->
- The set of entities that are mapped to a resource are considered equal (by resource identifier and/or representation). [2] <!--(5.2.1.1-2)-->
- The semantics of mapping a resource to an entity distinguishes one resource from another and is constant. [2] <!--(5.2.1.1-2)-->
- Representations are late-bound and based on characteristics of the request. [2] <!--(5.2.1.1-4)-->
- An identifier may exist without, or before, any realized representations. [2] <!--(5.2.1.1-2)-->

## *RESTful* Versioning Options
A quick review of objectives, for any given resource representation: 
- we need to differentiate change independently from unrelated representations
- we need to differentiate different changes to related representations at the same time

There are really only two fundamental options for _API Versioning_ (I didn't use _RESTful Versioning_ for reasons I hope will become clear):
- Version moniker in the URI/URN, or
- Version moniker in the headers (or media-type)

### URI/URN
In REST, a URL/URI **only** identifies a resource, it is not a content-type identifier.  One reason for this is _Content Negotiation_.  Content negotiation details that in the **request for any particular resource**, the _representation_ of the resource (the response) can be negotiated through headers and responses.  That negotiation occurs through the single URL/URI.

I.e. the response format does not need to be consistent per URL/URI. [4] If it's not clear, supporting multiple representations means there can be _many_ response formats for any single URI/URN.  Since we've already shown that each representation is independent of other, **multiple versions need to be represented per URL**. Making something like `example.com/picture/v2` for the SVG format meaningless. Therefore URI/URN versioning doesn't support some fundamental REST features.

### Media Types (Headers)
Media types are monikers for a particular re presentation.  XML and Json or JPEG and PNG are examples of particular representations of the same resource.  But media types are more complex than that.
Media types can consist of a registered type (`application`, `audio`, `example`, `font`, `image`, `message`, `model`, `multipart`, `text`, and `video`), a subtype (the registered format in the standards tree, or a dot-delimited subtype tree), a suffix (prefixed with `+`), and optional parameters (key/optional-value pairs prefixed with `;`). Suffixes can be used to specify the underlying _structure_ of a type/subtype, e.g. JSON and XML.  Formats like SVG can be either textual or binary, so although being a image and SVG, simply specifying `image/svg` is not enough to cover both of those structures. The media type for the XML format of SVG ends up being `image/svg+xml`.  Application-specific types use the `application` type and a subtype in the vendor tree (`vnd`).  If a custom application format for a _person_ resource that uses XML format would have a media type of `application/vnd.person+xml`.  If the service also supports JSON it would have another media type `application/vnd.person+json`. `charset` is a reserved parameter, other parameters have unique meaning defined within the type/subtype.  for example `text/html; charset=UTF-8` and `application/vnd.person+json; version=2.0.0`.

The take away is that **media-types are independent from the endpoint**. 

# Wrapping Up
It may make sense to think that the resource is changing, but in reality it is the representation that changes.  The resource is abstract, like _client_.  Changing Birth Date from local to UTC doesn't change the fact that the **resource is still a _client_**.  If the resource fundamentally changes, that's when you change the URL/URI.  But not with a version identifier, but a new _resource_.  If something previously considered a "client" changes so is conceptually no longer a "client", then a new URI/URN should be used (like "client" to "lead").  _We wouldn't have different versions of clients, merely different representations of client information_.

## TL;DR
A URI/URN is a reference to the single conceptual resource and not to a particular representation.  Since media types _are_ the data format of the representation and the same conceptual resource has representations that can change, **media type must be used to specify different representations that a single URI/URNs supports**.


[1]: https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_2_1_1
[2]: https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_2_1_1
[3]: https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_3_1
[4]: https://tools.ietf.org/html/rfc7231#section-3.4
