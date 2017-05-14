---
layout: post
title:  "SSL is not the basis of mission critical security"
redirect_from: "/2014/04/17/ssl-is-not-the-basis-of-mission-critical-security/"
date:   2014-04-16 12:00:00 -0600
categories: ['Heartbleed', 'Security', 'Uncategorized']
tags:
- msmvps
---
[Source](http://pr-blog.azurewebsites.net/2014/04/17/ssl-is-not-the-basis-of-mission-critical-security/ "Permalink to SSL is not the basis of mission critical security")

# SSL is not the basis of mission critical security

I was a amused by a naïve post about "heartbleed" the other day and I'd thought I'd get my thoughts out via a blog post.  The post in question: <http://www.computerworld.com/s/article/9247678/Evan_Schuman_With_Heartbleed_IT_leaders_are_missing_the_point>

## SSL

SSL was created by Netscape in the 1990's and has had problems basically from the start.  It had "security flaws" up to version 3.0.  Each subsequent version of SSL (or "TLS" after version 3.0 of SSL) strengthened security and thus prior versions we viewed as "weaker" in security.  In fact, TLS was defined to *never* down-negotiate to SSL v2.0 due to v2.0 not having a "sufficiently high level of security" back in 2011.

I'll refer to SSL as "TLS" from here on in, as that's effectively the contemporary implementation.

While TLS is transport-layer security (which means it can secure most application-level protocols) it is designed to be and primarily used when browsing the web.  It was designed to always authenticated servers (web sites) and optionally authenticate clients.  What this means is there's a certain degree of anonymity involved in TLS communications.  In the majority of usages, TLS does not authenticate the client.  Think, for example, when you log into your bank via the browser.  Your browser "authenticates" that you're talking to your bank (or really just authenticates that you're talking to the URL you've asked to communicate with) by use of a certificate issues by a third-party "authority".  The user delegates to these third party authorities (and really delegates to the browser manufacturer to "accept" these third party authorities to issue certificates).  So, for a particular web site to be "authenticated" the browser must know about the certificate authority, accept its certificate (a root certificate) and that that certificate not be revoked or expired, in addition to the server's certificate not being revoked or expired.

## Mission-critical security

Let's be clear, securing a browser connection to a web site is not "mission-critical".  If that's how your mission critical system is architected, you've got other problems.

If you *are* talking mission-critical security, do you really think you'd delegate *that* much to random third parties?  Sure, you could use TLS in such a way as to enforce authentication of both the server and the client, *and* mandate that only certain certificates are acceptable or certain authorities are acceptable.  You can even self-sign the certificates and circumvent the whole authority process (and you better be *really* sure you're adding value to those self-signed certificates–which means having *at least* the same level of security of your private certs as do the Authorities).  There's other things you can control too. But why?  Why would you circumvent a particular protocol to that degree and still use it for "mission critical" security?

Short answer is: you wouldn't.  You shouldn't and you wouldn't.  I'm not saying don't use whatever security library you want (this isn't a question that TLS is not secure just because it was implemented in the open like OpenSSL) I'm saying you should pick the most secure protocol for your circumstances.  If you have a policy to authenticate both the client and the server, a protocol that allows unauthenticated clients isn't the best protocol.  A protocol that relinquishes some level of control (or policy) to third parties to authenticate the nodes on your distributed system isn't the best idea for mission-critical security either.  Leaving a protocol up to a standards body to update with the latest and greatest encryption currently-accepted practices isn't the best idea for mission-critical security either.

TLS is used *all across the internet*.  Rolling-your-own authentication protocols and authorization and encryption is simply stupid, but TLS is a huge attack surface.

TLS is also *transport layer* security.  Which means it only "secures" data from point A to point B (and only authenticates Point A and Point B–or sometimes Point A).  In mission critical systems having data only going from point A to point B is not scalable.  Mission-critical systems need to scale.  Which likely means TLS is securing data only up to point A, and only beyond point B (or at least those are the only places you really have control).  This often means mission critical systems should be applying security policy at the application level–not the transport level.

Below the application level, application needs and requires cannot be know.  If an application has security policy over and above any given transport layer security, you can't expect that to be known at the transport layer (you'd stop having lower-level layers and thus stop having layers altogether if that were the case).  Mission-critical systems generally have fairly distinct security requirements.  Data security often involves many levels of authentication and authorization.  The only authorization TLS performs is that of authentication–one or both sides need to be authenticated to authorize *all access* to the data.

There's nothing wrong with application-level security *and then* communicating that over TLS–but you're not likely to leave all of your mission-critical data security up to *just* TLS.

TL;DR: SSL is not intended for mission-critical systems and shouldn't be considered for mission critical systems.  Ergo hyperbole about heartbleed being the least of our problems and that we need to "fundamentally rethink how the security of mission-critical software" is just that: hyperbole.

references:  
<https://web.archive.org/web/20130530054017/http://www.mozilla.org/projects/security/pki/nss/ssl/draft02.html>  
<http://en.wikipedia.org/wiki/Transport_Layer_Security>

