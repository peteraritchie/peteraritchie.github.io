---
layout: post
title: 'Sudden "…you must have Terminal Server User Access permissions on this computer." Error.'
tags: ['Small Business Server 2003 R2', 'Software Development', 'Team Foundation Server', 'msmvps', 'February 2007']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/02/03/sudden-you-must-have-terminal-server-user-access-permissions-on-this-computer-error/ "Permalink to Sudden "…you must have Terminal Server User Access permissions on this computer." Error.")

# Sudden "…you must have Terminal Server User Access permissions on this computer." Error.

I have a Small Business Server 2003 R2 Server running Team Foundation Server tucked out of the way to conserve desk space (three servers, two clients, two desks: not much space). I don't have it hooked up to a monitor (one: don't have that many monitors, and two: desk space). So, I've been merrily using Remote Desktop Connection (RDC)in Windows XP to connect to this server to perform my various administration tasks (like install service packs, hot fixes, etc.).

Well, I finally had a couple of cycles to install some hotfixes for the new daylight savings time changes to various components, so I sparked up RDC to get the ball rolling on my server–as I have done many times before. I was greeted with a message box as I logged in:

  

> To log on to this remote computer, you must have Terminal Server User Access Permissions on this computer. By default, members of the Remote Desktop group have these permissions. If you are not a member of the Remote Desktop Users group or another group that has these permissions, or if the Remote Desktop User group does not have these permissions, you must be granted these permissions manually.

Needless to say I was dumbfounded–it worked fine yesterday. After a bit of searching, it appears it was the 120 day anniversary of creating this server and Terminal Server (which is what is used for an _application server_ in Small Business Server) had "expired" (i.e. its grace period forCALs had expired). I was used to installing Windows Server and setting up Terminal Server for remote administration (there was a setting for that in Windows Server, I honestly don't remember what Small Business Server asked me whenI installed; it certainly wasn't clear it was different the other Windows Server installationprocesses). Apparently I missed the memo that remote administration is now called "Remote Desktop". Clearly a WTF moment.

As it turns out, the hoops to get back to the ability of remote administration aren't clearly documented (I actually couldn't find any documentation on the process, I actually inferred the process from various non-Microsoft sources–there could be documentation somewhere, I just didn't find it). The process requires that Terminal Server be uninstalled, the server rebooted, and Remote Desktopbe re-enabled. A point-list of the steps:

  

  

1. Run **Add/Remove Programs** (run "appwiz.cpl")
  

2. Click **Add/Remove Windows Components** (Alt-W)
  

3. Uncheck **Terminal Server**
  

4. Press **Next>**.
  

5. Follow instructions, including rebooting.
  

6. Open **System** control panel applet (run "sysdm.cpl")
  

7. Click **Remote** tab.
  

8. Check **Enable Remote Desktop on this computer**. (because removing Terminal Server disables this)
  

9. Click **Select Remote Users…**
  

10. Make sure administrators is in the list.
  

11. Click **OK**.
  

12. Click **OK**. for the next dialog.
  

13. Wait a few minutes for things to get up and running and you're no ready for remote administration again.

I hope this helps someone get back up and running faster than I did…


