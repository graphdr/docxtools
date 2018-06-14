# helper function for using rprojroot

get_my_path <- function(filename) {
	rprojroot::find_testthat_root_file(
		"testing_data", filename
	)
}

### create argumnents and expected result
### arguments in a list to be use with do.call
# data("CO2")
# x <- as.data.frame(head(CO2, n = 5L))
# y <- format_engr(x, sigdig = sigdig, ambig_0_adj = ambig_0_adj)
# sigdig <- c(3, 3)
# ambig_0_adj <- TRUE

### for testing format_engr()
# my_args <- list(x, sigdig, ambig_0_adj)
# save(my_args, file = "tests/testthat/testing_data/my_args_01.rda")
# exp_out <- format_engr(x, sigdig = sigdig, ambig_0_adj = ambig_0_adj)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_01.rda")

### for testing align_pander()
# my_args <- list(y)
# save(my_args, file = "tests/testthat/testing_data/my_args_02.rda")
# exp_out <- capture_output(align_pander(y))
# save(exp_out, file = "tests/testthat/testing_data/exp_out_02.rda")
