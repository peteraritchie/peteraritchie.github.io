---
layout: post
title: 'The Dispose Pattern as an anti-pattern'
tags: ['.NET Development', 'AntiPattern', 'C#', 'Design/Coding Guidance', 'DevCenterPost', 'Software Development Guidance', 'msmvps', 'January 2013']
---
[Source](http://blogs.msmvps.com/peterritchie/2013/01/20/the-dispose-pattern-as-an-anti-pattern/ "Permalink to The Dispose Pattern as an anti-pattern")

# The Dispose Pattern as an anti-pattern

When .NET first came out, the framework only had abstractions for what seemed like a handful of Windows features. Developers were required to write their own abstractions around the Windows features that did not have abstractions. Working with these features required you to work with unmanaged resources in many instances. Unmanaged resources, as the name suggests, are not managed in any way by the .NET Framework. If you don't free those unmanaged resources when you're done with them, they'll leak. Unmanaged resources need attention and they need it differently from managed resources. Managed resources, by definition, are managed by the .NET Framework and their resources will be freed automatically a great proportion of the time when they're no longer in use. The Garbage Collector (GC) knows (or is "told") what objects are in use and what objects are not in use.

The GC frees managed resources when it gets its timeslice(s) to tidy up memory—which will be some time *after* the resource stop being used. The IDisposable interface was created so that managed resources can be deterministically freed. I say "managed resources" because interfaces can do nothing with destructors and thus the interface inherently can't do anything specifically to help with unmanaged resources.

"Unmanaged resources" generally means dealing with a handle and freeing that handle when no longer in use. "Support" for Windows features in .NET abstractions generally involved freeing those handles when not in use. Much like managed resources, to deterministically free them you had to implement IDisposable and free them in the call to Dispose. The problem with this was if you forgot to wrap the object in a using block or otherwise didn't call Dispose. The managed resources would be detected as being unused (unreferenced) and be freed automatically at the next collection, unmanaged resources would not. Unmanaged resources would leak and could cause potential issues with Windows in various ways (handles are a finite resource, for one, so an application could "run out"). So, those unmanaged resources must be freed during finalization of the object (the automatic cleanup of the object during collection by the GC) had they not already been freed during dispose. Since finalization and Dispose are intrinsically linked, the Dispose Pattern was created to make this process easier and consistent.

I won't get into much detail about the Dispose Pattern, but what this means is that to implement the Dispose Pattern, you must implement a destructor that calls Dispose(bool) with a false argument. Destructors that do no work force an entry to be made in the finalize queue for each instance of that type. This forces the type to use its memory until the GC has a chance to collect and run finalizers. This impacts performance (needless finalization) as well as adds stress to the garbage collector (extra work, more things to keep track of, extra resources, etc.). [1] If you have no unmanaged resources to free, you have no reason to have a destructor and thus have no reason to implement the Dispose Pattern. Some might say it's handy "just in case"; but those cases are _really rare_.

.NET has evolved quite a bit from version 1.x, it how has rich support for many of the Windows features that people need to be able to use. Most of the type handles are hidden in these feature abstractions and the developer doesn't need to do anything special other than recognize a type implements IDisposable and deterministically call Dispose in some way. Of the features that didn't have abstractions, lower-level abstractions like SafeHandle (which SafeHandleZeroOrMinusOneIsInvalid and SafeHandleMinuesOneIsInvalid etc. derive from)—which implement IDisposable and makes every native handle a "managed resource"—means **there is very little reason to write a destructor**.

The most recent perpetuation of the anti-pattern is in a Resharper extension called [R2P][1] (refactoring to patterns). Let's analyze the example R2P IDisposable code:

![][2]

As we can see from this code, the Dispose pattern has been implemented and a destructor with a Dispose(false). If we look at Dispose(bool), **Dispose(bool) does nothing if a false argument is passed to it**. So, effectively we could simply remove Dispose(false) and get the same result. This also means we could completely remove the destructor. Now we're left with Dispose(true) in Dispose() and Dispose(bool). Since Dispose(bool) is now only ever called with a true argument, there's no reason to have this method. We can take the contents of the if(disposing) block, move it to Dispose (replacing the Dispose(true)) and have exactly the same result as before **without the Dispose Pattern**. Except now, we're reduced the stress on the GC *and* we've made our code much less complex. Also, since we no longer have a destructor there will be no finalizer, so there's no need to call SuppressFinalize. **Not implementing the Dispose Pattern would result in better code** in this case:
    
    
    	publicclassPerson : IDisposable
    	{
    		publicvoid Dispose()
    		{
    			Photo.Dispose();
    		}
     
    		publicBitmap Photo { get; set; }
    	}
    

Of course, when you're **deriving from a class that implements the Dispose Pattern** _and your class needs to dispose of managed resources_, then you need to make use of Dispose(bool). For example:
    
    
    	publicclassFantasicalControl : System.Windows.Forms.Control
    	{
    		protectedoverridevoid Dispose(bool disposing)
    		{
    			if(disposing)
    			{
    				Photo.Dispose();
    			}
    			base.Dispose(disposing);
    		}
    		publicBitmap Photo { get; set; }
    	}
    

Patterns are great, they help document code by providing consistent terminology and recognizable implementation (code). But, when they're not used in the right place at the right time, they make code confusing and harder to understand and become Anti-Patterns. 

[1] <http://bit.ly/YbBDAR>

[1]: http://blogs.jetbrains.com/dotnet/2013/01/r2p-a-general-purpose-resharper-plugin/
[2]: http://blogs.jetbrains.com/dotnet/wp-content/uploads/2012/12/71.png


