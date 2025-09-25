---
layout: post
title: 'Being A Successful Software Developer - Inspiration for Clear Expectations'
categories: ['September 2025']
comments: true
excerpt: '.'
tags: ['Software Development', 'Agile', 'Managing Expectations']
---
![agile work item hierarchy](../assets/agile-work-items.png)

In a [prior post](/posts/being-a-successful-software-developer--agilely-managing-expectations), I discussed agilely managing expectations, where I touched on ensuring user stories include measurable expectation detail by way of acceptance criteria. I detailed how the Gherkin or Given/When/Then format accommodates pre-conditions, actions, post-conditions, and quantifiers. Being able to format the expectations you've gathered is the easy part; the hard part is eliciting those expectations. If you don't already have a set of requirements with the level of detail you'd see in Given/When/Then format, that means no one has talked about expectations at that level of detail. This post will explore some strategies I've used to successfully collaborate with subject matter experts and product owners, helping them set clear expectations.

I've worked with many clients across a wide variety of verticals. I have some clients across the same vertical, but I wouldn't call myself a domain expert in the domain where nearly all of my clients operate. However, when I start working with a client I still need to become proficient enough to be productive right away. Let's explore some ways to uncover what inspires expectations.

Those with knowledge of what is needed are very close to the domain and naturally make assumptions, inadvertently leaving out information. We first have to recognize that and try to tease out implicit information to make it explicit. We technical folk want to work with "standard" user stories in a backlog, along with Feature and Epic descriptions.

<img src="/assets/agile-work-items.png" alt="Agile work item hierarchy." style="min-height: 10em; max-height: 75vmin; width: auto;">

## Epics and Features are more than groupings

It's easy to view Epics and Features as groupings, but they also represent business needs. Epics and Features can both represent a capability that the business is hoping to obtain. Alternatively, Epics can describe a Strategic Objective of the company. In either case, these needs serve as inspiration for the things under them. Like any hierarchy of goals and objectives, an objective at one level is a goal of the level below it. For example an Epic may have a Strategic Objective of "Increase Response times by an average of 20%" will lead to the creation of Features aimed at increasing response times. Features under that Epic should have a goal to contribute to that 20% increase. Stories under that Feature should have measurable objectives (quantifiable acceptance criteria) that contribute to that 20% increase.

At one level, during Story evaluation/refinement, we should be asking ourselves and the subject matter experts: "Is this user Story well aligned with the parent Feature?" That ensures the story is relevant, but it also ensures the Story is making forward progress on the goals of that Feature. Ensuring forward progress on Feature goals ensures we're addressing the Strategic Objectives of the Epic.

This is from the perspective of assessing or refining a User Story (or backlog item). Change happens, and it rarely happens at scheduled intervals like Epic planning or Feature planning. User Story refinement is the last point at which change can be recognized before committing to sprint work. Change can effect more than User Stories, it has an effect on Features, Epics, the Epic's Strategic Objective, the purpose of the current project, the Product, and even the Vision and Mission of the organization. Therefore a User Story might feel out of alignment for many reasons and assessment should cascade up the hierarchy until everyone involved is comfortable that alignment has been reached.

## User Story Unaligned With Feature

Although some user stories have an obvious functional or enabling motive, we typically want quantitative acceptance criteria for the User Story. Those quantifiers should align with the qualifiers and quantifiers of the parent Feature.

A goal or criteria of a Feature may be to improve performance, for example. A Story that contributes to that feature should have quantifiable acceptance criteria that measures how the Story contributes to improved performance. That User Story might be to add search indexing functionality. The purpose of search indexing may be to improve the performance of the existing search functionality. That existing functionality should have a performance baseline (i.e., the subject of the assessment that search performance was too slow) and in order to prove time spent implementing search indexing was successful, there should be a quantifiable amount that search performance should improve.

Some questions I've found to be valuable at uncovering missing expectations or clarifying expectations:

> What are we hoping to achieve with this functionality?

> I'm not clear on how this functionality contributes to "Feature X", could you help me understand?

If it's hard to get a quantifiable amount of anything for the acceptance criteria of a Story or, especially, if its difficult to quantifiable acceptance criterial for many of the User Stories for a Feature then that Feature may be unaligned with its parent Epic.

## Feature Unaligned With Epic

> What will this Feature enable users to accomplish?

> What new ability will this Feature give to users?

> I'm not clear on how this Feature contributes to the Strategic Objective of "objective", could you help me understand?


## Epic/Feature/Story Unaligned With Project Purpose

## Epic/Feature/Story Unaligned With Product Vision

> What capability will the organization obtain by successfully completing this Epic?

> What user behavior do we hope to change by successfully completely this Epic?

--- 

