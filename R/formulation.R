#' Get formulations
#'
#' @param creds A list containing the access token and host
#' @return A data frame with the formulations
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_formulations(creds)
#' }
api_formulations <- function(creds) {
  token <- creds$access_token
  host <- creds$host

  formulations_url <- paste0(host, "/formulations")
  req <- formulations_url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token)

  formulations <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data") |>
    dplyr::bind_rows()

  return(formulations)
}
