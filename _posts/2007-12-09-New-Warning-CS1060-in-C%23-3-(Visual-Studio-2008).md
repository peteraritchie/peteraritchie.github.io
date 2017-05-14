---
layout: post
title: New Warning CS1060 in C# 3 (Visual Studio 2008)
date:   2007-12-08 19:00:00 -0500
categories: ['.NET 3.5', '.NET Development', 'C# 3.0 Breaking Changes', 'Software Development', 'Visual Studio 2008']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/12/09/new-warning-cs1060-in-c-3-visual-studio-2008/ "Permalink to New Warning CS1060 in C# 3 (Visual Studio 2008)")

# New Warning CS1060 in C# 3 (Visual Studio 2008)

Recompiling C# 2 (Visual Studio 2005) code in C# 3 (Visual Studio 2008), you may incounter a new warning that didn't used to ocur:

Warning CS1060: Use of  
        possibly unassigned field 'fieldName'. Struct instance variables are initially unassigned if struct is unassigned.

Dealing strictly with syntax, C# let's you declare a value type (struct) with a reference member, for example:

  

    
    
    namespace Examples
    
    
    {
    
    
        using System.Drawing;
    
    
        public static class Program
    
    
        {
    
    
            public static void Main()
    
    
            {
    
    
                LabelEntry labelEntry;
    
    
                labelEntry.Location.Point.X = 0;
    
    
            }
    
    
        }
    
    
     
    
    
        public struct LabelEntry
    
    
        {
    
    
            public LabelLocation Location;
    
    
            public String Label;
    
    
        }
    
    
     
    
    
        public class LabelLocation
    
    
        {
    
    
            public Point Point;
    
    
        }
    
    
    }

Unfortunately, in C# 2, and previous, it wouldn't give you an warning if you tried to read a value type reference member before initializing it, as in the highlighted code.

As I've alluded to before, syntactic correctness does not imply conceptional correctness and this warning improves syntax correctness.

If avoiding reference members in structs isn't clear, let me know and I can do a post on that.

