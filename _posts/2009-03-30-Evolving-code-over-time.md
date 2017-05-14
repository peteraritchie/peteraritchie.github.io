---
layout: post
title: Evolving code over time
categories: ['.NET Development', 'C#', 'Design/Coding Guidance', 'Software Development', 'Software Development Guidance', 'Visual Studio 2010 Best Practices']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2009/03/30/evolving-code-over-time/ "Permalink to Evolving code over time")

# Evolving code over time

Given economics, time constraints, resource limitations, etc.; you can't write all the functionality for a given solution for a single release.  Even if you weren't limited by these constraints, you're likely to get changing requirements as development progresses and everyone learns more about the software under development. 

It's fairly easy to prioritize what is developed and what isn't.  You simply develop only what you need (see YAGNI).  But, how do you manage adding new functionality without causing undue grief?  One way is to only make additive changes to the code.  For example, let's say we have the method create CreateRequestPacket that creates a blob of bytes to send to a host over the wire: 

> public static byte[] CreateRequestPacket()   
{   
    byte[] result = new byte[12];   
    result[0] = REQUEST_CODE;   
    result[1] = NO_OPTIONAL_DATA_FLAG;   
    result[2] = (byte) (result.Length – 2); 
> 
>     Random random = new Random();   
    for(int i = 3; i < result.Length; ++i)   
    {   
        result[i] = (byte) (random.Next() % byte.MaxValue);   
    }   
    return result;   
}

 

 

In iteration x it writes out a request making certain assumptions about what the request contains.  But, in iteration y it needs to optionally include other data.  A non additive way is to simply modify CreateRequestPacket to do what is needed: 

> public static byte[] CreateRequestPacket(bool useOptionalData)   
{   
    byte[] result = new byte[12];   
    result[0] = REQUEST_CODE;   
    result[1] = OPTIONAL_DATA_FLAG;   
    int index = 2;   
    if(useOptionalData)   
    {   
        result[index] = GetOptionalData();   
        ++index;   
    }   
    result[index] = (byte) (result.Length – index); 
> 
>     Random random = new Random();   
    for(int i = index + 1; i < result.Length; ++i)   
    {   
        result[i] = (byte) (random.Next() % byte.MaxValue);   
    }   
    return result;   
}

Now all calls to CreateRequestPacket need to change before a build can occure and you might not be able to modify all the files that contain these calls.  So it causes undue blocking and forces you to change a number of files before you can check the file that CreateRequestPacket is contained withing. 

Another way of implementing this would be to implement an additive change.  That is, add a method that does what is needed and change the previous implementation to call the new method.  For example: 

> public static byte[] CreateRequestPacket(bool useOptionalData)   
{   
    byte[] result = new byte[12];   
    result[0] = REQUEST_CODE;   
    result[1] = OPTIONAL_DATA_FLAG;   
    int index = 2;   
    if(useOptionalData)   
    {   
        result[index] = GetOptionalData();   
        ++index;   
    }   
    result[index] = (byte) (result.Length – index); 
> 
>     Random random = new Random();   
    for(int i = index + 1; i < result.Length; ++i)   
    {   
        result[i] = (byte) (random.Next() % byte.MaxValue);   
    }   
    return result;   
} 
> 
> public static byte[] CreateRequestPacket()   
{   
    return CreateRequestPacket(false);   
}

This allows you to check the file that contains CreateRequestPacket in right after passing unit testing and allows you to gradually change all calls to CreateRequestPacket as time permits.

