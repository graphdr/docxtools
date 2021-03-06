% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/align_pander.R
\name{align_pander}
\alias{align_pander}
\title{Align the columns of a pander table.}
\usage{
align_pander(x, align_idx = NULL, caption = NULL)
}
\arguments{
\item{x}{A data frame to be printed in the output document.}

\item{align_idx}{Optional string made up of \code{l} (left-aligned),
\code{r} (right-aligned), and \code{c} (center-aligned)}

\item{caption}{Optional string used as the \code{pander()} caption
argument.}
}
\value{
Prints the data frame in table form using \code{pander(x)}.
}
\description{
Uses \code{pander()} to print a data frame as a table to the output
document.
}
\details{
Uses \code{panderOptions('table.alignment.default')} argument to assign
output column alignment. The default alignments are numeric right and
everything else left.

If \code{align_idx} is not NULL, a warning message is generated if its
string length does not match the number of columns in the table.

The function also sets these pander options as defaults:
  \itemize{
    \item \code{table.split.table = Inf}
    \item \code{keep.trailing.zeros = TRUE}
    \item \code{style = 'simple'}
  }
}
\examples{
x <- mtcars[1:5, 1:5]
align_pander(x)
align_pander(x, align_idx = "rcrrr")
align_pander(x, caption = "A nicely formatted table")

}
