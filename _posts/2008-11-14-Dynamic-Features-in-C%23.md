---
layout: post
title: Dynamic Features in C#
categories: ['C# 4']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/11/14/dynamic-features-in-c/ "Permalink to Dynamic Features in C#")

# Dynamic Features in C#

.NET is the evolution of COM.  .NET was rumoured to be originally called COM+ 2.5. 

.NET has evolved well beyond COM and while it fulfils many of the goals that COM originally tried to fulfil, .NET removes many of the COM trappings that developers have to deal with. 

C# is a .NET language with C++ heritage.  C++, unlike VB is not a dynamic language.  C# was only dynamic in that it provided COM interop abilities.  You can program to any COM API you like, as long as you know what you're talking to.  This is generally not a problem for 99% of COM libraries.  But, COM libraries offer the ability to be strongly typed and/or completely dynamic.  This means a method may return a value that simply isn't known until runtime.  In C#, if you know what the type of that value will be a runtime, you  can simply cast it to that type and it will work fine a runtime–sort of hiding the fact that it's really dynamic.  If you debug C# code that deals with COM APIs, you may have noticed the type of some COM objects are __ComObject–encapsulating the fact that type information doesn't really exist until runtime. 

The problem with dealing with some dynamic COM APIs is that what the actual type of some return values simply isn't documented at runtime.  In dynamic languages you can write things like this: 

var obj = GetSomeObject();   
obj.SomeMethod(); 

"SomeMethod" simply won't be resolved until runtime.  The above code effectively means "after you get the object from the GetSomeObject method, query the object for information about the "SomeMethod" method and if it exists, invoke it.  This is like duck typing. 

I say 99% of COM APIs because most COM APIs are written to be consumed by strongly-typed languages like C++.  But, COM doesn't require an object to have a strong type; an API can be written that completely relies upon checking for members at runtime. 

This has been a problem with C# because it simply hadn't supported that.  As I said, you can get around types with methods that return dynamic types through casting; but if that type is never concretely defined anywhere that cast would be impossible. 

C# 4 adds dynamic support to the language so it can now support circumstances like this.  It also makes consuming some COM APIs much easier because you don't have to know specific type information at compile-time.  You can get by with member names and leave it to the runtime to find the physical members for you, at run-time. 

Oddly, the Visual Studio automation and extensibility API is based on this dynamic ability.  Mostly legacy because Visual Studio has been around well before .NET and has supported automation and extensibility since then.  This extensibility was based on COM.  We have Visual Studio support .NET now, but the evolution of that extensibility has continued to support COM.  Plus, Visual Studio also supports non .NET languages and thus must support extensibility with those languages and COM is generally accepted means of doing that. 

For the most part, the extensibility model of Visual Studio is documented in VB.  In VB you have much more freedom to accept dynamic APIs.  Let's have a look at some examples from the documentation: 

