---
layout: post
title: 'Using Exceptions For Normal Logic Flow'
tags: ['.NET 2.0', '.NET Development', 'C#', 'Rant', 'msmvps', 'October 2007']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/10/12/using-exceptions-for-normal-logic-flow/ "Permalink to Using Exceptions For Normal Logic Flow")

# Using Exceptions For Normal Logic Flow

The generally accepted wisdom is that you shouldn't use Exceptions for normal logic flow. Normal logic flow is a bit subjective; but anything that must happen at least once in all known scenarios is normal logic flow.

Enter XML Serialization in the framework. The framework actually dynamically creates types that perform the actual serialization of a given type and caches that assembly. The next time that type needs to be serialized it reuses that generated type, reflection is minimized and things happen pretty quickly.

Here's the rub. The framework decides that it must generate the type when Assembly.Load generates an exception. Something like:

  

  Assembly assembly = null;

  try

  {

   assembly = Assembly.Load(assemblyName);

  }

  catch (Exception)

  {

   assembly = GenerateTempAssembly();

  }

Which means exceptions are being used for normal logic flow, because when the code is first runthe exception is thrown. Now, there's some folks out there (includingfolks at Microsoft) that will say "what's wrong with that, it gets the job done doesn't it?". Yes, it does get the job done. The problemis there's at least once that Assembly.Load is going to generate an exception (if you modify thetype being serialized it will happen again). Again,some maysay, "So what?". Well, in Visual Studio there is a BindingFailure Managed Debugging Assistant (MDA) that sits there looking for Assembly.Load failures. This will get kicked off and force a break the first time you try to serialize your type and you're debugging. When you're using XmlSerializer to serialize many different types and you turn on this MDA (after all, it's there and does do some good) then you'll spend a whole bunch of time wading through the BindingFailure MDA.

This has been occurring since XmlSerializer was created. I say "including folks at Microsoft", because up until a couple of days ago I thought someone was on this problem (although I can't find my sources anymore) at Microsoft. But, the problem still occurs in Ocras Beta 2; which means in the past 3-4 years no one has done a thing about this problem. So, I logged a bug about it on Connect (<https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=304095>) and it was quickly closed as "By Design".

Keep in mind, the "fix" were talking about is simply checking to see if a file exists before trying to load it, something like:

  

  Assembly assembly;

  try

  {

   Debug.Assert(assemblyName.CodeBase.StartsWith("file:///", true, System.Globalization.CultureInfo.InvariantCulture));



   String path = assemblyName.CodeBase.Substring(8).Replace('/', '\');

   if (!System.IO.File.Exists(path))

   {

    assembly = GenerateTempAssembly();

   }

   else

   {

    assembly = Assembly.Load(assemblyName);

   }

  }

  catch (Exception)

  {

   assembly = GenerateTempAssembly();

  }

…not too tricky…


