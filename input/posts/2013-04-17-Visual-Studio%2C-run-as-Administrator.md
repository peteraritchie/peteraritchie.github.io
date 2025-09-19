---
layout: post
title: 'Visual Studio, run as Administrator'
tags: ['.NET Development', '.NET', 'Visual Studio 2012', 'msmvps']
disqus_id: "821 http://blog.peterritchie.com/?p=821"
---
[Source](http://pr-blog.azurewebsites.net/2013/04/17/visual-studio-run-as-administrator/ "Permalink to Visual Studio, run as Administrator")

# Visual Studio, run as Administrator

![][1]I use enough technologies with Visual Studio that require that Visual Studio be run_ As Administrator_ that right-clicking the Visual Studio icon and selecting **Run as Administrator** has been very tiresome.

I've been asked enough times _why_ I need to run as administrator that I've compiled an incomplete list. For the most part, these are the technologies that **I** use that require run as administrator; I'm sure there's more. Post a comment if you know of others:
* Installing updates for various extensions (like NuGet)
* Developing for Windows Azure
* Coded UI tests
* Using IIS with web application [1]
* Developing with WCF [2]
* Profiling [3]

There's many more, and there's an incomplete list available on MSDN: <http://msdn.microsoft.com/en-us/library/vstudio/jj662724.aspx>

Suffice it to say that most of these technologies and Visual Studio itself really isn't designed around a least-privilege workflow. There's various good reasons why this simply can't be done for the average developer. I tried for the longest time to run Visual Studio under least privilege; but, it simply became too much of a burden to do it. You simply have to forget to run _as administrator_, close Visual Studio, re-run it, and reload your solution **once** for there to be too much friction.

For a while I had simply changed the shortcut for Visual Studio (right click the icon, click **Properties**, click **Compatibility** tab, check **Run this program as an administrator**). Which works fine when you click the icon _then_ load a solution/project. But, if Visual Studio gets executed in any other way (restart after extension update, double-click .SLN file, etc.) then Visual Studio is _not_ run as an administrator and you have to exit and manually re-start Visual Studio and re-load your solution to continue your work.

One particular day when I ended up having to restart Visual Studio at least three times, (i.e. six times) I decided that just setting the shortcut to _Run As Administrator_ was not enough. I decided that there must be a better way. Fortunately, I found one.

Sidebar: Double-clicking Visual Studio solution and project files is rather complex. Long story short, they are associated with an application called VSLauncher that peeks into the file to decide _which version_ of Visual Studio to run (it supports side-by-side deployment).

The first step is to make sure VSlauncher gets run as administrator. This process is the same as the Visual Studio shortcut icon. Navigate to the VSLauncher folder ("C:Program Files (x86)Common FilesMicrosoft SharedMSEnv" on my 64-bit computer), right click the EXE, select **Properties**, click **Compatibility** tab, and check **Run this program as an administrator**.

This was not enough to get Visual Studio to run elevated, I also needed to do the same thing to the DEVENV.EXE file. But, unfortunately, when you right-click the EXE and click Properties, there is not Compatibility tab. I don't know why DEVENV.EXE is special in this respect, but there is a work around. Instead of clicking Properties, click **Troubleshoot Compatibility**. Then, in the _Program Compatibility Troubleshooter_, click **Troubleshoot Program**. In there, check **The program requires additional permissions**.

Now, when you double-click on a SLN or CSPROJ file and have Visual Studio run as an administrator. As far as I have been able to tell, this is the only way for this to occur.

## Caveats

And really, there's always caveats, isn't there. The biggest problem that I've encountered is that you can no longer drag-drop files onto the Visual Studio surface from Windows Explorer. Windows Explorer runs in least privilege by default and you can't drag a file from one app to another with different privileges.

Another caveat is that you can no longer run Visual Studio in a least privilege mode. For mean, I rarely _can_, so it's not really a caveat for me.

Of course, all the other security-relaated caveats of running any program with elevated permissions apply. Use at your own risk, provided "as is" without warranty of any kind, either expressed or implied…. bleah bleah bleah.

[1] [http://msdn.microsoft.com/en-us/library/58wxa9w5.aspx][2]  
[2] [http://msdn.microsoft.com/en-us/library/ms751423.aspx][3]  
[3] [http://msdn.microsoft.com/en-us/library/vstudio/jj662724.aspx][4]

[1]: http://www.fotothing.com/photos/8d9/8d9ab6ce158fef47436f6df201f07091.jpg
[2]: http://bit.ly/Z3dxHY "http://msdn.microsoft.com/en-us/library/58wxa9w5.aspx"
[3]: http://bit.ly/11dfVLM "http://msdn.microsoft.com/en-us/library/ms751423.aspx"
[4]: http://bit.ly/17Gz1xm "http://msdn.microsoft.com/en-us/library/vstudio/jj662724.aspx"


