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