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

#' Get QT categories for a list of PZN batches
#'
#' @param creds A list containing the access token and host
#' @param pzn_batches A list of lists containing PZNs
#' @return A list of data frames with the interactions
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_qt_pzn_batch(creds, list(list(pzns = c("PZN1", "PZN2"), id = 1)))
#' }
api_qt_pzn_batch <- function(creds, pzn_batches) {
  host <- creds$host

  qts_url <- paste0(host, "/qt/pzns")

  pzn_batches <- pzn_batches |>
    purrr::map(~ {
      list(
        pzns = .x$pzns,
        id = as.character(.x$id)
      )
    })

  req <- qts_url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_body_json(pzn_batches)

  qts <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data") |>
    print()
  # purrr::map(~ {
  #   list(
  #     id = .x$id,
  #     status = .x$status,
  #     message = .x$message,
  #     qts = .listToDf(.x$qts)
  #   )
  # })

  return(qts)
}
