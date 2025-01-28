#' Login to the API
#'
#' @param host The host of the API
#' @param user The username
#' @param password The password
#' @param role The role of the user. Any of "user" or "admin".
#' @return A list with the access token and the host
#' @export
#' @examples
#' \dontrun{
#' api_login("https://api.example.com", "user", "password", "user")
#' }
api_login <- function(host, user, password, role) {
  login_url <- paste0(host, "/user/login")
  req <- login_url |>
    httr2::request() |>
    httr2::req_body_json(list(login = user, password = password, role = role))
 
  login <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data")
 
  login$host = host
  return(login)
}