> Even though starting a sprint is a form of committing to work, that doesn't mean we can't accommodate change. Change in circumstances large enough to jeopardize or negate the benefit the sprint work would provide, the sprint can be cancelled and re-planned. Something I feel isn't taken advantage enough.

> If you find that you plan sprints but the accepted stories change during the sprint then sprint planning isn't having the effect it is suppose to have and might be a waste of time.

That ensures the story is relevant, but we also want to verify that the implemented solution adds value, so we need to ask questions about the value the implementation provides. We can look to the Feature for some of those details, but the Feature is likely more abstract than the Strategic Objective of its parent Epic. So, we can look to the Epic for something more measurable (quantitative). In this example, although the Feature may not mention an increase in response times, the Epic does, and we want to make sure we get measurable criteria about how the implementation should increase response times.

Over and above the Initiative, Epic, Strategic Objective, or Feature; the product and organization are motivated by, well, business motivations. These motivations are over and above the effort of delivering software in the future and are usually focused on the here-and-now or operations. Both the organization and the product have a purpose: a Vision and or a Mission. Additionally, an organization has Values that guide all its actions. The effort to deliver new software as a project also has a purpose: Goals and Objectives. And since a project is a one-time effort with an scheduled completion date, it also has a Scope.

Although these motivations impact and guide how the business operates, they also guide what is expected of the functionality and quality of software.

-- we're not just looking for acceptance criteria to verify functionality once implemented, we're looking to filter out stories that are not relevant. Not relevant based project scope, etc... ---

## Project Goals and Objectives
Project goals and objectives are often quantitative in nature: "increase customer retention by 10%" or "improve performance by 25%". In cases like this a proxy that represents the objective and can be measured against a target needs to be agreed upon. If it's not obvious, it's important to ask subject matter experts how implementing or using this functionality would impact that objective. e.g.: "How will we that this functionality will increase customer retention." or "How will we that this functionality will improve performance." Often what this really means is asking "How do we currently measure and what is the baseline to compare to?"
For example, you can't specific functionality as improving customer retention, but you can measure usage of a feature. So acceptance criteria can usage metrics like amounts or durations. These metrics are somewhat one-way, but do measure that the customer is engaged and when aggregated along with usage measures of other functionality, how engaged they are&mdash;which can be compared over time. 
## Organizational Vision
Vision can be subjective, and thus qualitative. This goes towards the relevance of the functionality and can either be deferred to prioritized lower that other efforts.
## Organizational Mission
A mission describes what an organization or product does. This also goes towards the relevance of proposed functionality and can be used to either defer functionality or prioritize it lower than other efforts.
## Organizational Values
Values that might apply to the acceptance criteria for functionality can sometimes be abstract and high level. But sometimes they can offer insight in how we can verify functionality. For example, a value like "integrity" or "promote transparency and trust" might lead to acceptance criteria like "private information is not stored in clear text" or "passwords not stored."
## Project Scope

> There is no right way to do the wrong thing.

## Prioritization
Many of these motivations go towards the ability to prioritize stories and features. Those that are believed to contribute to specific goals or objectives can be prioritized above other functionality. Functionality that doesn't align with Values or Purpose (like Vision or Mission) or aren't in Scope can be deferred to canceled ensuring efforts are focused on the right functionality.

Other aspects of business 

Measurement
- Leading indicators
- Lagging indicators
Scoping
Prioritization

Ideally, user stories would be squared away when they become ready for work in the product backlog, but things happen. It's crucial to have these types of things squared away when estimating and accepting work to perform in a sprint, as this is the last point in time to ask some of these questions. We want to make sure we're focusing on providing the right solutions.

While Stories, Features, and Epics detail the requirements, they're not the whole story. These artifacts are often the last stretch of the journey—a journey with many motivations. Let's look at some of those motivations.

---
after business motivations, touch on agile things like DoD and WoW and how those can be updated to detail how to check these thing and ask questions.
---

It's usually not enough to accept the initial requirement or user story. The people writing that information are not technical, and they don't know enough about the technology to recognize things like race conditions, atomicity, or idempotency.

User Stories, Features, and Epics represent the needs. To identify what might be missing, we need to examine the motivations behind them. From a developer's standpoint, we're working on a small part of the business; the business has many larger goals and objectives. 

TODO HERE

> **If you find this useful**  
> I'm a freelance software architect. If you find this post useful and think I can provide value to your team, please reach out to see how I can help. See [About](/about) for information about the services I provide.
<!-- Calendly inline widget begin -->
<div class="calendly-inline-widget" data-url="https://calendly.com/peterritchie/client-meet-greet-zoom" style="min-width:320px;height:700px;"></div>
<script type="text/javascript" src="https://assets.calendly.com/assets/external/widget.js" async></script>
<!-- Calendly inline widget end -->