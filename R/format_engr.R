#' @importFrom dplyr n mutate filter select left_join if_else bind_cols %>%
#' @importFrom tidyr gather separate spread
#' @importFrom stringr  str_replace str_c str_detect str_trim
#' @importFrom rlang syms is_double is_integer is_character
#' @importFrom purrr map
#' @importFrom lubridate is.Date
NULL

#' Format numerical variables in engineering notation.
#'
#' Converts numeric variables in a data frame into character variables
#' formatted in engineering notation. The formatted character variables
#' are delimited with \code{$...$} for rendering as inline math.
#'
#' Engineering notation is a subset of scientific notation: the exponent of
#' ten must be divisible by three. Powers of ten are written with a product
#' symbol (the LaTeX \code{\\times} symbol), not computer E-notation. The
#' numerical output strings are bounded by \code{$...$} for rendering in
#' math mode.
#'
#' The output format is "coefficient x 10^exponent" except for exponents equal
#' to 0, 1, or 2. In these cases, the output format is floating-point.
#'
#' The input argument is a data frame with at least one numeric variable.
#' Only double variables (not integers and not dates) are formatted in
#' powers of ten.
#'
#' The function distinguishes between integers that represent factors and
#' those that represent numerical integers. Numerical integers are returned
#' as characters in math mode. Factors and other non-numeric variables
#' are returned unaffected.
#'
#' Each double variable (except dates) can be assigned its own number
#' of significant digits. The default is 4. If \code{sigdig} is a single
#' value, it is used for all variables; if a vector, it must have the
#' same number of elements as there are double variables in the data frame.
#' Setting \code{sigdig = 0} returns the double variables as characters
#' but unaltered.
#'
#' For numbers with no decimal point, trailing zeros can be ambiguous.
#' Such numbers can be optionally reported with the decimal moved an
#' additional three places to the left.
#'
#' To learn more about docxtools, start with the vignettes:
#' \code{browseVignettes(package = "docxtools")}.
#'
#' @param x A data frame with numeric variables to be formatted.
#' @param sigdig An optional vector of significant digits.
#' @param ambig_0_adj An optional logical to adjust the format
#'     to remove ambiguous trailing zeros. If TRUE, the decimal point is
#'     moved three places to the left. Default is FALSE.
#'
#' @return A data frame with numeric variables converted
#'   to formatted strings bounded by \code{"$...$"}.
#'
#' @examples
#' # Factors unaffected; ambiguous trailing zeros.
#' data("CO2")
#' x <- as.data.frame(head(CO2, n = 5L))
#' format_engr(x)
#' format_engr(x, sigdig = c(0, 3))
#' format_engr(x, sigdig = c(3, 3), ambig_0_adj = TRUE)
#'
#' # Ordered factor unaffected; ambiguous trailing zeros.
#' data("DNase")
#' x <- as.data.frame(tail(DNase, n = 5L))
#' format_engr(x)
#' format_engr(x, sigdig = c(6, 3))
#' format_engr(x, sigdig = c(6, 3), ambig_0_adj = TRUE)
#'
#' # Integers returned unchanged but delimited; NA unchanged.
#' data("airquality")
#' x <- head(airquality, n = 6L)
#' format_engr(x, sigdig = 3)
#'
#' @importFrom dplyr n
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

  # obtain list of symbolic variable names to recover column order
  var_name_list <- rlang::syms(names(x))

  # separate columns into three groups: double, numerical integer, others
  # double will be engr formatted, integer delimited $...$, others as-is
  # if no columns are of type double, return with warning

  double_TF  <- purrr::map(x, rlang::is_double) %>% unlist()
  integer_TF <- purrr::map(x, rlang::is_integer) %>% unlist()
  ordered_TF <- purrr::map(x, is.ordered) %>% unlist()
  factor_TF  <- purrr::map(x, is.factor) %>% unlist()
  charac_TF  <- purrr::map(x, rlang::is_character) %>% unlist()
  date_TF    <- purrr::map(x, lubridate::is.Date) %>% unlist()

  # double but not Date
  yes_double <- double_TF & !ordered_TF & !integer_TF &
    !factor_TF & !charac_TF & !date_TF
  # integers but not factors
  yes_integer <- integer_TF & !double_TF & !ordered_TF &
    !factor_TF & !charac_TF & !date_TF
  # everything else
  yes_others <- !yes_double & !yes_integer

  if (!any(yes_double)) {
    warning("No columns are of type double")
    return(x)
  }

  # sort columns of input into three mutually exclusive data frames
  double_col <- x[, yes_double, drop = FALSE]
  integer_col <- x[, yes_integer, drop = FALSE]
  all_other_col <- x[, yes_others, drop = FALSE]

  # sigdig vector length = 1
  m_double_col <- ncol(double_col)
  if (length(sigdig) == 1) {
    sigdig <- rep(sigdig, m_double_col)
  }
  # or length must = N numeric col
  if (length(sigdig) != m_double_col) {
    warning(paste(
      "Incorrect length sigdif vector. Applies only to numeric class 'double'."
    ))
    return(x)
  }

  # separate cols to be engr formatted
  numeric_engr <- double_col[, sigdig != 0, drop = FALSE]
  sigdig_engr <- sigdig[sigdig > 0]
  m_numeric_engr <- ncol(numeric_engr)

  # join as-is double (0 sig dig) with integers
  numeric_as_is <- double_col[, sigdig == 0, drop = FALSE]
  numeric_as_is <- bind_cols(numeric_as_is, integer_col)
  m_numeric_as_is <- ncol(numeric_as_is)

  # for rejoining later, add observation numbers to each df
  obs_add <- function(x) {
    x <- dplyr::mutate(x, observ_index = dplyr::row_number())
  }
  numeric_as_is <- obs_add(numeric_as_is)
  numeric_engr <- obs_add(numeric_engr)
  all_other_col <- obs_add(all_other_col)

  # format the numeric variables for all with sigdig > 0
  if (m_numeric_engr > 0) {

    # separate significand from the power of ten
    numeric_engr <- format(numeric_engr, scientific = TRUE) %>%
      tidyr::gather(var, value, 1:m_numeric_engr) %>%
      dplyr::mutate(observ_index = as.double(observ_index)) %>%
      mutate(value = ifelse(
        is.na(value),
        NA_character_,
        as.character(value)
      )) %>%
      # is it possible that separating by "e" varies by platform?
      # fill = right helps with an NA condition
      tidyr::separate(value, c("num", "pow"), "e",
        remove = FALSE, fill = "right"
      ) %>%
      # remove blanks around NA if any
      mutate(num = str_trim(num, side = "both")) %>%
      mutate(pow = str_trim(pow, side = "both")) %>%
      # convert any NA string to NA, otherwise double
      mutate(num = ifelse(!is.na(num), as.numeric(num), NA)) %>%
      mutate(pow = ifelse(!is.na(pow), as.numeric(pow), NA))

    # assign nonzero signif digits
    numeric_engr <- numeric_engr %>%
      dplyr::mutate(dig = rep(sigdig_engr, each = max(observ_index)))

    # power of 10 in multiples of 3 (pow mod 3)
    numeric_engr <- numeric_engr %>%
      mutate(div = pow %% 3) %>%
      mutate(num = num * 10^div) %>%
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
          flag = "#"
        )) %>%
        # delete decimal if it is the last character in the string
        mutate(num_str = str_replace(num_str, "\\.$", ""))

      # identify ambiguous trailing zeros: ends in 0 and no decimal point
      sel <- stringr::str_detect(numeric_string$num_str, "\\.")
      sel <- !sel & str_detect(numeric_string$num_str, "0$")

      # operate on selected num_str and pow only
      if (any(sel) & !is.null(ambig_0_adj)) {
        if (ambig_0_adj) {
          numeric_string$pow[sel] <- numeric_string$pow[sel] + 3
          temp_num <- as.numeric(numeric_string$num_str[sel]) / 1000
          numeric_string$num_str[sel] <- formatC(
            signif(temp_num, digits = jj),
            digits = jj,
            format = "fg",
            flag = "#"
          )
        }
      }
      collect <- rbind(collect, numeric_string)
    }
    numeric_engr <- collect

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
    observ_index <- numeric_as_is %>% select(observ_index)
    num_col <- numeric_as_is %>% select(-observ_index)

    for (jj in 1:m_numeric_as_is) {
      num_col[, jj] <- str_c("$", num_col[, jj], "$")
    }

    numeric_as_is <- bind_cols(num_col, observ_index)
  }

  # rejoin the parts (each part has at least the observ_index column)
  x <- dplyr::left_join(all_other_col, numeric_as_is, by = "observ_index")
  x <- dplyr::left_join(x, numeric_engr, by = "observ_index")
  x <- dplyr::select(x, !!!var_name_list)
}
"format_engr"
