---
layout: post
title: 'Extra Features: One of the Lean 7 Wastes of Software'
tags: ['Lean', 'Software Development', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/08/18/extra-features-one-of-the-lean-7-wastes-of-software/ "Permalink to Extra Features: One of the Lean 7 Wastes of Software")

# Extra Features: One of the Lean 7 Wastes of Software

[Derik Whittaker][1] recently [blogged about how writing unused code is one of the Lean 7 Wastes of Software][2]. Mary Poppendieck calls this "Extra Features" and has a one-to-one association to overproduction in manufacturing. 

In Manufacturing it has different caveats: if you overproduce something you have to have somewhere to store it until its sold. What do you do when you don't have the space to store it? If you have the space, it's not too much of an issue; you just tuck it away; but you still need people to move it, manage the space, manage the responsibilities around moving/storage, etc. etc. 

With Lean Software, there is still technically a storage issue (VCS, disk space, etc.). The real issue with extra features is that no one is using them. In the best case this means you're consuming expensive resources that aren't directly increasing revenue. Worst case you're also impacting the usability (and thus the sell-ability) of the software. If the extra features are something that the vendor hopes to be used in the future; then you've increased the time between implementation and fixing bugs. Unit testing aside, when customers log bugs against the software regarding something implement 6 months ago, you've increased the cost of fixing the bug exponentially as time goes on. This is the philosophy behind TDD, that unit tests find bugs as soon as possible (~build time, depending you your setup). 

From an Agile standpoint, extra features mean you're giving the user something they didn't want. This means you're not listening to your customer and don't have a relationship built on communication. In Agile, it's a tenet to build prototype code based ideas you've inferred from communication with the customer. This isn't extra features, this is the feedback process. It's fine to propose a feature to the user in the form of a prototype; but if they don't want it, it doesn't go into the release. 

Extra features is technical debt that you'll have to pay for eventually.

[1]: http://devlicio.us/blogs/derik_whittaker/default.aspx
[2]: http://devlicio.us/blogs/derik_whittaker/archive/2008/08/06/unused-code-is-the-worst-of-the-7-wastes-of-software.aspx


