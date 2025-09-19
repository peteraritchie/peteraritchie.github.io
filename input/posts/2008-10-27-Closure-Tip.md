---
layout: post
title: 'Closure Tip'
tags: ['Uncategorized', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/10/27/closure-tip/ "Permalink to Closure Tip")

# Closure Tip

In C# 2 and greater you have the ability to write closures. A closure is a function that is evaluated in an environment containing one ore more bound variables[1]. In C# 2 this is done by creating an anonymous method that accesses a variable declared outside the body of the anonymous method. Writing closures (which can evolve from an anonymous method that is not a closure) must be very deliberate and must be given great attention. Closures offer a very specific way of essentially creating code at runtime based on runtime values. But, with closures, they can be bound to a mutable variable. When you bind to a mutable variable you get the value of the variable when the closure is run, not when the closure was created. You intuitively expect to get the value when the closure was created, not when it was executed. For example
    
    
     String[] numbers = new[] {"one", "two", "three"};
    
    
     List<MethodInvoker> delegates = new List<MethodInvoker>();
    
    
     foreach(String number in numbers)
    
    
     {
    
    
     delegates.Add(delegate() { Trace.WriteLine(number); });
    
    
     }
    
    
     //...
    
    
     foreach(MethodInvoker method in delegates)
    
    
     {
    
    
     method();
    
    
     }

With this code, you would expect the following trace:

one   
two   
three

But, you get this:

three   
three   
three

This is because the anonymous method is bound to the variable _number_ which was "three" when the anonymous method was executed.

But, what can you do to create an anonymous method at runtime that will output the value of a specific value in a collection? Well, the answer is very simple, bind to a variable that doesn't change. For example:
    
    
     foreach (String number in numbers)
    
    
     {
    
    
     String text = number;
    
    
     delegates.Add(delegate() { Trace.WriteLine(text); });
    
    
     }
    
    
     foreach (MethodInvoker method in delegates)
    
    
     {
    
    
     method();
    
    
     }

The addition of the _text_ variable that is simply initialized with the value of _number_ means the closure isn't bound to a mutating variable and end up getting results that are more intuitive:

one   
two   
three

In C# 3 you also have the ability to write closures in the form of lambdas. You could do the same as the above with lambdas as follows:
    
    
     foreach (String number in numbers)
    
    
     {
    
    
     String text = number;
    
    
     delegates.Add(() => Trace.WriteLine(text));
    
    
     }
    
    
     foreach (MethodInvoker method in delegates)
    
    
     {
    
    
     method();
    
    
     }

Related advice may be found in Item 33 of Bill Wagner's _More Effective C#_.

With Resharper you get an added warning that warns you that you're accessing a modified closure. So, in the first example, the IDE would show _number_ as the WriteLine parameter as a warning.

[1] <http://en.wikipedia.org/wiki/Lexical_closure>


