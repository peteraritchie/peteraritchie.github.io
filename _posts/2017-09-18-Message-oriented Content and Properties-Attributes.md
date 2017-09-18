---
layout: post
title: Message-oriented Content and Properties/Attributes
date: 2017-09-14 23:32:00 -0500
categories: ['Message-oriented', 'Software Guidance']
comments: true
excerpt: "When to put data within the content of a message and when to not put data within the content of a message."
---
# Message-oriented Content and Properties/Attributes
Like HTTP, what should be in the headers and what should be in the message "content" can be difficult to pin down definitively.  Unlike HTTP (i.e. REST), message-oriented communication can be a lot easier when it comes to the "resource identifier".

[Messaging systems almost always consider "content" the "body" and have the concept of a message "header" that contains metadata about the message](http://www.enterpriseintegrationpatterns.com/patterns/messaging/Introduction.html); much in the same way as HTTP.  And like HTTP, what shouldn't be in the message body can sometimes be bewildering.

There are some straight-forward, established patterns and practices that cover some of the considerations about what might not be "content".  For example: [Envelope Wrapper](http://www.enterpriseintegrationpatterns.com/patterns/messaging/EnvelopeWrapper.html) details that non-body data should be in an "envelope" (which then becomes part of the "content" when you can't support a messaging system's headers).  But this can also be made less deterministic by established patterns like [Content-based Router].

Message-oriented is first and foremost about loose-coupling.  For the most part, the fact that you're using messaging (and that there is a message to be sent and to be received) should be the only thing that couples a producer to a consumer.  To some extent that's why patterns like [Content-based Router] exist, the sender of a message shouldn't need to do anything special for the message to be routed.  But, [Content-based Router] is about routing based on *content*, there are also reasons to route messages that may have nothing to do with content.  This doesn't mean pushing those things into the content in order be routed is the right thing to do.

As mentioned earlier, metadata *about* the content or the message should not be within the content and should be part of the message attributes or within the message headers (depending on how messages are transported, I'll refer to these simply as **message header values** or something within the **message headers**). This is the predominant rule of thumb.  Information like *sender* or *date/time sent* are obviously metadata *about* the message (or the sender) and are good candidates to be placed in the message headers.

What *is* data *about* content can be vague though.  [Content-based Router] points out routing and routing sometimes involved addressing.  With a Point-to-Point channel, addressing from a producer's point of view is simply just sending the message to a well-known queue.  In situations where the producer needs to *address* a message to a consumer or a *type of consumer*, message headers should be used for this.

Some [HTTP header fields] might be more familiar and a good source of inspiration.  For example:
- [Content-Type]
- [Authorization]
- [Cookie]
- [Host]

### Content-Type
In message-oriented systems, this is often referred to as a *Message Type*.  Like HTTP, the format of a message could be unique.  In cases where the type of message changes, a message header field that allows a consumer to differentiate the content properly is very useful (essential?).  And to be clear, the headers portion of HTTP (actually, all but the message-body) is a fixed format: ASCII.  The *Content-Type* field details (in that predetermined format/encoding) what encoding and format the message-body is in.  Message header values should be viewed the same way: in a predefined format/encoding and something like *Message-Type* details the format/encoding of the body.
### Authorization
Typically the *authentication* aspect of something like this is only used in message-oriented system (authorization handled by channel, for example).  Validating that a message came from a known producer is frequently required.  Many message transport systems can, like HTTP can, do that authentication/authorization within the transport; but application-specific authorization is common.
### Cookie
A cookie is a form of encoding stateful information so that a stateless protocol like HTTP can retain state from request to request.  It's extremely important to view message-oriented channels as stateless as well and if *state* is required to be known across messages, this needs to be included (or linked to) when sending the message.  This typically doesn't follow a cookie-like model (i.e. including the actual state within the request) but the message is *correlated* to that state and the receiver is able to *retrieve* that state.  Typically this is covered by other messaging patterns like *Correlation ID* or *Causation ID* to provide identification of that *context*.
### Host
Sometimes addressing of messages can simply be the fact of sending a message to a particular queue name/endpoint.  Sometimes there is application- or session-context that affects addressing, in which case addressing is included when the message is sent.  HTTP *Host* is similar to that, in that it provides the address where the message is sent to.  Typically in HTTP this is the same as the value in the URI involved in the request, but an HTTP request could be forwarded to another URI.  From a message-oriented point of view, this type of thing is generally referred to as a [Recipient List] when addressing to specific instances of consumers or [Routing Slip] when addressing by some level of context that a consumer that understands the context can consume.

Some other useful messaging-specific patterns involving header-related fields:
### Message ID
There are many cases where the producer of a message must identify the message in some way.  *Message ID* is a header value that holds that application-unique identifier of the message being sent.
##Correlation ID
The Correlation ID header value provides an application-unique identifier to some sort of context.  Often that is communication-unique (not just application-unique).  i.e. it may be a re-use of some other ID.  e.g. if the context of a given message is the fact that another message is being processed, the Correlation ID may be the Message ID of that original message (although, some prefer a Causation ID for that; but there's more semantics to that).  The re-used ID may have nothing directly to do with messaging.  For example, it could be the primary key of whatever is related to message being sent (e.g. `CaseId`).
### Causation ID
Much the same as a Correlation ID, but the added semantics of value being a Message ID sent previously.
### Sequence Ordinal
Although using message-orientation is partially to accomplish some level of abstraction of a consumer from a producer and both from the physical transport method, anything used in a system introduces coupling and what is coupled to should be viewed as a *leaky abstraction* that can affect *how* messages are sent.  Message size, for example, is often (technically *always*) a consideration and what *maximum message size* the transport or channel can handle may need to be taken into consideration.  If the data that needs to be sent is larger than can actually be sent by that transport of channel then the message must be split up.  Depending on the transport and the channel messages may not relate to one another (e.g. order) and how the sequence of those messages need to be interpreted by the consumer should be included when the messages are sent. A Sequence Ordinal (or Number or Identifier) can be included as a header value so the consumer, should it receive messages out-of-order, can sequence the messages to generate the larger piece of data or super-message.
### Expiration
Messages are often sent with the intent of accomplishing something (*event* messages are unique in that an *event getting sent* is really the only intent of the producer).  Sometimes, what needs to be accomplished has a shelf life; and if that thing that needs to be accomplished really has no point in being done if not done within that time, an *Expriation* can be included as a header value to hint to the consumer that if the message isn't processed within a certain amount of time, don't bother.  This is often a UTC date/time value.
### Return Address
Sometimes the sender may need to define *where* a response or related messages are sent in response to a message.  The Return Address pattern is used to communicate that to the consumer of the message so that any related/response messages can be sent to a specific channel.  *Be careful here, if the channel is really based on the content type,* Content Type *should probably be used instead avoid content-based coupling being additionally coupled to channel*.  Also, if *where* replies are sent are based on the destination having the state needed to process the reply, a *Correlation ID* should be used also to avoid state-based coupling being additionally coupled to channel.

### Wrap-up
I hope that gives you some good guidance with examples to better decide what should and should not be within the body of a message in message-oriented systems.  There are always exceptions, but those are scenario-specific and need to be addressed on a case-by-case basis.  Just remember that when making decisions, if something isn't giving you the value you need and you're doing it just because it's a guideline, you've misunderstood the meaning of *guideline*.

[Content-based Router]: http://www.enterpriseintegrationpatterns.com/patterns/messaging/ContentBasedRouter.html
[HTTP header fields]: https://en.wikipedia.org/wiki/List_of_HTTP_header_fields
[Cookie]: https://en.wikipedia.org/wiki/HTTP_cookie
[Host]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Host
[Authorization]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.8
[Content-Type]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17
[Routing Slip]: http://www.enterpriseintegrationpatterns.com/patterns/messaging/RoutingTable.html
[Recipient List]: http://www.enterpriseintegrationpatterns.com/patterns/messaging/RecipientList.html