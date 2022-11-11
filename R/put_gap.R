#' @importFrom ggplot2 ggplot element_rect theme
NULL

#' Insert a gap or whitespace in a document.
#'
#' Creates white space in a document by creating an empty plot in
#' \code{ggplot2}. Border and fill can be specified to create a box. The
#' defaults are transparent.
#'
#' Allows the author of Rmd to docx documents to insert a vertical white space
#' of specified height, particularly useful in creating documents that users
#' are expected to write in, such as workshop or student lab materials.
#'
#' The dimensions of the gap are determined when it is printed, e.g., using
#' \code{knitr} in an R Markdown script, the box height in inches is set with
#' the \code{fig.height} code chunk option.
#'
#' @param col Border color, default is \code{"transparent"}
#' @param fill Fill color, default is \code{"transparent"}
#'
#' @return Prints the box to the output document.
#' @export
put_gap <- function(col = NULL, fill = NULL) {
  if (is.null(col)) col <- "transparent"
  if (is.null(fill)) fill <- "transparent"
  p <- ggplot() +
    theme(panel.background = element_rect(color = col, fill = fill, linewidth = 0.5))
  print(p)
}
"put_gap"
