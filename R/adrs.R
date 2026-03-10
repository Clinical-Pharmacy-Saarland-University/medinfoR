#' Get ADRs for a list of PZNs
#'
#' @param creds A list containing the access token and host
#' @param pzns A vector with the PZNs
#' @param lang A string with the language. One of `english`, `german` or `german-simple`
#' @param details Logical. Whether to return detailed ADR information. Default `FALSE`.
#' @return A data frame with the ADRs
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_adr_pzn(creds, c("PZN1", "PZN2"), lang = "english")
#' }
api_adr_pzn <- function(creds, pzns, lang = c("english", "german", "german-simple"), details = FALSE) {
  lang <- match.arg(lang)
  host <- creds$host

  adrs_url <- paste0(host, "/adrs/pzns")

  adrs <- .get(
    adrs_url,
    parameters = list(
      pzns = paste(pzns, collapse = ","),
      lang = lang,
      details = tolower(as.character(details))
    ),
    credentials = creds
  ) |>
    .listToDf()

  return(adrs)
}

#' Get ADRs for a list of compounds
#'
#' @param creds A list containing the access token and host
#' @param compounds A vector with the compound names
#' @param lang A string with the language. One of `english`, `german` or `german-simple`
#' @param details Logical. Whether to return detailed ADR information. Default `FALSE`.
#' @return A data frame with the ADRs
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_adr_compound(creds, c("Aspirin", "Ibuprofen"), lang = "english")
#' }
api_adr_compound <- function(creds, compounds, lang = c("english", "german", "german-simple"), details = FALSE) {
  lang <- match.arg(lang)
  host <- creds$host

  adrs_url <- paste0(host, "/adrs/compounds")

  adrs <- .get(
    adrs_url,
    parameters = list(
      compounds = paste(compounds, collapse = ","),
      lang = lang,
      details = tolower(as.character(details))
    ),
    credentials = creds
  ) |>
    .listToDf()

  return(adrs)
}
