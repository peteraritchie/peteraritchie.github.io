---
layout: post
title: Fundamentals of OOD Part 3: Method Cohesion
categories: ['C#', 'Design/Coding Guidance', 'DevCenterPost', 'OOD', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/06/10/fundamentals-of-ood-part-3-method-cohesion/ "Permalink to Fundamentals of OOD Part 3: Method Cohesion")

# Fundamentals of OOD Part 3: Method Cohesion

Single Responsibility Principle (SRP) helps us write more cohesive types and methods.  Cohesion is the relatedness of the members of a type to each other and the relatedness parts of a method's code to other parts.

**Method cohesion**  
Often times a method is not very cohesive, meaning the code that it executes relates to more than one thing.  This can often be seen with a method that contains a large switch statement.  For any invocation of the method only one case statement may be executed; meaning that blocks of code within the method don't relate to all the other blocks.  Switch statements are often an indication that the design should be changed to be more polymorphic or introduce a pattern like the Strategy or Template Method patterns.  Likely a concept of the design is implicit instead of explicit (at least no more explicit than an enum).  For example:  

  

    public class Set {

        public enum Operation {

            Unknown,

            Union,

            Intersection,

            RelativeComplement,

            And,

            Conjunction = And

        }

 

        public static IList<int> PerformOperation(IList<int> one, IList<int> two, Operation operation) {

            List<int> result = new List<int>();

            switch (operation) {

                case Operation.Union:

                    result.AddRange(one);

                    result.AddRange(two);

                    break;

                case Operation.Intersection:

                    foreach (int x in one) {

                        if (two.Contains(x)) {

                            result.Add(x);

                        }

                    }

                    break;

                case Operation.RelativeComplement:

                    foreach (int x in one) {

                        if (!two.Contains(x)) {

                            result.Add(x);

                        }

                    }

                    break;

                case Operation.And:

                    foreach (int x in one) {

                        if (two.Contains(x)) {

                            result.Add(x);

                        }

                    }

                    break;

                default:

                    throw new ArgumentOutOfRangeException("operation");

            }

            return result;

        }

    }

This code works; but it's far from cohesive.  There are many combinations of execution paths this method can take, and each path is unrelated to the other paths.  For example, the Union case has no relation to any of the other cases.  Methods like this are also hard to maintain and prone to errors.  Obviously if another member were added to Operation PerformOperation would have to change–making PerformOperation tightly coupled to Operation–not very object oriented.

This can be made more object-oriented by through Dependency Inversion and the Strategy Pattern:

  

    public class Set2 {

        public abstract class Operation {

            public abstract IList<int> Execute(IList<int> left, IList<int> right);

        }

 

        public class UnionOperation : Operation {

            public override IList<int> Execute(IList<int> left, IList<int> right) {

                List<int> result = new List<int>();

                result.AddRange(left);

                result.AddRange(right);

                return result;

            }

        }

 

        public class IntersectionOperation : Operation {

            public override IList<int> Execute(IList<int> left, IList<int> right) {

                List<int> result = new List<int>();

                foreach (int x in left) {

                    if (right.Contains(x)) {

                        result.Add(x);

                    }

                }

                return result;

            }

        }

 

        public class RelativeComplementOperation : Operation {

            public override IList<int> Execute(IList<int> left, IList<int> right) {

                List<int> result = new List<int>();

                foreach (int x in left) {

                    if (!right.Contains(x)) {

                        result.Add(x);

                    }

                }

                return result;

            }

        }

 

        public class AndOperation : Operation {

            public override IList<int> Execute(IList<int> left, IList<int> right) {

                List<int> result = new List<int>();

                foreach (int x in left) {

                    if (right.Contains(x)) {

                        result.Add(x);

                    }

                }

                return result;

            }

        }

        public static IList<int> PerformOperation(IList<int> left, IList<int> right, Operation operation) {

            return operation.Execute(left, right);

        }

    }

Now each operation is encapsulated, explicit, PerformOperation need not change as new strategies are added, and we've completely avoided the InvalidOperationException.

![kick it on DotNetKicks.com][1]

[1]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f06%2f10%2ffundamentals-of-ood-part-3-method-cohesion.aspx

