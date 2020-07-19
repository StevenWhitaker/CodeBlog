---
layout: post
title:  "In-place Bibliography Entries"
date:   2030-07-18 13:38:00 -0400
categories: LaTeX bibliography bibentry
---

# Problem
I want to show the bibliography entry for my journal paper at the beginning
of my corresponding PhD thesis chapter.

---
# Solution
Use the `bibentry` package with the  `\nobibliography*` command:
```latex
\usepackage{bibentry}
\nobibliography*
```

Then, use the `\bibentry` command at the point in the document
where you want the in-place bibliography entry:
```latex
\bibentry{<cite key>}
```

#### Example
The following code created [this document][example].
```latex
{% include 2020-07-18-inplace-bibentry/inplace.tex %}
```

#### Extras
The `\bibentry` command just takes the bibliography entry
and pastes the text with no special formatting
(e.g., not in a float or even in its own paragraph).
It even omits the trailing period so you can customize
the punctuation more easily.
So you can easily add your own formatting to spruce things up.
As an example,
you can add some spacing and place the references in a box with the following.
```latex
{% include 2020-07-18-inplace-bibentry/inplace_extra_input.tex %}
```
Then you can replace `\bibentry{<cite key>}` in your document
with `\inplacebibentry{<cite key1>, <cite key 2>, ...}`.
[Here][example-extra] is what the result looks like.

[example]: /CodeBlog/assets/2020-07-18-inplace-bibentry/inplace.pdf
[example-extra]: /CodeBlog/assets/2020-07-18-inplace-bibentry/inplace_extra.pdf
