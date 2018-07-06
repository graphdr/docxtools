## docxtools 0.2.0 (2018-07-05)

### Deprecated

- `align_pander()` deprecated because pander package scheduled for archival on 2018--07--19 

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
