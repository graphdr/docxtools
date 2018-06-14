# run from devtools::test() only, otherwise the rds files are written
# to the project root directory

# add rprojroot to Suggests in DESCRIPTION file

context("put_functions")

test_that("Input arguments have correct form", {
	expect_error(
		put_axes(quadrant = 22),
		"Incorrect quadrant argument."
	)
})

# rprojroot stuff
# http://r-lib.github.io/rprojroot/articles/rprojroot.html#testthat-files
# create my_args.Rdata and expected_output.Rdata
# see helper.R file

# run the function with saved arguments
# path_to_my_args_file <- get_my_path("my_args_03.rda")
# load(file = path_to_my_args_file)
# my_fun_run <- do.call(docxtools::put_axes, my_args)
#
# # get the expected output and test
# load(file = get_my_path("exp_out_03.rda"))
#
# testthat::test_that(
# 	"put_axes() returns expected output",
# 	testthat::expect_equal(
# 		my_fun_run,
# 		exp_out
# 	)
# )

testthat::test_that("put_axes() returns expected output", {

	load(file = get_my_path("my_args_03.rda"))
	load(file = get_my_path("exp_out_03.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_04.rda"))
	load(file = get_my_path("exp_out_04.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_05.rda"))
	load(file = get_my_path("exp_out_05.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_06.rda"))
	load(file = get_my_path("exp_out_06.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_07.rda"))
	load(file = get_my_path("exp_out_07.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_08.rda"))
	load(file = get_my_path("exp_out_08.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_09.rda"))
	load(file = get_my_path("exp_out_09.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_10.rda"))
	load(file = get_my_path("exp_out_10.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_11.rda"))
	load(file = get_my_path("exp_out_11.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

	load(file = get_my_path("my_args_12.rda"))
	load(file = get_my_path("exp_out_12.rda"))
	testthat::expect_equal(do.call(docxtools::put_axes, my_args), exp_out)

})



