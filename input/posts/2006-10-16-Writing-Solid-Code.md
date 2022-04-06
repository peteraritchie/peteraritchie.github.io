---
layout: post
title: 'Writing Solid Code'
tags: ['C#', 'C++', 'Design/Coding Guidance', 'Software Development', 'msmvps', 'October 2006']
---
[Source](http://blogs.msmvps.com/peterritchie/2006/10/16/writing-solid-code/ "Permalink to Writing Solid Code")

# Writing Solid Code

My apologies to Steve Maguire for "borrowing" a title.

I constantly see code, examples, and advice that perpetuate unsafe coding practices. As programmers we have the habit of getting something to a "working" state and call it "done". This is especially true in processes that have no real architecture or design phases. Over the years, as a society, programmers have begun to realize some of the obvious flaws and have been perpetuating practices and code checkers to avoid such flaws. But, there's still the mentality of "but it works [in my limited tests], how could it be wrong". 

For example, I don't know of any programmers that would sanction the following C++ code:

 int * const p = new int[10];

 p[1] = 10;

 delete[] p;

 if(p[1] == 10)

 {

  puts("ten");

 }

 else

 {

  puts("not ten");

 }

But, "it works" in a release build.

There are many, many similar examples of code that "works" in limited circumstances and this is deemed acceptable by, what seems to be, a majority of programmers. I've seen many discussions of programming constructs that can't work 100% of the time; with impassioned participants that will always argue that either they can prove it works with an example and simply ignore proofs where it fails as "contrived" or statistically insignificant. Although, I don't know of a single programmer that can claim they've never been guilty of this.

From a bricks-and-mortar building standpoint; we, as a society, realized the errors of assuming just 99% is good enough. From this there were the instigation of Engineering certifications/licensing, building standards, etc. All to ensure that 1% was equally as important as the other 99%; to ensureengineers don't unintentionally kill someone. Even with this we're still reminded how important it is to abide by these standards and what happens when we don't (like the Hyatt Regency Walkway Collapse, or the Sampoong Department Store Collapse), despite the likelihood.

To a certain extent, our tools, processes, training, all seem to perpetuate the "good enough" mentality. The ANSI C library is a prime example. Largely designed in the 70's when security wasn't an issue yet, it's rife with functionality to let programmer write buffer overflow code to their heart's content. For example:

#pragma pack(1)

 struct MyStruct

 {

  char s[10];

  int i;

 } myStruct = {"", 1};

#pragma pack(pop)

 sprintf(myStruct.s, "1234567890");

 printf("%d", myStruct.i);

…where the output is "0", not "1"; with nary a compiler warning or runtime error. It's APIs like these and the mentality of "when is that ever going to happen" that lead to software security flaws. Even with continual bombardment of security patches, developers still can't get past the "works 99% of the time" hurdle.

Here issmall list of some of the "hot spots" that will still cause heated discussions even amongst experienced developers:

* .NET: Avoid catch(Exception) in anything other than a last-chance handler.
* C++: Avoid catch(…) in anything other than a last-chance handler.
* Windows: Don't access windows data from a thread that didn't create the window.
* .NET: Avoid Control.Invoke.
* .NET/VB: Avoid DoEvents.
* Performing potentially lengthy operations on the main/GUI thread.
* Testing for valid pointers and IsBad*Ptr().


