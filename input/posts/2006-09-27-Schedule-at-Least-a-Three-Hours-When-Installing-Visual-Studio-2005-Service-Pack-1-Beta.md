---
layout: post
title: 'Schedule at Least a Three Hours When Installing Visual Studio 2005 Service Pack 1 Beta'
tags: ['Visual Studio 2005', 'msmvps']
---
[Source](http://blogs.msmvps.com/peterritchie/2006/09/27/schedule-at-least-a-three-hours-when-installing-visual-studio-2005-service-pack-1-beta/ "Permalink to Schedule at Least a Three Hours When Installing Visual Studio 2005 Service Pack 1 Beta")

# Schedule at Least a Three Hours When Installing Visual Studio 2005 Service Pack 1 Beta

Yesterday, I got [Rob Caron's][1], the [Visual C++ Team's][2], and various other emails about the just-released [VS 2005 SP1 Beta][3].

After getting my approval to download it, I did just that. I then quickly proceeded to install it. It took well over 10 minutes to inform me that I have Web Application Project add-in (WAP) installed and it must be uninstalled before proceeding. 10 mins? I knew SP1 has Web Application Projects built-in, so I guess I understand. But, 10 mins? So, I pressedOK and waited a couple more minutes before the dialog went away. I then went to uninstall WAP, then the SP1 Beta install sparked up again! After about 10 mins the same message appeared. This occurred three times before it finally stopped. That was about 45 minutes blown and I haven't installed anything yet.

I proceeded to uninstall WAP, and started the SP1 install process again. As soon as the installation was started I noticed that despite the CPU not going much above 10% my whole system was not **very **responsive. "Preparing to install…" was all I saw for 11 minutes before that changed to "Please wait while Windows configures Microsoft Visual Studio 2005 Premier Partner Edition – ENU". Odd, I thought–I have Team Suite installed. 5 minutes later I was presented with "Do you want to install Microsoft Visual Studio 2005 Premier Partner Edition – ENU Service Pack 1 (KB918525) on Microsoft Visual Studio 2005 Premier Partner Edition – ENU". I just assumed it really mean Team Suite. So, I clicked Yes and was presented with the EULA then "Gathering required information…". This continued for a minute or so when I was presented with "Time remaining: 3 minutes". 6 minutes later, that changed to "time remaining: 37 minutes". Here is where I wonder why can't this application tell time, and time remaining for what? Was it expecting to take 3 minute to calculate that 37 minutes was required to install, or has it just given up and decided it was wrong with 3 minutes (which it seemed to be) and it should really take 37 minutes. This is what you do when your system is basically unusable and you've got about 37 minutes to do nothing (1hr and 14 minutes, if the program's accuracy with 3 minutes was any indication). 14 Minutes later that changed to "time remaining: 0 seconds" and the progress meter was at 100%. This his looking more promising then the actual 3 minutes time frame.Alas, that remained for another 5 minutes until I was presented with "Successfully installed". I was happy, but it took 45 minutes (not too far off 37+3). But, It was short lived because the "time remaining: 0 seconds" returned. This stuck around for about a minute before it was replaced with "Preparing to install…". That stuck around for 4 minutes before I was presented with "Please wait while Windows configures Microsoft Visual Studio 2005 Team Suite – ENU" and "Do you want to install Microsoft Visual Studio 2005 Team Suite – ENU Service Pack 1 (KB918525) on Microsoft Visual Studio 2005 Team Suite – ENU". Well, at this point I was thinking that it had already installed what it should; but I've had really bad luck when not continuing with Microsoft installs so, I just proceeded. Long story short, this repeated again for Visual Studio 2005 Team Explorer. I turns out I technically have three versions of Visual Studio 2005 installed and the service pack ran once for each. Yuck. That's 2 hours and 45 minutes. (not including the first 45 minsor so while it complained about WAP).

For those who haven't installed SP1 beta yet, be sure to uninstall WAP first. Might as well save yourself 15 minutes.

[1]: http://blogs.msdn.com/robcaron/archive/2006/09/26/772932.aspx
[2]: http://blogs.msdn.com/vcblog/archive/2006/09/27/772917.aspx
[3]: http://connect.microsoft.com/visualstudio


