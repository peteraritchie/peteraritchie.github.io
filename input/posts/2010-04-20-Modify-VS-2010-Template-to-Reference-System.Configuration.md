---
layout: post
title: 'Modify VS 2010 Template to Reference System.Configuration'
tags: ['.NET Development', 'C#', 'DevCenterPost', 'Software Development', 'Visual Studio 2010', 'WinForms', 'msmvps', 'April 2010']
---
[Source](http://blogs.msmvps.com/peterritchie/2010/04/20/modify-vs-2010-template-to-reference-system-configuration/ "Permalink to Modify VS 2010 Template to Reference System.Configuration")

# Modify VS 2010 Template to Reference System.Configuration

Almost every project I create in Visual Studio, I invariably have to add System.Configuration to the references for that project. As soon as I want to do much with app.config, I need to use something in System.Configuration. Well, rather than continue to add that reference to future projects, I've decided to change the project template so I don't have to. The following is a description of how to do that. 

The project templates are located at **C:Program FilesMicrosoft Visual Studio 10.0Common7ideProjectTemplates** (replace "Program Files" with "Program Files (x86)" if you're using a 64-bit version of Windows). For this example I'm going to change the C# Windows Forms Application template. Each language has their own directory and each template is localized to multiple languages. For me, my locale code is 1033, so the Windows Forms Application template is located in **CSharpWindows1033WindowsApplication.zip**. To modify anything in the template we need to extract the contents. This is best done by copying the file to your Documents directory then extracting the contents (in Windows 7, you'll get lots of UAC prompts when you start editing files in Program Files, so this makes life a little easier). Go ahead and make a backup of this file now. 

For what we want to do, we want to _edit the **windowsapplication.csproj**_ file, so open that in notepad. We want to change references, so we need to edit the Reference elements, so search for "<Reference". This will put you at a section of the file that looks like this:   
 <ItemGroup>   
 <Reference Include="System"/>   
 $if$ ($targetframeworkversion$ >= 3.5)   
 <Reference Include="System.Core"/>   
 <Reference Include="System.Xml.Linq"/>   
 <Reference Include="System.Data.DataSetExtensions"/>   
 $endif$   
 $if$ ($targetframeworkversion$ >= 4.0)   
 <Reference Include="Microsoft.CSharp"/>   
 $endif$   
 <Reference Include="System.Data"/>   
 <Reference Include="System.Deployment"/>   
 <Reference Include="System.Drawing"/>   
 <Reference Include="System.Windows.Forms"/>   
 <Reference Include="System.Xml"/>   
 </ItemGroup>

We want to add a reference to System.Configuration, so go ahead and add '<Reference Include="System.Data"/>' as the first item in the ItemGroup. We also want to remove references to System.Xml and System.Xml.Linq. Heck, while we're at it, let's also get rid of other references I don't use that much: System.Data.DataSetExtensions and Microsoft.CSharp. This leaves us with something like:   
 <ItemGroup>   
 <Reference Include="System.Configuration"/>   
 <Reference Include="System"/>   
 $if$ ($targetframeworkversion$ >= 3.5)   
 <Reference Include="System.Core"/>   
 $endif$   
 <Reference Include="System.Data"/>   
 <Reference Include="System.Deployment"/>   
 <Reference Include="System.Drawing"/>   
 <Reference Include="System.Windows.Forms"/>   
 </ItemGroup>

Now, save the file. 

If you're removing other references (like System.Core) you'll have to also edit some of the .cs files in the template to make sure they're not referencing namespaces within the removed references (like System.Linq in form1.cs). If you need to do that, go ahead and do that as well. 

Now, we need to take all those files and _re-zip them back into a file named WindowsApplication.zip_. Once we do that we can _copy that back into **c:Program FilesMicrosoft Visual Studio 10.0Common7ideProjectTemplatesCSharpWindows1033** _directory. Visual Studio also caches the files in the templates. There's a way to get VS to reconstruct that cache, but, it's easier to simply _copy the files from the WindowsApplication.zip file into the cache directory located at **C:Program Files (x86)Microsoft Visual Studio 10.0Common7IDEProjectTemplatesCacheCSharpWindows1033WindowsApplication.zip**_. This is actually a directory, not a ZIP file. Go ahead and copy all the files (or at least the ones you've modified to this directory. 

And we're done. Now, _restart VS_, and create a new Windows Forms Application project. You'll see that References in the Solution Explorer look something like this:

![project references][1]

No more System.Xml.*, Microsoft.CSharp, System.Data.DataSetExtensions and System.Configuration is now there.

Enjoy!

[1]: http://msmvps.com/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/peterritchie.metablogapi/0842.projectreferences_5F00_thumb_5F00_5862FABB.png "project references"


