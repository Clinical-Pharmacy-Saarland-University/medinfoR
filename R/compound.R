#' Get names for a list of compound names
#'
#' @param creds A list containing the access token and host
#' @param compounds A vector with the compound names
#' @return A list of data frames with the interactions
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_compound_name(creds, compounds = c("Aspirin", "Paracetamol"))
#' }
api_compound_name <- function(creds, compounds) {
  host <- creds$host

  compounds_url <- paste0(host, "/compounds/names")

  compounds <- .get(
    endpoint = compounds_url,
    parameters = list(names = paste0(compounds, collapse = ",")),
    credentials = creds
  ) |>
    purrr::map(~ {
      list(
        input = .x$input,
        matches = purrr::map(.x$matches, .listToDf)
        # matches = .listToDf(.x$matches)
      )
    })

  return(compounds)
}
