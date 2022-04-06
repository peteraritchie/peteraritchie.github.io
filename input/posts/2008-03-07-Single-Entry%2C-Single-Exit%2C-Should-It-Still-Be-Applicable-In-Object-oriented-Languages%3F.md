---
layout: post
title: 'Single-Entry, Single-Exit, Should It Still Be Applicable In Object-oriented Languages?'
tags: ['.NET Development', 'C#', 'Design/Coding Guidance', 'Software Development', 'msmvps', 'March 2008']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/03/07/single-entry-single-exit-should-it-still-be-applicable-in-object-oriented-languages/ "Permalink to Single-Entry, Single-Exit, Should It Still Be Applicable In Object-oriented Languages?")

# Single-Entry, Single-Exit, Should It Still Be Applicable In Object-oriented Languages?

Before the modern high-level languagesEdsgerDijkstra came up with "Structured Programming". This programming methodology relied on the programmer to form and enforce most of the structure of the program–manually keeping sub-structures and logic separate from one another to promote maintainability and easy of understanding, among other things. Think assembly language with a linear collection of instructions and jumps and then the only concept of a method or function is how the rest of the logic jumps to that block of code.

This concept of delineating functions hinged on a single entry, i.e. from point A to point B only one point is actually jumped to from "external" code. This single entry concept usually included a single exit, to ease the delineation of a "function". This is known as the single-entry, single-exit methodology (SESE).

It's hard to think of multiple entry points with modern high-level languages what with object-orientation and abstraction and encapsulation; but it's easy to see multiple exits from a method. For example:

  

  public static int CountCommas(string text)

  {

   if (String.IsNullOrEmpty(text))

   {

    return 0;

   }

   if (text.Length == 0)

   {

    return 0;

   }



   int index = 0;

   int result = 0;

   while (index > 0)

   {

    index = text.IndexOf(',', index);

    if (index > 0)

    {

     result++;

    }

   }

   return result;

  }

Structured programming (at least SESE) suggests writing the method like this instead:

  

  public static int CountCommas(string text)

  {

   int result = 0;

   if (!String.IsNullOrEmpty(text))

   {

    if (text.Length > 0)

    {

     int index = 0;

     while (index > 0)

     {

      index = text.IndexOf(',', index);

      if (index > 0)

      {

       result++;

      }

     }

    }

   }



   return result;

  }

  
This concept may have made for more readable code when Dijkstra first cemented the concept in the late 60's early 70's; but in Object-Oriented languages I believe it's less readable. For one thing, it's difficult to shoe-horn SESE with other language concepts like exceptions:

  

  public static int CountCommas(string text)

  {

   Exception exception = null;

   int result = 0;

   if (!String.IsNullOrEmpty(text))

   {

    if (text.Length > 0)

    {

     int index = 0;

     while (index > 0)

     {

      index = text.IndexOf(',', index);

      if (index > 0)

      {

       result++;

      }

     }

    }

    else

    {

     exception = new ArgumentException("argument of zero length", "text");

    }

   }

   else

   {

    exception = new ArgumentNullException("text");

   }



   if (exception != null)

   {

    throw exception;

   }



   return result;

  }

  
And this technically still violates SESE since we exit via return or via throw, although they have close proximity.

I believe the above example is hard to read and hard to maintain. I would abandon the SESE trappings of structured programming in favour of:  

  



 public static int CountCommas(string text)

  {

   if (String.IsNullOrEmpty(text))

   {

    throw new ArgumentNullException("text");

   }

   if (text.Length == 0)

   {

    throw new ArgumentException("argument of zero length", "text");

   }



   int index = 0;

   int result = 0;

   while (index > 0)

   {

    index = text.IndexOf(',', index);

    if (index > 0)

    {

     result++;

    }

   }

   return result;

  }

In high-level languages that do have concepts like functions, subroutines, or methods, the "Single Entry" aspect ofSESE is moot, evolving to the concept of "Single Exit" or the "Single Point of Exit From Methods Principle". This seems like a Cargo Cult to me–separating the part of a concept that is no longer obviously archaic in the hopes of getting the same result in a different context.

Interestingly, as I was writing this, Patrick Smacchia posted to his blog about [NDepend and Nesting Depth][1]–which basically details metrics that show the SESE implementations I show above would actually have higher nesting depths than the non-SESE implementations and thus be more complex, less readable, and less testable.

What are your thoughts? Do you generally follow Single Point of Exit From Methods Principle? If you do, do you ignore it for exceptions?

![kick it on DotNetKicks.com][2]

[1]: http://codebetter.com/blogs/patricksmacchia/archive/2008/03/07/a-simple-trick-to-code-better-and-to-increase-testability.aspx
[2]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f03%2f07%2fsingle-entry-single-exit-should-it-still-be-applicable-in-object-oriented-languages.aspx


