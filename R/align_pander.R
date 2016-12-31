#' Align the columns of a pander table.
#'
#' Uses \code{pander()} to print a data frame as a table to the output document.
#'
#' Uses \code{panderOptions('table.alignment.default')} argument to assign output column alignment.
#'
#' The default alignments are numeric right and everything else left.
#'
#' @param x : A data frame to be printed in the output document.
#' @param align_idx : Optional string made up of \code{l} (left-aligned), \code{r} (right-aligned), and \code{c} (center-aligned).
#' @param caption : Optional string used as the \code{pander()} caption argument.
#'
#' @import pander
#' @import stringr
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
		panderOptions('table.alignment.default'
			, function(x) ifelse(sapply(x, is.numeric), 'right', 'left'))
	} else {
		align_idx <- unlist(str_split(align_idx, ""))
		align_idx <- str_replace_all(align_idx, 'l', 'left')
		align_idx <- str_replace_all(align_idx, 'r', 'right')
		align_idx <- str_replace_all(align_idx, 'c', 'center')
		panderOptions('table.alignment.default', align_idx)
	}
	panderOptions('table.split.table', Inf)
	panderOptions('keep.trailing.zeros', TRUE)
	pander(x, caption = caption, style = 'simple')
}

