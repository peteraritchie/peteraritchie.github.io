---
layout: post
title: 'Who’s Referencing Whom?'
tags: ['.NET 2.0', '.NET Development', 'Debugging', 'Visual Studio 2005', 'msmvps', 'October 2007']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/10/12/who-s-referencing-whom/ "Permalink to Who’s Referencing Whom?")

# Who’s Referencing Whom?

When developing any sort of application, debugging in inevitable. Sometimes, part of that debugging means trying to figure out why objects haven't been collected and therefore figuring out what object is referencing the object that has yet to be collected.

There's many reasons why you'd want to find out what object is referencing, like suspected memory "leaks".

With Visual Studio (and MDbg) you can use a tool called SOS (or SonOfStrike). This is included in the .NET installation. To use SOS you first need to enable unmanaged debugging in your project (ProjectProperties, Debug tab, check "Enable unmanaged code debugging" in the "Enable Debuggers" section). Once unmanaged debugging is enabled you can then debug your application. To use SOS once debugging, you need to load the extension (every time a new debugging session is started). Once a breakpoint has been hit, open the Immediate Window and type .load sos which should result in the following:

  

> .load sos  
extension C:WINDOWSMicrosoft.NETFrameworkv2.0.50727sos.dll loaded

With SOS loaded, you can find out if any objects of a particular type are currently in memory with the "dumpheap -type" command, for example:

  

> !dumpheap -type NamespaceName.TypeName  
Address MT Size  
012b2db8 009159c4 328   
total 1 objects  
Statistics:  
 MT Count TotalSize Class Name  
009159c4 1 328 NamespaceName.TypeName  
Total 1 objects

This lists all objects of the requested type, their address, their MethodTable (MT), and the count of each object per MethodTable.

Once you have the object's address you can then find out what objects are referencing that particular instance. This is done with the gcroot command:

  

> !gcroot 012b2db8  
Note: Roots found on stacks may be false positives. Run "!help gcroot" for  
more info.  
Error during command: warning! Extension is using a feature which Visual Studio does not implement.  
  
Scan Thread 4756 OSTHread 1294  
ESP:12f0dc:Root:012b2db8(WindowsApplication1.Form1)->  
012bb104(WindowsApplication1.Form2)->  
012bb254(System.Collections.Generic.List`1[[NamespaceName.TypeName, WindowsApplication1]])->  
012bc178(System.Object[])->  
012bc16c(NamespaceName.TypeName)  
Scan Thread 3496 OSTHread da8

In this particular example, the above tells us that our object (012bc16c(NamespaceName.TypeName)) is referenced by an Object array (012bc178(System.Object[])), which is referenced by a `List<T>` object (012bb254(System.Collections.Generic.List`1[[NamespaceName.TypeName, WindowsApplication1]])), which is referenced by Form2 (012bb104(WindowsApplication1.Form2)), which is referenced by a Form1 object(ESP:12f0dc:Root:012b2db8(WindowsApplication1.Form1)).  


