---
layout: post
title:  "Testing Strategies Involving Async Functions"
date:   2010-11-03 12:00:00 -0600
categories: ['.NET Development', 'Async Functions', 'C# 5', 'Design/Coding Guidance', 'DevCenterPost', 'Software Development', 'TDD', 'Unit Testing']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/11/04/testing-strategies-involving-async-functions/ "Permalink to Testing Strategies Involving Async Functions")

# Testing Strategies Involving Async Functions

Some things to keep in mind when writing units tests for code that use  
async methods: You're not trying to test the framework's "awaitability"  
and you're not trying to test framework methods that are "awaitable".   
You want to test your code in certain isolation contexts.  One context,  
of course, is independent of asynchronicity–do individual units of code  
that don't depend on asynchronous invocation "work"…  e.g.  
"Task<string> MyMethodAsync()", you want to have a unit test that  
make sure this method does what it's supposed to do (one being it  
returns a "valid" Task<string> object, the other being that  
individual side-effects occur, if any).  Another context is dependent on  
asynchronicity–do individual units of code that do depend on  
asynchronous invocation (or depend on something being invoked  
asynchronously) "work".  

It's the second context that seems to be the hardest to grasp for most  
people to grasp and action.    
Let's take this example code:
    
    
    	private async void startButton_Click(object sender, EventArgs e)  
    {  
    try  
    {  
    startButton.Enabled = false;  
    var webRequest = WebRequest.Create("http://google.ca");  
    using (var response = await webRequest.GetResponseAsync())  
    using (var stream = response.GetResponseStream())  
    {  
    if (stream == null) return;  
    using (var reader = new StreamReader(stream))  
    {  
    textBox.Text = await reader.ReadToEndAsync();  
    }  
    }  
    }  
    finally  
    {  
    startButton.Enabled = true;  
    }  
    }  
    

A couple invariants that we want to test might be that the button is disabled during the asynchronous operations and enabled after the asynchronous operations.  It's not immediately obvious what to in order to validate these invariants.

