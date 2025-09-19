---
layout: post
title: 'Generating Windows Phone and Windows Store application images'
tags: ['.NET Development', '.NET', 'Software Development', 'Windows Phone 8.0', 'Windows Store', 'msmvps']
disqus_id: "1301 http://blog.peterritchie.com/?p=1301"
---
[Source](http://pr-blog.azurewebsites.net/2014/02/05/generating-windows-phone-and-windows-store-application-images/ "Permalink to Generating Windows Phone and Windows Store application images")

# Generating Windows Phone and Windows Store application images

One thing that you have to get your head around when you get started with Windows Phone or Windows Store development are all the icons you need to have in order to submit an app. Windows Phone 8 needs about 6 icons, depending on the tiles you support and Windows Store needs at least 4 (ApplicationIcon, FlipCycleTileLarge, FlipCycleTileMedium, FlipCycleTileSmall, IconicTileSmall, and IconicTileMediumLarge) depending on what scaling (resolutions) you want to support and whether you want more logos to display in the store.

You could, of course, have a completely different picture for each of these images; but there are many cases where these images are just a scaled version of one picture. After a couple of app submissions, you quickly grow tired of having to create all these images—even if you're just scaling one picture down to different dimensions. I certainly did, so I decided to automate the process.

I found that from a Windows Store/Phone aspect the highest common denominator is 300×300, so I create a 300×300 base image and scale it down to the various sizes that are required. After resounding feedback on Twitter that ImageMagick is the way to go for command-line image manipulation, I settled on using ImageMagick to scale the images. ImageMagick has a convert command (executable) to do various things including resizing. 

## Windows Store

To scale down my base image I simply use the resize option and scale down to the various dimensions (50×50, 30×30, 150×150, and 620×300):

With the 620×300 image I don't want to scale the image to fill the entire space, I just want to take the image and scale it up to 300×300 (or not, since I'm using a 300×300 base image) and centre it in a 620×300 image leaving the unused space transparent. this is where xc:transparent +swap –gravity center –composite comes from. xc:transparent +swap to make a 620×300 background image, and –gravity center –composite to overlay the source image on top of the background.

For more details on the options for Windows Store logos, check out [http://msdn.microsoft.com/en-us/library/windows/apps/hh846296.aspx][1]

## Windows Phone 8

And it's much the same with Windows Phone 8, with more non-square icons.

I haven't detailed anything on the Windows Phone 7.x side of things since this seems to be fairly unsupported at multiple levels. If there's interest, I can detail that as well.

[1]: http://bitly.com/1bltGeu "http://msdn.microsoft.com/en-us/library/windows/apps/hh846296.aspx"


