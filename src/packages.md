---
title: Packages
eleventyNavigation:
  key: Packages
  order: 1
---

{% for package in collections.package | sort(false, false, "data.title") %}
[{{ package.data.title }}]({{package.url|url}})
{% endfor %}

 <!-- TODO: organize packages directory and page by author -->
