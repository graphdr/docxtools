
## docxtools 0.1.2 (2018-06-11)

### Bug fixes

In `format_engr()`, corrected an error caused by an incorrect use of `str_trunc()`. 

### New features

In  `format_engr()`, added the `ambig_0_adj` argument.  Reformatting exponential notation to remove ambiguous trailing zeros is now an optional setting. 

### Minor improvements

In  `format_engr()`

- Replaced the formatting using `sprintf()` with `formatC()` for better control of significant trailing zeros. 
- Require the input to be a data frame. 
- Require the significant digits vector to have length 1 or match the number of numeric variables. 
- Replaced some code with tidy evaluation. 




<!-- ### New features -->

<!-- ### Minor improvements -->

<!-- ### Bug fixes -->

<!-- ### Deprecated -->

<!-- ### Defunct -->




## docxtools 0.1.1 (2017-03-10)

- released to CRAN 
