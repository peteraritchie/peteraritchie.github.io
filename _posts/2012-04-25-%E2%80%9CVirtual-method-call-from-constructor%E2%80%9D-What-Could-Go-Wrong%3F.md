---
layout: post
title: “Virtual method call from constructor” What Could Go Wrong?
categories: ['.NET Development', 'C#', 'Code Analysis/FxCop Warning Resolutions', 'DevCenterPost', 'Software Development', 'Software Development Guidance', 'Visual Studio']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2012/04/25/virtual-method-call-from-constructor-what-could-go-wrong/ "Permalink to “Virtual method call from constructor” What Could Go Wrong?")

# “Virtual method call from constructor” What Could Go Wrong?

If you've used any sort of static analysis on source code you may have seen a message like "Virtual method call from constructor".  In FxCop/Visual-Studio-Code-Analysis it's CA2214 "Do not call overridable methods in constructors".  It's "syntactically correct"; some devs have said "what could go wrong with that".  I've seen this problem in so many places, I'm compelled to write this post.

I won't get into one of my many pet peeves about ignoring messages like that and not educating yourself about ticking time bombs and continuing in ignorant bliss; but, I will try to make it more clear and hopefully shine some light on this particular class of warnings that arguably should never have made it into object-oriented languages.

Let's have a look at a simple, but safe, example of virtual overrides:
    
    
    public class BaseClass {
    	public BaseClass() {
    	}
     
    	protected virtual void ChangeState() {
    		// do nothing in base **TODO: consider abstract**
    	}
     
    	public void DoSomething() {
    		ChangeState();
    	}
    }
     
    public class DerivedClass : BaseClass {
    	private int value = 42;
    	private readonly int seed = 13;
     
    	public DerivedClass() {
    	}
     
    	public int Value { get { return value; } }
     
    	protected override void ChangeState() {
    		value = new Random(seed).Next();
    	}
    }
    

With a unit test like this:
    
    
    [TestMethod]
    public void ChangeStateTest() {
    	DerivedClass target = new DerivedClass(13);
     
    	target.DoSomething();
    	Assert.AreEqual(1111907664, target.Value);
    }
    

A silly example that has a virtual method that is used within a public method of the base class.  Let's look at how we might evolve this code into something that causes a problem.

Let's say that given what we have now, we wanted our derived class to be "initialized" with what ChangeState does (naïvely: it's there, it does what we want, and we want to "reuse" it in the constructor); so, we modify BaseClass to do this:
    
    
    public class BaseClass {
    	public BaseClass() {
    		DoSomething();
    	}
     
    	protected virtual void ChangeState() {
    		// do nothing in base **TODO: consider abstract**
    	}
     
    	private void DoSomething() {
    		ChangeState();
    	}
    }
     
    public class DerivedClass : BaseClass {
    	private int value = 42;
    	private readonly int seed = 13;
     
    	public DerivedClass() {
    	}
     
    	public int Value { get { return value; } }
     
    	protected override void ChangeState() {
    		value = new Random(seed).Next();
    	}
    }

and we modify the tests to remove the call to DoSomething, as follows:
    
    
    [TestMethod]
    public void ConstructionTest() {
    	DerivedClass target = new DerivedClass();
     
    	Assert.AreEqual(1111907664, target.Value);
    }
    

…tests still pass, all is good.

But, now we want to refactor our derived class.  We realize that seed is really a constant and we can get rid of the value field if we use an auto property; so, we go ahead and modify BaseClass as follows:
    
    
    public class DerivedClass : BaseClass {
    	private const int seed = 13;
     
    	public DerivedClass() {
    		Value = 42;
    	}
     
    	public int Value { get; private set; }
     
    	protected override void ChangeState() {
    		Value = new Random(seed).Next();
    	}
    }

Looks good; but now we having a failing test: Assert.AreEqual failed. Expected:<1111907664>. Actual:<42>.

"Wait, what?" you might be thinking…

What's happening here is that field initializers are executed before the base class constructor is called which, in turn, is called before the derived class constructor body is executed.  Since we've effectively changed the initialization of the "field" (now a hidden backing field for the auto-prop) we've switched it from a field initializer to a line in the derived constructor body: trampling all over what the base class constructor did when calling the virtual method.  Similar things happen in other OO languages; but, this particular order might be different.

Now, imagine if we didn't have a unit test to catch this; you'd have to run the application through some set of specific scenarios to find this error.  Not so much fun.

Unfortunately, the only real solution to this is to not make virtual method calls from your base constructor.  One solution to this is to separate the invocation of ChangeState from the invocation of the constructor.  One way is basically reverting back to what we started with and adding a call to ChangeState in the same code that invokes the constructor.  Without reverting our refactoring, we can change BaseClass to what it was before and invoke the DoSomething method in the test, resulting in the following code:
    
    
    public class BaseClass {
    	public BaseClass() {
    	}
     
    	protected virtual void ChangeState() {
    		// do nothing in base **TODO: consider abstract**
    	}
     
    	public void DoSomething() {
    		ChangeState();
    	}
    }
     
    public class DerivedClass : BaseClass {
    	private const int seed = 13;
     
    	public DerivedClass() {
    		Value = 42;
    	}
     
    	public int Value { get; private set; }
     
    	protected override void ChangeState() {
    		Value = new Random(seed).Next();
    	}
    }
    
    
    [TestMethod]
    public void ChangeStateTest() {
    	DerivedClass target = new DerivedClass();
     
    	target.DoSomething();
    	Assert.AreEqual(1111907664, target.Value);
    }

Issues with virtual member invocations from a constructor are very subtle; if you're using Code Analysis, I recommend not disabling CA2214 and promoting it to and error.  Oh, and write unit tests so you can catch these things as quickly as possible.

