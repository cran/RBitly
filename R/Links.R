#' @title Query for a Bitlink based on a long URL.
#' 
#' @seealso See \url{http://dev.bitly.com/links.html#v3_link_lookup}
#'
#' @param url - one long URLs to lookup.
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#'      
#' @return url - an echo back of the url parameter.
#' @return aggregate_link - the corresponding bitly aggregate link (global hash).
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' links_Lookup(url = "http://www.seznam.cz/")
#' links_Lookup(url = "http://www.seznam.cz/", showRequestURL = TRUE) 
#'
#' \dontrun{ 
#' manyUrls <- list("http://www.seznam.cz/", "http://www.seznamasdas.cz/", 
#' "http://www.seznam.cz/asadasd", "http://www.seznam.cz/adqwrewtregt")
#' for (u in 1:length(manyUrls)) {
#'    print(links_Lookup(url = manyUrls[[u]], showRequestURL = TRUE))
#' }
#' }
#' 
#' @export
links_Lookup <- function(url, showRequestURL = FALSE) {
  
  links_lookup_url <- "https://api-ssl.bitly.com/v3/link/lookup"
  
  query <- list(access_token = auth_bitly(NULL), url = url)
  
  # call method from ApbiKey.R
  df_link_lookup <- doRequest(links_lookup_url, query, showURL = showRequestURL)
  df_link_lookup_data <- df_link_lookup$data$link_lookup
  
  # sapply(df_link_lookup_data, class)
  return(df_link_lookup_data)
}

#' @title Used to return the page title for a given Bitlink.
#' 
#' @seealso See \url{http://dev.bitly.com/links.html#v3_info}
#' 
#' @note Either shortUrl or hash must be given as a parameter (or both).
#' @note The maximum number of shortUrl and hash parameters is 15.
#' 
#' @param hashIN - refers to one bitly hashes, (e.g.:  2bYgqR or a-custom-name). Required
#' @param shortUrl - refers to one Bitlinks e.g.: http://bit.ly/1RmnUT or http://j.mp/1RmnUT. Optional.
#' @param expand_user - optional true|false (default) - include extra user info in response.
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#'  
#' @return short_url - this is an echo back of the shortUrl request parameter.
#' @return hash - this is an echo back of the hash request parameter.
#' @return user_hash - the corresponding bitly user identifier.
#' @return global_hash - the corresponding bitly aggregate identifier.
#' @return error - indicates there was an error retrieving data for a given shortUrl or hash. An 
#' example error is "NOT_FOUND".
#' @return title - the HTML page title for the destination page (when available).
#' @return created_by - the bitly username that originally shortened this link, if the 
#' link is public. Otherwise, null.
#' @return created_at - the epoch timestamp when this Bitlink was created.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' links_Info(shortUrl = "http://bit.ly/DPetrov")
#' links_Info(hash = "DPetrov", showRequestURL = TRUE) 
#' links_Info(hash = "DPetrov", expand_user = "true")
#' 
#' ## hash is the one which is only returned. Dont use
#' links_Info(shortUrl = "on.natgeo.com/1bEVhwE", hash = "DPetrov") 
#' 
#' ## manyHashes <- list("DPetrov", "1QU8CFm", "1R1LPSE", "1LNqqva")
#' ## for (u in 1:length(manyHashes)) {
#' ##   print(links_Info(hashIN = manyHashes[[u]], showRequestURL = TRUE))
#' ## }
#' 
#' @export
links_Info <- function(hashIN = NULL, shortUrl = NULL, expand_user = "true", showRequestURL = FALSE) {
  
  links_info_url <- "https://api-ssl.bitly.com/v3/info"
  
  if (is.null(hashIN)) {
    query <- list(access_token = auth_bitly(NULL), shortUrl = shortUrl, expand_user = expand_user)
  } else {
    query <- list(access_token = auth_bitly(NULL), hash = hashIN, expand_user = expand_user)
  }
  
  # call method from ApbiKey.R
  df_link_info <- doRequest(links_info_url, query, showURL = showRequestURL)
  
  df_user_info_data <- data.frame(t(sapply(unlist(df_link_info$data$info), c)), stringsAsFactors = FALSE)
  df_user_info_data$created_at <- as.POSIXct(as.integer(df_user_info_data$created_at), 
                                             origin = "1970-01-01", tz = "UTC")
  
  # sapply(df_link_info_data, class)
  return(df_user_info_data)
}


