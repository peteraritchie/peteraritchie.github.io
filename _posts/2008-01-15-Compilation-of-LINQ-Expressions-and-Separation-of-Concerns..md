---
layout: post
title: Compilation of LINQ Expressions and Separation of Concerns.
date:   2008-01-14 19:00:00 -0500
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/01/15/compiled-linq-expressions-and-separation-of-concerns/ "Permalink to Compilation of LINQ Expressions and Separation of Concerns.")

# Compilation of LINQ Expressions and Separation of Concerns.

I was reading Rico Mariani's latest performance quiz ([#13][1]) involving compilation of LINQ expressions.  One point that I got from his [comments][2] on the solution is that swapping to/from compiled queries is likely to cause the code to "break even very easily".  So, you end up making the decision to compile or not not based on observed metrics but:  

  

  

1. is there any re-use at all

  

2. how much uglier is the compiled code pattern and is the benefit worth the hassle

Completely valid; and considering the savings you get, probably a fairly benign decision.

But, there's more object-oriented ways to approach this type of concern.  My use of "concern" should give part of it away.  The choice between whether an expression is compiled or not shouldn't be the concern of the method/class that is executing the LINQ expression.  The Strategy Pattern is an object-oriented pattern the ensure abstraction, Separation of Concern, and the Single Responsibility Principle (and probably more).  i.e. the choice between compilation or not is the responsibility of another class.

The Strategy Pattern can be implemented as a form of Inversion of Control or Dependency Injection.  In this case we want to decouple the dependency on compiled/uncompiled LINQ statements from the method that executes it.  The compiled/uncompiled strategy is injected into the class at construction or execution of the method and that class either makes (or made) the choice or acts as a proxy to execute the expression (compiling it first, with the compilation strategy).

Now, before I get too deep into doing this with a LINQ query (and you'll understand why in a bit) I'll show an example of implementing the Strategy Pattern.

One example of the Strategy Pattern involves choice of sorting techniques.  Let's say we have an integer array that we need to sort, but how it is sorted needs to be runtime-selectable.  We may do something like this:

  

    
    
        public interface ISortStrategy
    
    
        {
    
    
            void Sort(ref int[] data);
    
    
        }
    
    
        public class BubbleSort : ISortStrategy
    
    
        {
    
    
            public void Sort(ref int[] data)
    
    
            {
    
    
                //…
    
    
            }
    
    
        }
    
    
        public class HeapSort : ISortStrategy
    
    
        {
    
    
            public void Sort(ref int[] data)
    
    
            {
    
    
                //…
    
    
            }
    
    
        }

And an example of using these classes:

  

    
    
            static void SortData(ref int[] data)
    
    
            {
    
    
                ISortStrategy sortStrategy = Configuration.Create<ISortStrategy>();
    
    
                sortStrategy.Sort(ref data);
    
    
            }

 Fairly straightforward, SortData is now decoupled from the type of sort and is freely able to change by whatever means to be detected at runtime.  Configuration.Create may make the decision whether to use BubbleSort or HeapSort based on something in app.config, something in user configuration settings, etc.  The point is, SortData is not coupled to the instantiation of a particular sorting class.

Now, back to LINQ.  The example queries that Rico presented were:

 

  

            var q = (from o in nw.Orders

                    select new

                    {

                        OrderID = o.OrderID,

                        CustomerID = o.CustomerID,

                        EmployeeID = o.EmployeeID,

                        ShippedDate = o.ShippedDate

                    }).Take(5);

And

  

            var cq = CompiledQuery.Compile

            (

                (Northwinds nw) =>

                        (from o in nw.Orders

                        select new

                        {

                            OrderID = o.OrderID,

                            CustomerID = o.CustomerID,

                            EmployeeID = o.EmployeeID,

                            ShippedDate = o.ShippedDate

                        }).Take(5)

            );

These queries make use of an anonymous type.  In order to either compile & execute this query or just execute a single query we need be able to declare a single query that can be compiled an executed.  Unfortnately there's appears to be no way to do this.  The call to CompiledQuery.Compile accept an Expression<> object and compiles it,

 

[1]: http://blogs.msdn.com/ricom/archive/2008/01/14/performance-quiz-13-linq-to-sql-compiled-query-cost-solution.aspx
[2]: http://blogs.msdn.com/ricom/archive/2008/01/14/performance-quiz-13-linq-to-sql-compiled-query-cost-solution.aspx#7110594

