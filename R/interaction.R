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
api_interaction_pzn <- function(creds, pzns, details = FALSE)  {
  token <- creds$access_token
  host <- creds$host

  formulations_url <- paste0(host, "/interactions/pzns")
  req <- formulations_url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_url_query(
      pzns = paste(pzns, collapse = ","),  # Ensure multiple PZNs are joined by commas
      details = tolower(as.character(details))  # Convert boolean to lowercase string
    )

  formulations <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data") |>
    .listToDf()

  return(formulations)
}


api_batch_interaction_pzn <- function(creds, pzn_list)  {
  token <- creds$access_token
  host <- creds$host

  formulations_url <- paste0(host, "/interactions/pzns")
  req <- formulations_url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_url_query(
      pzns = paste(pzns, collapse = ","),  # Ensure multiple PZNs are joined by commas
      details = tolower(as.character(details))  # Convert boolean to lowercase string
    )

  formulations <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data") |>
    .listToDf()

  return(formulations)
}