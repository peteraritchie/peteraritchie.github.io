---
layout: post
title: Pass-through Constructors
date: 2008-11-20 19:00:00 -0500
categories: ['.NET Development', 'C#', 'Definition', 'Software Development']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/11/21/pass-through-constructors/ "Permalink to Pass-through Constructors")

# Pass-through Constructors

Pass-through constructors is a term I use to describe parameterized constructors that have none of their own logic and simply pass parameters to the base class.  For example: 

    public class BaseClass

    {

        private String text;

        public BaseClass(String text)

        {

            this.text = text;

        }

    }

 

    public class DerivedClass : BaseClass

    {

        public DerivedClass(String text)

            : base(text)

        {

        }

    } 

