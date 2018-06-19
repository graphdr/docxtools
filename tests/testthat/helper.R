# helper function for using rprojroot
get_my_path <- function(filename) {
  rprojroot::find_testthat_root_file(
    "testing_data", filename
  )
}

# ## create argumnents and expected result
# ## arguments in a list to be use with do.call
# data("CO2")
# x <- as.data.frame(head(CO2, n = 5L))
# sigdig <- c(3, 3)
# ambig_0_adj <- TRUE
# y <- format_engr(x, sigdig = sigdig, ambig_0_adj = ambig_0_adj)
# rm("CO2")
#
# ## for testing format_engr()
# my_args <- list(x, sigdig, ambig_0_adj)
# save(my_args, file = "tests/testthat/testing_data/my_args_01.rda")
# exp_out <- format_engr(x, sigdig = sigdig, ambig_0_adj = ambig_0_adj)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_01.rda")
#
# ## for testing align_pander()
# my_args <- list(y)
# save(my_args, file = "tests/testthat/testing_data/my_args_02.rda")
# exp_out <- capture_output(align_pander(y))
# save(exp_out, file = "tests/testthat/testing_data/exp_out_02.rda")
#
# ## for testing put_axes()
# my_args <- list(quadrant = NULL, col = NULL, size = NULL)
# save(my_args, file = "tests/testthat/testing_data/my_args_03.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_03.rda")
#
# my_args <- list(quadrant = 1, col = "red", size = 1)
# save(my_args, file = "tests/testthat/testing_data/my_args_04.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_04.rda")
#
# my_args <- list(quadrant = 2)
# save(my_args, file = "tests/testthat/testing_data/my_args_05.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_05.rda")
#
# my_args <- list(quadrant = 3)
# save(my_args, file = "tests/testthat/testing_data/my_args_06.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_06.rda")
#
# my_args <- list(quadrant = 4)
# save(my_args, file = "tests/testthat/testing_data/my_args_07.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_07.rda")
#
# my_args <- list(quadrant = 0)
# save(my_args, file = "tests/testthat/testing_data/my_args_08.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_08.rda")
#
# my_args <- list(quadrant = 12)
# save(my_args, file = "tests/testthat/testing_data/my_args_09.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_09.rda")
#
# my_args <- list(quadrant = 23)
# save(my_args, file = "tests/testthat/testing_data/my_args_10.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_10.rda")
#
# my_args <- list(quadrant = 34)
# save(my_args, file = "tests/testthat/testing_data/my_args_11.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_11.rda")
#
# my_args <- list(quadrant = 14)
# save(my_args, file = "tests/testthat/testing_data/my_args_12.rda")
# exp_out <- do.call(docxtools::put_axes, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_12.rda")
#
# # for testing put_gap()
# my_args <- list(col = NULL, fill = NULL)
# save(my_args, file = "tests/testthat/testing_data/my_args_13.rda")
# exp_out <- do.call(docxtools::put_gap, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_13.rda")
# #
# my_args <- list(col = "gray30", fill = "gray70")
# save(my_args, file = "tests/testthat/testing_data/my_args_14.rda")
# exp_out <- do.call(docxtools::put_gap, my_args)
# save(exp_out, file = "tests/testthat/testing_data/exp_out_14.rda")
