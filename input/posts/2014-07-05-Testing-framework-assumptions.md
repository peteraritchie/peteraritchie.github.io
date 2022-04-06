---
layout: post
title: 'Testing framework assumptions'
tags: ['Uncategorized', 'msmvps', 'July 2014']
---
[Source](http://pr-blog.azurewebsites.net/2014/07/05/testing-framework-assumptions/ "Permalink to Testing framework assumptions")

# Testing framework assumptions

Back in the day (before there were unit testing tools), when I wanted to prototype (i.e. test my assumptions) how I would use a framework for certain things, I would perform some experimental development with the creation of a test application. This would sometimes be a WinForms app, or sometimes a console app; but the type really doesn't matter. What matters was that _how_ I was going to use a given framework (.NET Framework for example) was prototyped and validated before I got to far into certain parts of development.

One problem with doing that was that the application was largely throw-away and while that gave _me_ the knowledge that could be used within the production application, it was lost on any other team members. And in some cases they may be performing the same work in isolation.

## Unit Testing Tools

Enter unit testing tools. At a philosophical level unit testing tools are just for **unit tests**. A unit test tests the smallest testable unit of code (typically a method) that given outputs or side-effects occur with given inputs. But, we can think of them more broadly than that. Unit testing tools are effective ways of performing any automated testing and we can expand out use of these tools to do much more than just _unit_ testing.

Nowadays all my prototyping is typically done in a unit testing tool. I can simply churn out a new test method to prototype almost any bit of code. It allows me to invoke that code whenever I want either manually or automatically. I can evolve that code from under test to in production by refactoring to other classes, etc.

Some may say this is a form of TDD, but it's more than that. I can create blocks of code that I want to prototype without any assertions just to get a basic understanding of code that I will need in production. Once I'm done prototyping, I can either add assertions or refactor the code into production classes then evolve the test method or create new ones. Or, I can simply leave the test method alone as a means of documenting the prototype and it can live with the code in source code control.

For example, I may need to use MessageQueue in a specific way. I can create a test method to prototype that usage and verify it through compilation and execution:

Of course, with the ability to constantly verify assertions, this type of prototype code can explicitly detail *why* the code does what it does; but, sometimes it's just a convenient place to keep sample code related to a project. In cases like this, I may add a category to the test method so that I can wire it off from automated test runs. For example, if I just want sample code on how to use a particular API in a framework, I may add an "Infrastructure" category:

One of the first things I do when I create a new solution in Visual Studio is to add a test project and I live in there most of the time prototyping and experimenting quickly and easily. I encourage you to make use of your unit testing tools for as many things as possible.


