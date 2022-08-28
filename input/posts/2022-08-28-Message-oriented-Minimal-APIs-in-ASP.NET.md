---
layout: post
title: 'Message-oriented Minimal APIs in ASP.NET Core'
categories: ['ASP.NET', 'Minimal APIs', 'Event-Oriented']
comments: true
excerpt: "Simplifying the implementation of APIs with ASP.NET Minimal APIs and event-orientation."
tags: ['August 2022']
---
TL;DR - [go to the implementation details](#implementation-details)

First of all, what is message-oriented?  Like many things in technology and life, terms like "oriented" are frequently used whose meaning may not be immediately connected to its usage.  Object-oriented, message-oriented, aspect-oriented, etc. have a vague meaning when used, which can sometimes introduce a lack of clarity.

*-Oriented means that a particular concept always taken into consideration and utilized in the specified circumstances.  Message-oriented means that interactions between concepts _at a certain layer_ involve messages.  This is sometimes referred to as Message Passing; or that communication between layer-specific concepts it done by passing messages to each other.

Things can be oriented in many ways at the same time.  A system may be simultaneously message-oriented and object-oriented, for example--which usually means that what produces and consumes messages are implemented as _objects_.

<!--Some may say that the Command Pattern is message-oriented.  For the purposes of this article, that's not the complete story.  A command can (and should) be a message; but a message on it's own does not constitute message-orientation.  Falling back to Message Passing, it's how the command is communicated is what makes a component message-oriented.

## Is HTTP Message-Oriented?

Yes, HTTP is message-oriented.  Underlying layers (like TCP) implement HTTP via frames and streams (and packets, datagrams, etc.) but at the HTTP layer, communication between major concepts is done with what is called "messages".
-->
## Being Message-Oriented

Message-orientation demands a level of loose coupling.  In object-oriented message-orientation objects donn't communicate with each other directly, a third-party transports message from the sender (or producer) to the receiver (or the consumer).  There an many ways that can happen: queues (or simply collections), mediators, buses, etc.  The type of the third-party component depends on the degree of loose coupling and how much work the third party takes on to transport those messages.  For the purposes of this article I'll focus on _Bus Architecture_.  Bus Architecture is a combination of a common data model, a common command set, and an infrastructure that provides a shared set of interfaces to transport messages.

## Being Successfully Message-Oriented

As with any layered architecture, implementation details at different layers allow us to compartmentalize different concerns to ease understanding and simplify implementation.  Message-oriented systems often classify messages to better implement and support a subdomain.  Messages are often classified as commands, events, or documents to better support common subdomain and communication scenarios.  Commands are messages that communicate a request or imperative intent.  Events are messages that communicate or encapsulate a change in state.  And documents are messages that contain data independent of a command or an event.

## Why Minimal APIs?

You may have read articles like "[MVC Controllers are Dinosaurs - Embrace API Endpoints](https://ardalis.com/mvc-controllers-are-dinosaurs-embrace-api-endpoints/)" that suggest that modern MVC implementation have controllers that don't actually "control" anything.  MVC details that Models, Views, and Controllers are decoupled from one another and cohesive in and of themselves.  Controllers should interpret input and convert it into invocations upon the model and the view.  Models are a dynamic data structure that directly manages data, logic, and rules for a given context.  When MVC was devised, the controller was far closer to the user and took on more responsibility to imperatively translate and route data.  With modern systems and technologies like JSON and programming language syntax, much of that translation and routing can be declarative--wiring up a request, its route, and the receiver of the command directly.

|As an aside, many have argued that _model_ and _view_ have been muddied and that _view_ doesn't exist with RESTful APIs, questioning "MVC" implementations altogether.|
|:-:|

When you don't really have a controller and data translation occurs under the hood, going through the motions of controllers and models with core subdomain objects is viewed as needless ceremony.

## Message-Oriented Frameworks

I've been working with a simple-but-no-simpler messaging library for several years.  It's a set of libraries that I maintain called `[PRI.Messaging](https://github.com/peteraritchie/Messaging)`.  It consists of primitive types (abstractions) (`PRI.Messaging.Primitives`) and pattern implementations (`PRI.Messaging.Patterns`).  It makes ideas like consumers, producers, and buses first-class concepts.  PRI.Messaging.Patterns includes a bus implementation that assumes the role of dependency injection and message routing, allowing you to simply create message producers, message consumers, and have them automatically wired-up and messages routed appropriately.

I'll be using these libraries to implement message-oriented minimal APIs in ASP.NET Core 6+.

## Implementation Details

For simplicity, I'll show making the default project created for minimal APIs message-oriented; get ready for some weather forecasting.

Starting with creating the default project:

```powershell
dotnet new webapi -minimal -o WebApi
dotnet new sln -n example
dotnet sln example.sln add WebApi
```

This gives us OpenAPI (Swagger) and HTTPs support along with a single `weatherforecast` endpoint and a `WeatherForecast` response model (message).

The important code from Program.cs:

```csharp
var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/weatherforecast", () =>
{
    var forecast =  Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
})
.WithName("GetWeatherForecast")
.WithOpenApi();

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
```

To become message-oriented we need to first create explicit messages to represent the interactions.  For this I've created a `GetWeatherForecastCommand` command and a `WeatherForecastedEvent` event:

```csharp
public class GetWeatherForecastCommand : ICommand
{
    public string CorrelationId { get; set; } = Guid.NewGuid().ToString();
}
```

```csharp
public class WeatherForecastedEvent : IEvent
{
    public WeatherForecast[] Forecasts { get; }

    public WeatherForecastedEvent(WeatherForecast[] forecasts)
    {
        Forecasts = forecasts;
    }

    public DateTime OccurredDateTime { get; set; } = DateTime.UtcNow;
    public string CorrelationId { get; set; } = Guid.NewGuid().ToString();
}
```

Now we need something that explicitly handles (consumes) the `GetWeatherForecastCommand` command produces the `WeatherForecastedEvent` event.  I prefer to call these types of things "Command Handlers".  So,:

```csharp
public class GetWeatherForecastCommandHandler : IConsumer<GetWeatherForecastCommand>, IProducer<WeatherForecastedEvent>
{
    private IConsumer<WeatherForecastedEvent> consumer = new ActionConsumer<WeatherForecastedEvent>((_) => { });

    public void AttachConsumer(IConsumer<WeatherForecastedEvent> consumer)
    {
        this.consumer = consumer;
    }

    private readonly string[] summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    public void Handle(GetWeatherForecastCommand message)
    {
        var forecasts = Enumerable.Range(1, 5).Select(index =>
            new WeatherForecast
            (
                DateTime.Now.AddDays(index),
                Random.Shared.Next(-20, 55),
                summaries[Random.Shared.Next(summaries.Length)]
            ))
            .ToArray();

        consumer.Handle(new WeatherForecastedEvent(forecasts));
    }
}
```

As you'll see in this command handler, I've moved the implementation details from Program.cs and encapsulated them into this class (i.e. `summaries` and the creation of the `WeatherForcast` array.)

Returning to Program.cs, we now need to inject a `Bus` service and update the route endpoint to accept a bus instance, translate to our command, and send it to the bus.

```csharp
app.MapGet("/weatherforecast", async (IBus bus) =>
{
    WeatherForecastedEvent result =
        await bus.RequestAsync<GetWeatherForecastCommand, WeatherForecastedEvent>(
            new GetWeatherForecastCommand());
    return Results.Ok(result.Forecasts);
})
.WithName("GetWeatherForecast")
.WithOpenApi();
```

The `IBus` `RequestAsync` extension method implements the asynchronous request-reply pattern.

With our messages, consumers, and producers we can now create a message bus singleton and have it wire-up the producers and the consumers.  This is simply done by invoking the `IBus.AddHandlersAndTranslators` method in addition to registering a singleton bus:

```csharp
IBus bus = new Bus();
bus.AddHandlersAndTranslators(
    Path.GetDirectoryName(typeof(Program).Assembly.Location)!,
    Path.GetFileName(typeof(Program).Assembly.Location), "");
builder.Services.AddSingleton(bus);
```

## Summary

As you can see, the route endpoint has an `IBus` injected into it (i.e. Dependency Injection) and is only concerned with sending a `GetWeatherForecastCommand` message and receiving a `WeatherForecastedEvent` message. Where that command goes and where the event comes from (and how it gets created) are irrelevant (i.e. neither knows nor cares about `GetWeatherForecastCommandHandler`).  With the implementation details of weather forecasting moved out into `GetWeatherForecastCommandHandler` those details are now longer directly coupled to a web API.  `GetWeatherForecastCommandHandler` exists in its own library and can be used by several types of applications.  `GetWeatherForecastCommandHandler` could be used, as is, within a console application, a PowerShell CmdLet, etc.  As with any well designed loosely coupled system, it's just a matter of correctly setting up a service container for the specific circumstances.

How will you use event-orientation?

## References

- [MVC Controllers are Dinosaurs - Embrace API Endpoints | Ardalis Blog](https://ardalis.com/mvc-controllers-are-dinosaurs-embrace-api-endpoints/)
- [PRI.Messaging - GitHub](https://github.com/peteraritchie/Messaging)
- [PRI.Messaging.Primitives - Nuget](https://www.nuget.org/packages/PRI.Messaging.Primitives/3.0.0-beta)
- [PRI.Messaging.Patterns - Nuget](https://www.nuget.org/packages/PRI.Messaging.Patterns/3.0.0-beta)
- [Asynchronous Request-Reply Pattern - Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/patterns/async-request-reply)
- [Request-Reply Messaging Pattern - Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com/RequestReply.html)
