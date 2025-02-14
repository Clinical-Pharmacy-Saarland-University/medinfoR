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
  token <- creds$access_token
  host <- creds$host

  priscus_url <- paste0(host, "/priscus/pzns")
  req <- priscus_url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_url_query(
      pzns = paste(pzns, collapse = ",")
    )

  priscus <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    .listToDf()

  return(priscus)
}
