---
layout: post
title: Developing Windows Services in Visual Studio
date: 2011-02-08 19:00:00 -0500
categories: ['C#', 'DevCenterPost', 'Software Development', 'Software Development Guidance', 'Visual Studio 2010']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2011/02/09/developing-windows-services-in-visual-studio/ "Permalink to Developing Windows Services in Visual Studio")

# Developing Windows Services in Visual Studio

Inevitably distributed systems often need a Windows service or two for certain tasks.  The [creation of a Windows service project and hooking up a project installer][1] to the service is fairly straightforward; so, I'm not going to get into much detail about that stuff.

The stuff that I find that isn't well understood is how to debug and deploy these services in a development environment.

First off, debugging.  A service is just an executable that is started up by the Windows service manager.  From a native application standpoint, it has some entry points in it that the service manager looks for and invokes.  From a managed standpoint, it's basically an object that is instantiated and given to System.ServiceProcess.ServiceBase.Run to get the service running.  Of course, the actual execution of service must be in the context of the service manager in order for ServiceBase to hook into it an tell it what to do.  So, simply running a service EXE will spit out a message about not being able to be run from the command-line or a debugger.  Ugh, shot down pretty quickly.

In it's default state, you can simply install the service, start it, and attach a debugger to it (<http://lynk.at/hIZu9w>).  This, of course, is a pain if what you want to debug doesn't need to be running in the service manager context.  What I've been doing with services for quite a while now is use a simple trick of deciding in Main whether to call ServiceBase or call my OnStart override directly.  This is based on tips like <http://www.codeproject.com/KB/dotnet/DebugWinServices.aspx> or <http://stackoverflow.com/questions/125964/easier-way-to-start-debugging-a-windows-service-in-c>

This little trick is basically adding a couple of lines to Main, and a couple of methods to your ServiceBase-derived class and you're done!  In your ServiceBase class, add two methods: InteractiveStart and InteractiveStop.  Each of these methods simply call OnStart and OnStop, respectively.  OnStart and OnStop are protected overrides, so the InteractiveStart and InteractiveStop let us gain access to them from outside the class.  For example:
    
    
    public partial class MonitoringService : ServiceBase {
    	public MonitoringService() {
    		InitializeComponent();
    	}
     
    	protected override void OnStart(string[] args) {
    		// complex multi-threaded code removed for clarity 😉
    	}
     
    	protected override void OnStop() {
    	}
     
    **	public void InteractiveStart() {
    		OnStart(null);
    	}
     
    	public void InteractiveStop() {
    		OnStop();
    	}**
    }

In Main, we simply check Environment.UserInteractive and call InteractiveStart and InteractiveStop.  For example:
    
    
    static void Main() {
    	var service = new MonitoringService();
    	if (Environment.UserInteractive) {
    		service.InteractiveStart();
    		Console.WriteLine("service running.  Press enter to exit");
    		Console.ReadLine();		
    		service.InteractiveStop();
    		return;
    	}
    	ServiceBase.Run(service);
    }

Probably a net gain of about seven lines of code.

To get this to work, you have to change your Windows service project's settings from Windows Application to Console Application.  You can now set a breakpoint in your service code and press F5.

This technique requires none of your service code to change, and you can wire off the code with a simple #if defined(…) if you like for Release builds.

Now that life's easier with the ability to easily debug a Windows service; what about where you want to debug something else that uses the service in a running state?  You could simply run the EXE so that it runs in our interactive mode and run the other application so it can interact with it.  But, sometimes you actually need to be running it as a service (e.g. you need the app to be running in a certain user context).  You can use your deployment project and install the service, type in username and password information and then run your other application.  But, having to do this more than a couple of times becomes tedious very fast.  Luckily, the Framework's InstallUtil has you covered there.  You may be familiar with InstallUtil's ability to install and uninstall services from the command line ("InstallUtil MonitoringService1.exe" to install and "InstallUtil /u MonitoringService.exe" to uninstall).  But, With the help of ServiceProcessInstaller added by the designer, InstallUtil also let's you provide a username and password for when your services is configured in the service process installer for ServiceAccount.User. It's a simple matter of using username and password service parameters.  For example:

installutil /username=".MonitorServiceAccount" " MonitoringService.exe

Try "installUtil MyService.exe /?" sometime to see all the options available to you, including password and username, ala _Additional Installer Options_ at [http://lynk.at/hNsK1R ][2]

Of course, you have to run these from a command line in Administrative mode if you're using Vista/7/2008 and need to make sure the account has rights to_ run as a service_.

You can even create a batch file to install and start the service.  For example:

installutil /username=".MonitorServiceAccount" /password="SuperSecretP@55w0rd" WindowsService1.exe   
net start MonitoringService

Hope this helps!

[EDIT: added the Console.ReadLine mentioned by Stefan]

[1]: http://lynk.at/g4l2UA
[2]: http://lynk.at/hNsK1R "http://lynk.at/hNsK1R "

