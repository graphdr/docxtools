#' Insert a two-dimensional coordinate axes in a document.
#'
#' Creates an empty, 2-dimensional, coordinate axes using \code{ggplot2}: no scales, no tick marks, no axis labels.
#'
#' The size of the figure is determined when printed, e.g., using \code{knitr} in an R Markdown script, the figure height in inches is set with the \code{fig.height} code chunk option.
#'
#' @param quadrant : The quadrant to plot, 1, 2, 3, 4, or 0 for all four. Default is the first quadrant.
#' @param col : Line color, default is \code{"gray60"}
#' @param size : Line width, default is \code{0.5}
#'
#' @return Prints the empty axes to the output document.
#'
#' @examples
#' put_axes()
#' put_axes(quadrant = 0)
#' put_axes(col = "red")
#' put_axes(size = 1)
#'
#' \dontrun{
#' # In an R Markdown script
#' ```{r fig.height = 3.2}
#' put_axes()
#' ```}
#'
#' @export
put_axes <- function(quadrant = NULL, col = NULL, size = NULL) {
	if (is.null(quadrant)) quadrant <- 1
	if (is.null(col))           col <- "gray60"
	if (is.null(size))         size <- 0.5
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
	} else{
		stop("put_axes(): Incorrect quadrant argument. Possible values are 0, 1, 2, 3, 4.")
	}
	p <- ggplot() +
		geom_line(aes(x = c(-1, 0, 1), y = c(0, 0, 0)), col = col, size = size) +
		geom_line(aes(x = c(0, 0, 0), y = c(-1, 0, 1)), col = col, size = size) +
		coord_fixed() +
		theme(axis.ticks = element_blank()
					, axis.text = element_blank()
					, axis.title = element_blank()
					, panel.grid = element_blank()
					, panel.background = element_blank()
		) +
		scale_x_continuous(limits = x_lim) +
		scale_y_continuous(limits = y_lim)
	suppressWarnings(print(p))
}