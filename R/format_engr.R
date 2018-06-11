#' @importFrom magrittr %>%
#' @importFrom dplyr mutate filter select left_join if_else bind_cols
#' @importFrom tidyr gather separate spread
#' @importFrom stringr  str_replace str_c str_detect
#' @importFrom rlang syms
#' @importFrom purrr map_chr
NULL

#' Format numerical variables in engineering notation.
#'
#' Converts numeric objects into character variables formatted in engineering
#' notation: base 10 with exponents that are multiples of 3. The input argument
#' is a data frame with at least one numeric variable.
#'
#' Non-numeric variables in a data frame are unaffected and are returned as-is.
#'
#' Each numeric variable can be assigned its own number of significant digits.
#' The default is 4. If \code{sigdig} is a single value, it is used for all
#' variables; if an array, it must have the same number of elements as there
#' are numeric variables in the data frame. Setting \code{sigdig = 0}
#' returns the numerical variables with no change to the numbers of digits.
#'
#' The output format is "coefficient x 10^exponent" except for exponents equal
#' to 0, 1, or 2. In these cases, the output format is floating-point. In all
#' cases, the decimal point in the coefficient floats.
#'
#' Trailing zeros to the right of a decimal are significant. A trailing zero
#' before a decimal is ambiguous; such numbers are reported with the decimal
#' moved an additional three places to the left except for cases in which doing
#' so results in a zero coefficient due to a small number of significant
#' digits.
#'
#' The numerical output strings are bounded by \code{"$...$"} for rendering in
#' an R markdown output document, e.g., HTML, PDF, or DOCX. For example, the
#' Rmd code chunk  \code{knitr::kable(engr_format(df))} prints the formatted
#' data frame to the output document.
#'
#' To learn more about docxtools, start with the vignettes:
#' \code{browseVignettes(package = "docxtools")}.
#'
#' @param x : The numeric object to be formatted.
#' @param sigdig : An optional vector of significant digits.
#' @param ambig_0_adj : An optional logical to adjust the format
#'     to remove ambiguous trailing zeros. Default is FALSE. If TRUE, the
#'     decimal point is moved three places to the left.
#'
#' @return A data frame with numeric variables converted
#'   to formatted strings bounded by \code{"$...$"}.
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
#'
#' \dontrun{
#' # if no columns are numeric, an error is thrown, e.g.,
#' a
#' format_engr(a)
#'
#' Error if input is not a data frame
#' format_engr(y, 2)  # numeric vector
#' }
#'
#' @export
format_engr <- function(x, sigdig = NULL, ambig_0_adj = FALSE) {

	# input argument x must be a data frame
	if (!is.data.frame(x)) {
		warning("Argument must be a data frame.")
		return(x)
	} else {
		# if already a df, make sure not a tibble (conflict with format)
		x <- as.data.frame(x)
	}

	# default significant digits
	if (is.null(sigdig)) {
		sigdig <- 4L
	} else if (any(sigdig < 0)) {
		warning("Significant digits must be 0 or positive integers.")
		return(x)
	} else {
		sigdig <- as.integer(sigdig) # ensure integer
	}

	# at least one column must be numeric
	var_class <- purrr::map_chr(x, class)

	if (!"numeric" %in% var_class) {
		warning("No columns are numeric.")
		return(x)
	}

	# obtain list of symbolic variable names to recover column order
	var_name_list <- rlang::syms(names(x))

	# separate numeric from non-numeric (can be empty)
	numeric_col <- x[ , var_class == "numeric", drop = FALSE]
	non_numeric <- x[ , var_class != "numeric", drop = FALSE]

	# sigdig vector length = 1
	m_numeric_col <- ncol(numeric_col)
	if (length(sigdig) == 1) {
		sigdig <- rep(sigdig, m_numeric_col)
	}
	# or length must = N numeric col
	if (length(sigdig) != m_numeric_col) {
		warning(paste("sigdig must have length 1 or", m_numeric_col))
		return(x)
	}

	# separate cols to be engr formatted
	numeric_as_is <- numeric_col[ , sigdig == 0, drop = FALSE]
	m_numeric_as_is <- ncol(numeric_as_is)

	numeric_engr  <- numeric_col[ , sigdig != 0, drop = FALSE]
	m_numeric_engr <- ncol(numeric_engr)
	sigdig_engr <- sigdig[sigdig > 0]

	# for rejoining later, add observation numbers to each df
	obs_add <- function(x) {
		x <- dplyr::mutate(x, observ_index = 1:n())
	}
	numeric_as_is <- obs_add(numeric_as_is)
	numeric_engr <- obs_add(numeric_engr)
	non_numeric <- obs_add(non_numeric)

	# format the numeric variables for all with sigdig > 0
	if (m_numeric_engr > 0) {

		# separate significand from the power of ten
		numeric_engr <- format(numeric_engr, scientific = TRUE) %>%
			tidyr::gather(var, value, 1:m_numeric_engr) %>%
			dplyr::mutate(observ_index = as.double(observ_index))	 %>%
			dplyr::mutate(value = as.character(value))	 %>%
			# is it possible that separating by "e" varies by platform?
			tidyr::separate(value, c("num", "pow"), "e", remove = FALSE) %>%
			mutate(num = as.double(num)) %>%
			mutate(pow = as.double(pow))

		# asssign nonzero signif digits
		numeric_engr <- numeric_engr %>%
			dplyr::mutate(dig = rep(sigdig_engr, each = max(observ_index)))

		# power of 10 in multiples of 3
		numeric_engr <- numeric_engr %>%
			mutate(div = pow %% 3) %>%
			mutate(num = num * 10^div) %>%
			mutate(num_sign = sign(num)) %>%
			mutate(pow = round(pow - div, 0))

		# construct strings in batches by sigdig
		collect <- numeric_engr[FALSE, ]
		collect$num_str <- character()

		for (jj in unique(sigdig_engr)) {
			numeric_string <- numeric_engr %>%
				filter(dig == jj) %>%
				# flag = "#" ensures keeping trailing zeros
				mutate(num_str = formatC(
					signif(num, digits = jj),
					digits = jj,
					format = "fg",
					flag = "#")) %>%
				# delete decimal if it is the last character in the string
				mutate(num_str = str_replace(num_str, "\\.$", ""))

			# identify ambiguous trailing zeros: ends in 0 and no decimal point
			sel <- stringr::str_detect(numeric_string$num_str, "\\.")
			sel <- !sel & str_detect(numeric_string$num_str, "0$")

			# operate on selected num_str and pow only
			if (any(sel) & ambig_0_adj) {
			numeric_string$pow[sel] <- numeric_string$pow[sel] + 3
			temp_num <- as.numeric(numeric_string$num_str[sel]) / 1000
			numeric_string$num_str[sel] <- formatC(
				signif(temp_num, digits = jj),
				digits = jj,
				format = "fg",
				flag = "#")
			}
			collect <- rbind(collect, numeric_string)
		}
		numeric_engr <- collect

		# minus sign added to string if needed
		numeric_engr <- numeric_engr %>%
			mutate(num_str = dplyr::if_else(
				num_sign < 0,
				stringr::str_c("-", num_str),
				num_str
			))

		# framework for printing as math with $...$
		numeric_engr <- numeric_engr %>%
			mutate(output = dplyr::if_else(
				pow == 0,
				"$nn$",
				paste("${nn}\\times 10^{pp}$")
			))

		# place numbers and power of ten in string
		numeric_engr <- numeric_engr %>%
			mutate(output = stringr::str_replace(output, "nn", num_str)) %>%
			mutate(output = stringr::str_replace(output, "pp", as.character(pow)))

		# reformat wide to match input
		numeric_engr <- numeric_engr %>%
			dplyr::select(observ_index, var, output) %>%
			tidyr::spread(var, output)
	}

	# place numeric_as_is in $...$, if any
	if (m_numeric_as_is > 0) {
		observ_index <- numeric_as_is %>%  select(observ_index)
		num_col   <- numeric_as_is %>%  select(-observ_index)

		for (jj in 1:m_numeric_as_is){
			num_col[ , jj] <- str_c("$", num_col[ , jj], "$")
		}

		numeric_as_is <- bind_cols(num_col, observ_index)
	}

	# rejoin the parts (each part has at least the observ_index column)
	x <- dplyr::left_join(non_numeric, numeric_as_is, by = "observ_index")
	x <- dplyr::left_join(x, numeric_engr, by = "observ_index")
	x <- dplyr::select(x, !!!var_name_list)
}
"format_engr"
