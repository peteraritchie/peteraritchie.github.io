---
layout: post
title: The case of the not-so-useful XBF error
categories: ['.NET Development', 'C#', 'Windows Store', 'XAML']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2014/03/23/the-case-of-the-not-so-useful-xbf-error/ "Permalink to The case of the not-so-useful XBF error")

# The case of the not-so-useful XBF error

Recently I was working on another Windows Store app. I wanted to move some text to resources so I didn't have the text in the controls and wanted to re-use text from control-to-control and from page-to-page.

I went to the XAML file that I wanted to add the test to and (after creating a Resource element) started typing in a String element.  I use Resharper, so I was presented with this:

![xbf][1]

Which allows me to import the System.String type by adding a xmlns:system="using:System" attribute and value to the root element of the file (by simply typing Alt+Enter).  Of course, I _do_ want a string, so System.String seems exactly what I want, so I let Resharper add the reference and change the <String> to <system:String> and I continue to add the text I want.  Something like this:

Sometime later, when I compile the app and try to test it, I'm presented with a vague error:

…somefile.xaml(15,24): XamlCompiler error WMC0610: Syntax Error found in XBF generation

Not telling me what was actually wrong and no squiggles in the editor, the only thing I could think to do at the time was remove the line entirely and move on.

Sometime later, I looked into a bit more, comparing working files with what was giving me errors.  I noticed that the working files looked like this:

Note that the namespaces is x and not System?!  It turns out there's another String type in the http://schemas.microsoft.com/winfx/2006/xaml namespace.  Very subtle!  So, in order to fix the nebulous error, I simply had to use x:String instead of System:String!

[1]: http://pr-blog.azurewebsites.net/wp-content/uploads/2014/03/xbf_thumb.png "xbf"

