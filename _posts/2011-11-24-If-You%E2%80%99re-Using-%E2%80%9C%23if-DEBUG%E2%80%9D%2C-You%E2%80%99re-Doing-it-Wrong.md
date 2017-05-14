---
layout: post
title: If You’re Using “#if DEBUG”, You’re Doing it Wrong
categories: ['.NET Development', 'C#', 'Code Contracts', 'DbC', 'Design/Coding Guidance', 'DevCenterPost', 'Software Development Guidance', 'Software Development Principles']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2011/11/24/if-you-re-using-if-debug-you-re-doing-it-wrong/ "Permalink to If You’re Using “#if DEBUG”, You’re Doing it Wrong")

# If You’re Using “#if DEBUG”, You’re Doing it Wrong

I was going through some legacy code the other day, refactoring it all over the place and I ran into many blocks of code wrapped in "#if DEBUG".  Of course, after a bit of refactoring in a RELEASE configuration these blocks of code were quickly out of date (and by out of date, I mean no longer compiling).  A huge PITA.

For example, take the following code:
    
    
    	public class MyCommand
    	{
    		public DateTime DateAndTimeOfTransaction;
    	}
     
    	public class Test
    	{
    		//...
    		public void ProcessCommand(MyCommand myCommand)
    		{
    #if DEBUG
    			if (myCommand.DateAndTimeOfTransaction > DateTime.Now)
    				throw new InvalidOperationException("DateTime expected to be in the past");
    #endif
    			// do more stuff with myCommand...
    		}
    		//...
    	}
    

If, while my active configuration is RELEASE, I rename-refactor DateAndTimeOfTransaction to TransactionDateTime then the block of code in the #if DEBUG is now invalid—DateAndTimeOfTransaction will not be renamed within this block.  I will now get compile errors if I switch to DEBUG configuration (or worse still, if I check in an my continuous integration environment does a debug build).

I would have run into the same problem had I been in a DEBUG configuration with all the "#if RELEASE" blocks.  Yes, I could create a configuration and define DEBUG **and** RELEASE and do my work in there.  Yeah, no, not going down that twisted path… i.e. try doing it without manually adding a conditional compilation symbol.

I got to thinking about a better way.  It dawned on me that #if blocks are effectively comments in other configurations (assuming DEBUG or RELEASE; but true with any symbol) and that [comments are apologies][1], and it quickly became clear to me how to fix this.

Enter Extract Method refactoring and Conditional Methods.  If you've been living under a rock or have simply forgotten, there exists a type in the BCL: System.Diagnostics.ConditionalAttribute.  You put this attribute on methods that[whose calls] may or may not be included in the resulting binary (IL).  But, they are still compiled (and thus syntax checked).  So, if I followed the basic tenet for [code comment smells][2] and performed an Extract Method refactoring and applied the ConditionalAttribute to the resulting method, I'd end up with something like this:
    
    
    		//...
    		public void ProcessCommand(MyCommand myCommand)
    		{
    			CheckMyCommandPreconditions(myCommand);
    			// do more stuff with myCommand...
    		}
     
    		[Conditional("DEBUG")]
    		private static void CheckMyCommandPreconditions(MyCommand myCommand)
    		{
    			if (myCommand.DateAndTimeOfTransaction > DateTime.Now)
    				throw new InvalidOperationException("DateTime expected to be in the past");
    		}
    

 

Now, if I perform a rename refactoring on MyCommand.DateAndTimeOfTransaction, **all** usages of DateAndTimeOfTransaction get renamed and I no longer introduce compile errors.

### Code Contracts

If you look closely at the name I chose for the extracted method you'll notice that what this DEBUG code is actually doing is asserting method preconditions.  This type of thing is actually supported in [Code Contracts][3].  Code Contracts implement a concept called [Design by Contract][4] (DbC).  One benefit to DbC is that these checks are effectively proved at compile time so there's no reason to perform this check at runtime or [even write unit tests to check them][5] because code to violate them becomes a "compile error" with Code Contracts.  But, for my example I didn't use DbC despite potentially being a better way of implementing this particular code.

Anyone know what we call a refactoring that introduces unwanted side-effects like compile errors?

[UPDATE: small correction to the description of conditional methods and what does/doesn't get generated to IL based on comment from Motti Shaked]

[1]: http://bit.ly/vDJekK
[2]: http://bit.ly/47Ld1d
[3]: http://bit.ly/s23uAU
[4]: http://bit.ly/szEmTc
[5]: http://bit.ly/tYnSGC

