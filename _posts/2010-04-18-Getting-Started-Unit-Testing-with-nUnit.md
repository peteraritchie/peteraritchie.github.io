---
layout: post
title:  "Getting Started Unit Testing with nUnit"
date:   2010-04-17 12:00:00 -0600
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/04/18/getting-started-unit-testing-with-nunit/ "Permalink to Getting Started Unit Testing with nUnit")

# Getting Started Unit Testing with nUnit

Getting started with unit testing with nUnit is easy.  _First download and install the latest version of nUnit_, which can be found here:  <http://www.nunit.org/index.php?p=download>

Next, you need to _decide where you want your unit tests will live_.  If you're developing a shrink-wrapped system that will be deployed to multiple customers or clients, you'll likely want to have an independent project to house your tests.  If you're developing an enterprise system—and the software won't be deployed outside your enterprise—then having the tests within an existing project (usually the highest-level project) is a valid option.

**Note:** The only configuration I've been able to get to work with Visual Studio 2010 compiled assemblies is to have my assemblies compile to x86 and use nunit-x86.exe to run the tests.

Wherever you decide to keep your unit tests, you need to add a reference to the nUnit assembly.  _Add a reference to nunit.framework.dll_.

Next, you can _write some tests_.  For example:

[TestFixture]   
public class TestSomething   
{   
    [Test]   
    public void FailingTest()   
    {   
        Assert.Fail("Fail description.");   
    }   
    [Test]   
    public void PassingTest()   
    {   
        Assert.Pass();   
    }   
    [Test]   
    public void InconclusiveTest()   
    {   
        Assert.Inconclusive("Reason for lack of conclusion.");   
    } 

}

Then, compile, and _load your test assembly into nUnit_.  Clicking the Run button should result in something like the following in nUnit.

![image][1]

You're now ready for Red Green Refactor.

## Yellow?

What about yellow?  Red means a test failure, Green means a test pass.  But, what about tests that don't have underlying code to be tested.  Some may say that this is just another failing test.  But, early in your testing efforts you may end up being overwhelmed by red.  This could lead to missing a failed test actually is testing code.  The alternative is to use the [Assert.Inconclusive()][2].  This actually gives you a purple, not yellow, result in nUnit, but you get the idea.

## Where to from Here?

Now we've got an external test runner and the unit tests for the runner to execute and inform you of red, green, and yellow; you may want to automate the testing process.  I would recommend looking at tools like [TestDriven.NET][3], [Resharper][4], and Continuous Integration tools like [CruiseControl.NET][5]

Of course, you've always got the option using the built-in automated testing tools in Visual Studio 2010 Professional, and the Continuous Integration abilities of Visual Studio Team System.

[1]: http://blogs.msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie.metablogapi/8037.image_5F00_thumb_5F00_75912CA9.png "image"
[2]: http://www.nunit.org/index.php?p=utilityAsserts&r=2.5.1
[3]: http://www.testdriven.net/
[4]: http://www.jetbrains.com/resharper/
[5]: http://confluence.public.thoughtworks.org/display/CCNET/Welcome+to+CruiseControl.NET

