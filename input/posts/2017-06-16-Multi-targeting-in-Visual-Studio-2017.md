---
layout: post
title: 'Multi-targeting in Visual Studio 2017'
categories: ['June 2017', 'Multi-targeting', '.NET Core', '.NET Standard', 'Visual Studio 2017']
comments: true
excerpt: "An effective way to target multiple platforms in Visual Studio 2017 and easily generate a Nuget package."
tags: ['Visual Studio 2017', '.NET']
---
I've got a few OSS projects on the go that have evolved over time enough that some target more than one version of .NET.  Recently I started adding support to some of those projects for .NET Standard and .NET Core. Traditionally I've attempted to support multiple targets with multiple projects: since there's a single target framework in a project.  This has served me well over the years.  Here's some details:

Once you've got a project on the go and a Nuget package being used, Microsoft releases a new framework.  Eventually there may be something you need to support but can't just drop your assembly that only supports the previous version, so you you create new project targeting the new framework.  Usually a new framework is backwards compatible with the version you're already deploying for, so all the code you currently have should work fine with the new framework.  The best way I've found so far is to simply link to all the existing files in the new project.  In Solution Explorer, right-click the new project and click **Add&#9658;Existing File&hellip;** and select the files you want to add as a link and click the &#9658; in the **Add &#9658;** button and click **Add Link**. This adds links to the files from another projetc so each file is shared across the two projects.  If you edit one, you edit for both (or all projects).  If you have a lot of files across more than few directories, you'll quickly notice that using the **Add&#9658;Existing File&hellip;** dialog will be a huge chore.  An easier way is to select the files in the previous project in Solution Explorer and drag and drop the files you want to share while holding the **Alt** key to the new project.  This will add links to your new project.  At this point, the project should compile and effectively give you an identical class library that supports the new framework.  For any new framework features you want to support, simply add them as new files into the project for that framework (remember `partial` if you want to add new framework functionality to an existing class.  In rare cases you may need to add a some compile-time constants like `NET40` and `NET45` to each project so that you can wire-off specific functionality in a shared file.

Now when you want to generate your new Nuget package, you can copy the library dlls into a convention-based folder that Nuget understands.  For example:

    \lib
        \net40
            myassembly.dll
        \netstandard1.3
            musassembly.dll

For example, one of my OSS projects, files are copied into a Nuget-convention `lib` folder like this:

    copy Pri.LongPath.net40\bin\Release\Pri.LongPath.dll nuget\lib\net40
    copy Pri.LongPath.net200\bin\Release\Pri.LongPath.dll nuget\lib\net20

Then Nuget just packages things properly.

This works, but realistically it's quite a bit of work.  Over time you get more and more projects, and if you have lots of files, you have more and more files in Solution Explorer and performance seems to suffer.

Fortunately, I've found that there's a much better way in Visual Studio 2017 and the new csproj files: via the [TargetFrameworks] element.  There does not seem to be support for this in the Visual Studio UI yet, so you have to manually edit your csproj to add support for multiple frameworks; but that's easy with the new csproj files because you can simply edit them in Visual Studio 2017 (right-click project in Solution Explorer and select **Edit**).  Once there, simply rename the `TargetFramework` element to `TargetFrameworks` (note the 's' suffix).  For example, if you create a .NET Standard class library, the csproj will contain the following:

    <Project Sdk="Microsoft.NET.Sdk">
 
    <PropertyGroup>
        <TargetFramework>netstandard1.3</TargetFramework>
    <!-- ... -->

to support .NET Standard 1.3 *and* .NET 4.6.2, change that to the following:

    <Project Sdk="Microsoft.NET.Sdk">
 
    <PropertyGroup>
        <TargetFrameworks>netstandard1.3;net462</TargetFrameworks>
    <!-- ... -->

Note the use of semicolons to separate framework monikers.

This method means that the one project is built for each framework and all the files are shared amongst those builds.  This means you have to resort to compile-time constants to signify framework-specific code.  Fortunately Visual Studio (or really the build system) knows about our multi-targeting, so it automatically provides compile-time constants.  The following table shows current compile-time constants (and the convention it uses, for future framework versions :) ):

    .NET Framework 2.0   --> NET20
    .NET Framework 3.5   --> NET35
    .NET Framework 4.0   --> NET40
    .NET Framework 4.5   --> NET45
    .NET Framework 4.5.1 --> NET451
    .NET Framework 4.5.2 --> NET452
    .NET Framework 4.6   --> NET46
    .NET Framework 4.6.1 --> NET461
    .NET Framework 4.6.2 --> NET462
    .NET Standard 1.0    --> NETSTANDARD1_0
    .NET Standard 1.1    --> NETSTANDARD1_1
    .NET Standard 1.2    --> NETSTANDARD1_2
    .NET Standard 1.3    --> NETSTANDARD1_3
    .NET Standard 1.4    --> NETSTANDARD1_4
    .NET Standard 1.5    --> NETSTANDARD1_5
    .NET Standard 1.6    --> NETSTANDARD1_6 

For example:

	#if (NET45 || NET451 || NET452 || NET46 || NET461 || NET462)

		public static Task ConnectAsync(this TcpClient tcpClient, EndPoint endPoint)
		{
			//...
		}
	#endif

To edit code in the context of a particular framework (and thus have the particular compile-time constants defined) you can select the file projects dropdown to show the file in the compiler context of the target:

![file projects dropdown](/assets/file%20projects%20dropdown.png)

Now when you build the project it will create a binary for each target platform (within the bin directory under Debug/Release and subdirectories by target name like "net45").

With a .NET Standard project in Visual Studio you can also have it create the Nuget package during build.  Since the project builds the nuget, you enter all the package information in the project settings.  And, of course, this means it builds a package with all the target binaries, not just one so you don't need to create a nuspec, nor edit it, more create a convention-based directory structure with the binaries for all the target frameworks you support.

### Caveats
As mentioned earlier, VS doesn't support multi-targeting like this right in the UI (other than the file projects dropdown to view the file in the compiler context of the target) so it can be tedious editing the csproj manually to change configuration like references etc.

[TargetFrameworks]: https://docs.microsoft.com/en-us/dotnet/core/tutorials/libraries
