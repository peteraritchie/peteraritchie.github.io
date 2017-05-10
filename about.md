---
layout: page
title: About
permalink: /about/
---

### More Information

Peter Ritchie

### Repositories

{% for repository in site.github.public_repositories %}
  * [{{ repository.name }}]({{ repository.html_url }})
{% endfor %}