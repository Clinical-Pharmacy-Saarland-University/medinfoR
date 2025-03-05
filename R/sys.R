#' Ping the API
#'
#' This function pings the  API to check if it is available.
#'
#' @param x A character string specifying the API host to be pinged or an object of class [ApiCredentials].
#' @seealso [api_login()] to retrieve the login object.
#' @seealso [api_info()] to retrieve information about the API.
#'
#' @return A list containing the response from the API. Throws an error if the API is not available.
#'
#' @examples
#' \dontrun{
#' api_ping("https://api.example.com")
#'
#' creds <- api_login("https://api.example.com", "username", "password")
#' api_ping(creds)
#' }
#' @export
api_ping <- function(x) {
  if (checkmate::testClass(x, "ApiCredentials")) {
    x <- x$host
  } else if (!checkmate::testString(x)) {
    stop("The argument must be an object of class 'ApiCredentials' or a string.")
  }

  host <- .remove_trailing_slash(x)
  url <- paste0(host, "/sys/ping")
  return(.get(url))
}


#' Retrieve API Information
#'
#' This function retrieves information about a specified API.
#'
#' @param x A character string specifying the API host for which information is to be retrieved or
#' an object of class [ApiCredentials].
#' @seealso [api_login()] to retrieve the login object.
#' @seealso [api_ping()] to check if the API is available.
#'
#' @return A list containing information about the specified API. Throws an error if the API is not available.
#'
#' @examples
#' \dontrun{
#' api_info("https://api.example.com")
#'
#' creds <- api_login("https://api.example.com", "username", "password")
#' api_info(creds)
#' }
#'
#' @export
api_info <- function(x) {
  if (checkmate::testClass(x, "ApiCredentials")) {
    x <- x$host
  } else if (!checkmate::testString(x)) {
    stop("The argument must be an object of class 'ApiCredentials' or a string.")
  }

  host <- .remove_trailing_slash(x)
  url <- paste0(host, "/sys/info")
  return(.get(url))
}
