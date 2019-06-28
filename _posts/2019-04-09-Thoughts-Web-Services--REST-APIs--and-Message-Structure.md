---
layout: post
title: ""
date: 2019-04-02
categories: ['Standards', 'REST', 'Versioning']
comments: true
excerpt: ""
---
# Thoughts on Web Services, REST APIs, and Message Structure
## Part 1: HTTP
Love it or hate it, HTTP is ubiquitous.  It's been around for thirty years. 
It has evolved alot in those thirty years.  One critical way it has evolved is 
to support flexibility. Despite the huge benefits of that flexibility it can 
and has lead people away from recommended and expected usage and patterns. 

"No big deal", some say, but being lead away from recommended 
usage leads to re-discovery and re-invention and an evolutionary way of 
working (i.e. it's never right the first time).  This evolutionary process 
is a constraining process, each step must be based on the last and all that 
came before it.  That's great when you do have to invent something that never 
existed; but when a solution already exists, this process needlessly 
constrains progress sometimes to the point of missing the actual 
recommendation or expectation.

The flexibility of HTTP really means that people have to have a deep or broad 
knowledge of it to use it properly.  Take the `Accept` request header and 
media types. It allows a requestor to limit and rank the possible content 
format. We typically see this with at least XML and JSON nowadays.  To be 
clear this means Web APIs can have different formats of responses. The 
Content-Type header field means the inverse, that an API can accept multiple 
request content formats.  As flexible as this is, different content formats 
have at least some lack of parity of features.  As an example, XML has rich 
syntax that includes things like full featured consistent schema definitions. 
JSON is working towards things like that, but this is an example where the 
two have different semantic structure.  There are things that can be done to 
compensate, but at the end of the day neither was designed to work exactly like 
the other (that's kinda the point, isn't it?)  This is just one example where 
there's possibility of mismatch, mismatch in how two content formats can 
represent the same thing.

You may be thinking, *where am I going this with*?  Thanks for the segue. What 
this means is there will be times when you *change the structure or schema* of 
content (request or response) **because it's one type OR the other**.  Which 
leads me back towards media types.  If the schema of a JSON response 
changes but the XML doesn't, what does *versioning* of APIs mean?  Well, it 
means that because there are different formats of content is independently 
changing schemas **you cannot reliably the version an API by URI**.  You can't even use a general 
header field that applies to all content because a change to one could be 
breaking but unnecessary or non-breaking in the other.  Making versioning 
problematic at best.  This means you really **must use media type as the 
versioning mechanism**. ("MTATEOV": Media Type As The Engine of 
Versionability?)

But, if you've ignored media types and effectively ignored schemas and cause 
breaking changes because it just works and breaking changes have been 
tolerable.  Of course, being in this situation and let the flexibility 
herd you into this corner.  But, it really is fairly easy also ends up 
solving these issues as well as open up some opportunities like Web Linking to 
content type and version! Let's have a look at the standard format of the media type.  

Media types consist of a *type* and a *subtype*, separated by a forward slash.  
For example "application/xml", "application/json".  The subtype is further 
structured in a tree that provides many options.  There are standards subtypes 
that are fixed or *standard" like "text/html" and "image/png" which specify a 
standard format.  The standards subtypes typically fall under types like 
"text", "image", etc.

There can be application-specific subtypes and those fall under the 
"application" type.  There is a bit of inconsistency in media types, like 
JSON is "application/json" and XML is "text/xml" despite the two content 
formats having standard structure and semantics.  But, I'll focus on 
application-specific structures because you should only need to version 
application-specific structures.

Despite application-specific, the application-specific parts can be built off 
of those standard content structures like XML and JSON to create a custom 
subset schema (so to speak).  Media type standard supports that including a 
suffix and parameters to the subtype.  The subtype format is essentially 
`subtype["+" suffix] [*";" parameter]` or "subtype" followed by an optional 
suffix separated by "+" followed by one or more parameters separated by ";".  
And each parameter may have an optional value separated by "=".
So, I could specify that I have HTML text encoding as UTF-8 as 
"text/html; charset=UTF-8" or I could specific an application-specific format 
(like "gibberish") that is based on XML like this "application/gibberish+xml".

In order to avoid name clashes with other vendors, these media types are 
expected to be in the Vendor Tree where standards types fall under the root or 
Standards Tree.  Trees are specified with a prefix to the subtype, making 
the standard structure of a subtype like this 
`[tree "."] subtype["+" suffix] [*";" parameter]`.  *tree* as the 
structure of `tree *["." subtree]` meaning there can be many trees separated 
by ".".  The standard details that the Vendor Tree starts with the "vnd." 
prefix.  So, our custom type should really have the form 
"application/vnd.pri.gibberish+xml", where "pri" is a vendor-specific name or 
identifier.  Or if JSON format is required: "application/vnd.pri.gibberish+xml".

Now that we know about custom, vendor application-specific type identifiers, 
on to dealing with changes to that content format that may introduce breaking 
changes, or *versioning*.  Since we're dealing with vendor and application-
specific identifiers within *subtype* we deviate into an area not covered 
specifically by a standard.  And you're basically free to do anything you want 
to specify the version, some have a format like 
"application/vnd.pri.gibberish.v2+xml".  Some use a subtype parameter like 
"application/vnd.pri.gibberish+xml;v=2" or 
"application/vnd.pri.gibberish+xml;version=2".  Since what lead us on 
this particular journey was the problem of diverging versions between 
underlying structures, the parameter route makes more sense because the 
version really applies, in that case, to the content with an underlying 
structure.  And being a parameter after the prefix, it's less like a version 
of the subtype. e.g. "application/vnd.pri.gibberish.v2+xml" could be 
interpreted as gibberish version 2 with an underlying XML structure.  But 
"application/vnd.pri.gibberish+xml;v=2" is easier to interpret as 
gibberish+xml version 2.

Side note: In the versions I've shown here I've not used a minor version 
(like 2.1).  I did that on purpose based on SEMVER that stipulates major 
version number increment to signify breaking changes.  Non-breaking changes 
in content is achieved with optional values, so client requestors that 
don't know the new optional values won't use them and thus minor version 
doesn't matter.  Also, if new optional values appear in a response, the 
requester shouldn't care either.  You can structure your schema to make such 
that a requestor need to care about it, but that is a breaking change and a 
major version increment, not a minor version increment.