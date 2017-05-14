---
layout: post
title: “CONSIDER providing method Close(), in addition to the Dispose(), if close is standard terminology in the area” considered deprecated
date: 2014-09-07 20:00:00 -0400
categories: ['.NET 4.5', 'C#', 'Design/Coding Guidance']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2014/09/08/consider-providing-method-close-in-addition-to-the-dispose-if-close-is-standard-terminology-in-the-area-considered-deprecated/ "Permalink to “CONSIDER providing method Close(), in addition to the Dispose(), if close is standard terminology in the area” considered deprecated")

# “CONSIDER providing method Close(), in addition to the Dispose(), if close is standard terminology in the area” considered deprecated

### Post navigation

[← Previous][1] [Next →][2]

In Framework Design Guidelines there is a [guideline][3] "CONSIDER providing method Close(), in addition to the Dispose(), if close is standard terminology in the area".  Recently this guideline has been considered deprecated.  Teams at Microsoft have come to the conclusion that this is more confusing than helpful.

The guideline basically suggests that another method be added to disposable types where something like "Close" may make more sense for the particular interface and implement IDisposable explicitly.  For example:

This would mean that Dispose() can be called when using the `using` statement, but could not be used without first casting to IDisposable if you wanted to call Dispose directly (and thus make you prefer `Close`) as show on line 12 of the above example.  Now you can avoid doing the explicit implementation of IDisposable and not add a class-specific method that just calls through to Dispose.  For example:

When the Guidelines where first written .NET was in its infancy.  Dispose has become very ubiquitous in .NET and something that you figure out very early when developing in .NET.  I surmise that because IDisposable is used across the Framework to such a degree that anything that acts like Dispose but isn't named Dispose is not intuitive to programmers.

There should be a forthcoming blog post from the teams that better detail the impetus of the decision (i.e. the confusions) and the documentation at <http://msdn.microsoft.com/en-us/library/b1yfkh5e.aspx> should eventually be updated to reflect the change.

As you can see in the current reference source (<http://referencesource.microsoft.com/#System/net/System/Net/Sockets/Socket.cs#6331>), that Socket.Dispose is no longer implement explicitly.  Of course, Close still exists because removing that would be a breaking change.  New classes will not implement Dispose explicitly and will not have extraneous methods like `Close`.  But, `Close` is still very common and will never entirely be gone from the Framework.

This entry was posted in [.NET 4.5][4], [C#][5], [Design/Coding Guidance][6] by [PeterRitchie][7]. Bookmark the [permalink][8]. 

[1]: http://pr-blog.azurewebsites.net/2014/08/12/maslows-hammer/
[2]: http://pr-blog.azurewebsites.net/2015/02/17/seam-expansion/
[3]: http://msdn.microsoft.com/en-us/library/b1yfkh5e.aspx
[4]: http://pr-blog.azurewebsites.net/category/dotnet/net45/
[5]: http://pr-blog.azurewebsites.net/category/csharp/
[6]: http://pr-blog.azurewebsites.net/category/design-guidance/
[7]: http://pr-blog.azurewebsites.net/author/peterritchie/
[8]: http://pr-blog.azurewebsites.net/2014/09/08/consider-providing-method-close-in-addition-to-the-dispose-if-close-is-standard-terminology-in-the-area-considered-deprecated/ "Permalink to "

