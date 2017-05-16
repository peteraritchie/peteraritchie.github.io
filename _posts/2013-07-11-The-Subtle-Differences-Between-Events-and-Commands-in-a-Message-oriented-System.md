---
layout: post
title:  "The Subtle Differences Between Events and Commands in a Message-oriented System"
redirect_from: "/2013/07/11/the-subtle-differences-between-events-and-commands-in-a-message-oriented-system/"
date:   2013-07-10 12:00:00 -0600
categories: ['Architecture', 'Design/Coding Guidance', 'Patterns', 'Software Development', 'Software Development Guidance']
tags:
- msmvps
disqus_id: "1041 http://blog.peterritchie.com/?p=1041"
---
[Source](http://pr-blog.azurewebsites.net/2013/07/11/the-subtle-differences-between-events-and-commands-in-a-message-oriented-system/ "Permalink to The Subtle Differences Between Events and Commands in a Message-oriented System")

# The Subtle Differences Between Events and Commands in a Message-oriented System

![][1]There's a common misconception I see in message-oriented software and discussions of such.  That is with the role of commands versus events.

There are two basic message channel types: one-to-many and one-to-one.  These are encapsulated in a couple of messaging patterns: publish-subscribe channel and point-to-point channel, respectively.

In any messaging system, what applications do are to "send" and "receive" messages.  Semantics come into play when you start to focus the intent of your system and your messages.  Semantically, you only "send" to point-to-point channels and "publish" to publish-subscribe channels.  Sometimes you semantically "publish" to a "topic" in a channel; but you still "publish"

Messages, commands, and events are much like vegetables and fruits.  A fruit is a type of vegetable but not all vegetables are fruits: commands and events are messages, but not all messages are commands and not all messages are events.

This relationship is mirrored by commands and events.  You "send" messages and you "publish" events.  This implies that commands only go over point-to-point channels, and events only go over publish-subscribe channels.  The relationship of event to message means that you can send an event on a point-to-point channel, but never publish a command over a publish-subscribe channel.

Gregor Hohpe is reasonably clear on these patterns in Enterprise Integration Patterns when he says "The Publisher-Subscriber pattern [POSA] expands upon Observer by adding the notion of an event channel for communicating event notifications"  Where [POSA] is "Pattern-Oriented Software Architecture" that also details an "event channel" when discussing publishers and subscribers.

In addition, Martin Fowler studies events and compares then briefly to commands and details "…broadcasting events to everyone who may be interested but sending commands only [to] a specific receiver" <http://bit.ly/13DEN43>

There are other references that detail these subtleties, e.g. <http://bit.ly/1aejlBD>.

Command messages are implementations of the Command Pattern–which is a means of encapsulating the parameters of a method/function.  The command object is given directly to a single invoker object.  The object that gives the command object to the invoker is decoupled from the actual method/function; but the command object is coupled to receiver object.  i.e. in order to create a command object, the invoker and receiver objects must exist.

Publish-subscribe is an implementation of the Observer Pattern–which is a means of decoupling observers from publishers of notifications.  To have an expectation of receipt and specific processing (i.e. a Command) is a level of coupling that Observer specifically avoids.

It's important to understand these subtleties because patterns are effectively a lexicon, each of which has specific meaning.  When you use a lexicon of context or with the wrong meaning, you're defeating one of the main purposes of patterns and thus introduces confusion where you're trying specifically to avoid it.

To sum up, a command is sent to a particular receiver and a publisher simply publishes events.  In pub/sub, who receives the events is handled by the channel, not by the publisher.

[image source: <http://www.eaipatterns.com/MessageChannel.html>]

[1]: http://www.eaipatterns.com/img/MessageChannelSolution.gif

