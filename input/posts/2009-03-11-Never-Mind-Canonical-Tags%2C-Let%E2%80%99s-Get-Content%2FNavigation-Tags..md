---
layout: post
title: 'Never Mind Canonical Tags, Let’s Get Content/Navigation Tags.'
tags: ['Non-development', 'Pontification', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2009/03/11/never-mind-canonical-tags-let-s-get-content-navigation-tags/ "Permalink to Never Mind Canonical Tags, Let’s Get Content/Navigation Tags.")

# Never Mind Canonical Tags, Let’s Get Content/Navigation Tags.

<http://www.appscout.com/2009/02/google_microsoft_yahoo_create.php>describes that Microsoft, Yahoo, and Google have agreed on a "canonical tag". This tag basically allows a web site owner to tell search sites where the main page of a site is, regardless of the URL.

This is fine, but it only reduces duplicate results. It does nothing for incorrect results.

Google's algorithm bases its results on content and voting (either explicit or implict), among other things. The longer content is around the more accurate Google is with results. New links suffer from not having any of this meta data to help Google rank the content in the results.

Many sites include "content" and "navigation". Navigation deals with allowing the user to browse around the site or to other sites. One popular navigation technique is to use tags to group/link to other content. The way all the major search sites work is to simply index all the text on a site and hits to any of those keywords results in a match. This is obviously useful but it skews the results.

This becomes more apparent when you start using services like Google Alerts. Google Alerts sends you an email when a new page is found with keywords that match your criteria. A problem occurs with sites with navigational text where Google sends you notices of new pages on those sites even though the real content doesn't match your critera. For example, let's say I create a Google alert for managed-extensibility-framework in the hopes of getting notification of new pages that relate to MEF. This starts to fall apart with sites like devtopics.com where each and every page contains the text "Managed Extensibility Framework" as one of the sites tags. This means every new page on devtopics.com is included in the alerts regardless of whether that page really relates to MEF.

There was an up-and-coming search provider (that never made it) several years ago that did recognize a content/non-content tag that could provide more accurate results in these circumstances; but there isn't one that is recognized by any of the major search sites. I think it's about time that web site designers could inform search sites about what is and isn't content on their site.

The alternative is for web site designers to look at the user agent HTTP header field and present only content when the Google agent is looking at the site.