When the compiler encounters the await operator, it actually goes searching for method that can act upon the type of the object being returned by the method used with the await operator.  In our first use of await (on GetResponseAsync()) the return type is Task<T> (Task<WebResponse> specifically, but for our example I'll use Task<T>).  There's various criteria the computer uses to search for this method, one method is to search for extension methods that match the name and return an "awaiter" type that has the following methods: BeginAwait and EndAwait (more details can be found in the Aync CTP documentation).  The compiler doesn't allow us to inject an awaiter type in the normal run-time dependency injection semantics; but it does allow us to implement an awaiter that does support dependency injection at run-time.  To do this I would create an ITaskAwaiter interface like this:
    
    
    	public interface ITaskAwaiter<out T>  
    {  
    bool BeginAwait(Action continuation);  
    T EndAwait();  
    }  
    

I then need to create a GetAwaiter(this Task<T>) extension method to return an implementation of this type.  The built-in System.Runtime.CompilerServices.TaskAwaiter<T> is public; but, unfortunately it's constructor (and the ability to pass in a Task<T>) object is internal.  So, we can't simply wrap the built-in awaiter and delegate to it as a default.  We actually have to write an awaiter that mimics what the built-in one does.  For example:
    
    
    	public class TaskAwaiter<T> : ITaskAwaiter<T>  
    {  
    private readonly Task<T> task;
    
    public TaskAwaiter(Task<T> task)  
    {  
    this.task = task;  
    }
    
    public bool BeginAwait(Action continuation)  
    {  
    if (task.IsCompleted) return false;  
    var synchronizationContext = SynchronizationContext.Current;  
    Action<Task> action = theTask =>   
                          	{  
                          		if (synchronizationContext != null)  
                          		{  
                          			synchronizationContext.Post(state => continuation(), null);  
                          		}  
                          		else  
                          		{  
                          			continuation();  
                          		}  
                          	};
    
    task.ContinueWith(action, CancellationToken.None, TaskContinuationOptions.ExecuteSynchronously, TaskScheduler.Current);  
    return true;  
    }
    
    public T EndAwait()  
    {  
    return task.Result;  
    }  
    }

This class is given the Task<T> in question, it implements a BeginWait method that sets up an Action delegate to invoke the continuation given to it in a specific synchronization context, then tells the task to use that new action as it's continuation via a call to ContinueWith.  When the task is completed EndAwait will be called and we simply return the result of the task.

Now, in order to add the ability to inject a customer awaiter, we need to provide the GetAwaiter extension method.  For example:
    
    
    	namespace PRI.Extensions  
    {  
    static class TaskExtensions  
    {  
    static public ITaskAwaiter<TResult> GetAwaiter<TResult>(this Task<TResult> task)  
    {  
    return TaskAwaiterFactory<TResult>.CreateTaskAwaiter != null  
    ? TaskAwaiterFactory<TResult>.CreateTaskAwaiter(task) : new TaskAwaiter<TResult>(task);  
    }  
    }  
    }

This extension method invokes a factory method delegate to create the ITaskAwaiter<T> object (or simply creates our new default awaiter).  This factory method looks like this:
    
    
    	internal static class TaskAwaiterFactory<TResult>  
    {  
    private static Func<Task<TResult>, ITaskAwaiter<TResult>> createTaskAwaiter = task =>  
                                                                                  	{  
                                                                                  		Current = new TaskAwaiter<TResult>(task);  
                                                                                  		return Current;  
                                                                                  	};  
    public static Func<Task<TResult>, ITaskAwaiter<TResult>> CreateTaskAwaiter  
    {  
    get { return createTaskAwaiter; }  
    set  
    {  
    createTaskAwaiter = task =>  
                        	{  
                        		Current = value(task);  
                        		return Current;  
                        	};  
    }  
    }  
    public static ITaskAwaiter<TResult> Current { get; private set; }  
    }

We can override this factory method and give a delegate to code that creates another type of ITaskAwaiter<T> implementation.  We also decorate the call to that provided delegate with something that keeps track of the Current awaiter (more on that later).  Now, we simply need to add a using statement within our namespace for the compiler to user our GetAwaiter when it compiles an await operator and use our factory.  For example:
    
    
    	namespace PRI.MainApplication  
    {  
    using PRI.Extensions;
    
    //...  
    

We're now all set to inject a new awaiter and be able to isolate our code from the framework and validate some invariants.  In our case, we'd like to check to make sure that the button is disabled during invocation of asynchronous operations and enabled when done.  So, we can create a spy awaiter that basically does nothing and sends back a fake or dummy object.  In our example we actually have two different types of Task<T> objects being awaited; so, we need to create a couple of awaiter spys.  One is generic and one is specific.  For example:
    
    
    	public class WebResponseTaskAwaiterSpy : ITaskAwaiter<WebResponse>  
    {  
    private class FakeWebResponse : WebResponse  
    {  
    public override Stream GetResponseStream()  
    {  
    return new MemoryStream(System.Text.Encoding.ASCII.GetBytes("got some text"));  
    }  
    }  
    private readonly MainForm form;  
    public bool ButtonEnabledState { get; private set; }  
    public WebResponseTaskAwaiterSpy(MainForm form)  
    {  
    this.form = form;  
    }
    
    public bool BeginAwait(Action continuation)  
    {  
    return false;  
    }
    
    public WebResponse EndAwait()  
    {  
    ButtonEnabledState = form.startButton.Enabled;  
    return new FakeWebResponse();  
    }  
    }
    
    public class TaskAwaiterSpy<T> : ITaskAwaiter<T>  
    {  
    private readonly MainForm form;  
    public bool ButtonEnabledState { get; private set; }  
    public TaskAwaiterSpy(MainForm form)  
    {  
    this.form = form;  
    }
    
    public bool BeginAwait(Action continuation)  
    {  
    return false;  
    }
    
    public T EndAwait()  
    {  
    ButtonEnabledState = form.startButton.Enabled;  
    return default(T);  
    }  
    }

Both classes don't actually execute the task because we know task execution works and we know it works asynchronously–we're not trying to test that.  The clases return false from BeginAwait to tell the generated code that the asynchronous code "completed" (we lie).  The generated code the calls the EndAwait method to get the result of the so-called asynchronous operation.  In both cases, we get the state of the button in EndAwait.  In the case of the generic spy, we simply return a dummy–the default value for that type parameter.  In the case of the WebResponse spy, we can't send back a dummy because that would be a null value and we'd get NullReferenceEexceptions that would abort our test.  So, we create a FakeWebResponse object and send that back that basically creates a canned response stream in memory and sends it back and that will be used in our second await.

Now, we can write a unit test for startButton_Click method.  For example:
    
    
    	MainForm form = CreateForm();  
    TaskAwaiterFactory<WebResponse>.CreateTaskAwaiter = task => new WebResponseTaskAwaiterSpy(form);  
    TaskAwaiterFactory<String>.CreateTaskAwaiter = task => new TaskAwaiterSpy<String>(form);
    
    form.startButton_Click(null, EventArgs.Empty);
    
    var spy1 = TaskAwaiterFactory<WebResponse>.Current as WebResponseTaskAwaiterSpy;  
    var spy2 = TaskAwaiterFactory<String>.Current as TaskAwaiterSpy<String>;
    
    Assert.IsTrue((spy2 != null && !spy2.ButtonEnabledState) && (spy1 != null && !spy1.ButtonEnabledState));  
    Assert.IsTrue(form.startButton.Enabled);  
    

This code injects our two types of awaiters (our spies), invokes the method, then checks the spies for the values we're looking for as well as the current state of our button (we assume the current state at this point is the same state immediately after the asynchronous operation completed) to validate our invariants.

 

 

![kick it on DotNetKicks.com][1]

[1]: http://dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%253a%252f%252fmsmvps.com%252fblogs%252fpeterritchie%252farchive%252f2010%252f11%252f04%252ftesting-strategies-involving-async-functions.aspx

