#' Create a service user
#'
#' This function creates a service user in the system.
#'
#' @param creds A list with the access token and the host.
#' @param mail The email of the user.
#' @param first_name The first name of the user.
#' @param last_name The last name of the user.
#' @param org The organization of the user.
#' @param password The password of the user.
#' @param role The role of the user. Any of "user" or "admin".
#' @return A message with the result of the operation.
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "user", "password", "user")
#' api_create_service_user(
#'   creds, "test-service@precisiondosing.de",
#'   "Test", "Service", "Precision Dosing", "password"
#' )
#' }
api_create_service_user <- function(creds, mail,
                                    first_name, last_name, org,
                                    password, role = "user") {
  token <- creds$access_token
  host <- creds$host

  body <- list(
    email = mail,
    first_name = first_name,
    last_name = last_name,
    organization = org,
    password = password,
    role = role
  )

  url <- paste0(host, "/admin/users/service")
  req <- url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_body_json(body)

  res <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("message")

  return(res)
}

#' Create a user
#'
#' This function creates a user in the system.
#'
#' @param creds A list with the access token and the host.
#' @param mail The email of the user.
#' @param first_name The first name of the user.
#' @param last_name The last name of the user.
#' @param org The organization of the user.
#' @param role The role of the user. Any of "user" or "admin".
#' @return A message with the result of the operation.
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "user", "password", "user")
#' api_create_user(
#'   creds, "test-service@precisiondosing.de",
#'   "Test", "Service", "Precision Dosing", "password"
#' )
#' }
api_create_user <- function(creds, mail,
                            first_name, last_name,
                            org, role = NULL) {
  token <- creds$access_token
  host <- creds$host

  body <- list(
    email = mail,
    first_name = first_name,
    last_name = last_name,
    organization = org,
    role = role
  )

  url <- paste0(host, "/admin/users")
  req <- url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_body_json(body)

  res <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("message")

  return(res)
}
