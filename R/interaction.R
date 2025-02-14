#' Get interactions for a list of PZNs
#'
#' @param creds A list containing the access token and host
#' @param pzns A vector with the PZNs
#' @param details A boolean indicating if detailed information should be returned
#' @return A data frame with the interactions
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_interaction_pzn(creds, c("PZN1", "PZN2"), details = TRUE)
#' }
api_interaction_pzn <- function(creds, pzns, details = FALSE) {
  token <- creds$access_token
  host <- creds$host

  interactions_url <- paste0(host, "/interactions/pzns")
  req <- interactions_url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_url_query(
      pzns = paste(pzns, collapse = ","),
      details = tolower(as.character(details))
    )

  interactions <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data") |>
    .listToDf()

  return(interactions)
}

#' Get interactions for a list of PZN batches
#'
#' @param creds A list containing the access token and host
#' @param pzn_batches A list of lists containing PZNs, id and a `details` boolean
#' @return A list of data frames with the interactions
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_interaction_pzn_batch(creds, list(list(pzns = c("PZN1", "PZN2"), id = 1, details = TRUE)))
#' }
api_interaction_pzn_batch <- function(creds, pzn_batches) {
  token <- creds$access_token
  host <- creds$host

  interactions_url <- paste0(host, "/interactions/pzns")

  pzn_batches <- pzn_batches |>
    purrr::map(~ {
      list(
        pzns = .x$pzns,
        id = as.character(.x$id),
        details = .x$details
      )
    })

  req <- interactions_url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_body_json(pzn_batches)

  interactions <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data") |>
    purrr::map(~ {
      list(
        id = .x$id,
        status = .x$status,
        message = .x$message,
        interactions = .listToDf(.x$interactions)
      )
    })

  return(interactions)
}
