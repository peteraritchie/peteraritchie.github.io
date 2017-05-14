---
layout: post
title:  "Persisting Azure Mobile Services authentication tokens and handling expiry"
redirect_from: "/2013/10/24/persisting-azure-mobile-services-authentication-tokens-and-handling-expiry/"
date:   2013-10-23 12:00:00 -0600
categories: ['.NET Development', 'Azure', 'Azure Mobile Services', 'C#', 'Mobile', 'Visaul Studio 2013', 'Visual Studio 2010', 'Windows Phone', 'Windows Phone 7.1']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2013/10/24/persisting-azure-mobile-services-authentication-tokens-and-handling-expiry/ "Permalink to Persisting Azure Mobile Services authentication tokens and handling expiry")

# Persisting Azure Mobile Services authentication tokens and handling expiry

With Azure Mobile Services, they provide the ability to authenticate users with a variety of providers (Twitter, Facebook, Google, Microsoft, and custom). This is very useful because you **do not** want to implement your own authentication services (ask Adobe).

There's really good documentation around registering providers and performing authentication (see MobileServiceClient.LoginAsync if you're implementing .NET clients).  This effectively lets authenticate a user when your application starts up.  But, you'll likely want to cache that so you can re-use the token across application invocations so you don't have to _always_ ask the user to authenticate upon every start-up.  Unfortunately, this isn't documented as well.  There used to be a way to pass along an IServiceFilter implementation (at least on Windows 8 clients) that could be used to detect 401 errors—and was blog-documented.  This effectively allowed you to re-authenticate the user upon an expired token (there seems to be no direct way to refresh the token—although you could probably get provider information and refresh directly—but that's another day).

But, IServiceFilter seems to be deprecated (or at least not available on Windows Phone [at least with 7.x]).  So, how _do_ you do it on Windows Phone?  Well, when you create a MobileServiceClient object you can pass along one or more HttpMessageHandlers.  HttpMessageHandler is an abstract class that you can implement to "intercept" requests.  You can then detect a 401 error and re-login the user.  HttpMessageHandler is completely abstract; but fortunately there's an implementation that implements the SendAsync method that you can override and _decorate_.  Let's have a look:

Now, of course, this isn't what I started with.  I was working with a Phone 7.1 app in Visual Studio 2010.  (I had just finished getting rid of VS 2012 and installed 2013 when I started this project before I realized VS 2013 doesn't support 7.1—so I was forced to use 2010).  So, for anyone in the same boat, here's similar code without the async/await:

