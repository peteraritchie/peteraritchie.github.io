---
layout: post
title: 'Comments in Markdown'
categories: ['Odds', 'Hacks', 'Markdown']
comments: true
excerpt: "Hacks for putting comments into markdown that won't appear when rendered."
tags: ['December 2017']
---
I was authoring some markdown the other day, and I wanted to make a note to myself about something I needed to return to later, when I came back to the document.  I thought to myself that this seems like a comment, something I don't want to see in the rendered markdown, just in the "source".

I think for the most part that this hack is likely renderer-specific (having no real standard around what rendering really does beyond visable HTML); but after some research and some trial and error; you can hack a comment into your markdown by using an un-referenced reference link.  Reference links have the format: `[link text][link-label]` that references a link label definition like `[link-label]: http://example.com`.  You may omit the link text and simply use the label: `[link text][link-label]` to reference a link, which would look like this: [link-label].  Labels may have spaces in them, so you can really have label that is the link text: `[link text]` and the link label definition: `[link text]: http://www.example.com` which would look like [link text].

Those link label defintions can appear anywhere in your markdown (as long as there's a blank line above it).  And, if you don't include the link references anywhere (e.g. `[link-label]`) then the what is in the link label definition is completely ignored (i.e. does not show up in the rendered HTML).  So, to add a comment to your markdown simply add an unused link label definition:

`[*]: # "TODO: Deal with this later"`

[link-label]: http://www.example.com
[link text]: http://www.example.com

[*]: # "TODO: Deal with this later"
[*]: # "this is my comment"

[1]: https://en.wikipedia.org/wiki/Message_passing
[comment]: # "the comment"

