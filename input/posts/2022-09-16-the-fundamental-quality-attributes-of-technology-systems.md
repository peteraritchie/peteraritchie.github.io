---
layout: post
title: 'Fundamental Quality Attributes of Technology Systems'
categories: ['Quality Attributes', 'Architecture']
comments: true
excerpt: "Customers expect features that operate without fault or error, operate consistently within expectations, operate within resource constraints, and protect from unauthorized access."
tags: ['Quality Attributes', 'Architecture']
---
What are quality attributes? The term "non-functional requirements" has been more prevalent, but that is a technologist's term. The first time you bring up "non-functional requirements" with a customer, there's always confusion, then concern. I've heard more than once, "we want something functional."

The most important attribute of a system is its functionality. Functionality is whether a system is _fit for purpose_. A system's functionality is what makes it unique, so I'll defer detail on functional attributes for another time. In this post I'll focus this post on cross-cutting quality attributes that permeate all aspects of a solution.

Quality attributes are the characteristics a system needs to exhibit--qualifications of the system's desired functionality. Quality attributes address customer concerns regarding the degree of success of a system. A customer's concerns of a system are unique and thus precludes having a universal prioritized list of quality attributes.

It is simple to describe the characteristics a customer expects of a system that provides the features they need:  Customers expect features that operate without fault or error, operate consistently within expectations, operate within resource constraints, and protect from unauthorized access. Translating that into a collection of system-specific measures is an enormous undertaking that cannot be taken lightly.

Many philosophies about quality attributes (usually termed "quality models") exist, like FURPS, ISO/IEC 9126/25010, McCall, etc. These models detail several categories that organize the many adjectives that can apply to software systems. Some common categories may include Reliable, Efficient, Maintainable, Secure, etc. I view quality attributes as a palette of possible adjectives; no one list is perfect for every situation. There are top-/high-level categorizations that can apply more broadly. When discussing quality attributes, we use the noun form (Reliability vs. Reliable.) I've landed on the following top-level categories (in no particular order): Performance, Operability, Security, and Dependability.

## Dependability (of features)

- to function, without fault or error

Dependability involves concerns such as:

- availability — readiness for usage
- reliability — continuity of service
- safety — non-occurrence of catastrophic consequences on the environment
- confidentiality — non-occurrence of unauthorized disclosure of information
- integrity — non-occurrence of improper alterations of information
- maintainability — aptitude to undergo repairs and evolution

## Performance (of execution)

- To function within resource constraints (time, compute, storage, memory, network) constraints

Performance involves concerns such as:

- latency - the degree of responsiveness.
- throughput - the rate at which work can be performed
- capacity - the amount of work that can be performed

## Operability (of function)

- to become and remain operable.

Operability involves concerns such as:

- deployability - the ability of a system to be put into production
- monitorability - the ability of a system's health and operation to be monitored
- configurability - the ability of a system's behavior to be customized

## Security

- To ensure authorized usage.

Security involves concerns such as:

- Confidentiality - the quality of a system restrict access to information
- Integrity - the quality of a system adhere to accuracy and consistency of information and behavior 
- Availability - the quality of a system to provide access to information to those authorized
- accountability - the quality of a system to account for its actions when fulfilling its responsibilities

Because quality attributes address customer concerns, there are overlaps between categories. For example, there's a dependability concern that data integrity does not impact functionality; there's also a security concern that data integrity doesn't result in data loss. Don't let the overlap distract you from what's best for your solution. It will change even if you could pre-define a complex structure of quality attributes most suitable for your solution. Needs change, priorities change, and quality attributes are philosophic influencers to a solution that requires nurturing.

