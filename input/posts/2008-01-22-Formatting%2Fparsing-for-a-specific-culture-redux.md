---
layout: post
title: 'Formatting/parsing for a specific culture redux'
tags: ['.NET 2.0', '.NET Development', 'C#', '.NET', 'DevCenterPost', 'Framework Bug', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/01/22/formatting-parsing-for-a-specific-culture-redux/ "Permalink to Formatting/parsing for a specific culture redux")

# Formatting/parsing for a specific culture redux

In [recent blog post][1] I detailed how creating a culture via the CultureInfo constructor could actually create a user-overridden culture–which could be completely different than the culture that you've requested by name. Fortunately there's a way of overriding the user override (apologies foroverloading "override") by supplyingthe boolean value "false" ina CultureInfo overload.

As [Greg Beech][2] [commented][3], there's another method to create a culture–[System.Globalization.CultureInfo.CreateSpecificCulture][4]. This sounds like it does exactly what you might expect and creates a "specific" culture. Unfortunately, this method too violates the [principle of least astonishment][5] and creates a culture that uses the user-overridden values when the culture name matches that of the user's current culture.

CreateSpecificCulture does not, as far as I can tell, have an overload/alternative to you allow to to force a "specific" culture, so the problem is much worse with CreateSpecificCulture. I've gone ahead and logged a bug for it on Connect: <https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=321241>

In case you're wondering why this is more serious, consider the following following block of code that formats a date value as text:

  

  

 System.Globalization.CultureInfo ci;

 String text;

 ci = System.Globalization.CultureInfo.CreateSpecificCulture("en-us");

 text = String.Format(ci, "{0:d}", DateTime.Now);

And that textis transmitted to another application (or another session of the same application, e.g. serialization), potentially in another locale, to beparsed with the followingblock of code:

  

 System.Globalization.CultureInfo ci;

 ci = System.Globalization.CultureInfo.CreateSpecificCulture("en-us");

 String text = ReadRecord();

  

 DateTime now = DateTime.Parse(text, ci);

If either (or) the user's current culture is set to "English (United States)"and they've overridden the currency format the short date (say from "M/d/yyyy" to "d/M/yyyy") will randomly result in the wrong date.



[1]: http://msmvps.com/blogs/peterritchie/archive/2007/12/27/formatting-parsing-for-a-specific-culture.aspx
[2]: http://gregbeech.com/blogs/tech/
[3]: http://msmvps.com/blogs/peterritchie/archive/2007/12/27/formatting-parsing-for-a-specific-culture.aspx#1442156
[4]: http://msdn2.microsoft.com/en-us/library/system.globalization.cultureinfo.createspecificculture(VS.80).aspx
[5]: http://en.wikipedia.org/wiki/Principle_of_least_astonishment


