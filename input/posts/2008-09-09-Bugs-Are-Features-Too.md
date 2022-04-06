---
layout: post
title: 'Bugs Are Features Too'
tags: ['Microsoft', 'Product Bugs', 'Software Development', 'Visual Studio 2005', 'Visual Studio 2008', 'msmvps', 'September 2008']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/09/09/bugs-are-features-too/ "Permalink to Bugs Are Features Too")

# Bugs Are Features Too

It's surprising how many bugs on Microsoft Connect are closed as Won't Fix with a reason that fixing the bug would be a breaking change. 

The logic is that someone could be dependant on the errant behaviour and thus changing it would cause their code to break. 

Here's some samples. 

TypeConverter.IsValid(Object). This method is described as "Returns whether the given value is valid for this type". But, this results in true: 

   TypeConverter typeConverter = TypeDescriptor.GetConverter(typeof(int));

   Console.WriteLine(typeConverter.IsValid("ten")); 

Based on the description of IsValid that this is what was intended:

   Debug.Assert(false == typeConverter.IsValid("ten"), "TypeConverter.IsValid return true when it shouldn't have");

   Debug.Assert(true == typeConverter.IsValid("10"), "TypeConverter.IsValid return false when it shouldn't have");

Ergo, the argument is there must be some code out there that relies on the fact that IsValid returns true for invalid values. The best I could come up with was:

   TypeConverter typeConverter = TypeDescriptor.GetConverter(typeof(int));

   if(!typeConverter.IsValid("ten"))

   {

    MessageBox.Show("value cannot be converted to integer");

    return;

   }

   try

   {

    Int32 value = (Int32)typeConverter.ConvertTo("ten", typeof(Int32));

   }

   catch (FormatException)

   {

    MessageBox.Show("value cannot be converted to integer");

    return;

   }

If they changed TypeConverter.IsValid to return whether the given value is valid for this type then obviously it would break the above code. 

That bug was logged by Daniel Cazzulino at <https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=93559>

One I personally logged had to do with methods documented as "Always throws". 

There exists several methods in the framework like Convert.ToDecimal(DateTime) that do nothing but throw an exception. The response was that the methods exist to allow easier conversion from VB6. 

What scares me is that that suggests that the methods exists so that VB6 code copied to VB.NET will compile without error rather than attempting to follow a well-known axiom of getting the compiler to detect logic errors whenever possible. Rather than providing a compile error and forcing someone to fix the problem before releasing the software, these methods allow the software to compile and it's then the onus of the unit tests or the testers to find the runtime error. 

This bug can be found at <https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=94770>. 