#' @title Given a ow.ly URL, returns information about it.
#' 
#' @seealso See \url{http://ow.ly/api-docs#info}
#'
#' @param shortUrl - a short URL 
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#' 
#' @description Given an ow.ly URL, returns information about the page, including the original URL,
#' the HTML title, total clicks, and the "votes" value for the link (votes may be a positive or negative value).
#' This is higly experimental ! Please report bugs if there are any. 
#' 
#' @examples 
#' \dontrun{
#' links_InfoOwly("http://ow.ly/RE1wg")
#' }
#' 
#' @return Returns full short url data on success.
#' 
#' @export
links_InfoOwly <- function(shortUrl, showRequestURL = FALSE) {
  links_info_url <- "http://ow.ly/api/1.1/url/info"
  
  query <- list(access_token = auth_owly(NULL), shortUrl = shortUrl)
  
  # call method from ApiKey.R
  df_link_info <- doRequest(links_info_url, query, showURL = showRequestURL)
  
  # to be validated with the API Key, if ever. Check types
  df_link_info_data <- df_link_info$results
  # sapply(df_link_info_data, class)
  
  return(df_link_info_data)
  
}

#' @title Given a bitly URL or hash (or multiple), returns the target (long) URL.
#' 
#' @seealso See \url{http://dev.bitly.com/links.html#v3_expand}
#'
#' @param hashIN - refers to one bitly hashes, (e.g.:  2bYgqR or a-custom-name). Required
#' @param shortUrl - refers to one Bitlinks e.g.: http://bit.ly/1RmnUT or http://j.mp/1RmnUT. Optional.
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#' 
#' @section TODO: or more URLs  Up TO 15
#' 
#' @note Either shortUrl or hash must be given as a parameter.
#' @note The maximum number of shortUrl and hash parameters is 15.
#' 
#' @return short_url - this is an echo back of the shortUrl request parameter.
#' @return hash - this is an echo back of the hash request parameter.
#' @return user_hash - the corresponding bitly user identifier.
#' @return global_hash - the corresponding bitly aggregate identifier.
#' @return error - indicates there was an error retrieving data for a given shortUrl or hash. An 
#' example error is "NOT_FOUND".
#' @return long_url - the URL that the requested short_url or hash points to.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' links_Expand(shortUrl = "http://bit.ly/DPetrov")
#' links_Expand(hash = "DPetrov", showRequestURL = TRUE) 
#' links_Expand(hash = "DPetrov")
#' links_Expand(shortUrl = "on.natgeo.com/1bEVhwE", hash = "1bEVhwE")
#' 
#' ## manyHashes <- list("DPetrov", "1QU8CFm", "1R1LPSE", "1LNqqva")
#' ## for (u in 1:length(manyHashes)) {
#' ##   print(links_Expand(hashIN = manyHashes[[u]], showRequestURL = TRUE))
#' ## }
#' 
#' @export
links_Expand <- function(hashIN = NULL, shortUrl = NULL, showRequestURL = FALSE) {
  
  links_expand_url <- "https://api-ssl.bitly.com/v3/expand"
  
  if (is.null(hashIN)) {
    query <- list(access_token = auth_bitly(NULL), shortUrl = shortUrl)
  } else {
    query <- list(access_token = auth_bitly(NULL), hash = hashIN)
  }
  
  # call method from ApbiKey.R
  df_link_expand <- doRequest(links_expand_url, query, showURL = showRequestURL)
  
  df_link_expand_data <- data.frame(t(sapply(unlist(df_link_expand$data$expand), c)), stringsAsFactors = FALSE)
  
  # sapply(df_link_expand_data, class)
  return(df_link_expand_data)
}


