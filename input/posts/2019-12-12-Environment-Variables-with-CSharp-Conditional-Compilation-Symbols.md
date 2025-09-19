---
layout: post
title: 'Environment Variables with C# Conditional Compilation Symbols'
categories: ['C#', 'Visual Studio']
comments: true
excerpt: "This how you can get Visual Studio to create compilation symbols based on environment variables like `USERNAME`"
tags: ['.NET', 'C#', 'Visual Studio']
---
Have you ever thought, it would be nice to have a symbol like `PETERRIT` that is unique to your domain account that you could use for code that YOU maybe working on but don't want to break the build?

I occaisionally think I would like to do this:

```csharp
#if PETERRIT
   public class ViolatileExperiment()
   {
     //...
   }
#endif
```
When I think of this I go look at the docs or on Stackoverflow, but I never find anything that allows me to do that.

I had that thought recently and poked around in the Project Settings for a few minutes to see what's going on.  Interestingly `"%USERNAME%"` causes and error, but doesn't break the build.

Damn, I thought.  But % is so... DOS, maybe they use a different delimiter.  So, I stuck in `${USERNAME}`.  Nope.  Then I thought, wait, macros in build events have a specific format!  I entered `$(USERNAME)` and low-and-behold **it worked!**

It's a little wonky though, in the Project Settings it shows the expanded variable (`PETERRIT`), but in the project file it shows the macro reference. (`$(USERNAME)`).  I can see the macro reference getting overwritten from time to time.

Enjoy!
