---
layout: post
title: Data virtualization in Windows Phone 7.1 (or Why INotifyCollectionChanged is fundamentally broken)
redirect_from: "/2013/12/07/data-virtualization-in-windows-phone-7-1-or-why-inotifycollectionchanged-is-fundamentally-broken/"
date:   2013-12-06 19:00:00 -0500
categories: ['C#', 'Software Development Guidance', 'Visual Studio 2010', 'Windows Phone', 'Windows Phone 7.1']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2013/12/07/data-virtualization-in-windows-phone-7-1-or-why-inotifycollectionchanged-is-fundamentally-broken/ "Permalink to Data virtualization in Windows Phone 7.1 (or Why INotifyCollectionChanged is fundamentally broken)")

# Data virtualization in Windows Phone 7.1 (or Why INotifyCollectionChanged is fundamentally broken)


| ----- |
| ![][1] |  I'm no stranger to data and UI virtualization. I've done a lot of work with UIs that model a much larger set of data—as set of data that couldn't possibly fit in memory or the details of which weren't yet available to display.  This was in WinForms and Win32—and it was fairly straight forward.  I'm not going to detail how easy that was via examples, but will concede welcome that XAML should be *different* to how it _used to be done_.  This isn't a _get off my lawn_ moment, or _who moved by cheese_ moment. | 

One caveat/disclosure: I started this on Windows Phone 7.x and have yet to implement this in any other XAML framework.  I've researched some of the same areas in other XAML frameworks but can't *really* confirm the same issues really do exist on the other XAML frameworks (yet) despite no significant observed design/implementation differences between the frameworks in certain areas.

## What is data virtualization and why am I doing it?

First, some context: data virtualization is the practice of making a data set act smaller that it really is.  For example, I may have a data set that is 10000 elements but I may have a UI that can only have 10-25 visible at a time.  There's not good reason to have to retrieve and store 10000 elements in this scenario.  We would like to tell and item control the maximum number of items but provide only some of those items on demand.  Sometimes this is referred to as "paging".  I felt this was important to start with because of the complete lack of information about how this can be done successfully on Windows Phone 7.1 (I assume it's similar on 8; but have to confirm—and expect the "best practice" to be different than 7.1 [e.g. LongListSelector instead of ListBox] but also expect lack of information because I didn't find anything trying to implement it in 7.1).

Why do I feel this is important?  Well, Windows Phone is a very scaled-down platform.  7.1 supports only a single processor and 8 supports as little as 512 MB of memory.  Resource usage needs to be very calculated and usage needs to take the principle of little-as-possible.  Certification requirements are such that responsiveness factors into whether your app can even be allowed into the Store.  "Out of the box" and the overwhelming documentation on items controls are the use of collections that implement IEnumerable—which means the items control will enumerate every single item in the collection before it even displays anything on the screen.  With a sufficiently large data set, this could take a noticeable amount of time and have your app fail certification.  Given there's no physical limit to the number of elements an IEnumerable can enumerate, you would think data virtualization would be front-and-centre with Windows Phone and that work would be required to avoid data virtualization.  Alas, that's not the case.

There are examples of "data virtualization" out there and at first blush it's not really that complicated.  You really just have to implement IList (but *only* IList) and "virtualization" is magically supported.  ListBox and other items controls detail that "UI and data virtualization" are supported, but don't do enough to detail where and how.  In fact there seems to be conflicting information like "[Currently, no WPF controls offer built-in support for data virtualization.][2]" and "[[LongListSelector] supports full data and UI virtualization][3]".  But, the examples are pedantic to the point of being irresponsible.

## First, what to avoid

I think it's important to start with why INotifyCollectionChanged is fundamentally broken so you don't go down the same rat hole I did (despite the fact that I effectively succeeded—I'm sure others have not).  When you think of data virtualization you probably think that at least chunks of data will be retrieved after an items control is displayed and that retrieving that data will be non-trivial and something you should avoid doing on the UI thread.  (**the only examples of "data virtualization" I could find don't make this assumption and do all the work on the UI thread**).  Once you think that your data retrieval will be asynchronous and that you're providing chunks of data at a time ("paging") then you quickly realize that the best way to do this is with data binding and "observable collections".  I quote "observable collections" because ObservableCollection<T> implements Collection<T> and thus doesn't support the "data virtualization" that Windows Phone 7 supports (i.e. it will be enumerated from beginning to end before it is displayed destroying memory usage and responsiveness).  As I said, I encountered this on Windows Phone, but there are also problems with INotifyCollectionChanged in WPF—see the references at the end for more details.

