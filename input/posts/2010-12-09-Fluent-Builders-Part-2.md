---
layout: post
title: 'Fluent Builders Part 2'
tags: ['Uncategorized', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2010/12/09/fluent-builders-part-2/ "Permalink to Fluent Builders Part 2")

# Fluent Builders Part 2

In this part I'm going to go into the principles behind a fluent builder.

Fluent builders don't simply provide a method for each argument a constructor (or other method) may take, they provide consistency when providing related arguments.

In my fluent builder example I had a WithCredentials method on the builder that take two related arguments: a username and a password. I could have just as easily have a WithPassword and WithUserName method and used it like this:
    
    
    Subscription subscription = newRabbitMQSubscriptionBuilder()  
    .WithUserName("pQowiht12glsh%d")  
    .ToHost("localhost", 8181)  
    .WithPassword("i21uWghe&gjs")  
    .SubscribeToQueue("messages");  
    



We achieve the same result; but now we can have username and password disconnected with this new interface. It's not clear that username and password go hand-in-hand.

A fluent builder is all about readability and expressiveness. It's about using basic compiler tricks to maintain consistency while providing an expressive and readable interface. The very nature of chained method calls is basically a violation of the Law of Demeter, for example—depending on your interpretation. Builders are transient containers of data that transform data into the creation of an object. They're not modeling domain behaviour; they're strictly utility. So they don't have to completely abide by object-oriented design principles.

There's been a couple of comments about the property with only a getter that has side-effects. For classes that model domain behaviour, I completely agree that getters with side-effects are an abomination. But, we're not modeling domain behaviour with builders; we're simply attempting to provide the most expressive interface to build object so that it's readable by just about anyone reading the code. The fact that WithAcknowledgements is a property with only getter that has side-effects is moot. It could have been implemented with a method with no parameters; but that doesn't add any expressiveness nor add to readability at all—it just adds more typing.

We're trying to define an interface that allows the programmer to convey intent. WithAcknowledgements as a property or a method that takes no arguments shows much more intent than WithAcknowledgementsEnabled(bool).

In my original example, I should have also included WithoutAcknowledgements in order for the programmer to accurately convey that they understand the default values. We'd end up being able to convey that intent nicely with code like this:
    
    
    Subscription subscription = newRabbitMQSubscriptionBuilder()  
    .WithCredentials("pQowiht12glsh%d", "i21uWghe&gjs")  
    .ToHost("localhost", 8181)  
    .WithoutAcknowledgements  
    .SubscribeToQueue("messages");  
    

I've also chosen to use an implicit cast operator to convert the builder to the object it builds and chosen in my example to not use an implicitly typed variable as the for the object created by the builder. My views on implicitly typed variables are pretty well known. Should a programmer using this interface accidentally used an implicitly typed variable; they'd quickly have a compile error; so, I don't feel there's much issue with this technique. If implicitly typed variables are a preference, the programmer could write code like this:
    
    
    var subscription = (Subscription)newRabbitMQSubscriptionBuilder()  
    .WithCredentials("pQowiht12glsh%d", "i21uWghe&gjs")  
    .ToHost("localhost", 8181)  
    .WithoutAcknowledgements  
    .SubscribeToQueue("messages");  
    

Not much more ore less expressive than the original; but a little bit more typing. Sure, there could be a method that terminates the method chain like "Build" and we could do this:
    
    
    var subscription = newRabbitMQSubscriptionBuilder()  
    .WithCredentials("pQowiht12glsh%d", "i21uWghe&gjs")  
    .ToHost("localhost", 8181)  
    .WithoutAcknowledgements  
    .SubscribeToQueue("messages")  
    .Build();  
    

But, it's no more expressive that our previous version. Plus, there's an implied order to the call to Build: it always has to be at the end. This seems like unnecessary ceremony.

## Other Practices

Generally methods are prefixed with "With" to convey that builder is building up an object through a series of additions. But, when another prefix would add more expressiveness or clarity, that prefix should be preferred over "With". The "ToHost" is a good example. The builder is creating an object that connects to a remote host; "With" could be ambiguous. "ToHost" conveys better that the resulting object connects **to** a host of given name and port.

I hope this short excursion into fluent builders and fluent interfaces has given you the motivation to add expressiveness to your code where you find long strings of meaningless parameters. By all means you should implement your builders that are most expressive to you; but don't let strict adherence to object-oriented principles make these utilitarian classes more complex than they need to and end up hindering your expressiveness.


