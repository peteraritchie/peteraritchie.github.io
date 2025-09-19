---
layout: post
title: 'What Code Comments are Not For.'
tags: ['Uncategorized', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2012/01/30/what-code-comments-are-not-for/ "Permalink to What Code Comments are Not For.")

# What Code Comments are Not For.

I deal a lot with other people's and legacy code. One of the things I see very often is what I call "misuse of code comments". Let me provide an exhaustive list of what code comments are for:

* Describing why code isn't doing something obvious

There, done.

What code comments are not for (not complete):

// set the value of i   
i = value;

It's obvious that the code is doing that; the comment adds no value here. The compiler provides no validation that the "i" in the comment really applies to any variable in the line the comment applies to. Nor does it even know what line the comment applies to! Comments like this actually introduce some technical debt because I can refactor this code to move it around independently of the comment and thus the comment would appear to annotate some other line of code. Refactoring tools help somewhat with this; but they only really do name matching in comments when you rename a variable. Do you think renaming "i" to "count" really means replacing all "i"'s in all comments with "count"? Probably not; don't use refactoring tools as a crutch.

You can't possibly know what the reader of your code does and does not know. This is especially true of what they do and don't know of language syntax. The language syntax is your common language; you can only assume they know it. You can't possibly know if a comment about language syntax is going to help the reader or not. If they don't know it, they should look it up. Comments that describe syntax are a no-win proposition, you can't possibly have a comment that helps _every_ reader of the code.

An example:   
 /// <summary>   
 /// Constructor for class.   
 /// </summary>   
 public MyClass()

If your reader doesn't know this is a constructor, they probably don't even know what a c'tor is—this comment isn't going to help them much. 

Slightly different example:

> /// <summary>   
/// Initializes a new instance of the MyClass class   
/// </summary>   
public MyClass()

If the reader doesn't know what a c'tor does, does all your code include comments that will help this reader? These comments are a waste of time and add no value. Same technical debt as Obvious, it's not a syntax error to separate the comment from the declaration; there is a risk they will become disconnected or out of synch. If the comment has no value having to manage it also has no value and therefore adds work to the project.

Another example verging on Obvious:   
public MyClass()   
{   
 // Empty   
}

As this stands, it seems benign. But one, it should be Obvious. Two, if it's not, the reader should be brushing up on language syntax. Three, it's not verified. I can edit this c'tor to make it do something else this is perfectly syntactically correct:

public MyClass()   
{   
 x = 42;   
 // Empty   
}

Now, the comment is meaningless and potentially confusing. Reading this for the first time makes you wonder did the class just have // Empty in it in the past and x = 42 was added, or does "empty" mean something different to the author, or did the author suffer from a stroke and possibly need medical attention?

You _can_ assume the reader of your code doesn't know anything about the code. If the language can't express the concepts in the code properly (if it can, you should be writing it that way; if you choose not to, comment _why_.) then comment _why_ the language isn't describing the concepts.

Writing comments to aid the reader in the understanding of the language is sometimes describing HOW the language is working. That's not describing the code but describing the language. Comments should describe WHY the code was written that way if it's not obvious. Again, the language is the common denominator between the reader and the author. There's many references the reader can refer to to learn the language–let them do that; you may not be the best person to help someone learn the language; at the very least you don't know the degree to which they don't know the language. Let the code clearly describe HOW.

Use of comments is often a form of religion; people are very opinionated about them in one way or another. Robert Martin pulls no punches in [Clean Code][1] by saying:

> "The proper use of comments is to compensate for our failure to express yourself in code. Note that I used the word failure. I meant it. Comments are always failures."

Martin has previous described comments as "apologies" for "making the code unmaintainable"…

If you want to use concepts like XMLDOC or tools like JavaDoc to document members and classes, that's fine; just make sure your comments are meaningful and can stand alone.

For what it's worth, these are comments that I have encountered; more than once and on more than one project.

Do you have some code comment pet peeves? We'd love to hear them!

[1]: http://bit.ly/yBatMT


