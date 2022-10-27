---
layout: post
title: 'Visual Studio Performance with Microsoft Defender'
categories: ['Developer Experience', 'Optimization']
comments: true
excerpt: "Improve Visual Studio build times with Windows Virus & Threat Protection exclusions."
tags: ['October 2022']
---
![Antivirus Exclusion Developer Dall-E image](/assets/antivirus%20exclusion%20developer.png)

Steve Smith posted about [speeding up built times in Visual Studio](https://ardalis.com/speed-up-visual-studio-build-times/?utm_sq=h3m43zzlkm) by configuring Windows Defender.  That was in 2016 and to say things have changed a bit is probably an understatement.  Configuring a new laptop, I thought I'd revisit this briefly.

Before changing anything in Windows Virus & Threat Protection, go ahead and run a scan to make sure we're starting with a clean slate.  ~~Go to [Windows Security](ms-settings:windowsdefender) and click **Virus & threat protection** then click the **Quick scan** button.~~ I've been advocating scripting all-the-things, to run a quick scan in an administrator Powershell terminal run `Start-MpScan -ScanType QuickScan`.  You can also run a full-scan, if that makes you more comfortable: `Start-MpScan -ScanType FullScan`.

Once that's complete we can configure Windows Virus and Threat Protection to "trust" (exclude) Visual Studio.  To do that in PowerShell you can use the [`App-MpPreference` cmdlet](https://learn.microsoft.com/en-us/powershell/module/defender/add-mppreference?view=windowsserver2022-ps) (as well as see what's already configured with the [`Get-MpPreference` cmdlet](https://learn.microsoft.com/en-us/powershell/module/defender/get-mppreference?view=windowsserver2022-ps)).  Some examples:

With Visual Studio 2022 Enterprise:

```PowerShell
Add-MpPreference -ExclusionProcess "$Env:ProgramFiles\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe"
```

With Visual Studio 2022 Professional:

```PowerShell
Add-MpPreference -ExclusionProcess "$Env:ProgramFiles\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
```

With Visual Studio 2022 Community:

```PowerShell
Add-MpPreference -ExclusionProcess "$Env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
```

And, with Visual Studio 2022 Preview:

```PowerShell
Add-MpPreference -ExclusionProcess "$Env:ProgramFiles\Microsoft Visual Studio\2022\Preview\Common7\IDE\devenv.exe"
```

You can also do that for Visual Studio Code:

```PowerShell
Add-MpPreference -ExclusionProcess "$Env:LocalAppData\Programs\Microsoft VS Code\code.exe"
```

You can also exclude the location of where you store your source code.  The default location is `C:\Users\<user-name>\source\repos` for Visual Studio.  So, in PowerShell, you can add a path exclusion:

```PowerShell
Add-MpPreference -ExclusionPath "$Env:USERPROFILE\source\repos"
```

|Note:|
|-|
|If you're working with Git repositories that you're unsure of what they contain, you may want to separate where you clone those repos from where you exclude.|

Or, if you want a PowerShell script to just do all thee things, see [optimize-defender.ps1](https://gist.githubusercontent.com/peteraritchie/d6025591566821b4ae5995eb831b6e8d/raw/912b5b20b749d506562437f40e169e6a3e24d279/optimize-defender.ps1)

Other processes to consider:

```PowerShell
Add-MpPreference -ExclusionProcess "$Env:ProgramFiles\dotnet\dotnet.exe"
```

Any other processes or paths that you'd consider for exclusion?
