---
layout: post
title: Routing and Remote Access, NAT, and Internet connection sharing.
date: 2006-07-14 20:00:00 -0400
categories: ['General']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2006/07/15/routing-and-remote-access-nat-and-internet-connection-sharing/ "Permalink to Routing and Remote Access, NAT, and Internet connection sharing.")

# Routing and Remote Access, NAT, and Internet connection sharing.

I've got a Windows 2000 Server running Routing and Remote Access with the NAT functionality to route my Internet connection through a computer running a firewall, etc.

This works well, I can share my Internet amongst my local network while offering a bit more security.

The problem is, Routing and Remote Access often gets confused and can't perform DNS lookups and therefore blows Internet connection sharing out of the water.  This seems to occur if the radio/modem loses power.

Until recently, the only way I found that rectified the problem (sometimes) is by rebooting the server. As you might understand, this is a real pain.  But, recently I happened across a series of actions that seems to get Routing and Remote Access back up and running.  I can managed to fix the connection sharing if I perform the following steps in the exact order:

  

  

1. Stop the Routing and Remote Access service.
  

2. Release the the IP address assigned to the NIC connected to the ISP and used with NAT.
  

3. Renew the IP address of above NIC.
  

4. Start the Routing and Remote Access service.

This turns out to be more reliable than rebooting the server.  There's been a couple of times I've had to reboot twice.

Please correct me if there's a better way or post if this problem doesn't exist in later version of Windows Server (I don't have the resources to upgrade at the moment).

I post here for posterity, my own reference, and anyone else you happens to find it.

keywords: Reset NAT RRAS DNS remoteaccess ipconfig net stop start release renew

