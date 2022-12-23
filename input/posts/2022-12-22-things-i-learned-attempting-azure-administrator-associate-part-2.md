---
layout: post
title: 'Things I Learned Attempting Azure Administrator Associate - Part 2 - Storage'
categories: ['Azure', 'Azure Administrator Associate (AZ-104)']
comments: true
excerpt: Azure Administrator Associate certification is about the skills required to be an Azure account, subscription, tenant, etc., administrator. If your end goal is to develop applications on Azure, that involves a lot of administration of Azure resources. Regardless of your plan, storage administration is nuanced. This post focuses on some of those nuances, nuances that may not be apparent in the documentation
tags: ['December 2022']
---
![distributed cloud data storage](/assets/DALL·E-2022-12-22-17.03.40--distributed-cloud-data-storage-in-the-style-of-salvator-dali.png)

Azure Administrator Associate certification is about the skills required to be an Azure account, subscription, tenant, etc., administrator. If your end goal is to develop applications on Azure, that involves a lot of _administration_ of Azure resources. Regardless of your plan, storage administration is nuanced. This post focuses on some of those nuances, nuances that may not be apparent in the documentation.

### Overview

<!--capabilities-->
Azure provides storage services for Files, Blobs, Queues, and Tables. Files are blobs that support access via SMB protocol, AKA File Shares. Blobs are web resources that support access via a URI (HTTP). Blob Storage supports two types of blobs: block blobs and page blobs. Table Storage supports key-based relational and document access. Queues support access to ephemeral messages.

Azure Files has a File Sync feature that supports file-level replication across Windows Servers. The Azure File endpoint is also called the Cloud Endpoint and is part of a Sync Group that includes one or more Windows Server file shares.

There are two performance options for Storage Accounts: Standard (general purpose v2) and Premium (for low latency.)

<!--tiers/skus-->
Storage has a couple of storage tiers: Standard and Premium. Storage tiers provide different functionality at different costs. Blob Storage has several access tiers: Hot, Cool, and Archive. Access tiers offer a way to communicate the frequency and type of data access to reduce storage costs. Access tiers can be used to implement a lifecycle for data, moving to lower-cost tiers over time to reduce cost.

<!--durability/high-availability-->
Storage supports data redundancy that makes copies of data to avoid loss due to infrastructure failure. There are several options: Locally-Redundant Storage (LRS), Zone-Redundant storage (ZRS), Geo-Redundant Storage (GRS), and Geo-Zone-Redundant Storage (GZRS). LRS stores three copies of the data asynchronously within a single data center. ZRS duplicates those 3 LRS copies across three availability zones (clusters) in a region. GRS duplicates those 3 LRS asynchronously to a single zone in a secondary region. GZRS duplicates the ZRS data across zones within the secondary region.

<!--data protection-->
Recovery Services is the service responsible for storing backups and recovery points. Recovery Services stores data within Recovery Services Vaults.

Encryption scopes logically group blobs or containers and assign an encryption key specific to that scope.

<!--access control-->
There are a couple options for controlling access to data: Azure AD accounts/groups or Shared Access Signatures (SAS). Azure AD Groups provide a more manageable way to control Azure AD account access to data (than simply Azure AD accounts). SAS provides a granular means to provide delegate access to external entities.

### Notable information <!--TIL-->

- LRS protects against rack-level hardware failure (so, if you want data-center-wide failure protection, LRS is insufficient).
- LRS is supported for Standard File and Standard Block Blob account types (otherwise, GRS is the default.)
- ZRS protects against data loss due to data center failure (so, if you want region-wide failure protection, ZRS is insufficient)
- GRS protects against region failure.
- GRS and GZRS secondary regions are pre-defined, forcing your data into a specific region.
- GZRS protects against region failure and simultaneous data center failure in the secondary region.
- When defining a data lifecycle, in the case of a tie, the option that results in the least cost will be chosen.
- Migrating from LRS to GRS is supported with a feature called "Live Migration." Migration from LRS in other scenarios (e.g. to ZRS) must be done manually. Since Premium Storage accounts do not support LRS, Live Migration does not support Premium Storage accounts.
- Live migration supports the use case of a storage account failure of GRS-replicated data. GRS is a second LRS in a secondary region. If a region fails, GRS reduces to LRS, so recovering means using Live Migration.
- Durability is not backup; it provides access to data when infrastructure recoverability isn't an option. Apart from Live Migration, _restoration_ is limited to manually copying live data when needed.
- Durability does not protect against application-level failure; use backups or custom (application-level) durability in those scenarios.
- Encryption scopes are useful for providing logical data tenancy.
- Files added/modified in a File Share are only detected and replicated to the Windows Server file shares once every 24 hours (i.e., only visible after 24 hours).
- Adding a file share to a Sync Group acts like all the files and folders within the file share were just added, replicating to the cloud endpoint and any other file shares.
- When applying _least privilege_ to storage accounts, the **Reader** role is also required on the Azure AD account if the Azure AD account needs to navigate storage resources in the Azure Portal.
- Asynchronous data redundancy options introduce the possibility of data loss. If the asynchronous duplication to the secondary region did not complete, it is out of sync with the last state of the primary region. Application-level logic is required to prevent loss of data in this scenario.
- The Archive tier does not have immediate access; it must be _rehydrated_ to a cool/hot tier first (usually with a Copy Blob operation of up to 15 hours completion time).
- File Share storage may be backed up to Recover Service vaults, but Blob Storage may not.

This table summarizes the types of storage accounts and the features/redundancy that each support.

Account | Redundancy | block blob | page blob | append blob | file share | queue | table 
-|-|:-:|:-:|:-:|:-:|:-:|:-:
Standard account | LRS | &#9745; | &#9745; | &#9745; | &#9745; | &#9745; | &#9745;
Standard account | GRS | &#9745; | &#9745; | &#9745; | &#9745; | &#9745; | &#9745; |
Standard account | GAZRS | &#9745; | &#9745; | &#9745; | &#9745; | &#9745; | &#9745; |
Standard account | RA-GZRS |&#9745; | &#9745; | &#9745; | &#9745; | &#9745; | &#9745; |
Premium Block blobs account | LRS | &#9745; | &#9744; | &#9745; | &#9744; | &#9744; | &#9744; |
Premium Block blobs account | ZRS | &#9745; | &#9744; | &#9745; | &#9744; | &#9744; | &#9744; |
Premium File shares account | LRS | &#9744; | &#9744; | &#9744; | &#9745; | &#9744; | &#9744; |
Premium File shares account | ZRS | &#9744; | &#9744; | &#9744; | &#9745; | &#9744; | &#9744; |
Premium Page blobs account | LRS | &#9744; | &#9745; | &#9744; | &#9744; | &#9744; | &#9744; |
Premium Page blobs account | ZRS | &#9744; | &#9745; | &#9744; | &#9744; | &#9744; | &#9744; |
