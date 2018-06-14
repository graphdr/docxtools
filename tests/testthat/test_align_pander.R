# run from devtools::test() only, otherwise the rds files are written
# to the project root directory

# add rprojroot to Suggests in DESCRIPTION file

context("align_pander")

# trying the rprojroot stuff
# http://r-lib.github.io/rprojroot/articles/rprojroot.html#testthat-files
# create my_args.Rdata and expected_output.Rdata
# see helper.R file

# run the function with saved arguments
path_to_my_args_file <- get_my_path("my_args_02.rda")
load(file = path_to_my_args_file)
my_fun_run <- do.call(docxtools::align_pander, my_args)

# get the expected output and test
load(file = get_my_path("exp_out_02.rda"))

testthat::test_that(
	"align_pander() returns expected output",
	testthat::expect_equal(
		my_fun_run,
		cat(exp_out)
	)
)

test_that("Input arguments have correct form", {
	x <- mtcars[1, 1:5]
	expect_warning(
		align_pander(x, align_idx = "rcrr")
		, "The length of align_idx should be 5 characters."
		)
})



