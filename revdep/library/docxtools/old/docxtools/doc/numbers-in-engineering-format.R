## ----setup, echo = FALSE, message = FALSE-------------------------------------
# knitr::opts_knit$set(root.dir = "../")
knitr::opts_chunk$set(
  echo = TRUE, # varies from one Rmd to another
  message = FALSE,
  warning = FALSE,
  collapse = TRUE,
  comment = "#>",
  error = TRUE
)
knitr::knit_hooks$set(inline = function(x) {
  if (!is.numeric(x)) {
    x
  } else if (x >= 10000) {
    prettyNum(round(x, 2), big.mark = ",")
  } else {
    prettyNum(round(x, 2))
  }
})
options(tibble.print_min = 8L, tibble.print_max = 8L)

## -----------------------------------------------------------------------------
library("dplyr")
library("knitr")
library("docxtools")

## -----------------------------------------------------------------------------
density

## -----------------------------------------------------------------------------
map_chr(density, class)
map_chr(density, typeof)

## -----------------------------------------------------------------------------
density_engr <- format_engr(density)
density_engr

## -----------------------------------------------------------------------------
map_chr(density_engr, class)

## -----------------------------------------------------------------------------
kable(density_engr)

## -----------------------------------------------------------------------------
density_engr <- density %>%
  format_engr()
kable(density_engr)

## -----------------------------------------------------------------------------
density_engr <- format_engr(density, sigdig = 3)
kable(density_engr)

## -----------------------------------------------------------------------------
density_engr <- format_engr(density, sigdig = c(5, 4, 0, 5))
kable(density_engr)

## -----------------------------------------------------------------------------
x <- density %>%
  select(T_K, p_Pa, R, density)

## -----------------------------------------------------------------------------
kable(format_engr(x, sigdig = 4), caption = "4 digits")

## -----------------------------------------------------------------------------
kable(format_engr(x, sigdig = 3), caption = "3 digits")

## -----------------------------------------------------------------------------
kable(format_engr(x, sigdig = 2), caption = "2 digits")

## -----------------------------------------------------------------------------
kable(format_engr(x, sigdig = 2, ambig_0_adj = TRUE), caption = "Removing ambiguity")

## -----------------------------------------------------------------------------
kable(format_engr(x, sigdig = c(4, 2, 0, 3), ambig_0_adj = FALSE))

## -----------------------------------------------------------------------------
kable(format_engr(x, sigdig = c(4, 2, 0, 3), ambig_0_adj = TRUE))

