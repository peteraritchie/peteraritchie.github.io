---
layout: post
title: 'Using the dynamic Keyword in C# to Improve Object-Orientation'
tags: ['.NET 4.0', '.NET Development', 'C#', 'C# 4.0', 'Code Smells', 'Design/Coding Guidance', 'DevCenterPost', 'OOD', 'Refactoring', 'Software Development', 'Visual Studio 2010', 'msmvps', 'May 2010']
---
[Source](http://blogs.msmvps.com/peterritchie/2010/05/24/using-the-dynamic-keyword-in-c-to-improve-object-orientation/ "Permalink to Using the dynamic Keyword in C# to Improve Object-Orientation")

# Using the dynamic Keyword in C# to Improve Object-Orientation

With polymorphism, object-oriented languages allow "…different data types to be handled using a uniform interface". Ad-hoc polymorphism is when you declare multiple methods of the same name but differ by the type of an argument. For example: 
    
    
     private  static  void  Draw(Circle  circle)
    
    
     {
    
    
     	//... 
    
    
     }
    
    
     private  static  void  Draw(Square  square)
    
    
     {
    
    
     	//... 
    
    
     }
    
    
     

These are usually referred to as _method overloads_ or _method overloading_. Which Draw method that gets invoked would be decided upon at compile-time based on the type of the parameter passed to it. 

This is great, there are many situations where this is useful; but what about situations where you don't know the exact type of the object until run-time? Many programmers instinctly lean towards using the GetType method available on all objects in .NET and perform a manual type comparison. For example: 
    
    
     public  void  ProcessShape(Shape  shape)
    
    
     {
    
    
     	Type  type = shape.GetType();
    
    
     	if  (type == typeof (Square ))
    
    
     	{
    
    
     		Draw((Square )shape);
    
    
     	}
    
    
     	else  if  (type == typeof (Circle ))
    
    
     	{
    
    
     		Draw((Circle )shape);
    
    
     	}
    
    
     	//... 
    
    
     }
    
    
     

There are other variants of this that make it a little harder to detect (and often gets around static code analysis warnings): 
    
    
     public  void  ProcessShape(Shape  shape)
    
    
     {
    
    
     	Square  square = shape as  Square ;
    
    
     	if  (square != null )
    
    
     	{
    
    
     		Draw(square);
    
    
     		return ;
    
    
     	}
    
    
     	Circle  circle = shape as  Circle ;
    
    
     	if  (circle != null )
    
    
     	{
    
    
     		Draw(circle);
    
    
     		return ;
    
    
     	}
    
    
     	//... 
    
    
     }
    
    
     

This code is a problem because we lose the benefits of C#s polymorphism (this code is coupled to Circle and Shape, if either is removed, this code would have to be changed and re-tested. If another Shape derivative were added, the code would again have to be changed and re-tested). There are multiple circumstances where this might happen over and above the so-far specious examples above. For example, deserializing an object from a Stream often results in not knowing the exact type of the object that has been deserialized. This is common with type hierarchies. For example: 
    
    
     private  static  Shape  DeserializeShape(Stream  stream)
    
    
     {
    
    
     	IFormatter  formatter = new  BinaryFormatter ();
    
    
     	return  formatter.Deserialize(stream) as  Shape ;
    
    
     }
    
    
     

With the above code, we've re-hydrated either a Circle of a Square object into a Shape object (and ignored the appropriate checks to make sure a Shape object was loaded). We're now unable to use all the other polymorphism features of C#: method overloading won't work, C# will always only use the overload with the Shape argument and generics suffers from the same problem, it will always resolve to the type parameter of type Shape. For example, if we try to call one of our two Draw methods with our re-hydrated Shape object: 

  
…we simply get a CS1502 warning because there is now Draw(Shape shape) method. 



When programmers simply compare types, they're admitting that polymorphism has been circumvented and they have to resort to introducing the _Conditional Complexity_ Code Smell or the _Switch Statement_ Code Smell (C# doesn't support Type in a switch statement, so some programmers go ahead and create a integer type code–or even worse, use String in the switch statement) 

So, what's a programmer to do to keep our code object-oriented and use polymorphism? 

Well, if you read the title of this post, you've probably figured it out: use the dynamic keyword. The dynamic keyword bypasses static (compile-time) type checking and performs the type-checking dynamically (at run-time). So, for us to use our Draw overloads with our Shape object, we simply assign it to a dynamic object and use that object instead. For example: 
    
    
     			Shape  shape = DeserializeShape(stream);
    
    
     			dynamic  dynShape = shape;
    
    
     			Draw(dynShape);

Now the runtime will check to see the actual type of dynShape object and invoke the corresponding Draw overload. 

In our example, we've used inheritance to derive our two shapes from a single base. But, given our current use of Circle and Square objects, we don't need them to inherit from the same base class. We could simply view these shapes as an Object when we want to use dynamic. For example: 
    
    
     private  static  Object  DeserializeShape(Stream  stream)
    
    
     {
    
    
     	IFormatter  formatter = new  BinaryFormatter ();
    
    
     	return  formatter.Deserialize(stream);
    
    
     }
    
    
     
    
    
     			//... 
    
    
     			dynamic  shape = DeserializeShape(stream);
    
    
     			Draw(shape);
    
    
     

With the above, we'd have the same result without deriving both Circle and Square from Shape.

![kick it on DotNetKicks.com][1]

[1]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2010%2f05%2f24%2fusing-the-dynamic-keyword-in-c-to-improve-object-orientation.aspx


