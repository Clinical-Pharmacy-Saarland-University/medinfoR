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
  host <- creds$host

  formulations_url <- paste0(host, "/formulations")
  formulations <- .get(formulations_url, credentials = creds) |>
    purrr::pluck("formulations") |>
    dplyr::bind_rows()

  return(formulations)
}
