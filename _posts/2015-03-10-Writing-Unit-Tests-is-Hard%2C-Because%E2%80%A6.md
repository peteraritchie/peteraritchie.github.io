---
layout: post
title: Writing Unit Tests is Hard, Because…
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2015/03/10/writing-unit-tests-is-hard-because/ "Permalink to Writing Unit Tests is Hard, Because…")

# Writing Unit Tests is Hard, Because…

![hard-work][1] There are lots of things in life that are hard.  There is also lots of things in life that we make hard for ourselves when we don't have to.  Unit testing is one of those things that we've made hard for ourselves and we don't have do.

Before I go into not making unit testing harder than it needs to be, let me first talk about accidental complexity.  Fred Brooks details two types of complexity in his book _No Silver Bullet – Essence and Accidents of Software Engineering_: **Essential Complexity** and **Accidental Complexity**.  Essential complexity is complexity inherent in the problem.  Accidental complexity is the complexity engineers add in an effort to solve a problem.  Essential complexity cannot be avoided, accidental complexity can.

So, how does this apply to unit testing?  Well, when unit testing is hard it is an indication that there is unnecessary coupling.  If you can't test a controller without the model that accesses the database (and thus an RDMS, an instance of the database, test data, etc.) then you have accidental complexity that hinders your ability to test.  There are ways to design software and structure code such that a controller can be composed at run-time and interact with abstractions so that the uniqueness of the controller (or the value-add) can be tested independently.  Because we *can* design this way, anything that hinders fine-grained testing is accidental complexity, by definition.

Dealing with this accidental complexity with unit tests is straightforward, but requires thinking about design.  Changing a design to remove the accidental complexity is _doable_, but not adding the accidental complexity at all is _preferable_.  TDD helps a lot with that; but that's for another post—the focus of this post will be about changing design, or _removing_ accidental complexity.

Removing accidental complexity is really about decoupling.  Two of the most useful techniques for creating a decoupled design are the **Dependency Injection pattern** and the **Dependency Inversion Principle**.

The Dependency Inversion Principle (DIP) states:

> A. HIGH LEVEL MODULES SHOULD NOT DEPEND UPON LOW LEVEL MODULES. BOTH SHOULD DEPEND UPON ABSTRACTIONS. 
> 
> B. ABSTRACTIONS SHOULD NOT DEPEND UPON DETAILS. DETAILS SHOULD DEPEND UPON ABSTRACTIONS.

This is extremely important for designing and implementing testable software.  Let's be clear here; we're talking about unit tests (or automated tests) where we want to be able to (at least) have fine-grained tests that test the smallest _unit_ possible per test which allows us to find and fix problems much more quickly.  With top-down designed software, there's no easy way to separate out these smaller units of code for testing.

Let's look an example.  Say I have an MVC application that has a CategoryController.  And with any typical MVC application the controller translates view actions into interactions with the model.  In a top-down design, you might have a CategoryController constructor like this
    
    
    public class CategoryController
    {
    	private CategoryModel model;
     
    	public CategoryController()
    	{
    		model = new CategoryModel();
    	}
     
    	//...
    }

![66795][2]Imagine if this top-down design continued, where CategoryModel depended on various things, and the various things that CategoryModel depended on depended on various other things…  CategoryController would be the tip of an iceberg with untold depths of dependencies below the surface, all of which limiting our ability to use CategoryController in any but one scenario (especially not the testing scenario).

From a functionality standpoint _top-down design works_. But to test the tip of the iceberg we end up _testing the whole iceberg_.  To test CategoryController we'd have to write a test like this.
    
    
    [Test]
    public void ListActionReturnsListOfCategories()
    {
    	var controller = new CategoryController();
     
    	var result = (ViewResult) controller.List();
    	Assert.IsTrue(result.ViewData.Model is IEnumerable<Category>);
    	IEnumerable<Category> listCategories = (IEnumerable<Category>) result.ViewData.Model;
     
    	Assert.AreEqual(1, listCategories.Count());
    }

But, for this to work we have to make sure all the requirements are met for CategoryModel to operate correctly.  If CategoryModel is an abstraction around a Repository implementation or a data context (like Entity Framework), then there is a lot of configuration required for our simple tests to run.  Having test setup code to do this configuration is simply not feasible.  It's unreasonable for test setup code to install and configure SQL Server, for example.  Even if we _did_ spend the time to get that configuration done (and that would be on _one_ developer workstation) we'd end up testing the controller, the model, the database server, the database scheme, the test data, etc.—any of which could cause a test failure limiting our ability to focus on _where_ the failure was (or whether it was a configuration error).   No, we want to be able to execute tests with zero configuration dependencies.

