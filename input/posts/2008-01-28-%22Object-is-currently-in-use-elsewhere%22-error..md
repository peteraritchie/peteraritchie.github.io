---
layout: post
title: '"Object is currently in use elsewhere" error.'
tags: ['.NET Development', 'C#', 'DevCenterPost', 'WinForms', 'msmvps', 'January 2008']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/01/28/quot-object-is-currently-in-use-elsewhere-quot-error/ "Permalink to "Object is currently in use elsewhere" error.")

# "Object is currently in use elsewhere" error.

I was debugging what I thought was a strange exception the other day. The exception was an InvalidOperationException and the message was "Object is currently in use elsewhere". Unless you're familiar with this exception, it really doesn't offer much as to why the exception is occurring. There seems to be several stale threads on the Web about this issue, so I'd thought I'd post about it.

As it turns out it had to do with some code that was PInvoking some native graphics functions and the interaction with the WinForm that was hosting the drawing surface was to blame.

What's really happening with "Object is currently in use elsewhere" is that GDI+ is complaining that the device context (DC)that it is trying to use is already "in use". With WinForms, this generally means there is a recursive Graphics.GetHdc occurring. GetHdc must match a ReleaseHdc before any other GetHdc. Recursive means you have something like GetHdc->GetHdc->ReleaseHdc->ReleaseHdc, instead of GetHdc->ReleaseHdc->GetHdc->ReleaseHdc. Another possibility is that there is a missing call toReleaseHdc. (i.e. GetHdc->GetHdc->ReleaseHdc)

Now, in my case there was some seemingly innocuous code like this:

  

 SafeNativeMethods.DrawSomeStuff(e.Graphics.GetHdc(), parameters);

  

 e.Graphics.DrawString(text, this.Font, Brushes.Black, point);

…no matching ReleaseHdc(), before the DrawString call.

The fix turned out to be really simple:

  

  

 try

 {

  SafeNativeMethods.DrawSomeStuff(e.Graphics.GetHdc(), parameters);

 }

 finally

 {

 e.Graphics.ReleaseHdc();

 }

 e.Graphics.DrawString(text, this.Font, Brushes.Black, point);

You can also encounter this exception if you're drawing to a form from multiple threads. You'll likely also be encountering a cross-threading exception as well. The solution in this case is to not use multiple threads when accessing a form, including drawing.


