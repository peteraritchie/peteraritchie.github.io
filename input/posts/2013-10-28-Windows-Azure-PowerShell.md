---
layout: post
title: 'Windows Azure PowerShell'
tags: ['Uncategorized', 'msmvps']
---
[Source](http://pr-blog.azurewebsites.net/2013/10/29/windows-azure-powershell/ "Permalink to Windows Azure PowerShell")

# Windows Azure PowerShell

The management portal for Azure is very powerful—letting you do almost anything you need to. But, it's a web interface requiring navigation, mouse clicks, etc. From an operational standpoint, why bother when you can script anything? The majority of documentation about working with Azure is all through the management portal, you almost never see PowerShell examples of working with features. I haven't really seen a good single source for Azure and PowerShell, so I thought I'd collect some information about it.

The Windows Azure PowerShell consists of a PowerShell module (among other things—like dependencies on various Azure SDKs) that contains a plethora of Cmdlets devoted to scripting various actions on a Azure subscription. You get started, you need to install that. This is installed through the Web Platform Installer (WPI). If you have WPI installed you can select Windows Azure PowerShell in there, or you can get WPI and automatically jump to Azure PowerShell by downloading and running: [http://go.microsoft.com/fwlink/p/?linkid=320376&clcid=0x409][1]

Once you have Azure PowerShell installed, you need to configure it to recognize your subscription. There's a couple of ways of doing this. Both ways are accomplished within the Azure PowerShell—so, you have to run Windows Azure PowerShell from the Start menu. The first way is to use the Add-AzureAccount. (all my examples will use Camel Case for readability, the names of the cmdlets are not case-sensitvie—for those PowerShell n00bs) This prompts you to log in to Azure (or your Microsoft ID) then you're able to perform operations on your subscription. This method of adding a subscription times-out, and after 12 hours you'll have to log in again. The other (more automation-friendly) method is to import a publishsettings file. If you don't have a Azure publishsettings file you can use Get-AzurePublishSettingsFile to get one. Once you have one, you can use Import-AzurePublishSettingsFile to import the credentials and the management certificate. The cmdlet will tell you that it's changed the default and current subscription. You can use the Get-AzureSubscription command to verify you've added your subscription and detail the subscriptions you have associated with that Microsoft ID.

It's recommended that you don't leave your publishsettings file lying around. When you're done with it, they recommend deleting it.

More information on the process so far can be found here: <http://www.windowsazure.com/en-us/manage/install-and-configure-windows-powershell/>

You can add multiple subscriptions with Import-AzurePublishSettingsFile and switch between which account you want to work with with the Select-AzureSubscription cmdlet. For example:

The Azure cmdlets generally follow a naming pattern. Similar to existing PowerShell patterns, cmdlets that get information start with "Get-" and cmdlets that set information start with "Set-". In general, cmdlets that add or create things things start with "New-" or" "Add-" and cmdlets that delete or remove things start with "Remove-".

Now that you're able to script your Azure subscription. Let's do some stuff.

There's many easy operations you can perform from the Portal. One of the more involved operations is creating a VM. You can script this with the New-AzureQuckVM cmdlet—which is the equivalent of Quick Create in the portal—selecting a particular image. For example (all one line):

This creates a VM with specified admin username and password with the specific vhd from the gallery (Windows Server 2012 R2) and stores the newly created VHD in a WestUS-ST storage account with the name MyVM.vhd and puts the VM in the WestUS-AG affinity group and names the VM and corresponding service "MyVM1". Of course, this assumes you've already created the storage account and affinity group. If you didn't want to add the VM to an affinity group, you could use a location with the –Location option, for example: –Location "East US". And if you wanted to script the creation of the storage account:

For a list of the available azure cmdlets, you can type help azure.More information on the cmdlets available can be found here: [http://msdn.microsoft.com/en-us/library/jj152841.aspx][2]

The Azure PowerShell module is open-source and can viewed/contributed-to here: [https://github.com/WindowsAzure/azure-sdk-tools][3]

[1]: http://go.microsoft.com/fwlink/p/?linkid=320376&clcid=0x409 "Microsoft Web Platform Installer"
[2]: http://bit.ly/1bvPYuf "http://msdn.microsoft.com/en-us/library/jj152841.aspx"
[3]: http://bit.ly/17o6i3y "Windows Azure PowerShell code repository"


