---
layout: post
title: Iterator Methods
categories: ['.NET Development', 'C#']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2014/07/17/iterator-methods/ "Permalink to Iterator Methods")

# Iterator Methods

Despite being around a while, I find that **Iterator Methods** haven't gotten nearly as much attention they deserve and aren't as understood maybe as they should be.  So, I thought I devote a post to Iterator Methods.

MSDN documents an Iterator Method is a method that performs a custom iteration over a collection and also uses the yield keyword.  I don't think given C#'s evolution since yield was introduced that such a narrow definition is necessary.  I'd expand that definition to detail a method that returns a deferred enumerable.

A typical example of an iterator method:

This is a simple iterator method with a compile-time sequence of numbers that we want to be able to _iterate_.  While you might think this is the same as the following:

…it's much more powerful than that.  Returning a collection instance requires that the entire collection be allocated _in memory_ and that each element _actually exist when the iterator method is called_.  The second part is one of the most interesting things that iterator methods offer, _deferred execution_.  You can get that sort of thing with LINQ, but you can write your own deferred execution without having to hand-write a complex IEnumerable<T> implementation.  (I say "hand-write" because the compiler writes one for you).

For example, I wrote long ago about using an iterator method to return an IEnumerable to iterate _all future key presses_.  Something like this:

This creates an infinite IEnumerable<char> that effectively contains data from the future.  Something you couldn't possibly do with a collection type instance.

This is a fairly pedantic example, but it shows the power of what you can do with iterator methods.

MSDN describes these types of methods as performing a custom iterator over a collection; here's an example:

Now, pay attention to the possibility here and not the fact that LINQ to Objects could do the same thing.  But, again, why limit "Iterator Methods" to something that uses yield return.  I would still consider this an Iterator Method:

If the incoming IEnumerable was deferred, so too would this method.

Iterator methods allow you to operate at the element level rather than at the sequence level.  They allow you to process a sequence without having to know about, or even have in-memory, the entire sequence.  This offers a composability that Bill Wagner describes in much more detail in _More Effective C#_ (Item 17). Suffice it to say, it allows you to decouple processing a sequence from the storage model used to store that sequence (or the fact that _no_ storage model for the "sequence" may exist).  This offers huge gains in the ability to process large quantities of data more-or-less independently from the amount of memory we have at our disposal.

In a future post I hope to get into a specific case of where iterator methods can provide easy ways of dealing with sequences that would otherwise be limited by memory.

