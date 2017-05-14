---
layout: post
title: Azure Table Storage and the Great Certificate Expiry of 2013
categories: ['.NET 4.0', '.NET 4.5', 'Azure', 'C#']
tags:
- msmvps
---
[Source](http://blogs.msmvps.com/peterritchie/2013/03/01/azure-table-storage-and-the-great-certificate-expiry-of-2013/ "Permalink to Azure Table Storage and the Great Certificate Expiry of 2013")

# Azure Table Storage and the Great Certificate Expiry of 2013

I won't get into too much detail about what happened; but on 22-Feb-2013, roughly at 8pm the certificates used for *.table.core.windows.net expired.  The end result was that any application that used Azure Table Storage .NET API (or REST API and used the default certificate validation) began to fail connecting to Azure Table Storage.  More details can be found [here][1].  At the time of this writing there hadn't been anything published on any root cause analysis.

The way that SSL/TLS certificates work is that they provide a means where a 3rd party can validate an organization (i.e. a server with a given URL, or range of URLS).  That validation occurs by using the keys within the certificate to sign data from the server.  A client can then be assured that if a trusted 3rd party issued a cert for that specific URL and that cert was used to sign data from that URL, that the data *must* have come from a trusted server.  The validation occurs as part of a "trust chain".  That chain includes things like checking for revocation of the certificate, the URL, the start date, the expiry date, etc.  The default action is the check the entire chain based on various policies—which includes checking to make sure the certificate hasn't expired (based on the local time).

Now, one might argue that "expiry" of a certificate may not be that important.  That's a specific decision for a specific client of said server.  I'm not going to suggest that ignoring the expiry is a good or a bad thing.  But, you're well within your rights to come up with your own policy on the "validity" of a certificate from a specific server.  For example, you might ignore the expiry all together, or you may have a two-week grace period, etc. etc.

So, how would you do that?  

Fortunately, you can override the server certificate validation in .NET by setting the ServicePointManager.ServerCertificateValidationCallback property to some delegate that contains the policy code that you want to use.  For example, if you want to have a two week grace period after expiry, you could set the ServerCertificateValidationCallback like this:

Now, any subsequent calls into the Azure Table Storage API will invoke this callback and you can return true if the certificate is expired but still in the grace period.  E.g. the following code will invoke your callback: 

## Caveat

Unfortunately, the existing mechanism (without doing SSL/TLS negotiation entirely yourself) of using ServicePointManager.ServerCertificateValidationCallback is a global setting, effectively changes the server certificate validation process of every-single TLS stream within a given AppDomain (HttpWebRequest, TlsStream, etc.).  This also means that any other code that feels like it can change the server certificate validation process.

So, what can you do about this?  Well, nothing to completely eliminate the race condition—ServicePointManager.ServerCertificateValidationCallback is simply designed wrong.  But, you can set ServerCertificateValidationCallback as close to the operation you want to perform.  But, this means doing that each for and every operation.  Seeing as how the Azure API make take some time before actually invoking a web request there's a larger potential for race condition than we'd like.

An alternative is to invoke the REST API for Azure Table Storage and set ServerCertificateValidationCallback just before you invoke your web request.  This, of course, is a bit tedious considering there's an existing .NET API for table storage.

## Introducing RestCloudTable

I was interested in working with Azure REST APIs in general; so, I created a simpler .NET API that uses the REST API but also allows you to specify a validation callback that will set ServerCertificateValidationCallback immediately before invoking web requests.  This, of course, doesn't fix the design issue with ServerCertificateValidationCallback but reduces the risk of race conditions as much as possible.

I've created a RestCloudTable project on GitHub: <https://github.com/peteraritchie/RestCloudTable>.  Feel free to have a look and use it as is, if you like to avoid any potential future Azure Table Storage certificate expiry.

[1]: http://bit.ly/13rkTrs