In this top-down design implementation, the controller takes a dependency on CategoryModel (has ownership).  We want to _invert_ that dependency such that ownership is inverted and that the controller simply takes a dependence at the code level on an abstraction.  But, since the controller is currently the owner of the model, we must first talk about The Dependency Injection Pattern.

The Dependency Injection pattern defines that the dependencies that one unit (class or method) requires be _injected_ into the unit.  This means that the dependency be instantiated outside the unit and be passed in (either in a constructor if it is a mandatory class dependency, a property if it is an optional class dependency, or as a parameter of the method if it is a method dependency).  Optional class dependencies and method dependencies are really indications that there is a responsibility problem (i.e. something has taken on too much responsibility) so I generally try to focus solely on constructor injection.

In the case of our CategoryController, this means creating a model abstraction and injecting an instance of an implementation of that abstraction into our controller.  Our model is fairly simple, so our abstraction might look like this:
    
    
    public interface ICategoryModel
    {
    	IEnumerable<Category> List();
    }

And we'd derive our CategoryModel class from ICategoryModel:
    
    
    public class CategoryModel : ICategoryModel
    {
    	public IEnumerable<Category> List()
    	{
    		//...
    	}
    	//...
    }

And in order to use this in production code, instead of simply instantiating the controller, we'd instantiate the model first:
    
    
    var controller = new CategoryController(new CategoryModel());
    

And, of course, modify CategoryController like this:
    
    
    public class CategoryController
    {
    	private ICategoryModel model;
     
    	public CategoryController(ICategoryModel categoryModel)
    	{
    		model = categoryModel;
    	}
     
    	//...
    }

Keep in mind that the composition of the controller would be done in a MVC-compatible factory.

But, now we are free to use any ICategoryModel implementation when composing a CategoryController.  In the case were we want to focus on the unit of CategoryController.List(), we can mock away the production-level model and focus solely on the CategoryControl.List() unit. So, we might update our test method as follows:
    
    
    [Test]
    public void ListActionReturnsListOfCategories()
    {
    	var controller = new CategoryController(new MockCategoryModel());
     
    	var result = (ActionResult) controller.List();
    	Assert.IsTrue(result.ViewData.Model is IEnumerable<Category>);
    	IEnumerable<Category> listCategories = (IEnumerable<Category>) result.ViewData.Model;
     
    	Assert.AreEqual(1, listCategories.Count());
    }

![Ice-Cubes][3] Now we are able to reason about smaller parts of our system.  This allows us (or forces us, depending on your point of view) to compose our systems from smaller, decoupled, parts (like ice cubes instead of one iceberg).  We instantiate several objects independently (each of which is injected into another) to compose a system.  We can compose those instances in the way we'd need for our production system, or we could compose those instances in a way that allows is to test individual units of code. This allows us to get away from the _tip of the iceberg_ design smell that plagued our ability to test.

By taking on this bottom-up design design philosophy it allows us the freedom to compose our systems and subsystems in code (in other words at run-time) offering great flexibility in the granularity at which we can test.  We can still perform integration and system-level automated testing, but now we're free to have fine grain tests that will run quickly and fail fast allowing very quick and tight dev/test cycles.

If you're new to this bottom-up design philosophy and want to get better at composable systems, I'd recommend trying to do Test-Driven Design (TDD) whenever you can.  TDD forces you to create simple tests before you start to write the system under test, so it forces you to have a testable (and thus likely composable) design.

When we allow accidental complexity into our software, design, and processes; what we are really doing is adding needless coupling.  The more complex something is, the more it is coupled to many, potentially unrelated, things.  With that increased coupling it's hard to make fine-grained changes to things.  To make the changes we want to make takes much more work and causes much more instability.  But that's for yet another blog post.

[1]: http://pr-blog.azurewebsites.net/wp-content/uploads/2015/03/hardwork_thumb.png "hard-work"
[2]: http://pr-blog.azurewebsites.net/wp-content/uploads/2015/03/tip_of_the_iceberg_thumb.jpg "66795"
[3]: http://pr-blog.azurewebsites.net/wp-content/uploads/2015/03/IceCubes_thumb.png "Ice-Cubes"

