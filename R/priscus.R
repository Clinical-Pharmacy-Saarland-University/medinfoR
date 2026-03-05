#' Get PRISCUS status for a list of PZNs
#'
#' @param creds A list containing the access token and host
#' @param pzns A vector with the PZNs
#' @return A data frame with the priscus status
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_priscus_pzn(creds, c("PZN1", "PZN2"))
#' }
api_priscus_pzn <- function(creds, pzns) {
  host <- creds$host

  priscus_url <- paste0(host, "/priscus/pzns")
  priscus <- .get(
    priscus_url,
    parameters = list(pzns = paste(pzns, collapse = ",")),
    credentials = creds
  ) |>
    .listToDf()

  return(priscus)
}

#' Get PRISCUS status for a list of compound names
#'
#' @param creds A list containing the access token and host
#' @param compounds A vector with compound names
#' @return A data frame with the priscus status
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_priscus_compound(creds, c("Metoprolol", "Aspirin"))
#' }
api_priscus_compound <- function(creds, compounds) {
  host <- creds$host

  priscus_url <- paste0(host, "/priscus/compounds")
  priscus <- .get(
    priscus_url,
    parameters = list(compounds = paste(compounds, collapse = ",")),
    credentials = creds
  ) |>
    .listToDf()

  return(priscus)
}
