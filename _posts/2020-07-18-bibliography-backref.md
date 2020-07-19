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

---
# Solution
Pass the `pagebackref` option to the `hyperref` package:
```latex
\usepackage[pagebackref]{hyperref}
```

#### Example
The following code created [this document][example].
```latex
{% include 2020-07-18-bibliography-backref/backref.tex %}
```

#### Extras
As written above, the bibliography entry simply includes a page number
with no context as to what it is.
If you want to customize how the backreference appears,
you can do something like the following.
```latex
\renewcommand{\backref}[1]{(Cited on #1.)}
```
Then instead of just having a cryptic number at the end of the reference,
the reference will terminate with "(Cited on *page number*.)".

---
# Rambling
It amazed (and frustrated) me how long it took
to find out how to add backreferences in LaTeX.
Looking back, it appears the real problem was that
I didn't know what to search for.
I spent hours searching for things like
"latex hyperlinks from bibliography to document",
but that just came up with how to have links
from the document to the bibliography.
After much searching I finally came across the term "backreference",
and after that it was smooth sailing.

[example]: /CodeBlog/assets/2020-07-18-bibliography-backref/backref.pdf