#' @title Given a long URL, returns a short Bit.ly link.
#'
#' @seealso See \url{http://dev.bitly.com/rate_limiting.html}
#' @seealso See \url{http://dev.bitly.com/links.html#v3_shorten}
#'
#' @param longUrl - a long URL to be shortened (example: http://betaworks.com/).
#' @param domain - (optional) the short domain to use; either bit.ly, j.mp, or bitly.com or 
#' a custom short domain. The default for this parameter is the short domain selected by each 
#' user in their bitly account settings. Passing a specific domain via this parameter will override
#' the default settings.
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#' 
#' @note The bitly API does not support shortening more than one long URL with a single API call. 
#' Meaning 1 Long URL = 1 Function call.
#' @note Long URLs should be URL-encoded. You can not include a longUrl in the request 
#' that has &, ?, #, or other reserved parameters without first encoding it.
#' @note The default value for the domain parameter is selected by each user from within their bitly 
#' account settings at \url{https://bitly.com/a/settings/advanced}.
#' @note Long URLs should not contain spaces: any longUrl with spaces will be rejected. All spaces 
#' should be either percent encoded %20 or plus encoded +. Note that tabs, newlines and trailing 
#' spaces are all indications of errors. Please remember to strip leading and trailing whitespace 
#' from any user input before shortening.
#' 
#' @return new_hash - designates if this is the first time this long_url was shortened by this user. 
#' The return value will equal 1 the first time a long_url is shortened. It will also then be added 
#' to the user history.
#' @return hash - a bitly identifier for long_url which is unique to the given account.
#' @return long_url - an echo back of the longUrl request parameter. This may not always be equal to 
#' the URL requested, as some URL normalization may occur (e.g., due to encoding differences, or case 
#' differences in the domain). This long_url will always be functionally identical the the request parameter. 
#' @return global_hash - a bitly identifier for long_url which can be used to track aggregate stats 
#' across all Bitlinks that point to the same long_url.
#' @return url - the actual Bitlink that should be used, and is a unique value for the given Bitly account.
#' 
#' @examples
#' options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909")
#' links_Shorten(longUrl = "http://slovnik.seznam.cz/")
#' links_Shorten(longUrl = "https://travis-ci.org/dmpe/rbitly/builds/68231423", domain = "j.mp")
#' 
#' @export
links_Shorten <- function(longUrl, domain = NULL, showRequestURL = FALSE) {
  
  links_shorten_url <- "https://api-ssl.bitly.com/v3/shorten"

  query <- list(access_token = auth_bitly(NULL), longUrl = longUrl, domain = domain)

  # call method from ApbiKey.R unlist
  df_link_shorten <- doRequest(links_shorten_url, query, showURL = showRequestURL)
 
  df_link_shorten_data <- data.frame(t(sapply(df_link_shorten$data, c)), stringsAsFactors = FALSE)
  
  # sapply(df_link_shorten_data, class)
  return(df_link_shorten_data)
}


##############################
##          Ow.ly           ##
##############################

#' @title Given a long URL, returns a short Ow.ly link.
#' 
#' @seealso See \url{http://ow.ly/api-docs#shorten}
#'
#' @param longUrl - a long URL to be shortened (example: http://betaworks.com/).
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#' 
#' @description Given a full URL, returns an ow.ly short URL. Currently the API only supports 
#' shortening a single URL per API call. Your API Key controls whether the short url returned is 
#' a static value (default), or whether it's always a unique value. See the Authentication \link{rbitlyApi} section 
#' for more details.
#' This is higly experimental ! Please report bugs if there are any. 
#' 
#' @return Returns short URL on success
#' 
#' @export
links_ShortenOwly <- function(longUrl, showRequestURL = FALSE) {

  links_shorten_url <- "http://ow.ly/api/1.1/url/shorten"
  
  query <- list(access_token = auth_owly(NULL), longUrl = longUrl)
  
  # call method from ApiKey.R unlist
  df_link_shorten <- doRequest(links_shorten_url, query, showURL = showRequestURL)
  
  # to be validated with the API Key, if ever
  df_link_shorten_data <- df_link_shorten$results
  
  return(df_link_shorten_data)
}


#' @title Given an ow.ly URL, returns the target (long) URL.
#' 
#' @seealso See \url{http://ow.ly/api-docs#expand}
#'
#' @param shortUrl - a short URL to be expanded
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#' 
#' @description Given an ow.ly URL, returns the original full URL. 
#' This is higly experimental ! Please report bugs if there are any. 
#' 
#' @return Returns the original url.
#' 
#' @export
links_ExpandOwly <- function(shortUrl, showRequestURL = FALSE) {
  
  links_expand_url <- "http://ow.ly/api/1.1/url/expand"
  
  query <- list(access_token = auth_owly(NULL), shortUrl = shortUrl)
  
  # call method from ApiKey.R unlist
  df_link_expand <- doRequest(links_expand_url, query, showURL = showRequestURL)
  
  # to be validated with the API Key, if ever
  df_link_expand_data <- df_link_expand$results$longUrl
  
  return(df_link_expand_data)
}


############################ 
##         Goo.gl         ##
############################

