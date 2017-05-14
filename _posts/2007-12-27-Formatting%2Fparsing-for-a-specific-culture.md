---
layout: post
title: Formatting/parsing for a specific culture
categories: ['.NET Development', 'C#', 'DevCenterPost']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2007/12/27/formatting-parsing-for-a-specific-culture/ "Permalink to Formatting/parsing for a specific culture")

# Formatting/parsing for a specific culture

Sometimes you may want to use a specific format for formatting and parsing of textual data.  The easiest way to do this is to select a specific culture and use that with formatting and parsing methods.  Unfortunately, the CultureInfo constructor that just takes the name of the culture defaults to accepting any overrides the current user has set in Regional and Language Options.

For example, if in Regional and Language Options you have English (United States) selected and you've changed the currency symbol to be something other than the dollar sign ($), the following won't use the dollar sign:

  

    
    
                Decimal d = 2123.5M;
    
    
                String text = String.Format(new System.Globalization.CultureInfo("en-us"), "{0:c}", d);

If you want to use a specific culture, you must use the CultureInfo constructor overload that accepts a Boolean so you can tell it not to use the user overrides.  For example, the following _will_ result in a dollar sign, despite what the user has done in Regional and Language Options:

  

    
    
                Decimal d = 2123.5M;
    
    
                String text = String.Format(new System.Globalization.CultureInfo("en-us"**, false**), "{0:c}", d);

 

