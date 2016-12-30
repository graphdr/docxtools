#' Format numerical variables in engineering notation.
#'
#' Converts numeric objects into character variables formatted in engineering
#' notation: base 10 with exponents that are multiples of 3. The input argument
#' is a numeric vector or a data frame with at least one numeric variable.
#'
#' The preferred input is a data frame. If the input is a numeric vector, it
#' will be formatted and returned as a data frame with the variable name
#' \code{value}. To preserve the variable name from the calling script, convert
#' the number or vector to a data frame before calling \code{engr_format()}.
#'
#' Non-numeric variables in a data frame are unaffected and are returned as-is.
#'
#' Each numeric variable can be assigned its own number of significant digits.
#' The default is 4. If \code{sigdig} is a single value, it is used for all
#' variables; if an array, an excess number of elements is truncated and a
#' shortage of elements is filled with the default 4. Setting \code{sigdig = 0}
#' returns the numerical variable as-is.
#'
#' The output format is "coefficient x 10^exponent" except for exponents equal
#' to 0, 1, or 2. In these cases, the output #' format is floating-point. In all
#' cases, the decimal point in the coefficient floats.
#'
#' Trailing zeros to the right of a decimal are significant. A trailing zero
#' before a decimal is ambiguous; such numbers are reported with the decimal
#' moved an additional three places to the left except for cases in which doing
#' so results in a zero coefficient due to a small number of significant digits.
#'
#' The numerical output strings are bounded by \code{"$...$"} for rendering in
#' an R markdown output document, e.g., HTML, PDF, or DOCX. For example, the Rmd
#' code chunk  \code{knitr::kable(engr_format(df))} prints the formatted data
#' frame to the output document.
#'
#' @param x : The numeric object to be formatted.
#' @param sigdig : An optional vector of significant digits.
#'
#' @import dplyr
#' @import stringr
#' @import tidyr
#'
#' @return The returned object is a data frame with numeric variables converted
#'   to formatted strings bounded by \code{"$...$"} and interpreted by R
#'   Markdown as an equation.
#'
#' @examples
#' # create test input arguments
#' set.seed(20161221)
#' n <- 5
#' a <- sample(letters, n)
#' b <- sample(letters, n)
#' w <- runif(n, min =  -5, max =  50) * 1e+5
#' y <- runif(n, min = -25, max =  40) / 1e+3
#' z <- runif(n, min =  -5, max = 100)
#' x <- data.frame(z, b, y, a, w, stringsAsFactors = FALSE)
#'
#' # format different objects
#' print(x)
#' format_engr(x)
#' format_engr(x, sigdig = 3)
#' format_engr(x, sigdig = c(3, 4, 5))
#' format_engr(y, 2)  # numeric vector
#' format_engr(n, 3)  # numeric scalar
#'
#' # using base R data sets
#' format_engr(DNase[1:10, ], sigdig = 4)
#' format_engr(mtcars[1:5, 1:5], sigdig = c(3, 0, 0, 0, 3))
#' format_engr(CO2[1:5,], 3)
#'
#' \dontrun{
#' format_engr(a) # non-numeric, produces an error}
#'
#' @export
format_engr <- function(x, sigdig = NULL) {
	# if x is scalar or vector, create data frame x$value
	if (is.atomic(x) & !is.list(x) & is.null(dim(x))) {
		x <- data.frame(x, stringsAsFactors = FALSE)
		names(x) <- "value"
	}
	stopifnot(is.data.frame(x))

	# to return data frame variables in the same order received
	orig_names <- names(x)
	n          <- dim(x)[1]
	obs        <- as.integer(1:n)

	# prepare significant digits
	if (is.null(sigdig)) sigdig <- 4
	sigdig <- as.integer(sigdig)
	stopifnot(sigdig >= 0)

	# declare variables to address the "no visible binding" check
	# there may be a better way, but I don't know what it is yet
	div      <- 0
	num_sign <- 0
	num      <- 0
	num_left <- 0
	num_str  <- ""
	output   <- ""
	pow      <- ""
	value    <- ""
	var      <- ""

	# isolate the numeric variables
	numeric_cols   <- x %>% select_if(is.numeric)
	m_numeric_cols <- dim(numeric_cols)[2]
	numeric_cols   <- mutate(numeric_cols, obs = obs)
	stopifnot(m_numeric_cols > 0)

	# match sigdig array to numeric data
	sigfig_length <- length(sigdig)
	if (sigfig_length == 1) {
		sigdig <- rep(sigdig, m_numeric_cols)
	} else if (sigfig_length > 1 & sigfig_length < m_numeric_cols) {
		sigdig <- c(sigdig, rep(4, m_numeric_cols - sigfig_length))
	} else if (sigfig_length > m_numeric_cols) {
		sigdig <- sigdig[1:m_numeric_cols]
	} else {
		sigdig <- sigdig
	}
	sigdig <- as.integer(sigdig)

	# format the numeric variables, omitting any with sigdig = 0
	if (sum(sigdig) > 0) {
		numeric_cols <- format(numeric_cols, scientific = TRUE) %>%
			gather(var, value, 1:m_numeric_cols) %>%
			separate(value, c("num",  "pow"), "e", remove = FALSE) %>%
			mutate(sigdig = rep(sigdig, each = n)) %>%
			filter(sigdig > 0) %>%
			mutate(num = as.numeric(num)) %>%
			mutate(pow = as.numeric(pow)) %>%
			mutate(div = pow %% 3) %>%
			mutate(num = num * 10 ^ div) %>%
			mutate(pow = round(pow - div, 0)) %>%
			mutate(num = signif(num, sigdig)) %>%
			mutate(num_sign = sign(num)) %>%
			mutate(num_str = sprintf(paste0("%.", sigdig, "f"), abs(num))) %>%
			separate(num_str, c("num_left", "num_right"), "\\.", remove = FALSE) %>%
			mutate(num_str = if_else(str_length(num_left) >= sigdig
															 , num_left
															 , str_trunc(num_str, sigdig + 1, "right", "")))

		# adjust coefficient and exponent when significance of trailing zero is ambiguous
		sel <- as.numeric(numeric_cols$num_right) == 0 & str_detect(numeric_cols$num_left, "0$") & as.numeric(numeric_cols$num_left)/1000 >= 0.1
		numeric_cols$num_str[sel] <- sprintf(paste0("%.", numeric_cols$sigdig[sel], "f"), as.numeric(numeric_cols$num_str[sel]) / 1000)
		numeric_cols$pow[sel] <- numeric_cols$pow[sel] + 3

		# continue the formatting
		numeric_cols <- numeric_cols %>%
			mutate(num_str = if_else(num_sign < 0, str_c("-", num_str), num_str)) %>%
			mutate(output  = if_else(pow == 0, "$nn$"
															 , str_replace(paste("${nn}\\times 10^{pp}$"), "pp", pow))) %>%
			mutate(output = str_replace(output, "nn", num_str)) %>%
			select(obs, var, output) %>%
			spread(var, output) %>%
			mutate(obs = as.integer(obs))
	} else {
		numeric_cols <- select(numeric_cols, obs)
	} # end of engr-format section

	# separate the zero sig dig cols if any
	non_numeric_logic <- !(names(x) %in% names(numeric_cols))
	non_numeric_cols  <- select(x, which(non_numeric_logic))

	zero_sig_cols   <- select_if(non_numeric_cols, is.numeric)
	m_zero_sig_cols <- dim(zero_sig_cols)[2]
	zero_sig_cols   <- mutate(zero_sig_cols, obs = obs)

	if (m_zero_sig_cols > 0) {
		zero_sig_cols <- zero_sig_cols %>%
			gather(var, value, 1:m_zero_sig_cols) %>%
			mutate(value = paste0("$", value, "$")) %>%
			spread(var, value)
	}

	non_numeric_logic0 <- !(names(non_numeric_cols) %in% names(zero_sig_cols))
	non_numeric_cols  <- select(non_numeric_cols, which(non_numeric_logic0)) %>%
		mutate(obs = obs)

	# rejoin the parts (each part has at least the obs column)
	df <- left_join(numeric_cols, zero_sig_cols, by = "obs")
	df <- left_join(df, non_numeric_cols, by = "obs")
	df <- select(df, -obs)

	x <- select(df, match(orig_names, names(df)))

	# return the df
	return(x)
}

