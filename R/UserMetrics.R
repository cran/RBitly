#' @title Returns the aggregate number of clicks on all of the authenticated user's Bitlinks.
#' 
#' @seealso See \url{http://dev.bitly.com/user_metrics.html#v3_user_clicks}
#' 
#' @param limit - 1 to 1000 (default=1000).
#' @param units - an integer representing the time units to query data for. Pass -1 to return all 
#' units of time.
#' @param unit - minute, hour, day, week or month, default: day; Note: when unit is minute the maximum 
#' value for units is 60.
#' @param rollup - true or false. Return data for multiple units rolled up to a single result instead 
#' of a separate value for each period of time.
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#' 
#' @return dt - a unix timestamp representing the beginning of this unit.
#' @return day_start - a unix timestamp representing the beginning of the specified day (ONLY returned 
#' if unit is not specified).
#' @return clicks - the number of clicks on this user's links in the specified timeframe.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' user_Metrics_Clicks(unit = "day", units = -1, limit = 100, rollup = "true")
#' user_Metrics_Clicks(unit = "day", units = -1, limit = 100, rollup = "false")
#' 
#' @note without the parameter unit this endpoint returns a legacy response format which assumes 
#' rollup=false, unit=day and units=7.
#' 
#' @export
user_Metrics_Clicks <- function(limit = 1000, unit = c("minute", "hour", "day", "week", "month"), 
                               units = -1, rollup = c("false", "true"), showRequestURL = FALSE) {
  unit_matched <- match.arg(unit)
  rollup_matched <- match.arg(rollup)
  
  user_metrics_clicks_url <- "https://api-ssl.bitly.com/v3/user/clicks"
  
  query <- list(access_token = auth_bitly(NULL), limit = limit, unit = unit_matched, units = units, 
                rollup = rollup_matched)
  
  # call method from ApiKey.R
  df_user_metrics_clicks <- doRequest(user_metrics_clicks_url, query, showURL = showRequestURL)
  df_user_metrics_clicks_data <- df_user_metrics_clicks$data$user_clicks
  
  if (rollup == "true") {
    
    # won't return a data frame, just a number
    return(df_user_metrics_clicks_data)
    
  } else {
    df_user_metrics_clicks_data$dt <- as.POSIXct(as.integer(df_user_metrics_clicks_data$dt), 
                                                 origin = "1970-01-01", tz = "UTC")
    # sapply(df_user_metrics_clicks_data, class)
    return(df_user_metrics_clicks_data)
  }
}


#' @title Returns aggregate metrics about the countries referring click traffic to all of the authenticated user's Bitlinks.
#' 
#' @seealso See \url{http://dev.bitly.com/user_metrics.html#v3_user_countries}
#'  
#' @inheritParams user_Metrics_Clicks
#' 
#' @return clicks - the number of clicks referred from this country.
#' @return country - the two-letter code of the referring country.
#' 
#' @note When a unit is specified (always the case), rollup is always (!) true.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' user_Metrics_Countries(unit = "day", units = -1, limit = 100, rollup = "true")
#' 
#' @export
user_Metrics_Countries <- function(limit = 1000, unit = c("minute", "hour", "day", "week", "month"), 
                                   rollup = "true", units = -1, showRequestURL = FALSE) {
  unit_matched <- match.arg(unit)

  user_metrics_countries_url <- "https://api-ssl.bitly.com/v3/user/countries"
  
  query <- list(access_token = auth_bitly(NULL), limit = limit, unit = unit_matched, units = units, 
                rollup = rollup)
  
  # call method from ApiKey.R
  df_user_metrics_countries <- doRequest(user_metrics_countries_url, query, showURL = showRequestURL)
  
  df_user_metrics_countries_data <- df_user_metrics_countries$data$user_countries
  
  # sapply(df_user_metrics_countries_data, class)
  return(df_user_metrics_countries_data)
}

#' @title Returns the authenticated user's most-clicked Bitlinks (ordered by number of clicks) in a given time period.
#' 
#' @seealso See \url{http://dev.bitly.com/user_metrics.html#v3_user_popular_links}
#'
#' @inheritParams user_Metrics_Clicks
#' 
#' @return link - a Bitlink.
#' @return clicks - the number of clicks on that Bitlink in the specified timeframe.
#' 
#' @note This replaces the realtime_links endpoint.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' user_Metrics_PopularLinks(unit = "day", units = -1, limit = 100)
#' 
#' @export
user_Metrics_PopularLinks <- function(limit = 1000, unit = c("minute", "hour", "day", "week", "month"),
                                       units = -1, showRequestURL = FALSE) {
  unit_matched <- match.arg(unit)
  
  user_metrics_popular_links_url <- "https://api-ssl.bitly.com/v3/user/popular_links"
  
  query <- list(access_token = auth_bitly(NULL), limit = limit, unit = unit_matched, units = units)
  
  # call method from ApiKey.R
  df_user_metrics_popular_links <- doRequest(user_metrics_popular_links_url, query, showURL = showRequestURL)
  df_user_metrics_popular_links_data <- df_user_metrics_popular_links$data$popular_links
  
  # sapply(df_user_metrics_popular_links_data, class)
  return(df_user_metrics_popular_links_data)
  
}


