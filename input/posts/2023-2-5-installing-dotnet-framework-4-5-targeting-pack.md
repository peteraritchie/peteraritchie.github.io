---
layout: post
title: 'Installing .NET Framework 4.5 Targeting Pack'
categories: ['Azure', 'Azure Administrator Associate (AZ-104)']
comments: true
excerpt: 
tags: ['February 2023']
---
![When working in an IDE seems like working with crayons](/assets/DALL·E-2023-02-05-13.14.52--ludites-frustration-with-errors-in-integrated-development-environments-(IDE)-pencil-and-watercolor.png)

Something came up with a client around Live Dependency Validation in Visual Studio recently.  Digging into it I ran into several issues, one of which was the error:

```
Severity	Code	Description	Project	File	Line	Suppression State
Error		The reference assemblies for .NETFramework,Version=v4.5 were not found. To resolve this, install the Developer Pack (SDK/Targeting Pack) for this framework version or retarget your application. You can download .NET Framework Developer Packs at https://aka.ms/msbuild/developerpacks	DependencyValidation	C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\amd64\Microsoft.Common.CurrentVersion.targets	1229	
```

.NET Framework 4.5 has been out of support since 2016, so its targetting pack isn't available for download.  I found a couple blogs posts about editing the modelproj file to add things like `ResolveAssemblyReferenceIgnoreTargetFrameworkAttributeVersionMismatch` or a `PackageReference` to `microsoft.netframework.referenceassemblies.net45` but neither worked.

One of the features of Visual Studio Installers is that they can be a one-stop-shop for all the things you're going to need to develop software (with or without Visual Studio).  One of these features is to install .NET targeting packs!  Although the latest version of Visual Studio doesn't include out-of-support components, prior versions of Visual Studio are available.  Visual Studio 2019 came out before .NET Framework 4.5 was completely unsupported (i.e. still had the option of paid support) so it offers the ability to install some targetting packs that are currently out of support.

You can download older versions of Visual Studio via [https://visualstudio.microsoft.com/vs/older-downloads/](https://bit.ly/vs-old), which seems to redirect you eventually to Visual Studio Subscriptions downloads.  For our purposes, Visual Studio Community Editions works fine.

To install, run the Visual Studio installer that you've downloaded (if you already have 2019 installed, run the already installed Visual Studio Installer and click **Modify**) then click **Continue** to go past the _set up a view things_ dialog. (if you have VS 2022 installed, this seems to do nothing.)

|**Note**|
|-|
|Make sure you don't change any of the _workloads_ (if you have Visual Studio 2019 install already, some may be checked--don't uncheck them, that will uninstall them).|

![Visual Studio Installer](/assets/vs2019-installer-45-targetting-pack.png)

Click on the **Individual Components** tab at the top (to the right of _Workloads_ and to the left of _Language packs_.)  In the .NET section, find an check **.NET Framework 4.5 targetting pack**.

Click **Install** or **Install while downloading**.

Once completed, you now have the .NET Framework 4.5 targetting pack.  If you're doing this in response to a .NET Framework 4.5 targetting pack error message in Visual Studio, exit and re-start Visual Studio--the error should go away (it does with the modelproj error.)

--- 

Incidentally, the other issues I encountered are:

```
Full solution analysis for C# is currently disabled. You may not be seeing all possible dependency validation issues in C# projects. Options... Don't show again 
```
... with no way to enable full solution analysis in a way that this notice recognizes and goes away.

I'd appreciate any advice to resolve that that doesn't involve clicking **Don't show again**.
