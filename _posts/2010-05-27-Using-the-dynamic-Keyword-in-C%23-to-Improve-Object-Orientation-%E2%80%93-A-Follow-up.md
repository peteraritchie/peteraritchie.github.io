---
layout: post
title:  "Using the dynamic Keyword in C# to Improve Object Orientation – A Follow-up"
date:   2010-05-26 12:00:00 -0600
categories: ['.NET 4.0', 'C#', 'C# 4.0', 'Design/Coding Guidance', 'DevCenterPost', 'Patterns', 'Software Development', 'Visual Studio 2010']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/05/27/using-the-dynamic-keyword-in-c-to-improve-object-orientation-a-follow-up/ "Permalink to Using the dynamic Keyword in C# to Improve Object Orientation – A Follow-up")

# Using the dynamic Keyword in C# to Improve Object Orientation – A Follow-up

Based on some feedback, some clarification is warranted with regard to my previous post titled "[Using the dynamic Keyword in C# to Improve Object Orientation][1]".

As [Jarek Kowalski][2] correctly pointed out, the example code that I provided could have used the [Visitor pattern][3] instead to get the same result.  My impetus for using the dynamic keyword the way I did was slightly different from how I described my example—which was meant to be easier to read.

I think it's worthwhile describing the Visitor Pattern.  The Visitor pattern is a pattern used to separate the responsibility of an algorithm from the class that the algorithm should operate upon.  Essentially, a Visitor class is created to contain the algorithm that would be invoked through its Visit method and the classes that the algorithm operates upon some sort of method that accepts a reference to a Visitor object (which would simply invoke the Visit method).  The example that Jarek provided was very similar to:
    
    
     	public interface IShapeVisitor 
    
    
     	{
    
    
     		void Visit(Circle square);
    
    
     		void Visit(Rectangle square);
    
    
     	}
    
    
     
    
    
     	public class Circle : Shape 
    
    
     	{
    
    
     		public override void Accept(IShapeVisitor shapeVisitor)
    
    
     		{
    
    
     			shapeVisitor.Visit(this);
    
    
     		}
    
    
     		//... 
    
    
     	}
    
    
     

And an implementation of IShapeVisitor would be provided like this:
    
    
     	public  class  DrawingVisitor  : IShapeVisitor
    
    
     	{
    
    
     		public  void  Visit(Circle circle)
    
    
     		{
    
    
     			// draw circle here 
    
    
     		}
    
    
     		public  void  Visit(Rectangle rectangle)
    
    
     		{
    
    
     			// draw rectangle here 
    
    
     		}
    
    
     	}
    
    
     
    
    
     

In our case, the bodies of Visit methods would call a Draw method contained in another class like a View implementation.  For example:
    
    
     	public  class  DrawingVisitor  : IShapeVisitor 
    
    
     	{
    
    
     		private  IView  view;
    
    
     		public  DrawingVisitor(IView  view)
    
    
     		{
    
    
     			this.view = view;
    
    
     		}
    
    
     
    
    
     		public  void  Visit(Circle  circle)
    
    
     		{
    
    
     			view.Draw(circle);
    
    
     		}
    
    
     
    
    
     		public  void  Visit(Rectangle  rectangle)
    
    
     		{
    
    
     			view.Draw(rectangle);
    
    
     		}
    
    
     	}
    
    
     

This of course, adds another level of indirection that allows our target (a Shape implementation) to invoke a virtual method that ends up delegating to the Visitor.  An implementation of [Double Dispatch][4].  This allows objects whose type isn't known until run-time to properly invoke overloaded methods of another type.

As you can see, this is very powerful but adds a bit more complexity.

Now, in my original scenario (before I wrote the example for the post), I was dealing with invoking particular series of static overloads of System.Convert.  Because I was dealing both with a class outside of my control and dealing with static overloads, the Visitor pattern could not be applied.

[1]: http://msmvps.com/blogs/peterritchie/archive/2010/05/24/using-the-dynamic-keyword-in-c-to-improve-object-orientation.aspx
[2]: http://www.twitter.com/JarekKowalski
[3]: http://en.wikipedia.org/wiki/Visitor_pattern
[4]: http://en.wikipedia.org/wiki/Double_dispatch