#' @title Expand a short URL to a longer one
#'
#' @seealso See \url{https://developers.google.com/url-shortener/v1/getting_started#shorten}
#' @seealso See \url{https://developers.google.com/url-shortener/v1/url/get}
#'
#' @param shortUrl - The short URL, including the protocol. 
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#' @param projection - "FULL" - returns the creation timestamp and all available analytics (default) OR
#' "ANALYTICS_CLICKS" - returns only click counts OR "ANALYTICS_TOP_STRINGS" - returns only top 
#' string counts (e.g. referrers, countries, etc)
#' 
#' @description For the given short URL, the url.get method returns the corresponding long URL and the status.
#' 
#' @section Quotas: By default, your registered project gets 1,000,000 requests per day for the URL 
#' Shortener API (\url{https://console.developers.google.com/})
#' 
#' @examples 
#' options(Goo.gl = "AIzaSyAbJt9APfph1JGIhflkoH9UuGhOACntOjw")
#' g1 <- links_ExpandGoogl(shortUrl = "http://goo.gl/vM0w4",showRequestURL = TRUE)
#' g4 <- links_ExpandGoogl(shortUrl="http://goo.gl/vM0w4",projection = "FULL",showRequestURL = TRUE)
#'
#' @note Returns a dataframe of expanded short URL and a list of its analytics.
#' 
#' @return id - is the short URL you passed in.
#' @return longUrl - is the long URL to which it expands. Note that longUrl may not be present in 
#' the response, for example, if status is "REMOVED".
#' @return status - is "OK" for most URLs. If Google believes that the URL is fishy, status may be 
#' something else, such as "MALWARE".
#'
#' @export
links_ExpandGoogl <- function(shortUrl = "", projection = NULL, showRequestURL = FALSE) {
  links_expand_url <- "https://www.googleapis.com/urlshortener/v1/url"
  
  query <- list(key = auth_googl(NULL), shortUrl = shortUrl, projection = projection)
  
  # call method from ApiKey.R
  df_link_expand <- doRequest(links_expand_url, queryParameters = query, showURL = showRequestURL)
  df_link_expand_data_analytics <- df_link_expand$analytics
  df_link_expand$analytics <- NULL
  df_link_expand_data <- list(original_data = data.frame(df_link_expand, stringsAsFactors = FALSE),
                              analytics = df_link_expand_data_analytics)
  
  return(df_link_expand_data)
}


#' @title Given a long URL, returns a short Goo.gl link.
#' 
#' @seealso See \url{https://developers.google.com/url-shortener/v1/url/insert}
#' @seealso See \url{https://developers.google.com/url-shortener/v1/getting_started#shorten}
#' @seealso See \url{http://stackoverflow.com/a/13168073}
#' 
#' @param longUrl - a long URL to be shortened (example: http://betaworks.com/).
#' @param showRequestURL - show URL which has been build and requested from server. For debug purposes.
#' 
#' @description Given a full URL, returns an goo.gl short URL. The returned resource contains the 
#' short URL and the long URL. Note that the returned long URL may be loosely canonicalized, e.g. 
#' to convert "google.com" into "http://google.com/". See the Authentication 
#' \link{rbitlyApi} section for more details.
#' 
#' @return id is the short URL that expands to the long URL you provided. If your request includes 
#' an auth token, then this URL will be unique. If not, then it might be reused from a previous 
#' request to shorten the same URL.
#' @return longURL - longUrl is the long URL to which it expands. In most cases, this will be the 
#' same as the URL you provided. In some cases, the server may canonicalize the URL. For instance, 
#' if you pass http://www.google.com, the server will add a trailing slash.
#' 
#' @examples 
#' options(Goo.gl = "AIzaSyAbJt9APfph1JGIhflkoH9UuGhOACntOjw")
#' g2 <- links_ShortenGoogl(longUrl = "https://developers.google.com/url-shortener/v1/url/insert")
#' 
#' @export
links_ShortenGoogl <- function(longUrl = "", showRequestURL = FALSE) {
  links_shorten_url <- paste0("https://www.googleapis.com/urlshortener/v1/url?key=", auth_googl(NULL))
  
  resource <- paste0("{'longUrl':", paste0("'",longUrl,"'}"))
  
  # call method from ApiKey.R 
  df_link_shorten <- doRequestPOST(links_shorten_url, queryParameters = resource, showURL = showRequestURL)
  
  df_link_shorten_data <- data.frame(df_link_shorten, stringsAsFactors = FALSE)
  
  # sapply(df_link_shorten_data, class)
  return(df_link_shorten_data)
}
