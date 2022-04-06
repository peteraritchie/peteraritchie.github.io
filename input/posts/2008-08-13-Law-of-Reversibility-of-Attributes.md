---
layout: post
title: 'Law of Reversibility of Attributes'
tags: ['Design/Coding Guidance', 'Software Development', 'msmvps', 'August 2008']
---
[Source](http://blogs.msmvps.com/peterritchie/2008/08/13/law-of-reversibility-of-attributes/ "Permalink to Law of Reversibility of Attributes")

# Law of Reversibility of Attributes

I'vecome up with a simple law called Law of Reversability of Attributes. It's based on the physics law of a similar name. Basically what the law means is that the inverse of a transformation should result in a return to the original state.

The Law of Reversibility of Attributes is defined as:

For a given state of an object; when a attribute's value is changed, the inverse of that value, when applied to that attribute, will result in the object returning to its original state.

I say "attribute" rather than "property" to encompass methods that imply setting of attributes. So, for example
    
    
     myObject.BooleanValue = !myObject.BooleanValue;
    
    
     myObject.BooleanValue = !myObject.BooleanValue;

and
    
    
     myObject.SetBooleanValue(!myObject.GetBooleanValue());
    
    
     myObject.SetBooleanValue(!myObject.BooleanValue());

means _myObject_ will be in the same state after the second line of code than it was before the first line of code.

[UPDATE: interestingly, after I wrote this post–which was delay-published–[Bill Wagner][1] wrote a great [article on a very similar topic][2] in Visual Studio Magazine]

[1]: http://srtsolutions.com/blogs/billwagner/default.aspx
[2]: http://visualstudiomagazine.com/columns/article.aspx?editorialsid=2719


