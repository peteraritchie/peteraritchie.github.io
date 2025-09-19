---
layout: post
title: 'Accumulative Construction'
tags: ['.NET Development', 'C#', '.NET', 'Design/Coding Guidance', 'Software Development', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/05/18/accumulative-construction/ "Permalink to Accumulative Construction")

# Accumulative Construction

A while back someone asked for guidance on what order should polymorphic construction occur in C# classes. I guess I had never really put much thought into it before and have never seen other guidance on the topic; but, I can see where this can become a valid design consideration.

Polymorphic construction is when a class has more than one constructor. If one constructor reuses the services of another constructor, I've coined the term Accumulative Construction, i.e. through successive calls to potentially many constructors.

Here's some guidance that serves me well:

  

> Polymorphic constructors should be called from most specific to least specific.

For example; you may want to write class with several parts to its invariant, where one or many of those parts may have defaults or are optional. In this case you may provide several constructors allowing the user to construct your object in different combinations of required and optional information. In cases like this, the most specific constructors should call least specific constructors.

  

 internal class Person

 {

  int age;

  String firstName;

  String middleName;

  String lastName;



  public Person ( String firstName, int age )

  {

   this.firstName = firstName;

   this.age = age;

  }



  public Person ( String firstName, String lastName, int age )

   :this(firstName, age)

  {

   this.lastName = lastName;

  }



  public Person ( String firstName, String middleName, String lastName, int age )

   :this(firstName, lastName, age)

  {

   this.middleName = middleName;

  }



  // properties and methods follow…

 }

This nicely matches generally accepted exception handling: order catch blocks from most to least derived class (which is detected automatically by the C# compiler).


