api_ping <- function(x) {
  if (checkmate::testClass(x) != "ApiCredentials") {
    stop("The argument must be an object of class 'ApiCredentials'")
  }
  checkmate::assert_string(host)
  host <- .remove_trailing_slash(host)

  url <- paste0(host, "/sys/ping")
  return(.get(url))
}
