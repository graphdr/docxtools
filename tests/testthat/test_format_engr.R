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
  y <- CO2[, 1:3]
  expect_warning(
    format_engr(y),
    "No columns are of type double"
  )
})

test_that("Integers are returned as characters but unformatted", {
  data("airquality")
  x <- head(airquality, n = 6L)
  y <- format_engr(x)
  expect_equal(class(x$Ozone), "integer")
  expect_equal(class(y$Ozone), "character")
})

test_that("sigdig vector is correct", {
  # data("airquality")
  # x <- head(airquality, n = 1L)
  x <- data.frame(Ozone = 41, Solar.R = 190, Wind = 7.4, Temp = 67, Month = 5, Day = 1)
  y <- format_engr(x, sigdig = 6)
  expect_equal(y$Wind, "$7.40000$")
  expect_warning(
    format_engr(x, sigdig = c(4, 3)),
    "Incorrect length sigdif vector. Applies only to numeric class 'double'."
  )
  expect_warning(
    format_engr(x, sigdig = -1),
    "Significant digits must be 0 or positive integers."
  )
})

# trying the rprojroot stuff
# http://r-lib.github.io/rprojroot/articles/rprojroot.html#testthat-files
# create my_args.Rdata and expected_output.Rdata
# see helper.R file

# run the function with saved arguments
path_to_my_args_file <- get_my_path("my_args_01.rda")
load(file = path_to_my_args_file)
my_fun_run <- do.call(docxtools::format_engr, my_args)

# Load the historical expectation with the helper
load(file = get_my_path("exp_out_01.rda"))

# Pass all tests and achieve nirvana
testthat::test_that(
  "format_engr() returns expected output",
  testthat::expect_equal(
    my_fun_run,
    exp_out
  )
)
