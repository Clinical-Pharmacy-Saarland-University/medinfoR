api_login <- function(host, user, password, role) {
  login_url <- paste0(host, "/user/login")
  req <- login_url |>
    httr2::request() |>
    httr2::req_body_json(list(login = user, password = password, role = role))
 
  login <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("data")
 
  login$host = host
  return(login)
}




