---
layout: post
title: 'Naming Things - Common Actions and Events'
categories: ['Naming Things', 'Architecture']
comments: true
excerpt: "One aspect of making it easier to name things is to settle on some common terms, avoiding confusing synonyms.  In this case common actions and events."
tags: ['September 2022']
---
In this multi-part series on Naming Things, I dig into the benefits of having a clear understanding of common terms and concepts--in this case, common actions and events.

What does Deleted mean? Is it the same as Removed or Destroyed? What if you want to support soft delete as well as hard delete?

I want to be clear; these aren't developer decisions. They're developer problems based on a lack of clarity in the customer's domain. A customer likely won't use terms like "soft delete" and "hard delete ."The customer will probably refer to the most common form of delete as "delete." An architect role is responsible for teasing out the nuances of meaning into terms that the subject matter experts agree upon and getting consensus on usage with the development team.

Every system involves mutating data and information, yet it can be a common source of confusion regarding naming things. There are multiple types of data changes. Systems can create new data and may add that new data to a collection--physical or logical. Systems may change data, or designers may change the structure of data. Data is often removed--from a particular view or existence.

English allows us to reuse terms to mean many things. "Delete" and "changed," for example. There are well-known terms that enable us to communicate intent and consequences easily. But, when we reuse these terms across different contexts with different intents and consequences, we introduce the possibility of confusion, making naming things seem difficult.

It's important to understand the different intents and resulting consequences to data and attempt to get consensus on names and terms that adequately and uniquely represent these situations.

"Delete" is a common point of confusion. There may be a need for _soft deletes_ and _hard deletes_; both of WHICH make data inaccessible in a context. But, data may also be moved from one context to another, changing its accessibility but not making it _inaccessible_. To use a single term like "delete" for all of these situations leads to confusion and issues in naming things.  

<!--
An important aspect of naming: name the consistency boundary. What is a date? A year, month, and day. If we included time, is it still a date? Typically that would be called date/time.  
-->
Each domain can be different, but the situations I've just described are very common. For those, I start with unique terms for each and work with the subject matter experts to refine them (if needed):

- **Deleted** means something is no longer accessible in some context.
- **Destroyed** means removed from existence; no possible way to ever get it back.
- **Removed** means a thing has been moved out of or removed from a container/collection.

Inverse terms:

- **Created** signifies something new has come into existence (rather than Added).
- **Added*** signifies something has been added to a container or collection.

Mutating information seems like such a simple concept. But, we often need to know if data changes within the context of other data.  Unique data mutation terms I start out with when working with subject matter experts:

- **Updated** signifies the value properties or attributes of an existing thing (entity) have been changed.
- **Changed** signifies an entire thing (entity) has been replaced with another.

## Word Form

Actions are verbs, and events are past participles constructed from verbs. Most event names are constructed from regular verbs by adding the prefix -ed. Delete + ed: deleted; create + ed: created.  Sometimes events are constructed from irregular verbs and don't end in ed. Bind: bound; drive: driven; sleep: slept.

Events are not simply verbs in past tense form. An event's context is that it is related to a subject. For example, the event "deleted" involves a subject and is used to describe the current state as a result of a past action. In grammar, this is _present perfect tense_ and implies an auxiliary verb of "has been ."e.g., _The customer record has been deleted_ or _The customer record is deleted_. Since this details the subject somehow, it is also in a _present indicative_ form. This detail is important but normally for edge cases. Normal domain narratives should align with this because that's normal language in these scenarios.

- Match events to actions; don't define events when no action would result in that event.
- Don't assume events always end in "ed."
- Events are present indicative, past participles, and in the present perfect tense.

Do you have other actions and events that you commonly encounter?
