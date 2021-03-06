% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/UserMetrics.R
\name{user_Metrics_ShortenCounts}
\alias{user_Metrics_ShortenCounts}
\title{Returns the number of Bitlinks created in a given time period by the authenticated user.}
\usage{
user_Metrics_ShortenCounts(limit = 1000, unit = c("minute", "hour", "day",
  "week", "month"), rollup = c("false", "true"), units = -1,
  showRequestURL = FALSE)
}
\arguments{
\item{limit}{- 1 to 1000 (default=1000).}

\item{unit}{- minute, hour, day, week or month, default: day; Note: when unit is minute the maximum
value for units is 60.}

\item{rollup}{- true or false. Return data for multiple units rolled up to a single result instead
of a separate value for each period of time.}

\item{units}{- an integer representing the time units to query data for. Pass -1 to return all
units of time.}

\item{showRequestURL}{- show URL which has been build and requested from server. For debug purposes.}
}
\value{
dt - datetime when shortens had been made.

shortens - the number of shortens made by the specified user in the specified time.
}
\description{
Returns the number of Bitlinks created in a given time period by the authenticated user.
}
\examples{
options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
user_Metrics_ShortenCounts(unit = "day", units = -1, limit = 100, rollup = "true")
user_Metrics_ShortenCounts(unit = "day", units = -1, limit = 100, rollup = "false")
user_Metrics_ShortenCounts(unit = "day", units = -1, limit = 100)
}
\seealso{
See \url{http://dev.bitly.com/user_metrics.html#v3_user_shorten_counts}
}

