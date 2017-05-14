---
layout: post
title:  "Dependency Injection"
date:   2007-12-12 19:00:00 -0500
categories: ['.NET Development', 'C#', 'Patterns', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/12/13/dependancy-injection/ "Permalink to Dependency Injection")

# Dependency Injection

Dependency injection (DI) is a form of inversion of control.  There seems to be a tendency in some circles to refer to dependency injection as inversion of control (IoC). 

Dependency injection is a form of abstraction by removing physical dependencies between classes and potentially assemblies.  This abstraction can have many different motives.  One motive is for Aspect Oriented Software Development (ASOD) where you're abstracting shared (or cross-cutting) concerns into independent classes.  Another motive is for Test-Driven Development (TDD) where you want to be able to test each class independently of its dependencies–in which case injected dependencies are "mocked"–technically this is still AOSD because you're separating the testing concern.

Dependency injection in .NET is most frequently implemented using interface-oriented design/programming, where a dependency of a class is on an interface.  Any class implementing that interface is then a candidate for being "injected" into the other class. There's many ways to inject dependency, one is at time of construction the other is at time of operation. 

There are many examples of dependency injection at time of operation in the .NET Framework.  Normally when an interface is involved, dependency injection is also involved.  Serialization is a good example.  Serialization in .NET allows programmers to serialize to pretty much anything.  "Anything" being a stream.  Serialization abstracts the destination from the act of serializing and allows programmers to inject a dependency on any type of destination (media, resource, mock, etc.) simply by implementing IStream.  For example, for any given class in .NET I can "serialize" it to any stream:

  

    
    
                MyType myType = new MyType();
    
    
                IFormatter formatter = Configuration.CreateFormatter(typeof(myType));
    
    
                using (Stream stream = new MemoryStream())
    
    
                {
    
    
                    formatter.Serialize(stream, myType);
    
    
                    // TODO: something with stream.
    
    
                }

In the above example, IFormatter.Serialize(Stream, Object), uses dependency injection at time of operation to serialize to a MemoryStream object.  In no way is IFormatter.Serialize dependant on MemoryStream.  The same call could be written as follows:

  

    
    
                using(Stream stream = new FileStream("file.dat", FileMode.Create))
    
    
                {
    
    
                    formatter.Serialize(stream, myType);
    
    
                    // TODO: something with stream.

            }

The above form of DI is interface (and class) based, in that you need to implement a specific interface to inject as a dependency.  Another form of DI is via delegates.  You can abstract a particular class from other concerns simply by accepting a delegate.  Any class that wants to be injected simply needs to implement a method with the same signature as the required delegate.  Events are an example of this.  Any class that raises events is completely independent of any other classes that want to act as observers and subscribe to these events.  Subscribers are, in effect, are preforming dependency injection by subscribing to an event.  This form of DI is not limited to DI, it can be any delegate.  In .NET 2.0 there were many examples of this introduced.  List.ForEach, for example:

  

    
    
    namespace Examples
    
    
    {
    
    
        using System.Collections.Generic;
    
    
        public class Program
    
    
        {
    
    
            static void Main()
    
    
            {
    
    
                List<string> names = new List<string>();
    
    
                // TODO: populate names
    
    
                names.ForEach(Print);
    
    
            }
    
    
            static void Print(String name)
    
    
            {
    
    
                Console.WriteLine(name);
    
    
            }
    
    
        }
    
    
    }

In this example, List<T>, of course, is completely independent from Program and Program is free to be static because there are no interface implementation requirements.

