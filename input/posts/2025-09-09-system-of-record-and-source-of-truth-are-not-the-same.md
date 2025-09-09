---
layout: post
title: 'System of Record And Source of Single Truth Are Not The Same'
categories: ['September 2025']
comments: true
excerpt: 'A System of Record is one of many operational systems that owns the transactions applied to a specific subset of business entity data. Single Source of Truth is an analytical system that aggregates operational and reference data from multiple sources for reporting and decision support.'
tags: [''Software Architecture', 'Fundamentals', 'System of Record', 'Single Source of Truth']
---

I [recently blogged](/posts/architecture-fundamentals--system-of-record) about the importance of distinct and isolated subsystems where real-time data transactions that apply to a particular business data entity are processed, known as a System of Record. Someone referenced that post and incorrectly implied that I was suggesting a Single Source of Truth. I didn't delve deeper into Single Source of Truth in that post to keep it concise. Still, I was careful to suggest "how important it is to separate operational systems from analytical systems" and that analytical systems "must support multiple independent Systems of Record." And in fact, I diagrammed information refinement and how it progresses within enterprises. That diagram isolated Systems of Record from a Single Source of Truth and isolated Operational Systems from Analytical Systems. In this post, I want to detail how and why a **Single Source of Truth is different from Systems of Record**.

<img src="/assets/sor-data-architecture.png" alt="Example data architecture that leverages Systems of Record." style="min-height: 10em; max-height: 75vmin; width: auto;">

A System of Record is an operational system with a data store (an _operational data store_) that captures, validates, updates, and stores authoritative records focused _only on a specific type of business data entity_. **A System of Record is not used directly for reporting** or analytics. As an operational data store, it supports the execution of one part of day-to-day business processes involved in the production of goods or services within an enterprise. Operational systems are optimized to ensure specific **business operations execute in real-time as quickly and reliably as possible**. Additionally, as business records, information in a System of Record has applicable retention requirements. While Systems of Record may purge information for maintainability, often enterprises must retain information in such systems for regulatory and compliance purposes.

Reflecting on the outcome of those operations is distinctly different from executing those operations: analyzing metrics and trends in the production of goods or services, and strategizing how to guide or improve active operations. **Analytics involves viewing the metadata about, the historic results of, and the context around operational business activities in multidimensional groups** to support decision-making about past business transactions. For example, in an e-commerce site, operational activities involve facilitating the purchase/sale of products. Analytics enables historical analysis of those sales across dimensions like time (months, quarters, etc.), demographics (region, customer segment, etc.), strategy (e.g., campaigns), etc. That is, a view of performance from the singular perspective of the entire enterprise, across different departments/verticals. The information retention constraints of the source system should not limit the extent to which historical analysis should go. This holistic view is the _truth_ that needs to be consistently available across the enterprise: _The Single Source of Truth_.

> A Single Source of Truth is a single analytical view of an enterprise across different departments/verticals.

Analytics isn't useful without the data a System of Record provides, but business records alone are not enough to make decisions across those dimensions. The information from business records needs to be aggregated and combined with information from other parts of the enterprise to produce those dimensions. The process of aggregating information from business records needs to occur independently of the operational system because not all the necessary information is at the individual business record level. e.g., campaign timeframes are overlaid over a range of transactions across multiple operational systems (information aggregated across operational systems). Remember that business operations must execute in real-time as quickly and reliably as possible, regardless of whether analytics data is being processed.

> Impacting a sale today due to a query that aggregates data from last month does not make good business sense.

To maintain the independence of all data sources, the processing involved in aggregating and populating analytical systems is kept as isolated as possible. **Data lakes and data warehouses separate a Single Source of Truth from source Systems of Record to achieve this isolation.**. Data lakes are updated with operational data only as needed. Extract, Transform, and Load (ETL) processes consume data from data lakes and other sources to update data warehouses that ultimately populate the analytical systems. This type of information refinement pipeline minimizes the impact on operational systems.

Systems of Record differ from a Single Source of Truth in the same ways operational data differs from analytical data:

| Attribute | Operational Data | Analytical Data |
| :--- | :--- | :--- |
| Goal | Daily efficiency and immediate actions. | Long-term strategy and decision-making. |
| Data | Real-time, transactional. | Historical, aggregated. |
| Performance | Write-intensive, speed-focused. | Read-intensive, query-focused. |
| Audience | Customers, front-line staff. | Data analysts, business strategists. |

I have found that "Single Source of Truth" is used to refer to any data source. Sometimes "Source of Truth" is used interchangeably. This is unfortunate because it leads to confusion, ultimately resulting in poor architectures.

Personally, I purposefully avoid using the phrase "Source of Truth" to avoid confusion with "Single Source of Truth" and refer to "Single Source of Truth" only as an isolated analytical system separate from "Systems of Record."

> **If you find this useful**  
> I'm a freelance software architect. If you find this post useful and think I can provide value to your team, please reach out to see how I can help. See [About](/about) for information about the services I provide.
<!-- Calendly inline widget begin -->
<div class="calendly-inline-widget" data-url="https://calendly.com/peterritchie/client-meet-greet-zoom" style="min-width:320px;height:700px;"></div>
<script type="text/javascript" src="https://assets.calendly.com/assets/external/widget.js" async></script>
<!-- Calendly inline widget end -->