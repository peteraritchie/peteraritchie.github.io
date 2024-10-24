---
layout: post
title: 'Naming things: Actions'
categories: ['Naming Things']
comments: true
excerpt: "Naming is hard and easy to get wrong, leading to hard-to-understand code. Getting agreement on generic action names can ... and make naming other things less paralyzing"
tags: ['Oct 2024', 'Naming Things', 'DDD', 'Domain-Driven Design']
---
![Overwhelming Possibilities](../assets/overwhelming-possibilities.png)

A few years ago, I decided to look into _why_ naming is hard. That spawned a conference talk that I've done several times. Part of what I present in that talk is my observations of working with many teams regarding establishing names for generic actions applicable in their unique domain. 

## Actions, Activities, Operations, Events, Occurrences, Oh My

Generic actions have many synonyms. Without considering different words to mean the same thing, the names of things in the code related to generic actions added a noticeable cognitive load to the initial understanding of the domain. Let's look at what I mean by _generic actions_.

In a domain, things _happen_ to domain objects. Many of these actions can be considered "updates," but it's more fine-grained. For example, here's a table of some verbs that could mean some sort of _update_ in most domains:

```text
Add     Create   Generate  Build   Construct  Initialize  Make    Establish
Update  Change   Modify    Mutate  Alter      Revise      Adjust  Transform
Delete  Destroy  Remove    Erase   Move       Release     Pull    Withdraw
```

It's extremely unlikely that there are 24 distinct mutating actions in any domain. Most domains work on a CRUD model where, besides Read, there are `Create`, `Update`, and `Delete`. Unfortunately, three mutating actions are typically too coarse-grained and can be unrepresentative of the domain language.

Spending a short time creating a happy medium is valuable: making a brief list of the terms used for the generic domain actions. The list should be imperative verbs that can be (or are) transitive (that is, they can refer to an object. e.g., "arrive" is a verb that cannot be transitive).

Once there is agreement on the generic actions that apply to the domain, establishing a similar list of events further increases value. That list should be the action verbs in past participle form. For example, if "create" is an action in the domain, then the event that describes it would be the past participle form of "create": "created."

## Example

Each domain is unique, so make sure these terms work for yours.

### Actions

- **`Create`** - to bring something into existence. Contrast with Add. See also `Destroy`.
- **`Add`** - to add something (already created) to a container or collection. See also `Remove`.
- **`Update`** - to change the value of one or properties of an object. Contrast with `Change`.
- **`Change`** - to replace an entire instance with another instance. 
- **`Delete`** - to remove access to something in some context. Contrast with `Destroy`.
- **`Destroy`** - to eliminate something from existence, the opposite of Create. Contrast with `Delete`.
- **`Remove`** - to remove something from a container or collection, the opposite of Add. Contrast with `Delete`.
- **`Modify`** - to modify the structure or schema of something. Contrast with `Update` and `Change`.

This list should be a stretch for most domains. Many domains don't have a concept of _modifying_ schema or _changing_ instances. Further still, I have found that most domains either `Delete` or `Destroy` data. This leaves `Create`, `Delete`, `Add`, `Remove`, and `Update`.

Remember that this example list is designed to be generic--actions not likely to be domain-specific. In your ubiquitous language, you will still have other terms to refer to domain-specific actions. e.g., you may `Correct` an Address in the domain to signify an `Update` or `Change` to an Address to differentiate it from a `Move` concept. Or a domain might have a `Restore` behavior as a specialized type of `Update` or `Change`.

I recommend establishing a similar list of event names that is effectively the same list of verbs for the actions but in past participle form:

### Events

- **`Created`** - something was brought into existence. Contrast with `Added`. See also `Destroyed`.
- **`Added`** - something (already created) was added to a container or collection. See also `Removed`.
- **`Updated`** - the value of one or properties of an object was changed. Contrast with `Changed`.
- **`Changed`** - an entire instance was replaced with another instance. 
- **`Deleted`** - access to something was removed in some context. Contrast with `Destroyed`.
- **`Destroyed`** - something was eliminated from existence, the opposite of `Created`. Contrast with `Deleted`.
- **`Removed`** - something was removed from a container or collection, the opposite of `Added`. Contrast with `Deleted`.
- **`Modified`** - the structure or schema of something was modified. Contrast with `Updated` and `Changed`.

This list of events could be similarly optimized as `Created`, `Deleted`, `Added`, `Removed`, and `Updated`.

My experience has been that establishing and communicating lists like these work well in avoiding ambiguity and establishing clarity. Most domains are complex, but clarifying the names of generic actions can make a noticeable difference in understandability and approachability. I've even found that this level of attention to naming makes the code base more agile.

In the comments, I'd love to hear what generic actions apply to your domain if these don't apply.
