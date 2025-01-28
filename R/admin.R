create_service_user_api <- function(creds, mail, 
                                    first_name, last_name, org,
                                    password, role = "user") {
  token <- creds$access_token
  host <- creds$host

  body <- list(
    email = mail,
    first_name = first_name,
    last_name = last_name,
    organization = org,
    password = password,
    role = role)
  

  url <- paste0(host, "/admin/users/service")
  req <- url |>
    httr2::request() |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_body_json(body)

  res <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("message")

  return(res)
}