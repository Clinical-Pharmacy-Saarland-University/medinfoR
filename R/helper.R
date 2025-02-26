.listToDf <- function(list) {
  list <- purrr::map(list, ~ purrr::map(.x, ~ ifelse(is.null(.x), NA, .x)))
  dplyr::bind_rows(list)
}

.remove_traling_slash <- function(url) {
  if (stringr::str_sub(url, -1) == "/") {
    url <- stringr::str_sub(url, end = -2)
  }
  return(url)
}

.post <- function(endpoint, body, credentials = NULL) {
  .request(endpoint, body, credentials)
}

.get <- function(endpoint, credentials = NULL) {
  .request(endpoint, credentials = credentials)
}

# Inernal Helper functions
.trow_api_error <- function(code, message) {
  stop(paste0("API error (", code, ") : ", message), call. = FALSE)
}

.throw_error_body <- function(res) {
  has_body <- httr2::resp_has_body(res)
  if (!has_body) {
    .trow_api_error(res$status_code, "Unknown error")
  }

  .try_json <- purrr::safely(httr2::resp_body_json)
  .try_str <- purrr::safely(httr2::resp_body_string)

  body <- .try_json(res)
  if (is.null(body$error)) {
    .trow_api_error(res$status_code, jsonlite::toJSON(body$result, auto_unbox = TRUE))
  }

  body <- .try_str(res)
  if (is.null(body$error)) {
    .trow_api_error(res$status_code, body$result)
  }

  .trow_api_error(res$status_code, "Unknown error")

  return(res)
}

.fetch_body_data <- function(req) {
  res <- req |>
    httr2::req_error(is_error = \(resp) FALSE) |>
    httr2::req_perform()


  if (res$status_code >= 400) {
    .throw_error_body(res)
  }

  return(res |>
    httr2::resp_body_json() |>
    purrr::pluck("data"))
}

.request <- function(endpoint, body = NULL, credentials = NULL) {
  req <- endpoint |>
    httr2::request()

  if (!is.null(body)) {
    req <- req |>
      httr2::req_body_json(body)
  }

  if (!is.null(credentials)) {
    credentials$refresh(force = FALSE)
    req <- req |>
      httr2::req_auth_bearer_token(credentials$access_token)
  }

  res <- .fetch_body_data(req)
  return(res)
}
