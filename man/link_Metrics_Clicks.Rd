% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/LinksMetrics.R
\name{link_Metrics_Clicks}
\alias{link_Metrics_Clicks}
\title{Returns numbers of click on a link.}
\usage{
link_Metrics_Clicks(link, limit = 1000, unit = c("minute", "hour", "day",
  "week", "month"), units = -1, rollup = "true", showRequestURL = FALSE)
}
\arguments{
\item{link}{- a Bitlink.}

\item{limit}{- 1 to 1000 (default=1000).}

\item{unit}{- minute, hour, day, week or month, default: day; Note: when unit is minute the
maximum value for units is 60.}

\item{units}{- an integer representing the time units to query data for. Pass -1 to return all
units of time.}

\item{rollup}{- true (default) or false.  Return data for multiple units rolled up to a
single result instead of a separate value for each period of time.}

\item{showRequestURL}{- show URL which has been build and requested from server. For debug purposes.}
}
\value{
clicks - the number of clicks on the specified Bitlink.

dt - time in UTC format (only when rollup = "false")
}
\description{
Returns the number of clicks on a single Bitlink of the authenticated user.
}
\section{TODO}{
 or more URLs up to 15
}
\examples{
options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
link_Metrics_Clicks(link = "http://bit.ly/DPetrov", unit = "day", units = -1, limit = 100)
}
\seealso{
\url{http://dev.bitly.com/link_metrics.html#v3_link_clicks}
}

