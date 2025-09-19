---
layout: post
title: 'Things I Learned Attempting Azure Administrator Associate - Part 1'
categories: ['Azure', 'Azure Administrator Associate (AZ-104)']
comments: true
excerpt: "."
tags: ['Azure', 'Azure Administrator Associate (AZ-104)']
---
![person going through the process of certifying knowledge](/assets/DALL·E-2022-12-20-15.03.33---A-woman-going-through-the-process-of-certifying-knowledge.png)

I recently earned certification for Azure Administrator Associate.  My goal is to make my experience and skills more verifiable in areas like application solution architecture.  Azure Administrator Associate is a prerequisite for Azure Solutions Architect Expert and DevOps Engineer Expert (I imagine it's a prerequisite for all Azure * {Expert|Associate} certs.)

Certifications aren't perfect, "certification" has different meanings to the observer and the certification itself. Most certifications bring with them an expected minimum understanding of the subject.  Does it mean the earner will do everything perfectly with the subject?  Of course not, but it gives the person a certain vocabulary to communicate more efficiently on the subject.

The road to Azure Administrator Associate was interesting, and sharing some notable information would be helpful for others.

## Making The Implicit Explicit

The key to good communication is clearly understanding a subject and eliminating assumptions and misunderstandings. While understanding what is expected of a certified Azure Administrator Associate, I noticed some knowledge that I realized is typically implicit. Another way of looking at the following is that each starts with "It may seem obvious, but...".

Implicit knowledge is knowledge obtained through incidental activities; knowledge gained without awareness of learning is occurring.

### Line of Business (LoB) Applications

Line of Business (LoB) applications is ubiquitous in the computing industry.  Everyone knows what it _means_, but if you ask two people to define it, you'll get more than one answer.  While agreement/standardization on what a LoB application is isn't going to happen any time soon, there are certain truths about LoB applications:

- An in-house, custom web application
- Not accessible via the Internet, either behind a firewall or strict access control (authentication and authorization)
- Access _may_ occur via an application gateway or load balancer
- Specific to the company, business area, or industry

### AzCopy 

AzCopy works with Azure storage but only Azure Blob Storage and Azure Files.

## Conclusion

There are many areas of clarification with Azure Administrator Associate.  Future posts on the subject will address clarifications involving important explicit limits, restrictions, constraints, rules, etc.

Are there other implicit aspects of Azure administration that can be made explicit?
