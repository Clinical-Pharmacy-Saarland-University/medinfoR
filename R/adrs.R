#' Get ADRs for a list of PZNs
#'
#' @param creds A list containing the access token and host
#' @param pzns A vector with the PZNs
#' @param lang A string with the language. One of `english`, `german` or `german-simple`
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
    parameters = list(pzns = paste(pzns, collapse = ","), lang = lang),
    credentials = creds
  ) |>
    .listToDf()

  return(adrs)
}
