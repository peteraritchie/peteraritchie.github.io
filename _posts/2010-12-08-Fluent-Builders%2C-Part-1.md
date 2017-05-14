---
layout: post
title: Fluent Builders, Part 1
categories: ['.NET 4.0', '.NET Development', 'C#', 'C# 4', 'Patterns', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/12/08/fluent-builders-part-1/ "Permalink to Fluent Builders, Part 1")

# Fluent Builders, Part 1

I've seen some conversations about fluent builders as of late, and I'd thought I'd post some information about fluent builders, the principles behind them, the problems they address, and how to implement them.

Fluent Builder is a combination of the builder pattern and a fluent API.

The builder pattern is similar to the factory pattern in that it's intended to abstract the creation of other objects.  This is often meant to abstract the fact that many objects need to be created (ala the composite pattern).  It's often intended to hide the fact that the creation of one object is dependant on the creation of one or more other objects.

A Fluent API or a Fluent Interface is a pattern-like design technique introduced by Eric Evans and Martin Fowler and is an interface that makes use of method chaining to promote readability of code.

The combination of a Fluent API and a the Builder pattern give us fluent builders—the ability to fluently build complex objects.  The principle of doing this is not only to gain the readability of a Fluent API but to also gain the expressiveness that we can get from the use of named methods and properties.

Let's look at a simple example that I encountered recently in the creation of a RabbitMQ Subscription object:
    
    
    var connectionFactory = new ConnectionFactory  
    {  
    HostName = "localhost",  
    UserName = "pQowiht12glsh%d",  
    Password = "i21uWghe&gjs",  
    Port = 8181  
    };  
    var connection = connectionFactory.CreateConnection();  
    var model = connection.CreateModel();  
    var subscription = new Subscription(model, "messages", false);  
    var currentMessage = subscription.Next();  
    // ...  
    

A Subscription object is dependant on an IModel object, and the creation of an IModel object is dependant on the creation of a IConnection object, and the IConnection object is dependant on the creation of a ConnectionFactory.  The IConnection requires a host name, a user name, a password and a port number.  A subscription requires an IModel object, a queue name, and whether messages retrieved from the queue require an acknowledgment or not.

The creation of a connection factory is fairly easy to understand because it uses properties to configure the object and we've chosen to use the object initializer syntax to initialize said object type.  When we get to the creation of the Subscription object, it gets a little sketchy.  What does "messages" mean and what does "false" mean?  It's not clear from the call to the Subscription constructor what those two parameters mean.  Someone reading this code needs to understand what arguments this particular Subscription constructor accepts to really understand this code.

Now, let's look an example using a Fluent Builder:
    
    
    Subscription subscription = new RabbitMQSubscriptionBuilder()  
    .WithCredentials("pQowiht12glsh%d", "i21uWghe&gjs")  
    .ToHost("localhost", 8181)  
    .SubscribeToQueue("messages");  
    var currentMessage = subscription.Next();  
    

 

With this code, it's extremely obvious what "pQowiht12glsh%d", "i21uWghe&gjs" are and that they are related to one-another.  It's also obvious that "localhost" and 8181 are related to one-another.  It's now clear what "messages" meant and model and false are completely abstracted away.  We've also got a few less lines of code.

If we look at the actual builder that is used with this example:
    
    
    public class RabbitMQSubscriptionBuilder {  
    public string UserName { get; set; }  
    public string Password { get; set; }  
    public string HostName { get; set; }  
    public ushort PortNumber { get; set; }  
    public string ExchangeName { get; set; }  
    public string QueueName { get; set; }  
    public bool AckRequired { get; set; }
    
    public RabbitMQSubscriptionBuilder() {  
    HostName = "localhost";  
    PortNumber = 5672;  
    UserName = "guest";  
    AckRequired = false;  
    }
    
    public RabbitMQSubscriptionBuilder WithAcknowledgements {  
    get {  
    AckRequired = true;  
    return this;  
    }  
    }
    
    public RabbitMQSubscriptionBuilder WithCredentials(string userName, string password) {  
    UserName = userName;  
    Password = password;
    
    return this;  
    }
    
    public RabbitMQSubscriptionBuilder ToHost(string hostName, ushort portNumber) {  
    HostName = hostName;  
    PortNumber = portNumber;
    
    return this;  
    }
    
    public RabbitMQSubscriptionBuilder PublishToExchange(string exchangeName) {  
    ExchangeName = exchangeName;
    
    return this;  
    }
    
    public RabbitMQSubscriptionBuilder SubscribeToQueue(string queueName) {  
    QueueName = queueName;
    
    return this;  
    }
    
    public static implicit operator Subscription(RabbitMQSubscriptionBuilder builder) {  
    var connectionFactory = new ConnectionFactory  
    {  
    HostName = builder.HostName,  
    UserName = builder.UserName,  
    Password = builder.Password,  
    Port = builder.PortNumber  
    };  
    var connection = connectionFactory.CreateConnection();  
    var model = connection.CreateModel();  
    return new Subscription(model, builder.QueueName, builder.AckRequired);  
    }  
    }

…and look at where we create our Subscription object, it's now more clear what the arguments are being sent to the constructor.

If we wanted to now create a Subscription object that required acknowledgements, we'd write code like this:
    
    
    Subscription subscription = new RabbitMQSubscriptionBuilder()  
    .WithCredentials("pQowiht12glsh%d", "i21uWghe&gjs")  
    .ToHost("localhost", 8181)  
    **.WithAcknowledgements  
    **	.SubscribeToQueue("messages");  
    

…instead of changing false to true.  Much more clear.

I, personally, think the expressiveness of the fluent builder is second to none.  But, let's look at a couple of alternatives.

The builder pattern is very similar to the Introduce Parameter Object refactoring where you'd create another class that groups the parameters together into a single class.  The issue here is that we're dealing with the creation of multiple objects in order to get the final Subscription object. We could create a parameter class for Subscription to give us a bit in the way of readability and come up with something like this:
    
    
    var connectionFactory = new ConnectionFactory  
    {  
    HostName = "localhost",  
    UserName = "pQowiht12glsh%d",  
    Password = "i21uWghe&gjs",  
    Port = 8181  
    };  
    var connection = connectionFactory.CreateConnection();  
    var model = connection.CreateModel();  
    var parameters = new SubscriptionParameters  
             {  
                 Model = model,  
                 QueueName = "messages",  
                 RequiresAcks = false  
             };  
    var subscription = CreateSubscription(parameters);  
    var currentMessage = subscription.Next();  
    

We get some expressiveness with the names of properties in SubscriptionParameters; but we've now added several lines of code to support SubscriptionParameters because it only introduces an abstraction for the parameters of a single method.  Not without benefit; but kind of an expensive benefit.

There's a few readers who are probably thinking of what C# 4 an offer.  And yes, that's where I'm going next: named parameters.  Given our original example, C# offers the following possibility:
    
    
    var subscription = new Subscription(model: model, queueName: "messages", noAck: false);  
    

This offers the same readability and expressiveness of the Introduce Parameter Object refactoring; but with much less of the overhead.  We don't need a new class with three parameters and we don't need a new method to accept the new parameter object.  But, it still only really addresses a single method.

If we look back at what we get from the fluent builder, it abstracts building a single scenario; a scenario that includes several objects.  This scenario better encapsulates a particular usage pattern, not a particular class.  It better encapsulates our intention to create and use the concept of a Rabbit MQ "subscription"; the fact that a connection and a model are needed truly become implementation details that they are, abstracted within the builder.

