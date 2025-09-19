---
layout: post
title: 'Generating Windows Phone and Windows Store application images–the vector version'
tags: ['.NET Development', '.NET', 'Software Development', 'Windows Phone 8.0', 'Windows Store', 'msmvps']
---
[Source](http://pr-blog.azurewebsites.net/2014/02/24/generating-windows-phone-and-windows-store-application-imagesthe-vector-version/ "Permalink to Generating Windows Phone and Windows Store application images–the vector version")

# Generating Windows Phone and Windows Store application images–the vector version

In a prior [post][1] I detail how you can generate the bitmaps required for both Windows Store and Windows Phone app submissions by scripting the resizing a single source bitmap.

As Andrew Duthie ([@devhammer][2]) quite righly pointed out, scaling a vector image would provide better fidelity in the final scaled bitmaps. Andrew gave an example of using Inkscape (both free and open-sourced) as a vector image editor.

I knew vector images are, of course, better for scaling; but I had never really gotten into using vector images. Andrew's response was the motivation I needed to get into it.

[Inkscape][3] (also available on Chocolatey as Inkscape ) is fairly easy to use, and there are lots of open vector images to base a new image from. But, I won't get into to many details of using Inkscape. Inkscape _does_ provide an ability to script it (via batch files or PowerScript) in terms of exporting to a bitmap file. So, we can expand what I posted before to automate the generation of application bitmaps for both Windows Store and Windows Phone from a vector image source to generate better looking application bitmaps.

The Inkscape.exe supports many command-line options, the one we're interested in is export-png. This command exports the vector image (SVG in my examples) to a PNG file. There's a bit of prep-work involved to be to do this easily and reliably. For the images we're interested in, for the most part they are square. So, we can set the properties of the Inkscape document to have equal page width and height (File/Document Properties). It really doesn't matter what width you pick with vector images; but I used 5 in by 5 in because of the default scaling—which made it visually easy to work with. You can then create the vector image within the page rectangle (centred, or however you need it) and save your image (SVG in my examples). Once saved you can use the export-png command to export to png.

I could not find a way to export to non-square bitmaps without skewing the image and making it look horrible, so I used ImageMagick again to post-process the generated PNG to change the canvas width or height (in the same way I did in the prior post).

So, to create Windows Store images from a single vector image, I used this:

In my case, I'm basing my images from a source SVG file named CumulusNotes.svg.

To create Windows Phone images from a single vector image, I used this:

Both of which presume that both ImageMagick and Inkscape are in your path.

If you feel like doing the same in a PowerScript, feel free to post a comment so other can benefit.

[1]: http://bitly.com/1k110wt
[2]: https://twitter.com/devhammer
[3]: http://bitly.com/1k3WH6U


