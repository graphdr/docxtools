<!-- major . minor . patch . dev -->
<!-- MAJOR version when you make incompatible API changes -->
<!-- MINOR version add functionality in a backwards-compatible manner -->
<!-- PATCH version backwards-compatible bug fixes -->



## docxtools 0.2.2 (2020-05-06)

- Minor change for compatibility with dplyr 1.0.0 
- submitted to CRAN


## docxtools 0.2.1.9001 (2019-06-11)

- Add CRAN check badge 
- Add dependency badge 


## docxtools 0.2.1 (2019-02-09)

- Edited vignette to accommodate deprecated function `align_pander()`. Help pages for deprecated functions are available by running `help("docxtools-deprecated")`.

- Edited function `n()` as `dplyr::n()` for compatibility with dplyr release 0.8.0



## docxtools 0.2.0 (2018-07-05)

This update removes the dependency on CRAN package pander, now scheduled for archival on 2018--07--19.  

### Deprecated

- `align_pander()` deprecated, suggest using `knitr::kable()` instead

### Minor improvements

- Switched pipe dependency from magrittr to dplyr 




## docxtools 0.1.3 (2018-06-19)

- Updated unit testing for compatibility with latest version of ggplot2 

## docxtools 0.1.2 (2018-06-14)

### Bug fixes

In `format_engr()` 

- Corrected an error caused by an incorrect use of `str_trunc()`. 
- Variable types date, factor, ordered factor, and character are now correctly ignored by the formatting routine. 

### New features

In  `format_engr()`, added the `ambig_0_adj` argument.  An optional argument to reformat (or not) to address ambiguous trailing zeros. 

### Minor improvements

For  `format_engr()`

- Replaced the formatting using `sprintf()` with `formatC()` for better control of significant trailing zeros. 
- Require the input to be a data frame. 
- Require the significant digits vector to have length 1 or match the number of numeric variables. 
- Replaced some code with tidy evaluation. 
- Revised the vignettes and examples. 
- Unit testing to provide 100% coverage. 




<!-- ### New features -->

<!-- ### Minor improvements -->

<!-- ### Bug fixes -->

<!-- ### Deprecated -->

<!-- ### Defunct -->




## docxtools 0.1.1 (2017-03-10)

- released to CRAN 
