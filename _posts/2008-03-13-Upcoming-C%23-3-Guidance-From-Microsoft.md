---
layout: post
title:  "Upcoming C# 3 Guidance From Microsoft"
date:   2008-03-12 12:00:00 -0600
categories: ['.NET 3.5', '.NET Development', 'C# 3.0', 'Design/Coding Guidance', 'DevCenterPost']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/03/13/upcoming-c-3-guidance-from-microsoft/ "Permalink to Upcoming C# 3 Guidance From Microsoft")

# Upcoming C# 3 Guidance From Microsoft

Mircea Trofin has some [design guidelines with regard to some C# 3 language additions][1] (that I assume will make it into a revised Framework Design Guidelines of some sort).  They more less agree with the [guidelines I published][2] in Code Magazine a while ago.  There are some slight differences:

_**Consider **using extension methods in any of the following scenarios: to provide helper functionally relevant to every implementation of an interface_… and,

_**Do** define extension methods in the same namespace as the extended type, if the type is an interface, and if the extension methods are meant to be used in most or all cases._  This applies to framework designers that are publishing interfaces but also want to publish callable methods that apply to all implementation of those interfaces.  My article approaches the guidelines more from a non-framework designer.  I do agree that extension methods to extend interfaces is very useful and is probably one of the most adept use of extension methods.  Although, I think the wording of this guideline could use improvement.

_**Avoid** defining extension methods on System.Object, unless absolutely necessary_.  Good advice.

_**Do not** define extension methods pertaining to a feature in namespaces normally associated with other features.  Instead define them in the namespace associated with the feature they belong to, or a namespace of it._  This is really unclear (and seems to suggest contradicting the first guideline: _Avoid frivolous use of the extension methods feature when defining methods on a new type.  Use the canonical, language-specific means for defining type members_).  I'm assuming the jist of this is, as a framework designer, don't arbitrarily put extension methods in the namespace of the type the method applies to, consider putting the extension method in a more applicable namespace, if possible.  For example, if you want to declare an extension method "Forward" for Telecom.INode implementations, putting the method in a "Routing" namespace would be better than arbitrarily putting it in the "Telecom" namespace.  I've changed the Mircea's guidance slightly to use a interface in the example–which I think makes it more clear.

Mircea also includes _**Consider** using extension methods in any of the following scenarios:… when object model considerations would dictate taking a dependency on some assuming but taking such a dependency would break dependency management rules_.  This means, should you need to add a method to a class but adding that method would create cyclic dependency or would cause a lower level assembly/class to be dependant on a higher level class, break the method out into another assembly as an extension method.  Use this advice with caution; I would argue that if you think you need a method like this at all (even if implemented as an extension method), you likely have some design problems and should only be considered when revising a published framework, and not when creating a new framework.

Another tidbit of guidance that came about after I wrote the article and Mircea doesn't mention is that [extension methods can make writing fluent interfaces much cleaner][3] by separating the state management concern of supporting a fluent interface from the class that it applies to.

Thoughts?  Any additional guidance you feel has been overlooked (with regard to extension methods and LINQ)?

![kick it on DotNetKicks.com][4]

[1]: http://blogs.msdn.com/mirceat/archive/2008/03/13/linq-framework-design-guidelines.aspx
[2]: http://www.code-magazine.com/Article.aspx?quickid=0801061
[3]: http://codebetter.com/blogs/gregyoung/archive/2007/12/05/a-use-for-extension-methods.aspx
[4]: http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fmsmvps.com%2fblogs%2fpeterritchie%2farchive%2f2008%2f03%2f13%2fupcoming-c-3-guidance-from-microsoft.aspx

