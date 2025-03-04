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
  host <- creds$host

  interactions_url <- paste0(host, "/interactions/pzns")

  interactions <- .get(
    interactions_url,
    parameters = list(pzns = paste(pzns, collapse = ","), details = tolower(as.character(details))),
    credentials = creds
  ) |>
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

  interactions <- .post(
    interactions_url,
    pzn_batches,
    credentials = creds
  ) |>
    purrr::map(~ {
      list(
        id = .x$id,
        status = .x$status,
        interactions = .listToDf(.x$interactions)
      )
    })

  return(interactions)
}

#' Get interactions for a list of Compounds
#'
#' @param creds A list containing the access token and host
#' @param compounds A vector with the Compound names
#' @param details A boolean indicating if detailed information should be returned
#' @param doses A boolean indicating if doses should be returned
#' @return A data frame with the interactions
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_interaction_compound(creds, c("Aspirin", "Paracetamol"), details = TRUE)
#' }
api_interaction_compound <- function(creds, compounds, details = FALSE, doses = TRUE) {
  token <- creds$access_token
  host <- creds$host

  interactions_url <- paste0(host, "/interactions/compounds")
  interactions <- .get(
    interactions_url,
    parameters = list(
      compounds = paste0(compounds, collapse = ","),
      details = tolower(as.character(details)),
      doses = tolower(as.character(doses))
    ),
    credentials = creds
  ) |>
    .listToDf()

  return(interactions)
}

#' Get interactions for a list of compound batches
#'
#' @param creds A list containing the access token and host
#' @param compound_batches A list of lists containing compounds, id, a `details` boolean, and a `doses` boolean
#' @return A list of data frames with the interactions
#' @export
#' @seealso [api_login()] to retrieve the login object.
#' @examples
#' \dontrun{
#' creds <- api_login("https://api.example.com", "username", "password", "user")
#' api_interaction_compound_batch(creds, list(list(compounds = c("Aspirin", "Paracetamol"), id = 1, details = TRUE, doses = FALSE)))
#' }
api_interaction_compound_batch <- function(creds, compound_batches) {
  host <- creds$host

  interactions_url <- paste0(host, "/interactions/compounds")

  compound_batches <- compound_batches |>
    purrr::map(~ {
      list(
        compounds = .x$compounds,
        id = as.character(.x$id),
        details = .x$details,
        doses = .x$doses
      )
    })

  interactions <- .post(
    interactions_url,
    compound_batches,
    credentials = creds
  ) |>
    purrr::map(~ {
      list(
        id = .x$id,
        status = .x$status,
        interactions = .listToDf(.x$interactions)
      )
    })

  return(interactions)
}
