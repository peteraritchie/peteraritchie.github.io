---
layout: post
title: 'If you think you need to use an ORM, think some more.'
tags: ['Architecture', 'Design/Coding Guidance', 'Software Development', 'Software Development Guidance', 'msmvps']
---
[Source](http://pr-blog.azurewebsites.net/2014/08/05/if-you-think-you-need-to-use-an-orm-think-some-more/ "Permalink to If you think you need to use an ORM, think some more.")

# If you think you need to use an ORM, think some more.

Software developers took great strides when they defined and/or embraced Agile. Agile tells use that software is about the user, it's not about all the supporting process. You should be talking to your user, find out what they _need_ and give them that—they don't _need_ process, they don't _need_ huge design documents, and they don't _need_ only things you want to work with.

But, developers continue to want to force process where it's not needed or doesn't add value. Developers tend to learn something and want to "processize" it—make it rote. Especially with things that may excite them. They continually want to reduce the amount of thought they put into things.

ORMs are a perfect example. "Back in the day", when SQL databases were either the only thing available for storing data or were middleware decreed by the ivory tower (data) architect or IT department, writing object-oriented software was at odds with relational data. An object could be structured data and a relational database (when following the penultimate normal form) was a subset of linked, flat tables. Objects with their structured data and behaviour, of course, could not be accurately represented by a subset of over-normalized flat (but linked) tables. Enter impedance mismatch. And ORMs where created to abstract the impedance mismatch (and other things) away from the object-oriented design so that software design could be done how it needed to be and be separate from the design of the data.

## Bottom-up design

One of the problems with many systems that use ORMs is that they were designed from the bottom up. The design started with implementation details like data, data structure, and thus implementation details like database type; **before what the software needed to do was known**. ORMs helped with the impedance mismatch of the relational data mapped to objects, but **forced developers down the relational database make-work machine**. ORM and mapping is an explosion of work and complexity that is only worth it if it is necessary. It's an explosion of work partially because despite an ORM, the "object" it maps to still has impedance mismatches and is an object at the data layer and still needs to be mapped to "view" types.

Much of the time it seems that a Visual Studio project is created and a bunch of nuget packages are added before discussion with the user/stakeholders to ask "what do you need". Much of the implementation details have already been decided upon before any real understanding of the problem that needs to be solved has begun. Sometimes it's even worse; developers have their** go-to architecture** and they rubber-stamp it into all the situations they're involved in.

## Design by rote

Mindlessly repeating something without thought is the definition of rote. I see design-by-rote too often due to people using only the things they have experience with (and thus are confortable with) and have not tried to learn more about the problem at hand and learn more about alternatives that would help solve _that_ problem better.

Rote is mindless, which means not enough thought has been put into the architecture or the most important part of the design.

Clearly software _can_ be written like this, because this is a prevalent problem in the software industry. It _can_ be done but it introduces a lot of work, process, and usually frustration for the end users because the software development effort focuses on process, ceremony, and implementation details. Sometimes, _instead_ of focusing on the solution the end user needs.

## Alternatives

I really don't think you can know about alternatives to the point where you can know where to apply them without understanding the specifics and nuances of some basic theories and concepts. ACID, of course, is something you really have to grok in order to decide a relational database is a good fit or not. Relational databases have strong consistency-during-write guarantees that drastically affect availability. You, of course, can't really grok how availability relates to consistency and thus how and where your prioritization of availability can impact your choice of database type without understanding the CAP theorem. Without understanding CAP, you'll assume you can have consistency, availability, and be able to support partitions all at the same time.

Without understanding CAP, you won't understand you can only have two. And, of course, if you've already forced yourself to pick a relational database before knowing more about what the user needs, you won't know how to prioritize consistency, availability, and partition support. Without knowing this prioritization you won't know if you should pick a CA database, an AP database, or a CP database.

Relational databases almost always lie in the CA space—which means their support for a partition is almost nil. If you need to support multiple nodes and have one or more of those nodes not being connected to _all_ the others for even a small amount of time, relational is a poor choice. (yes, it _can_ be done, but the work/hardware/system involved is not cost effective for most scenarios. Plus at the cost of availability). Imagine if Google had that level of consistency such that any write of data locked out any other read of that data until it completed—consider they have thousands upon thousands of nodes. Imagine blocking thousands of nodes and still having a responsive (available) site.

If CP or AP is the area you think you need to be in, then you might want to consider a document database, a key-value database (or store), or maybe even a column-oriented or tabular database. Most of the "web scale" databases lie in the AP area, like Dynamo (key-value), Cassandra (column-oriented/tabular), CoucheDB, and Riak (both document-oriented). You can still go with the CP side of things and have you choice of the same types of nosql databases like MongoDB (document-oriented), HBase (Hadoop: column-oriented), or Redis (key-value)

There are all sorts of great tools out there that specialize in solving all sorts of specific problems is some of the best ways possible. Shoe-horning one thing to solve all problems is rarely the best solution. Data analysis for example; SQL databases (and thus the need for ORM) that contain operational data may not be the best solution for any given system's data analysis and reporting needs. In fact,** that's what normalization is**: an attempt to make the data as flexible as possible **for reporting**. Data normalization isn't about making the software run faster, it's about making querying the data more flexible (remember the 'Q' in "SQL"?). In fact, relational databases make writing data fairly slow (and thus means locking out reads for potentially longer than they need to—potentially slowing the software). So, a write-heavy system that didn't need ACID-like consistency might be slow or not scale well (or at all). If the number of reads are drastically more (i.e. you're talking about factors more) than writes, a relational database may be a bad choice.

So, in addition to understanding ACID, CAP, CA databases, AP databases, CP databases, key-value stores, relational databases, column-oriented databases, document databases, etc. you also have to understand where reporting fits in and how you need to fulfil reporting requirements. Without knowing what tool is best for your end users, you won't know how to architect your system. There are all sorts of great business intelligence (BI) tools to help with data analysis of generally-transactional data. BI tools are great for allowing end-users to do ad-hoc reporting (rather than software developers spending weeks/months creating one-off reports for the end-users). To support those may require a specific architecture. A data-warehouse, for example, might be a good thing for most BI tools. That data-warehouse might be best suited as sourcing from a periodically updated relational database. At which point, having your operational data on a relational database may be a complete waste of time—introducing ORMs, ORM configuration, mapping, etc. solely for supporting the choice of relational databases. i.e. you don't need an ORM if you use a document database.

Arguably, effort into creating and writing ORMs might have better been served by writing more useful databases (i.e. getting nosql databases sooner) or pressuring the people involved away from process and toward software tools and middleware that made sense. But, that's where things went. And on the .NET side of things, that was really just perpetuated by the re-writes of lots of existing Java tools (like Hibernate).

ORMs are like any other tool—they have a specific time and place. If you find you've got to put screws into wood, don't pick a hammer to do it. Hammers are great for the task they're design for (just like ORMs), but other tools are better designed for certain tasks.