## Implementing data virtualization

This leaves you with implementing INotifyCollectionChanged to support data virtualization.  This unfortunately is a minefield of poor design and Liskov Substitution Principle (LSP) violations.  To support data virtualization you also must implement IList.  IList _derives_ from IEnumerable so you have to implement the IEnumerable members but they shouldn't be used and thus you don't have to implement them (i.e. throw NotImplementedException and violate LSP).  The important IList members to implement are IndexOf and the indexer (this[int index]).  For example:

Of course, the control does not know the data source is off getting a page-worth of data, so it's going to continue on calling the indexer asking for more items to display after the first item in a page—so you have to keep track of what's currently being requested and to not ask for that page again (see sample below).  If you want to abstract the retrieval of the data from the data source, you can use a delegate that will be called to get a page.  While the real data is being retrieved, it's useful to display a place holder—which would likely also be best being decoupled from the data source (e.g. a delegate).  And, I'm choosing the implement the storage of the retrieved data in a dictionary.  For example:

To notify the bound control of after-the-fact changes (e.g. new chunks or pages of data that have  been retrieved after the control's initial display) you need to deal with INotifyCollectionChanged.CollectionChanged and the poorly designed NotifyCollectionChangedEventArgs class.  NotifyCollectionChangedEventArgs supports four types of collection changed actions: Replace, Reset, Remove, and Add; but the class does not provide an interface that guides your towards success or follow the principle of least astonishment.  For example, it has three constructors, all of which take an action type; but two of the constructors **only accept** **one NotifyCollectionChangedAction value** and run-time and the other **only accepts two** (far from intuitive and not an interface the guides you towards success).

To reiterate: what we're trying to achieve here is a "fixed size" collection whose data is retrieved over time, on demand, in chunks.  You could also have a data virtualization scenarios where the end count of elements wasn't known; but I find modeling this in UIs to be cumbersome and prone to problems—so, I avoid it.

Silverlight for Windows Phone supports only notification of changes to single items in the collection.  If you're getting "pages" of data, you have to tell the control about each individual item at a time (or twice, as the case may be).  Despite NotifyCollectionChangedAction.NewItems and OldItems being of type IList and there being a NewStartingIndex _and_ OldStartingIndex properties, they are read-only properties and there is no way to construct a NotifyCollectionChangedAction object with anything but a single OldItem, NewItem or any way to initialize NewStartingIndex _and_ OldStartingIndex in any single particular instance.

So, with the mindset that we're going to get data and notify the control that data has been retrieved you'd think that we'd perform that notification under the guise of "replacing" the data (i.e. we've told the control we have a fixed size data set and that we now have data for an arbitrary item, "replacing" what it had before).  But, for the life of me, I could not get a ListBox to do anything but throw exceptions when using NotifyCollectionChangedAction.Replace.  I tried using Reset whenever new data was available, but unsurprisingly that cause the ListBox to scroll back up to the top.  The **only way I could get it to work** was to perform two notifications **Remove then Add**.  For example:

Fortunately the easy part is the XAML, you can use the built-in ListBox type with tried-and-true data templates:

So, a quick recipe for implementing data virtualization in Windows Phone 7.1:

1. Use built-in items containers like ListBox.
2. Don't use ObservableCollection<T>, implement IList and INotifyCollectionChanged.
3. Don't use NotifyCollectionChangedAction.Replace in your CollectionChanged event invocator, use NotifyCollectionChangedAction.Remove then Add.
4. Ensure your event invocator executes on the UI thread (not specific to this recipe, but good to keep in mind).

For complete source and a working VS 2010 solution, see <https://github.com/peteraritchie/WPVirtualizingDataTest>

Other references RE NotifyCollectionChangedEventArgs:

[1]: http://hypnosthlm.se/wordpress/wp-content/uploads/2012/01/berg1.jpg
[2]: http://msdn.microsoft.com/en-us/library/cc716879(v=vs.110).aspx
[3]: http://msdn.microsoft.com/en-us/library/windowsphone/develop/microsoft.phone.controls.longlistselector(v=vs.105).aspx

