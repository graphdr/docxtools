#' docxtools: R Markdown to docx helper functions.
#'
#' The docxtools package provides a set of helper functions for using R Markdown
#' to create documents in docx format, especially documents for use in a
#' classroom or workshop setting.
#'
#' The package provides two categories of functions: one for formatting numbers
#' and tables; and one for placing specific objects in a docx output document.
#'
#'
#' @section Number and table formatting:
#'
#'   \code{format_engr()} Format numerical variables in engineering notation.
#'
#'   \code{align_pander()} Align the columns of a pander table.
#'
#' @section Insert objects into docx documents:
#'
#'   \code{put_axes()} Insert a two-dimensional coordinate axes in a document.
#'
#'   \code{put_gap()}  Insert a gap or whitespace in a document.
#'
#' @import pander
#' @import stringr
#' @import ggplot2
#' @import dplyr
#' @import stringr
#' @import tidyr
#'
#' @docType package
#' @name docxtools
NULL