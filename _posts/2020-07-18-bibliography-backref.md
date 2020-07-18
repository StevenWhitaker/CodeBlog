---
layout: post
title:  "Bibliography Backreferences"
date:   2030-07-18 13:38:00 -0400
categories: LaTeX bibliography hyperref backref
---

# Problem
I want hyperlinks in my bibliography
that point to the page(s) in my document
where I made the citation(s).

# Solution
Pass the `pagebackref` option to the `hyperref` package:
```latex
\usepackage[pagebackref]{hyperref}
```

#### Example
The following code created [this document](/CodeBlog/assets/2020-07-18-bibliography-backref/backref.pdf).
```latex
{% include 2020-07-18-bibliography-backref/backref.tex %}
```

# Rambling
