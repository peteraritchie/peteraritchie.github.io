---
layout: post
title: 'IDisposable and Class Hierarchies'
tags: ['.NET Development', '.NET', 'C#', 'Design/Coding Guidance', 'DevCenterPost', 'Patterns', 'Software Development Guidance', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2013/01/21/idisposable-and-class-hierarchies/ "Permalink to IDisposable and Class Hierarchies")

# IDisposable and Class Hierarchies

In my [previous post][1], I showed how the Dispose Pattern is effectively obsolete. But, there's one area that I didn't really cover. What do you do when you want to create a class that implements IDisposable, doesn't implement the Dispose Pattern, **and** will be derived from classes that will also implement disposal?

The Dispose Pattern covered this by coincidence. Since something that derives from a class that implements the Dispose Pattern simply overrides the Dispose(bool) method, you effectively have a way to chain disposal from the sub to the base. There's a lot of unrelated chaff that comes along with Dispose Pattern if that's all you need. What if you want to design a base class that implements IDisposable and support sub classes that might want to dispose of managed resources? Well, you're not screwed.

You can simply make your IDisposable.Dispose method virtual and a sub can override it before calling the base. For example:
    
    
    	publicclassBase : IDisposable
    	{
    		privateIDisposable managedResource;
    		//...
    		virtualpublicvoid Dispose()
    		{
    			if(managedResource != null) managedResource.Dispose();
    		}
    	}
     
    	publicclassSub : Base
    	{
    		privateIDisposable managedResource;
    		publicoverridevoid Dispose()
    		{
    			if (managedResource != null) managedResource.Dispose();
    			base.Dispose();
    		}
    	}

If you don't implement a virtual Dispose and you don't implement the Dispose Pattern, you should** use the sealed modifier on your class** because you've effectively made it impossible for base class to dispose of both their resources and the base's resources in all circumstances. In the case of a variable declared as the base class type that holds an instance of a subclassed type (e.g. Base base = new Sub()) only the base Dispose will get invoked (all other cases, the sub Dispose will get called).

## Caveat

If you do have a base class that implements IDisposable and doesn't implement a virtual Dispose or implement the Dispose Pattern (e.g. outside of your control) then you're basically screwed in terms of inheritance. In this case, I would prefer composition over inheritance. The type that would have been the base simply becomes a member of the new class and is treated just like any other disposable member (dealt with in the IDisposable.Dispose implementation). For example:
    
    
    	publicclassBase : IDisposable
    	{
    		//...
    		publicvoid Dispose()
    		{
    			//...
    		}
    	}
     
    	publicclassSub : IDisposable
    	{
    		privateBase theBase;
    		//...
     
    		publicvoid Dispose()
    		{
    			theBase.Dispose();
    		}
    	}
    

This, of course, means you need to either mirror the interface that the previously-base-class provides, or provide a sub-set of wrapped functionality so the composed object can be used in the same ways it could have been had it been a base class.

This is why it's important to design consciously—you need to understand the ramifications and side-effects of certain design choices.

[1]: http://blogs.msmvps.com/blogs/peterritchie/archive/2013/01/20/the-dispose-pattern-as-an-anti-pattern.aspx


