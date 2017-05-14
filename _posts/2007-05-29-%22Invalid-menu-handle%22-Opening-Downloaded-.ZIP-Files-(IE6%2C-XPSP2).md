---
layout: post
title: "Invalid menu handle" Opening Downloaded .ZIP Files (IE6, XPSP2)
date:   2007-05-28 12:00:00 -0600
categories: ['Non-development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/05/29/quot-invalid-menu-handle-quot-opening-downloaded-zip-files-ie6-xpsp2/ "Permalink to "Invalid menu handle" Opening Downloaded .ZIP Files (IE6, XPSP2)")

# "Invalid menu handle" Opening Downloaded .ZIP Files (IE6, XPSP2)

I'm working on a new, least-privileges, computer and I ran into a very strange problem yesterday.  If I click on links to .ZIP files in IE and select Open,the file downloads but I'm presented with an "Invalid menu handle" message box.

I'm not the person who configured this computer; so, I wasn't entirely sure what the problem could be.  I had surmised that it had something to do with least-privileges and compressed (zipped) folders' ability to operate in that type of environment.  I tried Save, instead of Open, when clicking the link but had no problems double-clicking the zip file in Windows Explorer.

The computer is configured so some of the user files are stored on a network drive, so I then thought it had something to do with permissions on non-local drives (really least-privileges I guess); but the temporary Internet files are indeed stored on the local drive.

At this point, I was wandering around in the temporary Internet files directory and double-clicked the zip file, and this time it informed me that "This page has an unspecified potential security flaw."  With not much to go on, and the fact that I was having problems with *many* .ZIP files, I pressed Yes to continue.  Windows Explorer then asked me how to open the file–as if it hadn't associated compressed (zipped) folders with .ZIP files.  I was a bit dumbfounded, as that was my first course of action (to try double-clicking a .ZIP file in Windows Explorer and had no problems).  At this point I simply clicked compressed (zipped) folders and ensured "Always use the selected program…" was checked and pressed OK.  After that, I could then Open .ZIP files after clicking links to them in IE.

I'm not sure how the computer got into that state, or whether it was simply that directory (or the hierarchy it was in); but the problem is fixed.

If you run into the same problem, now you know what to do.

