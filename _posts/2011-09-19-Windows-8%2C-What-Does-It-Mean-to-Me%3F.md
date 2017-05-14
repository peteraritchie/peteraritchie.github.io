---
layout: post
title: Windows 8, What Does It Mean to Me?
date: 2011-09-18 20:00:00 -0400
categories: ['DevCenterPost', 'Software Development', 'Visual Studio 2011', 'Visual Studio vNext', 'Windows 8']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2011/09/19/windows-8-what-does-it-mean-to-me/ "Permalink to Windows 8, What Does It Mean to Me?")

# Windows 8, What Does It Mean to Me?

Well, unless you've been hiding under a rock, you've probably heard about Microsoft Build conference that happened in Anaheim last week.  It was during this conference that Microsoft finally released details about the successor to Windows 7.  This event is solely developer-focused and, in my opinion, tablet-specific.  It went into a lot of detail about the added APIs and usability changes in Windows 8 to better support tablet and touch-based computers.

First off, the new touch-first usability changes are called "Metro" and applications written for touch are called "Metro-style apps".

The term "touch-first" is used because it's not touch-only.  Metro will work fine with a mouse and a keyboard; but the user experience is obviously designed for a multi-touch device and that you can "get by" adequately with a mouse and a keyboard.  This was done for various reasons, one being that touch isn't good for entering reams of text and that you want to dock your tablet and use a keyboard and mouse when you want to do something that would be better served by a keyboard or a mouse.  e.g. tablet/touch-based UX is better for consuming information, whereas keyboard is better for producing information.

So, with all the focus was on tablet and touch, does that mean Windows 8 is all about Metro?  The focus of the conference was to show off (likely in answer to other vendors producing tablet-based hardware and systems) tablet- and touch-based user experiences.  In fact, paying attendees received a custom-made Samsung tablet computer with a version of Windows 8 (called Developer Preview) and the next version of Visual Studio (called Dev11, for now) pre-installed.  This puts the focus of Developer Preview almost solely on touch.  But, does this mean that mouse/keyboard was ignored or that we need a touch screen on our computers to be able to use Windows 8 when it is released?  No, of course not.  Discussing various things with numerous Softies, the message time and time again was that if something isn't mentioned, or doesn't have focus, that doesn't mean it won't exist in the release version or in the near future.  It was clear that this version of Windows 8 was produced strictly for this event, and since it was effectively deployed on tablet, it had a tablet edition of the OS.  I.e. if you by a desktop without a multi-touch monitor after Windows 8 comes out, the edition of Windows 8 that will be deployed will not likely have Metro on by default.  But, that's my opinion.

We now have Metro apps, and they're XAML-based and very similar to Silverlight.  You initialize the runtime slightly differently and do some other things slightly differently; but if you're a Silverlight developer you'll be right at home in Metro.  Does that mean all Windows 8 development is Metro?  Definitely not.  It's not C++ based and it is still managed code backed by the CLR (they shows using VB and C#; but F# support should be there for RTM).  The CLR backing Metro apps is the same CLR that backs "Desktop" apps written as WinForms (yes, they're still supporting _that_) traditional Silverlight, Console apps, Windows services apps, etc. etc. etc.

Does this mean Silverlight and .NET is dead?  Well, no; but you could interpret it that way.  Metro apps are driven by a new Windows API called WinRT—which is basically a object-oriented alternative for the Win32 API and removes blocking methods leaving, or replacing them with, asynchronous methods.  This and the CLR that backs it are inherent parts of Windows 8.  So, it's technically not it's own product and simply just another part of Windows.  So, you could say that .NET and Silverlight are just bits of Windows 8 and thus no longer exist as ".NET" and "Silverlight".  Just like Hydra or Terminal Services really doesn't exist any more because it's baked right into Windows.  But, that doesn't mean they don't exist in this new form.

Some discussion has occurred as to whether WinRT is truly CLI-compliant because it doesn't support all the types and methods that .NET does now.  This isn't true.  We had these same discussions when Silverlight and Windows Phone came out.  WinRT is just another "profile".  It has a subset .NET API.  Just like how Silverlight doesn't include classes like System.Windows.Forms.Form and Windows Phone doesn't include classes like System.Windows.Browser.HtmlDocument.  The depth of the .NET classes that are available to _WinRT_ developers is restricted, just restricted differently than Silverlight and Windows Phone.

Just how restricted is the WinRT profile?  Well, that remains to be seen at this point; but, from the looks of it it is minimally CLI compliant.  This means it doesn't include things like the reflection namespaces.  WinRT is, after all, for producing touch-based applications that may run on very minimal processors and hardware.

One thing of note, to finish, is that the theme of WinRT is _**asynchronous**_.  Anything that could take a noticeable amount of time ("blocking") is not available in the WinRT profile; so, get used to asynchronous programming.

