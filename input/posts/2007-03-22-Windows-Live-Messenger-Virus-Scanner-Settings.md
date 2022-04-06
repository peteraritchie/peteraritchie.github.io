---
layout: post
title: 'Windows Live Messenger Virus Scanner Settings'
tags: ['Non-development', 'msmvps', 'March 2007']
---
[Source](http://blogs.msmvps.com/peterritchie/2007/03/22/windows-live-messenger-virus-scanner-settings/ "Permalink to Windows Live Messenger Virus Scanner Settings")

# Windows Live Messenger Virus Scanner Settings

I recently change to ESET's [NOD32][1]for my virus scanner and realized that I hadn't set my Windows Live Messenger to use it to scan received files. I found this helpful posting that describes the necessary steps: <http://www.wilderssecurity.com/showthread.php?p=910390> And those steps are:

1\. Login to Messenger.

2\. Click on Tools.

3\. Click on Options.

4\. Click on "File Transfer".

5\. Place a tick in "Scan files for viruses using:".

6\. Paste the following (including the quotation marks):

"C:Program FilesEsetnod32.exe" /selfcheck+ /list+ /scroll+ /quit+ /pattern+ /heur+ /scanfile+ /scanboot- /scanmbr- /scanmem- /arch+ /sfx+ /pack+ /mailbox- /adware /unsafe /ah /prompt /all

7\. Click on "Apply".

8\. Click on "OK".

[1]: http://www.eset.com/products/index.php


