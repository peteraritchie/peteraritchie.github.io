---
layout: post
title: ' Data URLs in Markdown'
categories: ['Workplace']
comments: true
excerpt: "Data URLs embed data within the URI instead of being a link. Data URLs can be used to embed images into a web page. Data URLs can be used for images in markdown."
tags: ['Markdown', 'Tips & Tricks']
---

- Data URLs embed data within the URI instead of being a link
- Data URLs can be used to embed images into a web page
- Data URLs can be used for images in markdown

[TL;DR](#data-urls)&#x2bb7;

## Background

### Links in Markdown

URLs can be used in markdown as a hyper-link to another location (another page, or an anchor in the current page, or both.) These links in markdown come in two varieties: "conventional" and reference-style.  Conventional links have the format `[text](url)`.

Reference-style links have a two-part format.  The first is the reference declaration which consists of a name and the URL.  For example:

```markdown
[twitter]: https://twitter.com/peterritchie
```

Typically the reference declarations appear at the end of the markdown file.

That second-part of the format is slightly different than a conventional link: `[Visible Text][reference-name]` (notice that both parts are enclosed in square brackets)

For example: `[Me@Twitter][twitter]`.  Which would result in [Me@Twitter][twitter].

That reference can be used any number of times within markdown by referencing the reference name.

### Images in Markdown

An image in markdown is a special kind of link; it follows the same format as other links *except* that it starts with an exclamation mark (!) and has an optional title-text enclosed in quotes.  For example `![alt-text](url "title-text")`.  Since the image is what is visible, the title text portion of the link is text shown when hovering over the image and the alternative text is used by accessibility features.

## Data URLs

There exists the ability to encode content within a URL (so the URL is actually the "response" in the conventional URI request scenario).  [Data URLs][data-urls] (Formally known as Data *URIs*) use the `data:` URI schema followed by an optional media type, an optional base64 extension (`;base64`) followed by data (if the `base64` extension is used the data is binary and is base-64 encoded).

For example, with binary data for a red dot png a data URL may look like this:

```
data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==
```

### Images, Data Urls, and Reference-Style Markdown Links

Data URLs may be used in markdown image links. With image markdown format and a data URL:

```text
![a red dot](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==)
```

... and result in: ![a red dot](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg== "The Image")

...or with title text:

```text
![a red dot](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg== "The Image")
```

... and result in: ![a red dot](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg== "The Image")

Or, with a reference-style image link:

```markdown
![a red dot][red-dot]

[red-dot]: data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==
```

... and result in: ![a red dot][red-dot]

Data URLs are a handy way to reduce the number of files involved in a page.  Like any feature, that can get ridiculous so the value comes when working with small chunks of data (like a red dot image.)

## References

[Data URLs][data-urls]

[Data URI Scheme (wikipedia)][wikipedia]

[data-urls]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URLs

[wikipedia]: https://en.wikipedia.org/wiki/Data_URI_scheme

[twitter]: https://twitter.com/peterritchie

[red-dot]: data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==
