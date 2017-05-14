---
layout: post
title:  "visual studio jedi 2"
date:   2008-11-13 19:00:00 -0500
categories: ['Uncategorized']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/11/14/visual-studio-jedi-2/ "Permalink to visual studio jedi 2")

# visual studio jedi 2

**Project Naming**   
When you create a project that project name is also the name of the namespace.  If you want a particular namespace, enter it with the project name.  If you don't want your binary to contain that namespace, it's easier to rename that in the project properties Build tab than it is to change the default namespace, edit the class files, rename the project, rename folders, etc. 

**Solution Naming   
**When creating solutions it's often best to name the solution differently than the project that you're creating.  When I create a project it will be contained within a solution.  Once that solution is created I will always want to add sibling projects to that solution (like a test project, a front-end (or back-end) Project, a domain/model project, infrastructure project, etc.).  When I create the project and accept the name of the project as also the name of the solution it can be a bit confusing.  For example, if I want to create an n-layer Invoicing application I may need an invoicing front-end application, in which case I may create a project named PRI.InvoicingFrontEnd.  To support that front-end I will have a infrastructure layer project (repositories, application services, etc.), a domain layer project, and a test project.  As projects within a "PRI.InvoicingFrontEnd" this doesn't really make sense.  So, for my solution name I won't accept the same name as the project and enter something more sensible and that doesn't include namespaces. In this case, "Invoicing". 

**Repetitive tasks**   
Some repetitive tasks are easy to accomplish in Visual Studio.  For example, if I wanted to replace the string "wish" with "want" I'd simply to a project/solution-wide search and replace. 

Some repetitive tasks are not so easy.  For example, if I want a search and replace that involves replacing multiple lines, search and replace doesn't work. 

**Rectangular Selections is your friend**   
Many times you have rows of text that you want to incorporate into code.  Sometimes the text is outside the source code, sometimes its not.  An example may be a list of identifier names in a specification.  Sometimes this text is a single column of text that you can just paste into a CS file and search/replace with commas to create a enum.  Sometimes this text is a single column in a multi-column textual table.  This is easy to extract into code without having to come up with a complex regular expression.  Let's say we have tabular text like this: 

Name    Priority    

public enum Keys   
{   
    A = 65,   
    Add = 107,   
    Alt = 262144,   
    Apps = 93,   
    Attn = 246,   
    B = 66,   
    Back = 8,   
//…   
    Y = 89,   
    Z = 90,   
    Zoom = 251   
} 

Rather than 

