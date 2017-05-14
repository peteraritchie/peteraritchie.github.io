---
layout: post
title:  "Working with Resharper’s External Annotation XML Files"
date:   2008-07-20 12:00:00 -0600
categories: ['.NET Development', 'Resharper', 'Software Development', 'Visual Studio 2008']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2008/07/21/working-with-resharper-s-external-annotation-xml-files/ "Permalink to Working with Resharper’s External Annotation XML Files")

# Working with Resharper’s External Annotation XML Files

Resharper 4.0 has external annotation XML files that you can create to give Resharper more information about your code.  For example, you can tell Resharper that a particular method does not accept a null argument.  For example, the following method does not accept a null argument:
    
    
    using System;
    
    
     
    
    
    namespace Utility
    
    
    {
    
    
        public static class Text
    
    
        {
    
    
            public static int GetLength(String text)
    
    
            {
    
    
                if (text == null) throw new ArgumentNullException("text");
    
    
                return text.Length;
    
    
            }
    
    
        }
    
    
    }

An external annotation file can be created to inform Resharper of this fact and have it warn you when possible null values are passed as an argument:
    
    
                String text = null;
    
    
                Utility.Text.GetLength(text);

First, you need to create a directory within the Resharper ExternalAnnotations directory.  This ExternalAnnotations directory is usually in the form of "%SystemDrive%Program FilesJetBrainsReSharpervBuild#BinExternalAnnotations" for example "C:Program FilesJetBrainsReSharperv4.0.816.4BinExternalAnnotations".

The directory we need to create is the same name as our assembly (without the extension).  In our case this would be "C:Program FilesJetBrainsReSharperv4.0.816.4BinExternalAnnotationsUtility".

Next, we need to create an XML file to contain the information required by Resharper.  The name of this file is the same as the directory name, plus ".xml".  So, the full file name would be "C:Program FilesJetBrainsReSharperv4.0.816.4BinExternalAnnotationsUtilityUtility.xml".  This file essentially has an assembly element with child member elements that provide meta-data about methods and arguments.  In our case we want to tell Resharper that the Utility.Text.GetLength(String) method does not accept null values for the argument named "text".  To do this we populate the file with the following XML:
    
    
    <?xml version="1.0" encoding="utf-8" ?>
    
    
    <assembly name="Utility">
    
    
        <member name="M:Utility.Text.GetLength(System.String)">
    
    
            <parameter name="text">
    
    
                <attribute ctor="M:JetBrains.Annotations.NotNullAttribute.#ctor" />
    
    
            </parameter>
    
    
        </member>
    
    
    </assembly>

After restarting Visual Studio, Resharper will now warn that "text", when passed to GetLength, in the following code, has a "Possible 'null' assignment to entity marked with "NotNull" attribute".
    
    
                String text = null;
    
    
                Utility.Text.GetLength(text);

I've tried this with the GA build and with both Visual Studio 2005 (SP1) and Visual Studio 2008.

For more information about the annotation options, search for AssertionConditionType in the Resharper help and browse around "%SystemDrive%Program FilesJetBrainsReSharpervBuild#BinExternalAnnotations" for examples.

