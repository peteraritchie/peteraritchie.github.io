---
layout: post
title: 'The Dreaded Re-write'
tags: ['Architecture', 'Design/Coding Guidance', 'Patterns', 'Software Development Guidance', 'Software Development Practices', 'msmvps']
---
[Source](http://pr-blog.azurewebsites.net/2015/02/22/the-dreaded-re-write/ "Permalink to The Dreaded Re-write")

# The Dreaded Re-write

There are lots of people who have arbitrarily said "never do a rewrite". Some have caveats like "unless you have to" (without criteria). Some have even called it the "single worst strategic mistake" a software team can make. Refactoring is great, but sometimes a product is in dire straitsand the existing behaviour is part of the problem and ignoring any problem in software is a huge mistake.

Software evolves over time, the initial design and architecture is based on what was known when the project started. If a software product lasts long enough, changes to, and additions to, functionality eventually mean the design and architecture are no longer sufficient. We have all sorts of great patterns and practices that allow us to create design and architectures that are able to accommodate changing requirements, but future-proofing software is worse than a total rewrite (i.e. designing something that is not based on actual requirements—designing on what _might be_). "Never do a rewrite" is a sign of a immature project team not capable of re-architecting to something better.

When software lives beyond the applicability of its design and architecture, software effectively goes on life-support. Working with software not designed to accommodate certain features means adding these features involves a lot of tweaking and hacking (keeping in mind, "fixing" something might entail adding features). Adding features becomes complex and error-prone. Adding features becomes harder and harder over time and the development team becomes less and less responsive. The amount of time tweaking and hacking required to support new features is directly proportional to the amount of time required to fix the bugs that are introduced by those tweaks and hacks. That's the nature of a tweak/hack. There will be times when it's all-hands-on-deck trying to fix newly introduced problems–and no real forward progress can be made on new features or otherwise.

Experienced software designers and architects ignore this "never re-write" distortion and instead recognize when a design/architecture is no long sufficient. It is then that they take action. But, rather than misleading absolutes like "never do a re-write" or superlatives like "single worst strategic mistake" (because all absolutes and superlatives have exceptions in software development: "never say never"), they begin a re-architecture whose end-goal is effectively a "re-write". This doesn't mean hide a _re-write_ by calling it _re-architecture_; let's look a some criteria to temper a _re-architecture_.

Writing software isn't an atomic operation; things happen while you're architecting/designing/writing and by the time something is complete the assumptions you had going in may be wrong. This is the fundamental premise of agile software teams: the ability to recognize that change and be able to accommodate for it. Re-design and re-architecture is the same way, you can't simply take a team of people and "go dark" and expect to come out at the end and be successful.

Redesigning and re-architecting needs to take into account the environment it is in, the environment that needs redesign, the environment that is effectively funding the redesign. Re-architecture needs to take into account that writing any code takes time (even if it's writing new code) and accept existing products will exist until a re-architecture is fully complete and will need attention during that time.

Re-architecture should not be considered a "total re-write" it should be viewed as an "eventual re-write". "total re-writes" are viewed as atomic—something that cannot be interrupted between the start and the completion. Re-architecture is a _phased re-write_. A sly architect will re-architect a system so that parts of the system may be redesigned and implemented independently of one another. There are many ways to approach this independence, all of which deal with abstraction. Even the simplest of maintainable software has abstractions.

A well componentized architecture facilitates the phased nature of re-architecture. But, we're talking about something with a sub-optimal architecture, aren't we? So, which abstractions do we use? In a simple inter-process architecture, such as:

![Deploy][1]

…we have typical _object seams_ where the typical OO data-hiding comes into play and we can vary our implementation details as we see fit—one component at a time. As I mentioned in my [previous post][2], the concept of seams allows us to define a logical API grouping as a seam. In much the same way object-orientated languages provide abstraction boundaries (well defined) we can define logical abstraction boundaries (in the form of logical API groupings) to create new seams by which we can organize and plan re-architecture. In our previous architecture, we can see a couple of logic abstractions that we can view as seams:

![Deploy process seams][3]

As we can see, we've recognized seams at the inter-process boundaries of the Server and the Service. This allows is to not only organize independent work bounded by component seams, but also allows us to organize independent work bounded by inter-process seams. If we maintain these seams over time, we can view the Server and the Service processes as implementation details that are free to evolve how they need to. These are fairly easy abstraction points, and probably ones that seem (no pun intended) obvious. You probably already work within constrictions like this.

With a sufficiently complex code, breaking work up on at these inter-process seams may still be a huge amount of work to bite off. In order to delineate work to a more manageable level, a re-architecture might take some interrelated classes and logically group them together to create a new component whose existing interaction with the rest of the current system is now defined as a seam. For example:

![inter-component seams][4]

This new "component" could be logical or it could be physical. The main point here is we are bounding work to a specific API subset that we can delineate as a seam. We can communicate and reason about this seam in the same way as any other abstraction. We define that seam API as immutable and therefore decouple the work (implementation detail) from the rest of the system down to the build/link level. Changes to anything in this seam will require a re-build but will not require and code changes outside of the seam.

This seam abstraction allows us to limit the side-effects of a change and better estimate the work involved. This allows to delineate work and assign tasks, as well as better gauge progress once started. The key to agile development is to better gauge and demonstrate progress—without that, the effort appears to "go dark" and success is doomed.

What logical abstractions you define and use seams is up to our project, the people on it, the requirements, and the timeframes involved. You should optimize use of seams to your team—don't assume you ca cleave off any subset of APIs and be successful.

Once all the implementation details behind a dependent seam are complete (implemented, tested, etc.) then the seams can be evolved (hopefully just a refactoring, but could be deeper). Obviously both logical sides of a seam should be re-architected before attempting to evolve the API defined by the seam—otherwise we break the decoupling we created when work started on the one side.

Typical abstraction patterns (adapters, model-view, facades, etc.) can facilitate decoupling the implementation detail of the re-design of one side of the seam from the now well-defined API. It may seem like architecture overkill, but when you come back later (and sometimes that's much later) to refactor the seam API if you focus your work within abstractions, you'll be much more efficient and sane.

Re-architecting portions of software is a very powerful way of decoupling parts of a system from others so that work can be undertaken independently. Using the concept of seams allows you to better define and delineate parts of a system whose architecture is insufficient and allows to improve it more efficiently and effectively, without an overwhelming amount of work.

[1]: http://pr-blog.azurewebsites.net/wp-content/uploads/2015/02/Deploy_thumb.png "Deploy"
[2]: http://blog.peterritchie.com/?p=2291
[3]: http://pr-blog.azurewebsites.net/wp-content/uploads/2015/02/Deployprocessseams_thumb.png "Deploy process seams"
[4]: http://pr-blog.azurewebsites.net/wp-content/uploads/2015/02/intercomponentseams_thumb.png "inter-component seams"


