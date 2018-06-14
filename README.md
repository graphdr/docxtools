
<!-- README.md is generated from README.Rmd. Please edit that file -->

# docxtools <img src="man/figures/logo.png" align="right" />

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/docxtools)](http://cran.r-project.org/package=docxtools)
[![Build
Status](https://travis-ci.org/graphdr/docxtools.svg?branch=master)](https://travis-ci.org/graphdr/docxtools)
[![Coverage
Status](https://img.shields.io/codecov/c/github/graphdr/docxtools/master.svg)](https://codecov.io/github/graphdr/docxtools?branch=master)

## Overview

docxtools is a small set of helper functions for using R Markdown to
create documents in docx format, especially documents for use in a
classroom or workshop setting. These are particularly useful when one
tries to does one own’s work reproducibly but has collaborators who work
with Office software exclusively.

  - `format_engr()` to apply engineering format to numbers  
  - `align_pander()` to print a table of numbers using pander
  - `put_gap()` to create white space in a document
  - `put_axes()` to place unlabeled axes in a document

## Installation

From CRAN,

``` r
install.packages("docxtools")
```

Or you can obtain the latest devlopment version from GitHub

``` r
install.packages("devtools")
devtools::install_github("graphdr/docxtools")
```

## Usage

``` r
library(docxtools)

data("density")
y <- format_engr(density, sigdig = c(5, 4, 0, 4), ambig_0_adj = TRUE)

align_pander(y)
```

| date       | trial | T\_K       | p\_Pa                    | R       | density   |
| :--------- | :---- | :--------- | :----------------------- | :------ | :-------- |
| 2018-06-12 | a     | \(294.05\) | \({101.1}\times 10^{3}\) | \(287\) | \(1.198\) |
| 2018-06-13 | b     | \(294.15\) | \({101.0}\times 10^{3}\) | \(287\) | \(1.196\) |
| 2018-06-14 | c     | \(294.65\) | \({101.1}\times 10^{3}\) | \(287\) | \(1.196\) |
| 2018-06-15 | d     | \(293.35\) | \({101.0}\times 10^{3}\) | \(287\) | \(1.200\) |
| 2018-06-16 | e     | \(293.85\) | \({101.1}\times 10^{3}\) | \(287\) | \(1.199\) |

Using `put_gap()` with knitr and R markdown, the gap height is specified
in the R code-chunk header.

<pre class="r"><code>```{r fig.height = 0.75}
# a gap with a border
put_gap(col = "gray", fill = NULL)
<code>```</code></code></pre>

<img src="../man/figures/README-004-1.png" width="70%" style="display: block; margin: auto;" />

For `put_axes()` with knitr and R markdown, the axis height is specified
in the R code-chunk header.

<pre class="r"><code>```{r fig.height = 2}
# first quadrant axes
put_axes(1, col = "blue", size = 2)
<code>```</code></code></pre>

<img src="../man/figures/README-005-1.png" width="70%" style="display: block; margin: auto;" />

-----

License: MIT + File LICENSE<br> Richard Layton
