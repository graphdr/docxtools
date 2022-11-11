#' @importFrom ggplot2 ggplot geom_segment aes theme coord_fixed
#' @importFrom ggplot2 element_blank unit
NULL

#' Insert a two-dimensional coordinate axes in a document.
#'
#' Creates an empty, 2-dimensional, coordinate axes using \code{ggplot2}: no
#' scales, no tick marks, no axis labels.
#'
#' The size of the figure is determined when printed, e.g., using \code{knitr}
#' in an R Markdown script, the figure height in inches is set with the
#' \code{fig.height} code chunk option.
#'
#' @param quadrant : The quadrant to plot, 1, 2, 3, 4, or 0 for all four.
#'   Default is the first quadrant.
#' @param col : Line color, default is \code{"gray60"}.
#' @param linewidth : Line width, default is \code{0.5}.
#'
#' @return The empty axes.
#'
#'
#' @export
put_axes <- function(quadrant = NULL, col = NULL, linewidth = NULL) {
  if (is.null(quadrant)) quadrant <- 1
  if (is.null(col)) col <- "gray60"
  if (is.null(linewidth)) linewidth <- 0.5
  if (quadrant == 0) {
    x_lim <- c(-1, 1)
    y_lim <- c(-1, 1)
  } else if (quadrant == 1) {
    x_lim <- c(0, 1)
    y_lim <- c(0, 1)
  } else if (quadrant == 2) {
    x_lim <- c(-1, 0)
    y_lim <- c(0, 1)
  } else if (quadrant == 3) {
    x_lim <- c(-1, 0)
    y_lim <- c(-1, 0)
  } else if (quadrant == 4) {
    x_lim <- c(0, 1)
    y_lim <- c(-1, 0)
  } else if (quadrant == 12 | quadrant == 21) {
    x_lim <- c(-1, 1)
    y_lim <- c(0, 1)
  } else if (quadrant == 23 | quadrant == 32) {
    x_lim <- c(-1, 0)
    y_lim <- c(-1, 1)
  } else if (quadrant == 34 | quadrant == 43) {
    x_lim <- c(-1, 1)
    y_lim <- c(-1, 0)
  } else if (quadrant == 14 | quadrant == 41) {
    x_lim <- c(0, 1)
    y_lim <- c(-1, 1)
  } else {
    stop("Incorrect quadrant argument.")
  }
  p <- ggplot() +
    geom_segment(aes(x = x_lim[1], y = 0, xend = x_lim[2], yend = 0),
      col = col, linewidth = linewidth, lineend = "square"
    ) +
    geom_segment(aes(x = 0, y = y_lim[1], xend = 0, yend = y_lim[2]),
      col = col, linewidth = linewidth, lineend = "square"
    ) +
    theme(
      axis.ticks = element_blank(),
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      panel.background = element_blank(),
      plot.margin = unit(c(0, 0, 0, 0), "mm")
    ) +
    coord_fixed(xlim = x_lim, ylim = y_lim)
  return(p)
}
"put_axes"