#' @title Returns aggregate metrics about the pages referring click traffic to all of the authenticated user's Bitlinks.
#' 
#' @seealso See \url{http://dev.bitly.com/user_metrics.html#v3_user_referrers}
#'
#' @inheritParams user_Metrics_Clicks
#' 
#' @return clicks - the number of clicks referred from this URL.
#' @return referrer - the URL referring clicks.
#' 
#' @note When a unit is specified (always the case), rollup is always (!) true.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' user_Metrics_Referrers(unit = "day", units = -1, limit = 100, rollup = "true")
#' 
#' @export
user_Metrics_Referrers <- function(limit = 1000, unit = c("minute", "hour", "day", "week", "month"), 
                                   rollup = c("false", "true"), units = -1, showRequestURL = FALSE) {
  unit_matched <- match.arg(unit)

  user_metrics_referrers_url <- "https://api-ssl.bitly.com/v3/user/referrers"
  
  query <- list(access_token = auth_bitly(NULL), limit = limit, unit = unit_matched, units = units, 
                rollup = rollup)
  
  # call method from ApiKey.R
  df_user_metrics_referrers <- doRequest(user_metrics_referrers_url, query, showURL = showRequestURL)
  df_user_metrics_referrers_data <- df_user_metrics_referrers$data$user_referrers

  # sapply(df_user_metrics_referrers_data, class)
  return(df_user_metrics_referrers_data)
}

#' @title Returns aggregate metrics about the domains referring click traffic to all of the authenticated user's Bitlinks. 
#' 
#' @description If the user is a master (ent.) account, or is a subaccount with full_reports permission, the 
#' user may choose to view the metrics of any account belonging to the master account.
#' 
#' @seealso See \url{http://dev.bitly.com/user_metrics.html#v3_user_referring_domains}
#'
#' @inheritParams user_Metrics_Clicks
#' 
#' @param exclude_social_networks - true (default) or false. If true, exclude domains that are 
#' part of a social network that bitly tracks.
#' @param login - an optional string consisting of the account name used to report the appropriate
#' statistics; defaults to the current user.
#' 
#' @return clicks - the number of clicks referred from this URL.
#' @return referrer - the URL referring clicks.
#' 
#' @note When a unit is specified (always the case), rollup is always (!) true.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' user_Metrics_ReferringDomains(unit = "day", units = -1, limit = 100, rollup = "true")
#' user_Metrics_ReferringDomains(unit = "day", units = -1, limit = 100, rollup = "false")
#' user_Metrics_ReferringDomains(unit = "day", units = -1, limit = 100, 
#' exclude_social_networks = "false")
#' user_Metrics_ReferringDomains(unit = "day", units = -1, limit = 100, 
#' exclude_social_networks = "true")
#' 
#' @export
user_Metrics_ReferringDomains <- function(limit = 1000, unit = c("minute", "hour", "day", "week", "month"),
                                           rollup = c("false", "true"), units = -1, login = NULL, 
                                           exclude_social_networks = c("true", "false"), showRequestURL = FALSE) {
  
  unit_matched <- match.arg(unit)
  rollup_matched <- match.arg(rollup)
  exclude_social_networks_matched <- match.arg(exclude_social_networks)
  
  user_metrics_referring_domains_url <- "https://api-ssl.bitly.com/v3/user/referring_domains"
  
  query <- list(access_token = auth_bitly(NULL), limit = limit, unit = unit_matched, units = units, login = login,
                rollup = rollup_matched, exclude_social_networks = exclude_social_networks_matched)
  
  # call method from ApiKey.R
  df_user_metrics_referring_domains <- doRequest(user_metrics_referring_domains_url, query, showURL = showRequestURL)
  df_user_metrics_referring_domains_data <- df_user_metrics_referring_domains$data$user_referring_domains
  
  if (length(df_user_metrics_referring_domains_data) == 0) {
    df_user_metrics_referring_domains_data <- NULL
    message("You have zero referring domains given your function input.")
  }
  
  # sapply(df_user_metrics_referring_domains_data, class)
  return(df_user_metrics_referring_domains_data)
  
}


#' @title Returns the number of Bitlinks created in a given time period by the authenticated user.
#' 
#' @seealso See \url{http://dev.bitly.com/user_metrics.html#v3_user_shorten_counts}
#'
#' @inheritParams user_Metrics_Clicks
#' 
#' @return dt - datetime when shortens had been made.
#' @return shortens - the number of shortens made by the specified user in the specified time.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' user_Metrics_ShortenCounts(unit = "day", units = -1, limit = 100, rollup = "true")
#' user_Metrics_ShortenCounts(unit = "day", units = -1, limit = 100, rollup = "false")
#' user_Metrics_ShortenCounts(unit = "day", units = -1, limit = 100)
#' 
#' @export
user_Metrics_ShortenCounts <- function(limit = 1000, unit = c("minute", "hour", "day", "week", "month"),
                                        rollup = c("false", "true"), units = -1, showRequestURL = FALSE) {
  
  unit_matched <- match.arg(unit)
  rollup_matched <- match.arg(rollup)
  
  user_metrics_shorten_counts_url <- "https://api-ssl.bitly.com/v3/user/shorten_counts"
  
  query <- list(access_token = auth_bitly(NULL), limit = limit, unit = unit_matched, units = units, 
                rollup = rollup_matched, showURL = showRequestURL)
  
  # call method from ApiKey.R
  df_user_metrics_shorten_counts <- doRequest(user_metrics_shorten_counts_url, query, showURL = showRequestURL)
  df_user.metrics_shorten_counts_data <- df_user_metrics_shorten_counts$data$user_shorten_counts
  
  if (rollup_matched == "false") {
    df_user.metrics_shorten_counts_data$dt <- as.POSIXct(as.integer(df_user.metrics_shorten_counts_data$dt), 
                                                      origin = "1970-01-01", tz = "UTC")
    
  } else {
    df_user.metrics_shorten_counts_data
  }
  
  # sapply(df_user.metrics_shorten_counts_data, class)
  return(df_user.metrics_shorten_counts_data)
}

