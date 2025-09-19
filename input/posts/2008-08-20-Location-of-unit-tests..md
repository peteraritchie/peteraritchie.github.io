---
layout: post
title: 'Location of unit tests.'
tags: ['.NET Development', 'Design/Coding Guidance', 'General', 'Pontification', 'TDD', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/08/20/location-of-unit-tests/ "Permalink to Location of unit tests.")

# Location of unit tests.

I had a short conversation at Alt.Net Canada about the location of unit tests. I personally tend towards a distinct unit test project. But, I deal with mostly commercial, off-the-shelf (COTS) projects where I simply can't ship code like that. I also don't want to wire-off the unit test via #if because I would then be shipping something different than that which was tested. 

From an enterprise application point of view, this is different. I would have no problem including the unit tests within their respective project as production code 


