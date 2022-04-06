---
layout: post
title: 'Bye bye, eBay'
tags: ['Security', 'msmvps', 'May 2014']
---
[Source](http://pr-blog.azurewebsites.net/2014/05/25/bye-bye-ebay/ "Permalink to Bye bye, eBay")

# Bye bye, eBay

Yesterday I started the process of deleting my eBay account. "Why, isn't that a knee-jerk reaction?" some are probably asking. I'd thought I'd put my thoughts in a blog…

The IT industry isn't making a lot of strides in the way of security lately. All the existing recommended practices aren't new, they're been around a few years. I'm not talking about using the most secure encryption algorithm or use TLS where appropriate—most of those things come "out of the box" and you have to try really hard to circumvent them in your own deployments. No, I'm talking about basic secure design.

This is 2014, there is no good reason (barring basic design flaws in specific implementations of SSL/TLS) for a particular web site to announce to the public that they should change their passwords because of a security breach. Why? Because there's no reason for that site to even store passwords—there should be no passwords to be breached at all, full stop!

Identity theft isn't something new either. With a site devoted to e-commerce, it's got a *huge* target it on its back for personal information that unseemly people can use for identity theft. It appears *nothing* but out-of-the-box security was used to protect user information above and beyond passwords. i.e. it was protected *by accident*–by SSL/TLS and firewall.

How did it happen? Employee login credentials. I assume that means that only a password is required to get into one of the world's largest ecommerce sites to get at encrypted and unencrypted personal information of 145 million users and that only one or a handful of employees has access to 145 million in-production data.

Sites being hacked is in the news, constantly! I'm not asking eBay to try to tell the future or to try to fix problems that don't exist! It's just a matter of reading the news, and making an educated guess that one of the largest web sites in the world will have hacking attempts. I'm sure they're have been many, many attempts in the past, just that this attempt succeeded at getting vital information. I'm also not asking eBay to stay up-to-the-minute changing their design to suit every new security design practice (like two-factor). I'm only expected *basic* security practices They *failed*, miserably.

I don't use eBay enough to warrant risking my personal information on a site, so large, and with such a huge revenue to *not* perform basic security design and/or review.

I would say that similar things should happen as with Target. The CEO is ultimately responsible and has failed eBay's customers and stockholders.

Plus, it was 5 (FIVE) days and not one single email from eBay telling me of the problem. I have to read it, over and over, in the news. eBay is sure quick to send me an email when it changes its user policy (i.e. reduces what it's liable for or increases my responsibility), is privacy police (i.e. reduces privacy), and selling agreements. So, I know damn well they know my email and know how to send me an email. *Plus* they were pretty damn quick to send me an email both about me first resetting my password but as well as the account closure request.

The folks at eBay dropped the ball, in so many different ways—no one could argue otherwise. I'm getting my personal information off of eBay to mitigate future risk and moving on to other services. If that means I can't buy an eBay as well—too bad.


