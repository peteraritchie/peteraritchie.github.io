---
layout: post
title: 'Add Visual Studio 2005 Intermediate Files to Windows Disk Cleanup'
tags: ['Visual Studio 2005', 'msmvps', 'October 2006', 'Visual Studio 2005']
---
[Source](http://blogs.msmvps.com/peterritchie/2006/10/02/add-visual-studio-2005-intermediate-files-to-windows-disk-cleanup/ "Permalink to Add Visual Studio 2005 Intermediate Files to Windows Disk Cleanup")

# Add Visual Studio 2005 Intermediate Files to Windows Disk Cleanup

A few years ago I remember a small little Code Project project about a Windows Disk Cleanup component that would cleanup VC6 files. I had always meant to look into that for VS2005 when I had the time.

Well, I had a look at the interfaces that the the Disk Cleanup applet uses and it turns out you can add cleanup items to Disk Cleanup without writing a single line of code. There is a "fallback" cleanup COM component (DataDrivenCleaner)that you can reuse for situations where cleanup can be defined by a directory and/or set of files/wild-cards. Visual Studio 2005 fits this criteria quite nicely; so I whipped together a few registry entries that adds an item to Disk Clean to cleanup select Visual Studio intermediate files older than 30 days. I exported the entries into the attached file (zipped). The contents are as follows:

Windows Registry Editor Version 5.00



[HKEY_LOCAL_MACHINESOFTWAREMicrosoftWindowsCurrentVersionExplorerVolumeCachesVisual Studio 2005]

@="{C0E13E61-0CC6-11d1-BBB6-0060978B2AE6}"

"FileList"="*.obj|*.pch|*.ilk|vc80.pdb|vc80.idb|buildlog.htm"

"Display"="Visual Studio 2005 Intermediate Files."

"Priority"=dword:00000064

"Description"="Clean up Visual Studio project build files older than 30 days."

"IconPath"=hex(2):65,00,78,00,70,00,6c,00,6f,00,72,00,65,00,72,00,2e,00,65,00,

 78,00,65,00,2c,00,31,00,33,00,00,00

"Flags"=dword:00000001

"Folder"=hex(2):25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,

 00,45,00,25,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,6d,00,65,00,

 6e,00,74,00,73,00,5c,00,56,00,69,00,73,00,75,00,61,00,6c,00,20,00,53,00,74,

 00,75,00,64,00,69,00,6f,00,20,00,32,00,30,00,30,00,35,00,5c,00,50,00,72,00,

 6f,00,6a,00,65,00,63,00,74,00,73,00,5c,00,00,00

"LastAccess"=dword:0000001e

Most items are pretty self-explanatory. Both IconPath and Folder are REG_EXPAND_SZ value types, so the export shows them as hex bytes here. When merged with the registry you'll see IconPath: "explorer.exe,13", which just sets the item's icon to the folder icon; and Folder: "%USERPROFILE%My DocumentsVisual Studio 2005Projects". Flags is set to 1 to recurse subdirectories. And LastAccess = 1e means only files older than 30 (hex 0x1e) days will be cleaned.

So, basically, this will recurse the Visual Studio projects directory deleting files matching the FileList wild-cards (in this case *.obj, *.pch, *.ilk, vc80.pdb, vc80.idb, and buildlog.htm) and are older than 30 days. I purposely didn't add *.exe *.pdb because I often have files of these times that aren't with the Debug or Release directory of a project.

Handy if you have a scheduled cleanup (e.g. you run cleanup a hour before you disk defrag–no point in defragging a bunch of intermediate files…).


