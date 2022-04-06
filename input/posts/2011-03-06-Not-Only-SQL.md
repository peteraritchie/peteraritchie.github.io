---
layout: post
title: 'Not Only SQL'
tags: ['Uncategorized', 'msmvps', 'March 2011']
---
[Source](http://blogs.msmvps.com/peterritchie/2011/03/06/not-only-sql/ "Permalink to Not Only SQL")

# Not Only SQL

I just finished a session on NoSQL at the ODNC. Part of what I was trying to get across hinges on an understanding of what relational is, what it's strengths are, what's it's really about, and where it fits (as well as caveats; but, I think that horse is flogged enough).

So, before I get into some of the value-add that I think my session includes; I'd like to cover some detail about relational database.

**ACID**

Relational is really about consistency of data. ACID guarantees are really what relational is all about–apart from it's ability to process relations and the data surrounding those relations. Consistency is the 'C' in ACID where 'A' is Atomicity, 'I' is Isolation, and 'D' is durability. Consistency is basically supported by Atomicity and Isolation; i.e. you can't get consistency without isolation and atomicity.

With relational, the consistency comes from the appearance that update operations are atomic. This means they either complete successfully or they don't complete at all and that appears as one operation—where a single operation can't be "interrupted" by another (as if the database performed a single operation at a time).

Update operations appear atomic because the operation is isolated from the rest of the system until that operation completes successfully. This ability of atomicity through isolation ensures application-level invariants can be guaranteed and data consistency can be achieved. For example, I could have an update operation that updates the quantity-in-stock of an item at the same time as creating an invoice line-item with the quantity sold of that same type of item. This is an application-level invariant where I can't sell something that isn't in stock. If I wrap the update operation that updates the quantity-in-stock and creates the line-item in an transaction correctly they I can be sure not to subtract or update quantity-in-stock with the number of sold items within a line-item while something else is updating that amount. Guaranteeing, at least at the database level, that my quantity-in-stock doesn't drop below zero based on some race condition.

Of course, in order to guarantee that, the database effectively makes quantity-in-stock unavailable for certain operations until my transaction completes because the database is in control of all access to data. This is one of the issues highly-distributed systems have a problem with. With a single database server, ensuring nothing accesses certain data until the transaction is complete is reasonably trivial. When you distribute that data across thousands of nodes at a global level; making sure that data isn't accessed out-of-turn on each one of those nodes becomes an extremely expensive operation.

Durability is the ability of the database to keep data consistent in light of failures. This is also important; but really isn't something that differentiates RDBMS' from other types of databases; so, I'm not going to get into any more detail with regard to durability.

In my next couple of posts I'll get into some of the relational data architecture smells that developers can look for to decide if relational or NoSQL is fits in certain scenarios.


