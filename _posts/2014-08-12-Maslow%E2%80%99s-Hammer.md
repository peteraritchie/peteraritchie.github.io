---
layout: post
title: Maslow’s Hammer
categories: ['Architecture', 'Design/Coding Guidance', 'Software Development', 'Software Development Guidance', 'Software Development Practices', 'Tips']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2014/08/12/maslows-hammer/ "Permalink to Maslow’s Hammer")

# Maslow’s Hammer

When you go about any task, knowledge and experience from a vast range of specialties can benefit you in your approach to a task.  I often draw similarities in writing software to building houses, for example—mostly as a an allegory. Writing software is a task largely performed by humans, as such human nature comes into play.  Research and understanding about human nature can benefit people who write or are involved in the writing of software.  Abraham Maslow had a goal of better understanding the human mind.  In that journey, he recognized the _law of the instrument_ and created a hammer allegory.  This concept seems to often apply to software technologists and I find myself having to refer to it way too often.  I'd thought I'd detail it here and put a bit of my spin on it.

## The Golden Hammer

Maslow detailed in his book The Psychology of Science, the concept of _if all you have is a hammer, everything looks like a nail_.  This is sometimes referred to _The Golden Hammer_, and a specialization of _the law of the instrument_.  Basically, what Maslow recognized was that we go about performing a task, we have only our knowledge and experience to apply to performing that task.

Maslow opined that if your knowledge is so narrow such that the only tool you know how to use is a hammer, that—when given a task to perform—you'll _project_ nails into places where nails don't really exist and thus want to use a hammer to complete the task.  The corollary to this is, of course, that as soon as you learn how to use a hammer you're hell-bent on using it, no matter the consequences.

I'm too often reminded of this in software development, that software developers like to take what is effectively an empirical process and make it a defined process whenever possible.  They want take their new-found ("shiny new thing"), or tried-and-true, knowledge and create a "just apply x" process to it.  I try to point this out when I can, and offer ways to help break free of that, or at least question the status quo, here on my blog and elsewhere.

## "Full stack developers"

Lately I've recognized that the same thing is happening at a broader level.  Developers have coined the term "full stack developer"—which is a developer that has knowledge and/or experience with every tool/library/framework from the lowest level to the highest level.  For some, this may be 3-layer development: WinForms front-end, .NET business logic layer, SQL Server data layer/back-end and all the _devops_ dependencies that go with that. For others this may be HTML front end, MVC framework-dujour, web service layer, database—with one flavour per devops platform for each.  Etc. **Software does get written this way**, I cannot deny that—we all know that software gets written and used despite things like technical debt, this, etc.  But, "full stack" is really just another incarnation of Maslow's Hammer.  We're conditioned that software developers know _one _of a handful of defined processes (use stack X, or use stack Y) and know the process of applying that process in different places.  I'm coining the term "Society of the Stack" to describe this—where there seems to be an actual community around using and promoting the use of a "stack" of pre-defined components/procedures to rubber-stamp where ever possible.  This simply strikes me as a resurgence of SDLC (and away from agile) at an architectural level.

If you want to break free of this type of thinking, try to put _thought_ into how you design software or how your current design is used.  If you consider yourself a "full stack developer", periodically check that every component or process in that stack makes sense in the situation you're using it in. (if it's not, you've recognized a technical debt).  To be able to do that effectively, always be knowledgeable about any alternatives to any components or processes within that stack.  Writing software is a _science_, the use of any component or process in a given situation should be backed up by facts—don't go down the dogma rat hole.

All software developers are recovering process addicts, we need to band together to make sure we don't let that monkey cloud our judgement.

## Conclusion

Yes, I _know_ that Maslow's Hammer is a tired analogy to how software developers write software; but software developers keep focusing only the knowledge they have to solve problems and seem to fail to widen their horizons to the fact that there are better, proven, solutions to the problems at hand.  If they only looked/listened.  The only thing I feel I can do—in addition to pointing out alternative solutions—is to reiterate Maslow's Hammer in the hopes that it helps at least one person break free of the _Society of the Stack_.

