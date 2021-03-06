% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/LinksMetrics.R
\name{link_Metrics_ReferringDomains}
\alias{link_Metrics_ReferringDomains}
\title{Returns metrics about the domains referring click traffic to a link.}
\usage{
link_Metrics_ReferringDomains(link, limit = 1000, unit = c("minute", "hour",
  "day", "week", "month"), units = -1, showRequestURL = FALSE)
}
\arguments{
\item{link}{- a Bitlink.}

\item{limit}{- 1 to 1000 (default=1000).}

\item{unit}{- minute, hour, day, week or month, default: day; Note: when unit is minute the
maximum value for units is 60.}

\item{units}{- an integer representing the time units to query data for. Pass -1 to return all
units of time.}

\item{showRequestURL}{- show URL which has been build and requested from server. For debug purposes.}
}
\value{
clicks - the number of clicks referred from this domain.

domain - the domain referring clicks.

url - the complete URL of the domain referring clicks.
}
\description{
Returns metrics about the domains referring click traffic to a single Bitlink.
}
\examples{
options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
link_Metrics_ReferringDomains(link = "http://bit.ly/DPetrov", unit = "day", units = -1, limit = 100)
}
\seealso{
\url{http://dev.bitly.com/link_metrics.html#v3_link_referring_domains}
}

