---
layout: post
title: 'New warning CS0809 in C# 3 (Visual Studio 2008)'
tags: ['.NET 3.5', 'C#', 'C# 3.0', 'C# 3.0 Breaking Changes', 'Design/Coding Guidance', 'Visual Studio 2008', 'msmvps', 'November 2007']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/11/26/new-warning-cs0809-in-c-3-visual-studio-2008/ "Permalink to New warning CS0809 in C# 3 (Visual Studio 2008)")

# New warning CS0809 in C# 3 (Visual Studio 2008)

There were several breaking changes (fixes) in C# 3 from C# 2. One is the ability to attribute a member override with ObsoleteAttribute without also attributing it the virtual member in the base class.

For example, the following will compile without error In C# 2 (Visual Studio 2005/.NET 2.0):

  

>   

>     
>     
>     using System;
>     
>     
>     
>     
>     
>     internal class BaseClass
>     
>     
>     {
>     
>     
>      public virtual void Method()
>     
>     
>      {
>     
>     
>      }
>     
>     
>     }
>     
>     
>     
>     
>     
>     internal class DerivedClass : BaseClass
>     
>     
>     {
>     
>     
>      [Obsolete]
>     
>     
>      public override void Method()
>     
>     
>      {
>     
>     
>      }
>     
>     
>     }
>     
>     
>     
>     
>     
>     public static class Progam
>     
>     
>     {
>     
>     
>      public static void Main()
>     
>     
>      {
>     
>     
>       BaseClass baseClass = new DerivedClass();
>     
>     
>       baseClass.Method();
>     
>     
>      }
>     
>     
>     }

This same code will generate a CS0809 warning with C# 3.

This change was done because, as you can see in the example, if DerivedClass.Method is accessed via a BaseClass reference, the compiler can't reliably warn you that you're in fact calling an Obsolete method.

In reality, even you you did call DerivedClass.Method() via a DerivedClass reference you still wouldn't get a warning. This may have something to do with a quirk in the way the compiler detects attributes with overrides and virtual methods; but I'm surmising.

The fix, if you have access to the base class, is to attribute bot the base and the derived class member with ObsoleteAttribute. If you don't have access to the base class, you'll have to live with or suppress the warning.  


