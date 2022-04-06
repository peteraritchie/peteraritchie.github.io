---
layout: post
title: 'Disabled Browser Copy-to-Clipboard: WTF?'
categories: ['Life Hacks']
comments: true
excerpt: "Re-enable copy-to clipboard on those annoying websites!"
tags: ['February 2019']
---
Seriously, web sites that disable copy-to-clipboard?  What do they think they are protecting?  It's very annoying.

The way they actually do that is to override the default `oncopy` event handler. But, you know what?  With browsers (at least Chrome), 
you can actually modify the document in real-time and remove that new handler.  Better yet, you can create a 
bookmarklet on your bookmark bar and re-enable copy-to-clipboard any time you want.  Just drag the following 
link to your browser bar and drop: 
<a href="javascript: (function () { document.oncopy = null;})();">javascript: (function () { document.oncopy = null;})();</a>
That creates a button with all that javascript in the name; if you prefer a simpler, 
icon-looking button, drag and drop this fist (fight the power) to accomplish the same thing
<a href="javascript: (function () { document.oncopy = null;})();">&#x270a;</a>

Now when you get one of those websites, click that bookmarklet and copy to clipboard All. You. Want.

If you have any similar tips and tricks, please share with a comment!
