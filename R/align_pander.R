#' @importFrom pander pander panderOptions
#' @importFrom stringr str_length str_split str_replace_all
NULL

#' Align the columns of a pander table.
#'
#' Uses \code{pander()} to print a data frame as a table to the output
#' document.
#'
#' Uses \code{panderOptions('table.alignment.default')} argument to assign
#' output column alignment. The default alignments are numeric right and
#' everything else left.
#'
#' If \code{align_idx} is not NULL, a warning message is generated if its
#' string length does not match the number of columns in the table.
#'
#' The function also sets these pander options as defaults:
#'   \itemize{
#'     \item \code{table.split.table = Inf}
#'     \item \code{keep.trailing.zeros = TRUE}
#'     \item \code{style = 'simple'}
#'   }
#'
#' @param x A data frame to be printed in the output document.
#' @param align_idx Optional string made up of \code{l} (left-aligned),
#'   \code{r} (right-aligned), and \code{c} (center-aligned).
#' @param caption Optional string used as the \code{pander()} caption
#'   argument.
#'
#' @return Prints the data frame in table form using \code{pander(x)}.
#'
#' @examples
#' x <- mtcars[1:5, 1:5]
#' align_pander(x)
#' align_pander(x, align_idx = "rcrrr")
#' align_pander(x, caption = "A nicely formatted table")
#'
#' @export
align_pander <- function(x, align_idx = NULL, caption = NULL) {
  stopifnot(is.data.frame(x))

  if (is.null(align_idx)) {
    pander::panderOptions(
      "table.alignment.default",
      function(x) ifelse(sapply(x, is.numeric), "right", "left")
    )
  } else {
    if (dim(x)[2] != stringr::str_length(align_idx)) {
      warning(paste(
        "The length of align_idx should be",
        dim(x)[2],
        "characters."
      ))
    }
    align_idx <- unlist(stringr::str_split(align_idx, ""))
    align_idx <- stringr::str_replace_all(align_idx, "l", "left")
    align_idx <- stringr::str_replace_all(align_idx, "r", "right")
    align_idx <- stringr::str_replace_all(align_idx, "c", "center")
    pander::panderOptions("table.alignment.default", align_idx)
  }

  pander::panderOptions("table.split.table", Inf)
  pander::panderOptions("keep.trailing.zeros", TRUE)
  pander::pander(x, caption = caption, style = "simple")
}
"align_pander"
