---
layout: post
title: The case of the enigmatic error 0x89721200
date: 2014-02-01 19:00:00 -0500
categories: ['.NET Development', 'Software Development', 'Visaul Studio 2013', 'Windows Phone', 'Windows Phone 8.0']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2014/02/02/the-case-of-the-enigmatic-error-0x89721200/ "Permalink to The case of the enigmatic error 0x89721200")

# The case of the enigmatic error 0x89721200

I do Windows Phone development here and there in my spare time.  This consists of both Windows 7.x development and Windows 8 (hopefully Windows 8.x sometime soon ![Winking smile][1]).  I often go a few days between working on Windows Phone apps.  Today I got back into working on some Windows 8 apps (starting with a small fix to an app I have in the store.

Much to my annoyance when I tried to debug the app that I wanted to fix I got an error deploying and the only hint was error 0x89721200.  Out of the gate, working with _just_ a COM error (that's what I call 32-bit hex error codes) is a less than pleasant experience.  Having a closer look, where I would usually have the option of picking "Device" or "Emulator *", I only had "Start".  It had been a while, so I couldn't think of any one thing that could have been the culprit.  I had begun a port over to Windows 8, I had installed VS 2013 Update 1, I had installed Update 3 of Windows Phone 8 Emulators, etc. etc.

A quick internet search really didn't find much.  There were a couple of threads about SDK and Windows region language/location information and how that needed to be in sync; but all of that seemed to be in sync.  Which really left me with absolutely nothing to go on (the fact that someone could create/allocate an error code and **not document it or support it** being aside at the moment).  I had already done some work and deployed several Windows Phone 8 apps—so, I know my basic configuration was sound.  Without anything to do on and any for of instant support (posting to the same forums that didn't resolve other people's 0x89721200 didn't seem like a productive avenue), I knew one option was to simply re-pave Visual Studio and the related SDKs.

Not wanting to really re-pave, I decided I'd try a repair install of Visual Studio.  I don't think any repair install had really done me any good in the past, but it was free (free as in time, that I could spend getting a beer then coming back).  Well, unfortunately that didn't help—other than to re-align the electrons on the reboot.  I did have a beer now, to that was good; but unrelated.

Grasping at straws I decided I go look at any of the SDKs that were there and try repair install of those.  I started with a recent update I installed Windows Phone 8 Emulators Update 3…

## TL;DR

Well, low-and-behold, that actually fixed the problem—**repair install of Windows Phone 8 Emulators Update 3 got rid of my 0x89721200 errors!**  I cannot confirm that it was _only repair install of Windows Phone 8 Emulators Update 3_ as I first repair-installed Visual Studio 2013.  I also re-installed Visual Studio 2013 Update 1 and still did not get any 0x89721200 errors

If you find you're in the same boat I was, try that first.

[1]: http://pr-blog.azurewebsites.net/wp-content/uploads/2014/02/wlEmoticon-winkingsmile.png

