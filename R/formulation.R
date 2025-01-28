

api_formulations <- function(creds) {
  token <- creds$access_token
  host <- creds$host

  formulations_url <- paste0(host, "/formulations")
  req <- formulations_url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token)

  formulations <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data")

  return(formulations)
}