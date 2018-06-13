# helper function for using rprojroot

get_my_path <- function(filename) {
	rprojroot::find_testthat_root_file(
		"testing_data", filename
	)
}

# create argumnents and expected result
# arguments in a list to be use with do.call
# data("CO2")
# x <- as.data.frame(head(CO2, n = 5L))
# sigdig <- c(3, 3)
# ambig_0_adj <- TRUE
# my_args <- list(x, sigdig, ambig_0_adj)
# save(my_args,
# 		 file = "tests/testthat/testing_data/my_args.rda"
# 		 )
#
# expected_output <- format_engr(x, sigdig = sigdig, ambig_0_adj = ambig_0_adj)
# save(expected_output,
# 		 file = "tests/testthat/testing_data/expected_output.rda"
# )