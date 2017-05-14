---
layout: post
title: The Custom Configuration Section Code Smell
date: 2010-12-17 19:00:00 -0500
categories: ['.NET 4.0', '.NET Development', 'Code Smells', 'Software Development Guidance', 'Software Development Principles', 'Unity 2.0']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2010/12/18/the-custom-configuration-section-code-smell/ "Permalink to The Custom Configuration Section Code Smell")

# The Custom Configuration Section Code Smell

I was recently involved in a project that involved some design-time configuration.  That design-time configuration was based on custom config sections. 

I didn't really pay too much attention to it at the time because I don't write my own custom config sections.  As I worked on the project and do what I usually do by refactoring and evolving the system to use various patterns and principles, I came to realize why I don't use my own custom config sections. 

That realization came as I began refactoring code for dependency inversion.  As I progressed getting the majority object creation code to get performed and managed by the container, I slowly started deleting the code that used these custom config sections.  I also started deleting the configuration sections from the app.config files.  It's then I realized why I don't use custom configuration section: I simply can't use them them. 

Custom config sections can be used for anything you need them for.  For the most part, they're about configuration settings for infrastructure-like objects.  Effectively the constructor arguments for a particular class or a façade for a group of related classes.  They're a way abstracting away the constructor parameters away from your code so that you don't need to recompile simply to change configuration-like information.  In an of itself, that's a good thing.  And, if, for whatever misguided reason you can't use an IoC container, custom configuration sections are a good thing. 

Let's look and an example of a custom config section.  Let's say that have a class that I use to connect to an external device via TCP.  To connect to that device I need an host name (or IP address) and a port number.  To communicate with the device (beyond "hello") I need a user name and password.  I also need some various other things like timeout values, retry values, etc.  For example: 
    
    
    public class Device : IDevice {  
    public string HostName { get; private set; }  
    public uint Port { get; private set; }  
    public string UserName { get; private set; }  
    public string Password { get; private set; }  
    public uint SocketTimeout { get; private set; }  
    public uint RetryCount { get; private set; }
    
    public Device(string hostName, uint port, string userName, string password, uint socketTimeout, uint retryCount) {  
    HostName = hostName;  
    Port = port;  
    UserName = userName;  
    Password = password;  
    SocketTimeout = socketTimeout;  
    RetryCount = retryCount;  
    }  
    //...  
    }

I may want a app.config like this:
    
    
    <?xml version="1.0" encoding="utf-8" ?>  
    <configuration>  
    	<configSections>  
    		<section name="device" type="DeviceConfigSection, Application"/>  
    	</configSections>  
    	<device hostName="192.168.0.111" port="8080" username="admin" password="p@55w0rd"/>  
    </configuration>

In order to do that I need a config section class like this:
    
    
    public class DeviceConfigSection : ConfigurationSection {  
    [ConfigurationProperty("hostName", IsRequired=true)]  
    public string HostName { get;  set; }  
    [ConfigurationProperty("port", IsRequired=true)]  
    public uint Port { get;  set; }  
    [ConfigurationProperty("username", DefaultValue="guest", IsRequired = false)]  
    public string UserName { get;  set; }  
    [ConfigurationProperty("password", IsRequired=false)]  
    public string Password { get;  set; }  
    [ConfigurationProperty("socketTimeout", DefaultValue = 1000u, IsRequired = false)]  
    public uint SocketTimeout { get;  set; }  
    [ConfigurationProperty("retryCount", DefaultValue = 3u, IsRequired = false)]  
    public uint RetryCount { get;  set; }  
    }

I'd then use it like this:
    
    
    	class Program {  
    static void Main() {  
    var config = System.Configuration.ConfigurationManager.GetSection("device") as DeviceConfigSection;  
    IDevice device = new Device(config.HostName, config.Port, config.UserName,  
                             config.Password, config.SocketTimeout, config.RetryCount);  
    
    
    
    			var x = new DeviceConsumer(device);  
    
    
    
    			//...  
    }  
    }  
    

Fairly straightforward; but quite a bit of code to separate construction parameters to design-time values.  Plus, my code is still tightly coupled to how a Device object is created _and_ tightly coupled to that device being the Device implementation.  Let's look at how I might do the same thing in an IoC container like Unity 2.0.

I'd start with a configuration file like this:
    
    
    <?xml version="1.0" encoding="utf-8" ?>  
    <configuration>  
    	<configSections>  
    		<section name="unity" type="Microsoft.Practices.Unity.Configuration.UnityConfigurationSection, Microsoft.Practices.Unity.Configuration"/>  
    	</configSections>  
    	<unity>  
    		<assembly name="Producer"/>  
    		<container>  
    			<register type="IDevice" mapTo="Device">  
    				<constructor>  
    					<param name="hostName" value="192.168.0.111"/>  
    					<param name="port" value="8080"/>  
    					<param name="userName" value="admin"/>  
    					<param name="password" value="p@55w0rd"/>  
    					<param name="socketTimeout" value="1000"/>  
    					<param name="retryCount" value="3"/>  
    				</constructor>  
    			</register>  
    		</container>  
    	</unity>  
    </configuration>

And to load that configuration I'd have code like this:
    
    
    	class Program {  
    static void Main() {  
    var unityContainer = new UnityContainer().LoadConfiguration();  
    var x = unityContainer.Resolve<DeviceConsumer>();  
    //...  
    }  
    }  
    

Et viola, a much simpler way of putting my parameters into the configuration file and making them a design-time concern.  Much less code.  If I want to do the same thing with another class, I just add more elements to the "unity" section, I don't need to add more configSection elements and I don't have to write a custom config section.  If you were paying close attention, you'll also notice that _I didn't actually write code to create a Device object_!  I simply tell Unity that I need a DeviceConsumer (which is a concrete class so I don't necessarily need to tell it how to create it) and the container figures out the dependency and if it knows about it (which it does, because I told it Device is a type of IDevice and what parameters to use when creating one) and instantiates it automatically.  My code is now completely decoupled from how a Device object is created and completely compile-time decoupled from the Device class!

Does that mean configuration section handlers are completely useless?  Of course not; but, as you embrace getting your dependencies in the right direction, decoupling your code from the responsibility of creating these dependencies the more and more you realize that configuration section handlers aren't the solution you need or even a solution you can use.  Of course, if you're an IoC container; that's a completely different story 🙂

I have come to decide that using a custom configuration section is a code smell.  The impetus to using them is basically decoupling creation from use; but it only does it half-way by moving just the parameters into app.config.

