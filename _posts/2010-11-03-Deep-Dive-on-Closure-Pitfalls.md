---
layout: post
title: Deep Dive on Closure Pitfalls
categories: ['.NET 2.0', '.NET 3.5', '.NET 3.x', '.NET 4.0', '.NET Development', 'C#', 'C# 3.0', 'C# 4', 'Design/Coding Guidance', 'DevCenterPost', 'Software Development Guidance']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/11/03/deep-dive-on-closure-pitfals/ "Permalink to Deep Dive on Closure Pitfalls")

# Deep Dive on Closure Pitfalls

I've [blogged about closures in C# and their pitfalls][1] before.  I keep seeing problems with closures–more now that lambdas expressions and statements ("lambdas") are becoming more widespread–even with experienced developers. So, I'd thought i'd post about some of the details surrounding where the C# compiler generates closures in the hopes that people will recognize more where they write code that creates a closure and its context.

The C# language spec does not refer specifically to "closures", with regard to capturing state for anonymous methods (including lambdas)–it refers to "outer variables" and "captured outer variables".  The captured outer variables for a specific anonymous method are the "closure".

The compiler captures the state of variables within the local scope of the anonymous method in a compiler-generated class.  The compiler effectively also captures the declaration scope of the state within the closure.  If a variable is declared outside the local scope, that is echoed in the use of that closure.  If the variable is declared within the local scope, that is captured in use of the closure.  So, an anonymous method that uses state (a variable) declared outside the local scope of the anonymous method, the compiler will generate a closure use that closure so that variable is only instantiated once.  For example: 
    
    
    	ICollection<Func<string>> Funcs = new List<Func<string>>();   
    String[] texts = new String[] { "one", "two", "three" };  
    foreach (String text in texts)  
    {  
    		Funcs.Add(delegate { return text; });  
    	}  
    

We have an anonymous method used within the local scope of the body of the foreach loop.  The anonymous method uses the text variable declared outside the scope of the foreach loop.  The compiler generates a class to contain the state and the code that uses that state (i.e. the anonymous method)–otherwise the highlighted code–and make use of that generated class.  For example:
    
    
    	Closure closure = new Closure();  
    for (int i = 0; i < texts.Length; ++i)  
    {  
    closure.text = texts[i];  
    Funcs.Add(new Func<string>(closure.Func));  
    }  
    

The compiler-generated class may look something like this:
    
    
    	internal class Closure  
    {  
    public string text;  
    public string Func()  
    {  
    return text;  
    }  
    }  
    

The compiler instantiates that class outside the generated for loop (because there is no "foreach" loop in .NET IL–what we see here for generated code is a C# view of IL) to match the single declaration of the text variable (as the body of the foreach loop sees it).  So, as we can tell from this code, each of these Func delegates are accessing the same variable.  So, if we invoked each of those delegate, they would all return "three".  While the code _looks_ like each Func delegate is dealing with a different value ("one", then "two", then "three"); it's not and you've probably got a logic error with this code.

So, as I pointed out in a previous post, we get around the problem by bringing the value from the outer scope into the inner scope of the anonymous method.  For example:
    
    
    	foreach (String text in texts)  
    {  
    		var temp = text;  
    Funcs.Add(delegate { return temp; });  
    	}  
    

Now, the compiler needs to generate a class to model this local scope–or the highlighted code.  This local scope includes the creation of an object and assigning it a specific value.  So, what the compiler generates now would be similar to the following:
    
    
    	for (int i = 0; i < texts.Length; ++i)  
    {  
    Closure closure = new Closure();  
    closure.temp = texts[i];  
    Funcs.Add(new Func<string>(closure.Func));  
    }  
    

With a closure class similar to:
    
    
    	private class Closure  
    {  
    public string temp;  
    public string Func()  
    {  
    return temp;  
    }  
    }  
    

As we can see here, the compiler is now instantiating a Closure class once for each iteration of the loop, assigning a specific value to the temp field, then passing a delegate to the Func instance method to a new Func<T> delegate.  Now, if we invoke each of our Func delegates we get what we expect "one", then "two", then "three".

I've specifically chosen deferred execution in these examples to separate parallel processing and what's going on.  The same issue occurs when we use anonymous delegates with multiple threads.   For example: 
    
    
    	var texts = new[] { "one", "two", "three" };  
    foreach (var text in texts)  
    {  
    ThreadPool.QueueUserWorkItem(v => Trace.WriteLine(text));  
    }  
    

 This anonymous method (as a lambda) would generate code similar to:
    
    
    	Closure closure = new Closure();  
    for (int i = 0; i < texts.Length; ++i)  
    {  
    closure.text = texts[i];  
    ThreadPool.QueueUserWorkItem(new WaitCallBack(closure.WaitCallback));  
    }  
    

As you can see, each thread is actually dealing with a single variable (Closure.text). At worst case when each thread runs, it outputs "three"–otherwise it's undefined what you'll see.  We fix that the same way we did previously by adding a variable into the local scope:
    
    
    	foreach (var text in texts)  
    {  
    var temp = text;  
    ThreadPool.QueueUserWorkItem(v => Trace.WriteLine(temp));  
    }  
    

This then generates something like this:
    
    
    	for (int i = 0; i < texts.Length; ++i)  
    {  
    Closure closure = new Closure();  
    closure.temp = texts[i];  
    ThreadPool.QueueUserWorkItem(new WaitCallback(closure.WaitCallback));  
    }  
    

This means each thread is operating on an independent variable (the Closure.temp field of each instance of Closure that was instantiated).

I hope this makes it more clear what the compiler is doing when you use anonymous methods (including Lambdas).

![kick it on DotNetKicks.com][2]

[1]: http://blogs.msmvps.com/blogs/peterritchie/archive/2008/10/27/closure-tip.aspx
[2]: http://dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%253a%252f%252fmsmvps.com%252fblogs%252fpeterritchie%252farchive%252f2010%252f11%252f03%252fdeep-dive-on-closure-pitfals.aspx

