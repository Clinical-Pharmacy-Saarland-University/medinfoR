#' Get active compounds for a list of PZNs
#'
#' @param creds A list containing the access token and host
#' @param pzns A vector with the PZNs
#' @return A data frame with the active compounds
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_product_compounds_pzn(creds, c("PZN1", "PZN2"))
#' }
api_product_compounds_pzn <- function(creds, pzns) {
  token <- creds$access_token
  host <- creds$host

  active_compounds_url <- paste0(host, "/product/activecompounds/pzns")

  active_compounds <- .get(
    active_compounds_url,
    parameters = list(pzns = paste(pzns, collapse = ",")),
    credentials = creds
  ) |>
    purrr::map(~ purrr::map(.x, .listToDf)) |>
    purrr::flatten() |>
    data.table::rbindlist() |>
    tibble::as_tibble()

  return(active_compounds)
}

#' Get product info for a list of PZNs
#'
#' @param creds A list containing the access token and host
#' @param pzns A vector with the PZNs
#' @return A data frame with the product info
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_product_info_pzn(creds, c("PZN1", "PZN2"))
#' }
api_product_info_pzn <- function(creds, pzns) {
  host <- creds$host

  info_url <- paste0(host, "/product/info/pzns")
  info <- .get(
    info_url,
    parameters = list(pzns = paste(pzns, collapse = ",")),
    credentials = creds
  ) |>
    .listToDf()

  return(info)
}
