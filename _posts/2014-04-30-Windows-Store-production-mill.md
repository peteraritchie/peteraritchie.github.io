---
layout: post
title:  "Windows Store production mill"
date:   2014-04-29 12:00:00 -0600
categories: ['.NET Development', 'C#', 'Tips', 'Windows Store', 'XAML']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2014/04/30/windows-store-production-mill/ "Permalink to Windows Store production mill")

# Windows Store production mill

I've written a few Windows Store apps.  Pretty quickly I found that, despite starting from project templates, I had a lot of repeated work before adding the application's value.  In order to publish an app (i.e. be certified) you need to provide a lot of application-/author-specific stuff.  For example, if your app needs network access (and what app doesn't, especially if you have ads) it also needs to have, or link to, privacy information.  Not hard, but those links/info isn't in the default templates.

## Sharing between projects

To get a lot of that info shared between projects, I created a new project (in a new solution).  I chose to create a Windows Store Class Library (rather than a PCL) because I knew I'd have Store-specific information there, and not much that I would share with Phone, WPF, or Silverlight apps.

I could have had this project within another solution with an app, but that becomes difficult to manage (same dependency across multiple apps but one app has more control: bleah).  And, I could have had one solution with all the apps in it and the shared assembly.  But, if you've ever had to deal with that before (with dozens of projects), you know why I didn't.

## Privacy Info

To cover the "requirements", I started out supporting the privacy info.  This is simply a settings flyout that contains the collection and sharing policies of the app.  All my apps have the same policy so this is more of an "author policy" so this flyout is just static for me and I can just use the flyout class in an App's OnWindowCreated hooking into the SettingsPane.  After referencing the shared assembly, I can just tell the App about the flyout at initialization:

**Caveat**: Be sure you reference to your _Release_ assembly when you want to certify your app—your app _won't pass the verification tests_ because of the debug assembly!

## About Flyout

I don't think an about flyout is mandatory; but I wanted to have one for support reasons and I believe that users expect it; so I add it to each of my apps.

Much in the same vein as privacy info, I've just created a flyout to share amongst the apps.  The about flyout is different  because it will have application-specific information in it.  I want to have the version #, the description and name of the application, and the support URL.  Adding the flyout to an app is almost identical:

The difference is in the content.  I chose to use XAML resources to contain the information.  With data binding, we can simply bind by static resource name in the shared XAML and just add it to each app's App XAML resources.  This is what it would look like in the shared XAML:

Note the bindings to "{StaticResource AppName}", "{StaticResource AppDescription}", and "{StaticResource SupportUrl}".

Then, in the app, I can simply add the three resources to the App's XAML resources in App.xaml:

In this case the Effective Blogger app…

**Caveat**:As with data binding, the bindings are loaded at run-time so if you forget to add the resources to your app, you won't get a compile error and you'll have to pay attention to the output windows during debugging to catch the binding errors.

## Other stuff

I've got other things that I share amongst some of my apps (but not all).  And this shared assembly is a perfect place to put things like this.  For example, I seem to use a boolean to Visibility value converter frequently, so I've also added that to my shared assembly.

I hope these little tips help keep you from repeating a bunch of code that you didn't need to repeat.  If you've got other ideas of some something different, feel free to comment!

