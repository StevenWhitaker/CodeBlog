<!--
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
-->
@def website_title = "CodeBlog"
@def website_descr = "A code blog"
@def website_url   = "https://stevenwhitaker.github.io/CodeBlog/"

@def prepath = "CodeBlog"

@def author = "Steven T. Whitaker"

@def mintoclevel = 1

<!--
Add here files or directories that should be ignored by Franklin, otherwise
these files might be copied and, if markdown, processed by Franklin which
you might not want. Indicate directories by ending the name with a `/`.
-->
@def ignore = ["node_modules/", "franklin", "franklin.pub"]

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\x}{\mathbf{x}}
\newcommand{\xhat}{\hat{\mathbf{x}}}
\newcommand{\y}{\mathbf{y}}
\newcommand{\A}{\mathbf{A}}

\newcommand{\argmin}[1]{\text{argmin}_{!#1}\;}

\newcommand{\reals}{\mathbb{R}}
