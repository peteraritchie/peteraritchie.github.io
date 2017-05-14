---
layout: post
title: My Visual Studio 2008 Code Analysis Rules
categories: ['Code Analysis Rules', 'Software Development', 'Visual Studio 2008']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/09/04/my-visual-studio-2008-code-analysis-rules/ "Permalink to My Visual Studio 2008 Code Analysis Rules")

# My Visual Studio 2008 Code Analysis Rules

Although a couple of suggestion for changes to existing rules seem to have made it into Visual Studio 2008 Beta 2, unfortunately, none of my suggestions for new Code Analysis rules made it into Orcas Beta 2 (and thus likely not in RTM).

I was holding off on writing my own rules waiting for a stable SDK because I didn't really want to write several different versions of the same rule.  But, unfortunately that also wasn't in the cards for Orcas, so I've begun writing a few rules for Visual Studio 2008 that I feel are important.

Some of the rules I've suggested over the years that I've implemented in this Code Analysis add-in are:  
**DoNotUseCurrentUICultureAsIFormatProviderArgument**  
I've blogged about issues using CurrentUICulture for formatting and parsing methods (i.e. as an IFormatProvider argument) in the past.  The issue is that CurrentUICulture can be assigned a neutral or a specific culture but formatting and parsing requires a specific culture.  A neutral culture is one that only specifies language and not region or country.  Region and country define the formatting specifications.  Using a neutral culture, although syntactically correct, as an IFormatProvider argument will result in an exception.

**DoNotLockOnOPubliclyVisibleObjects**  
This guideline is from from the MSDN documentation (in various places, see <http://msdn2.microsoft.com/en-us/library/c5kehkcz(vs.80).aspx> for one).  Code Analysis already checks for locks on typeof but it doesn't check for locks on this or other public members.  DoNotLockOnOPubliclyVisibleObjects checks for lock on "this" (or SyncLock on "Me") as well as direct use of Monitor.Enter/Exit.

I've created some rules for checking some of the issues I've blogged about in the past:  
**DoNotUseThreadAbort**  
**DoNotUseThreadSleep**  
**DoNotUsesleepWithZeroArgument**  
…I won't flog that horse more than it's already been flogged…

  
I created one of many (I hope) C#3/VB9 rules:   
**AvoidExtensionMethodsThatDuplicateInstanceMethods**  
In Visual C# Orcas you can write an extension method that has the same signature as an instance method.  With the method resolution rules in C# this extension method will never get called; but no warning is issued to that effect.  For example:

  

>   

> 
> using System;
> 
> using ArrayExtensions;
> 
>  
> 
> namespace Application
> 
> {
> 
>     class Program
> 
>     {
> 
>         static void Main ( string[] args )
> 
>         {
> 
>             int[] arr = new int[10];
> 
>             arr.SetValue(10, 0);
> 
>         }
> 
>     }
> 
> }
> 
>  
> 
> namespace ArrayExtensions
> 
> {
> 
>     internal static class Extensions
> 
>     {
> 
>         public static void SetValue ( this Array array, object value, int index )
> 
>         {
> 
>             array.SetValue(value, index);
> 
>         }
> 
>     }
> 
> }

No warning is given that Extensions.SetValue can never be called as an extension method. 

On much the same lines as AvoidExtensionMethodsThatDuplicateInstanceMethods I've also added:  
**DoNotRecursivelyReferenceProperty  
**Rather than requesting either of these be added to Code Analysis I'd recommend these checks actually be performed by the compiler (as I have with recursively calling a property).  In the meantime, these rules can be flagged as errors in Visual Studio.  Syntactically in C# there's nothing wrong with calling a property from itself.  This, of course, will result in a StackOverflowException and your application's termination because of the infinite recursion–without warning or error.  With DoNotRecursivelyReferenceProperty, there isn't enough metadata to efficiently distinguish between directly calling an object's property from itself or calling another object's property from the same property, so this rule will be raised on code like this:

  

  

    class Entity

    {

        private Entity otherEntity;

        private string text;

        String Text

        {

            get

            {

                if (otherEntity != null)

                {

                    return otherEntity.Text;

                }

                else

                {

                    return this.text;

                }

            }

        }

        //…

    }

I don't think this is a bad thing.  For one thing it's an unlikely scenario; and another, there's no way to tell if the code might get hit by an infinite recursion (otherEntity could be assigned "this").  In the unlikely event this scenario is legit (i.e. you're checking to make sure the object is not "this") then you can simply add a suppression for this rule where appropriate.  For example:

  

        [System.Diagnostics.CodeAnalysis.SuppressMessage("PRI.Design", "PRICA1001:DoNotRecursivelyReferenceProperty")]

        String Text

        {

            get

            {

                if (otherEntity != null)

                {

                    return otherEntity.Text;

                }

                else

                {

                    return this.text;

                }

            }

        }

**Download**

The add-ins may be downloaded from here: <http://www.peterritchie.com/Hamlet/Downloads/105.aspx>

**Deployment**  
After exiting all instances of Visual Studio 2008 Beta 2, simply unzip the contents to "C:Program FilesMicrosoft Visual Studio 9.0Team ToolsStatic Analysis ToolsFxCopRules" and re-load Visual Studio.

