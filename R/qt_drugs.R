#' Get QT category for a list of PZNs
#'
#' @param creds A list containing the access token and host
#' @param pzns A vector with the PZNs
#' @return A data frame with the QT category
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_qt_pzn(creds, c("PZN1", "PZN2"))
#' }
api_qt_pzn <- function(creds, pzns) {
  host <- creds$host

  qt_url <- paste0(host, "/qt/pzns")
  qt <- .get(
    qt_url,
    parameters = list(pzns = paste(pzns, collapse = ",")),
    credentials = creds
  ) |>
    .listToDf()

  return(qt)
}

#' Get QT category for a list of compound names
#'
#' @param creds A list containing the access token and host
#' @param compounds A vector with compound names
#' @return A data frame with the QT category
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_qt_compound(creds, c("Metoprolol", "Aspirin"))
#' }
api_qt_compound <- function(creds, compounds) {
  host <- creds$host

  qt_url <- paste0(host, "/qt/compounds")
  qt <- .get(
    qt_url,
    parameters = list(compounds = paste(compounds, collapse = ",")),
    credentials = creds
  ) |>
    .listToDf()

  return(qt)
}
