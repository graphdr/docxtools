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

test_that("put_axes() attributes match expectations",{

	p <- put_axes(0)
  expect_identical(class(p$data), "waiver")
  expect_identical(p$theme$plot.margin, unit(c(0, 0, 0, 0), "mm"))

  p <- put_axes(col = "blue", size = 1)
  expect_identical(p$layers[[1]]$geom$non_missing_aes, c("linetype", "size",      "shape"))

  p <- put_axes(2)
  expect_true(purrr::is_empty(p$mapping))
  p <- put_axes(3)
  expect_true(purrr::is_empty(p$mapping))
  p <- put_axes(4)
  expect_true(purrr::is_empty(p$mapping))
  p <- put_axes(12)
  expect_true(purrr::is_empty(p$mapping))
  p <- put_axes(23)
  expect_true(purrr::is_empty(p$mapping))
  p <- put_axes(34)
  expect_true(purrr::is_empty(p$mapping))
  p <- put_axes(14)
  expect_true(purrr::is_empty(p$mapping))
})

test_that("put_gap() attributes match expectations",{

	p <- put_gap()
	# expect_identical(class(p$data), "waiver")
	expect_identical(p$theme$plot.margin, NULL)

	p <- put_gap(col = "blue", fill = "blue")
	expect_true(purrr::is_empty(p$layers))
})

# rprojroot stuff
# http://r-lib.github.io/rprojroot/articles/rprojroot.html#testthat-files
# create my_args.Rdata and expected_output.Rdata
# see helper.R file

# testthat::test_that("put_gap() returns expected output", {
#   load(file = get_my_path("my_args_13.rda"))
#   load(file = get_my_path("exp_out_13.rda"))
#   testthat::expect_equal(do.call(docxtools::put_gap, my_args), exp_out)
#
#   load(file = get_my_path("my_args_14.rda"))
#   load(file = get_my_path("exp_out_14.rda"))
#   testthat::expect_equal(do.call(docxtools::put_gap, my_args), exp_out)
# })