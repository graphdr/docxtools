#' @title align_pander
#' @description Align the columns of a pander table
#' @param x A data frame to be printed in the output document
#' @param align_idx Optional string made up of \code{l} (left-aligned),
#'   \code{r} (right-aligned), and \code{c} (center-aligned)
#' @param caption Optional string used as the \code{pander()} caption
#'   argument
#' @return Prints the data frame in table form using \code{pander(x)}
#' @name align_pander-deprecated
#' @usage align_pander(x, align_idx = NULL, caption = NULL)
#' @seealso \code{\link{docxtools-deprecated}}
#' @keywords internal
NULL

#' @rdname docxtools-deprecated
#' @section \code{align_pander}:
#'   For \code{align_pander}, use \code{kable::knitr}.
#'
#' @export
align_pander <- function(x, align_idx = NULL, caption = NULL) {
  .Deprecated("kable", package = "knitr")
  invisible()
}
