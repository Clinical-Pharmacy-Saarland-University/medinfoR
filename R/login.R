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
api_login <- function(host, user, password, role = NULL) {
  login_url <- paste0(host, "/user/login")
  req <- login_url |>
    httr2::request() |>
    httr2::req_body_json(list(login = user, password = password, role = role))

  login <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data")

  login$host <- host
  return(login)
}

#' Set password
#'
#' @param host The host of the API
#' @param user The username/email
#' @param token The token received from the sign-up email
#' @param password The new password
#' @return A list with the response and the host
#' @export
#' @examples
#' \dontrun{
#' api_user_init_password("https://api.example.com", "test@user.com", "token", "password")
#' }
api_user_init_password <- function(host, user, token, password) {
  login_url <- paste0(host, "/user/password/init")
  req <- login_url |>
    httr2::request() |>
    httr2::req_body_json(list(token = token, email = user, password = password))

  res <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data")

  res$host <- host
  return(res)
}
