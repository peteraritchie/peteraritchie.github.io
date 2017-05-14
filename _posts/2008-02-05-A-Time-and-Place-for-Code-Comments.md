---
layout: post
title:  "A Time and Place for Code Comments"
date:   2008-02-04 19:00:00 -0500
categories: ['C#', 'Design/Coding Guidance', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/02/05/a-time-and-place-for-code-comments/ "Permalink to A Time and Place for Code Comments")

# A Time and Place for Code Comments

I've dealt with more than one person who believes all code comments are bad.

The first person I encountered who said that also asked me to explain why a particular algorithm was used instead of another because there were no comments explaining it.

But, one of my primary principles is that you should get the compiler to do as much work as possible when it's compiling.  This has to do with preferring compile-time errors over run-time errors; but it does have an effect on comments.  The result is that they should be avoided in preference to self-commenting code because the compiler does not check them.

I had the misfortune of working with a fellow once you named his variables starting with "a" and continuing alphabetically, adding a character when he ran out of letters.  His code mike look like this:  

  

    
    
        protected Boolean SuspendIfNeeded ( )
    
    
        {
    
    
            Boolean c = this.a.WaitOne(0, true);
    
    
     
    
    
            if (c)
    
    
            {
    
    
                Boolean d = Interlocked.Read(ref this.b.suspended) != 0;
    
    
                a.Reset();
    
    
     
    
    
                if (d)
    
    
                {
    
    
                    /// Suspending…
    
    
                    if (1 == WaitHandle.WaitAny(new WaitHandle[] { d, this.e }))
    
    
                    {
    
    
                        return true;
    
    
                    }
    
    
                    /// …Waking
    
    
                }
    
    
            }
    
    
     
    
    
            return false;
    
    
        }

..very painful.

While self-commenting code makes for code that is more maintainable; there are times where the code doesn't explain some higher-level concepts.  Domain-Driven Design helps to get you in the habit of making domain-specific design artifacts "explicit", which goes a long way to self-commenting code; but it doesn't address vital information like why certain algorithmic decisions were made.

This is one area where refactoring tools don't help.  They will often help deal with XML comments; but inline comments (and comments regarding implementation details don't belong in XML comments) can get lost unless you're paying attention–i.e. avoid refactoring by rote.

