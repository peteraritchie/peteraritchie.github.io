---
layout: post
title: Bridges and Factories
categories: ['.NET Development', 'C#', 'Patterns']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/12/21/bridges-and-factories/ "Permalink to Bridges and Factories")

# Bridges and Factories

In my [previous post][1], I talked about Dependency Injection (DI).  One implementation of DI is using interface-oriented design to abstract a class from an injected dependency via an interface.  This is one possible implementation of the Bridge pattern.  Depending only upon an interface and classes to implement that interface opens up some very interesting possibilities.

The tried-and-true means of creating an object is to simply directly use it's constructor, for example:

  

    
    
            IPerson person = new Employee("Peter", "Ritchie");

This is nice and simple; but we're still coupled to Employee despite using an IPerson object thereafter.  The above code hasn't truly eliminated the dependency upon the Employee class. Moving all that type of logic to a single method encapsulates the logic into one, reusable, place.  This is the Factory pattern, for example:

  

    
    
            person = Person.Create("Peter", "Ritchie");

The Create method, a "Factory Method" on a concrete (likely static) class Person, would know how to create an IPerson object.  At this point using a IPerson object is completely abstracted from a specific concrete type and its creation.

  

    
    
            InviteToMeeting(person);

InviteToMeeting is completely independent of the concrete type implementing IPerson (and it can actually be a private type) and how it was created or where it came from.  This abstraction leaves IPerson objects free to be created however they need to be.  The benefits of Dependency Injection, Bridge, and Factory patterns are synergistic–together they offer more than if they were apart.  In the above example they're created as Employee objects; but because their creation is completely encapsulated it could also be affected by policy.  Policy that clients of the factory would have no dependency upon.

In the simplest case Person.Create could always just create Employee objects; but because creation is hidden from the client the factory method could use other logic to decide what classes to use.  Person.Create could be implemented this way:

  

    
    
        public static IPerson Create ( String firstName, String lastName )
    
    
        {
    
    
            if (Configuration.IsAdministrator)
    
    
            {
    
    
                return new Employee(firstName, lastName);
    
    
            }
    
    
            else
    
    
            {
    
    
                return new Subordinate(firstName, lastName);
    
    
            }
    
    
        }

Now we're injecting policy into the creation process.  Somewhere, likely not in source code, whether the current user is running as an administrator.  This state is used in a policy to decide what type of IPerson object to create.

 

 

[1]: http://msmvps.com/blogs/peterritchie/archive/2007/12/13/dependancy-injection.aspx

