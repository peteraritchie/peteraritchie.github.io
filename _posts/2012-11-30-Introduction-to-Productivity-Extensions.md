---
layout: post
title:  "Introduction to Productivity Extensions"
redirect_from: "/2012/11/30/introduction-to-productivity-extensions/"
date:   2012-11-29 19:00:00 -0500
categories: ['.NET Development', 'C#', 'Open Source', 'Visual Studio 2010', 'Visual Studio 2012']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2012/11/30/introduction-to-productivity-extensions/ "Permalink to Introduction to Productivity Extensions")

# Introduction to Productivity Extensions

The .NET Framework has been around since 2002. There are many common classes and methods that have been around a long time. The Framework and the languages used to develop on it have evolved quite a bit since many of these classes and their methods came into existence. Existing classes and methods in the base class library (BCL) could be kept up to date with these technologies, but it's time consuming and potentially destabilizing to add or change methods after a library has been released and Microsoft generally avoids this unless there's a _really good_ reason.

Generics, for example, came along in the .Net 2.0 timeframe; so, many existing Framework subsystems never had the benefit of generics to make certain methods more strongly-typed. Many methods in the Framework take a `Type` parameter and return an`Object` of that `Type` but must be first cast in order for the object to be used as its requested type.`Attribute.GetCustomAttribute(Assembly, Type)` gets an `Attribute`-based class that has been added at the assembly level. For example, to get the copyright information of an assembly, you might do something like:
    
    
    var aca = (AssemblyCopyrightAttribute)Attribute.GetCustomAttribute(Assembly.GetExecutingAssembly(),
        typeof (AssemblyCopyrightAttribute));
    Trace.WriteLine(aca.Copyright);

Involving an `Assembly` instance, the `Attribute` class, the `typeof` operator, and a cast.

Another feature added after many of the existing APIs were released was _anonymous methods_.  Anonymous methods will capture outer variables to extend their lifetime so they will be available when the anonymous method is executed (presumably asynchronously to the code where the capture occurred).  There are many existing APIs that make the assumption that state can't be captured and it must be managed and passed in explicitly by the caller.  

For example:
    
    
      //...
      byte[] buffer = new byte[1024];
        fileStream.BeginRead(buffer, 0, buffer.Length, ReadCompleted, fileStream);
      //...
    
    private static void ReadCompleted(IAsyncResult ar)
    {
      FileStream fileStream = (FileStream) ar.AsyncState;
        fileStream.EndRead(ar);
        //...
    }

In this example we're re-using the stream (fileStream) for our state and passing as the state object in the last argument to `BeginRead`.

With anonymous methods, passing this state in often became unnecessary as the compiler would generate a state machine to manage any variables used within the anonymous method that were declared outside of the anonymous method. For example:
    
    
    fileStream.BeginRead(buffer, 0, buffer.Length, 
      delegate(IAsyncResult ar) { fileStream.EndRead(ar); },
        null);

Or, if you prefer the more recent lambda syntax:
    
    
    fileStream.BeginRead(buffer, 0, buffer.Length,
                        ar => fileStream.EndRead(ar),
                            null);

The compiler generates a state machine that captures fileStream so we don't have to.  But, since we're using methods designed prior to _out variable capturing_, we have to send `null `as the last parameter to tell the method we don't have any state that it needs to pass along. 

Microsoft has a policy of not changing shipped assemblies unless they have to (i.e. bug fixes).  This means that just because Generics or anonymous methods were released, they weren't going to go through all the existing classes/methods in already-shipped assemblies and add Generics support or APIs optimized for anonymous methods.  Unfortunately, this means many older APIs are harder to use then they need to be.

Enter Productivity Extensions.  When extension methods came along, I would create extension methods to "wrap" some of these methods in a way that was more convenient with current syntax or features.  As a result I had various extension methods lying around that did various things.  I decided to collect all those (and others), look at patterns and create a more comprehensive and centralized collection of extension methods—which I'm calling the Productivity Extensions.

One of those patterns is the Asynchronous Programming Model (APM) and the Begin* methods and their use of the state parameter.  Productivity Extensions provide a variety of overrides that simply leave this parameter off and call the original method with `null`.  For example:
    
    
    fileStream.BeginRead(buffer, 0, buffer.Length,
                        ar => fileStream.EndRead(ar));

In addition, overrides are provided to simply assume offset of 0 and a length that matches the array length.  So, using Productivity Extensions you could re-write our original call to BeginRead as:
    
    
    fileStream.BeginRead(buffer, ar => fileStream.EndRead(ar));

Productivity Extensions also include various extensions to make using older APIs that accept a Type argument and return an Object like Attribute.GetCustomAttribute to make use of Generics.  For example:
    
    
    var aca = Assembly.GetExecutingAssembly().GetCustomAttribute<AssemblyCopyrightAttribute>();

There's many other instances of these two patterns as well as many other extensions.  There's currently 650 methods extending over 400 classes in the .NET Framework.  This is completely open source at <http://bit.ly/RMOM0c> and available on NuGet (the ID is "ProductivityExtensions") with more information at <http://bit.ly/PDsKcs>.

I encourage you have a look and if you have any questions, drop me a line, add an issue on GitHub or add suggestions/issues on UserVoice at <http://bit.ly/SkupF9>.

