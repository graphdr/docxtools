# run from devtools::test() only, otherwise the rds files are written
# to the project root directory

# add rprojroot to Suggests in DESCRIPTION file

context("format_engr")

test_that("Input arguments have correct form", {
	expect_warning(format_engr(AirPassengers), "Argument must be a data frame.")
})

test_that("Factors are returned unaffected", {
	data("CO2")
	x <- format_engr(head(CO2, n = 5L))
	expect_equal(class(x$Plant), c("ordered", "factor"))
	expect_equal(class(x$Type), "factor")
})

test_that("Integers are returned as characters but unformatted", {
	data("airquality")
	x <- head(airquality, n = 6L)
	y <- format_engr(x)
	expect_equal(class(x$Ozone), "integer")
	expect_equal(class(y$Ozone), "character")
})

# trying the rprojroot stuff
# http://r-lib.github.io/rprojroot/articles/rprojroot.html#testthat-files
#
# create my_args.Rdata and expected_output.Rdata
# see helper.R file

# Find the correct path with the rprojroot helper function
path_to_my_args_file <- get_my_path("my_args.rda")

# Load the input arguments
load(file = path_to_my_args_file)

# Run the function with those arguments in a list
my_fun_run <- do.call(docxtools::format_engr, my_args)

# Load the historical expectation with the helper
load(file = get_my_path("expected_output.rda"))

# Pass all tests and achieve nirvana
testthat::test_that(
	"format_engr() returns expected output",
	testthat::expect_equal(
		my_fun_run,
		expected_output
	)
)