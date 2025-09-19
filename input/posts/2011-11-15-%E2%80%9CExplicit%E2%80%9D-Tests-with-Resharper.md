---
layout: post
title: '“Explicit” Tests with Resharper'
tags: ['.NET Development', '.NET', 'Software Development', 'Software Development Workflow', 'Unit Testing', 'Visual Studio', 'Visual Studio 2010 Best Practices', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2011/11/15/explicit-tests-with-resharper/ "Permalink to “Explicit” Tests with Resharper")

# “Explicit” Tests with Resharper

NUnit introduced a feature called Explicit Tests (a long time ago, I believe) that basically mean a test is considered tagged as Ignore unless the test name is explicitly given to the NUnit runner.

This is useful if you have tests that you don't want run all the time. Integration tests or tests highly coupled to infrastructure or circumstance come to mind… But, it's difficult to automate these types of tests because you always have to maintain a list of test names to give to the runner.

The ability of NUnit to run _explicit_ tests aside, I don't generally use the NUnit runner directly; I use other tools that run my tests. I use tools like Resharper to run my tests within Visual Studio, ContinuousTests for continuous testing, and TeamCity to run my tests for continuous integration.

Continuous integration is one thing, I can configure that to run specific test assemblies and with specific configuration and get it to run whatever unit tests I need it to for whatever scenario.

Within Visual Studio is another story. I sometimes want to run tests in a class or an assembly but not all the tests. At the same time I want the ability of the runner to run tests it wouldn't normally run without having to edit and re-compile code.

With Resharper there are several ways you can do this. One way is to use the Ignore attribute on a test. This is effectively the same as the NUnit Explicit attribute. If I run the test specifically (like having the cursor within the test and pressing Ctrl+U+Ctrl+R) Resharper will still run the test. If I run all tests in solution/project (Ctrl+U+Ctrl+L/right-click project, click Run Unit Tests) the test is ignored. This is great; but now this test is ignored in all of my continuous integration environments. Sad Panda.

If you're using NUnit or MSTest (amongst others that I'm not as familiar with) as your testing framework you can tag tests with a category attribute (MS Test is "TestCategory", NUnit is "Category"). Once tests are categorized I can then go into Resharper and tell it what category of tests to "ignore" (Resharper/Options, under Tools, select Unit Testing and change the "Don't run tests from categories…" section in Resharper 6.x). Now, when I run tests, tests with that category are effectively ignored. If I _explicitly_ run a test (cursor somewhere in test and I press Ctrl+U+Ctrl+R) with an "ignored" category Resharper will still run it. I now get the same ability as I did with the Ignore attribute but don't impact my continuous integration environment. I've effectively switched from an opt-in scenario to an opt-out scenario.

With the advent of [ContinuousTests][1], you might be wondering _why bother_? That's a good question. With ContinousTests only the tests that are affected by the changes you've just saved—automatically, in the background. In fact, having any of your tests run whenever you make a change that affects the test is one reason why I make some tests "explicit". I tend to use test runners as hosts to run experimental code, code that often will become unit tests. But, while I'm fiddling with the code I need to make sure it's only run when I explicitly run it—having it run in the background because something that affects the test isn't always what I want to do. So, I do the same thing with ContinousTests: have it ignore certain test categories (ContinuousTess/Configuration (Solution), _Various_ tab, _Tests categories to ignore_).

### Test Categorization Recommended Practices

Of course, there's nothing out there that really conveys any recommendations about test categorization. It's more or less "here's a gun, don't shoot yourself"… And for the most part, that's fine. But, here's how I like to approach categorizing tests:

First principle: don't go overboard.

Testing frameworks are typically about unit testing—that's what people think of first with automated testing. So, I don't categorize _unit tests_. These are highly decoupled tests that are quick to run and I almost always want to run these tests. If the tests can't always run or I don't want them run at any point in time, they're probably not _unit_ tests.

Next, I categorize non-unit tests by type. There's several other types of tests like Integration, Performance, System, UI, Infrastructure, etc. Not all projects need all these types of tests; but these other tests have specific scenarios where you may or may not want them run. The most common, that I've noticed, is Integration. If the test has a large amount of setup, requires lots of mocks, is coupled to more than couple modules, or takes a long time to run, it's likely not a unit test.

Do you categorize your tests? If so, what's your pattern?

[1]: http://continuoustests.com/


