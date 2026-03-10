.listToDf <- function(list) {
  list <- purrr::map(list, ~ purrr::map(.x, ~ ifelse(is.null(.x), NA, .x)))
  dplyr::bind_rows(list)
}

.remove_trailing_slash <- function(url) {
  if (stringr::str_sub(url, -1) == "/") {
    url <- stringr::str_sub(url, end = -2)
  }
  return(url)
}

.null_coalesce <- function(x, y) {
  if (is.null(x)) y else x
}

.post <- function(endpoint, body, credentials = NULL) {
  .request(endpoint, body = body, credentials = credentials, method = "POST")
}

.patch <- function(endpoint, body, credentials = NULL) {
  .request(endpoint, body = body, credentials = credentials, method = "PATCH")
}

.delete <- function(endpoint, credentials = NULL) {
  .request(endpoint, credentials = credentials, method = "DELETE")
}

.get <- function(endpoint, parameters = NULL, credentials = NULL) {
  .request(endpoint, parameters = parameters, credentials = credentials, method = "GET")
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
  res <- res |>
    httr2::resp_body_json() |>
    purrr::pluck("data")
  return(res)
}

.endpoint_registry <- function() {
  data.frame(
    method = c(
      "GET", "GET", "POST", "POST", "POST", "POST", "GET", "PATCH",
      "PATCH", "PATCH", "POST", "DELETE", "POST", "POST", "POST", "GET",
      "GET", "GET", "GET", "POST", "GET", "POST", "GET", "GET", "GET",
      "GET", "GET", "GET", "GET", "GET", "GET"
    ),
    path = c(
      "/sys/ping", "/sys/info", "/user/login", "/user/password/init",
      "/user/password/reset", "/user/password/reset/confirm", "/user/profile",
      "/user/profile", "/user/password", "/user/email", "/user/email/confirm",
      "/user", "/user/refresh-token", "/admin/users/service", "/admin/users",
      "/admin/users", "/compounds/names", "/compounds/guidelines",
      "/interactions/pzns", "/interactions/pzns", "/interactions/compounds",
      "/interactions/compounds", "/product/activecompounds/pzns",
      "/product/info/pzns", "/qt/pzns", "/priscus/pzns", "/adrs/pzns",
      "/formulations", "/qt/compounds", "/priscus/compounds", "/adrs/compounds"
    ),
    min_version = NA_character_,
    max_version = NA_character_,
    stringsAsFactors = FALSE
  )
}

.endpoint_channel_overrides <- function() {
  list(
    "GET /qt/compounds" = c("medinfo-dev", "unknown"),
    "GET /priscus/compounds" = c("medinfo-dev", "unknown")
  )
}

.parameter_channel_overrides <- function() {
  list(
    "GET /interactions/pzns" = list(
      text = c("medinfo-dev", "unknown")
    ),
    "GET /interactions/compounds" = list(
      text = c("medinfo-dev", "unknown")
    )
  )
}

.is_truthy_param <- function(x) {
  if (is.null(x)) {
    return(FALSE)
  }
  if (is.logical(x)) {
    return(isTRUE(x))
  }
  tolower(as.character(x)) %in% c("true", "1", "yes")
}

.parameter_supported <- function(method, path, parameters, channel, version) {
  if (is.null(parameters) || length(parameters) == 0) {
    return(list(supported = TRUE, reason = "Parameters are available"))
  }

  key <- paste(toupper(method), path)
  overrides <- .parameter_channel_overrides()[[key]]
  if (is.null(overrides)) {
    return(list(supported = TRUE, reason = "Parameters are available"))
  }

  for (param_name in names(overrides)) {
    param_value <- parameters[[param_name]]
    if (!.is_truthy_param(param_value)) {
      next
    }

    allowed_channels <- overrides[[param_name]]
    if (!(channel %in% allowed_channels)) {
      return(list(
        supported = FALSE,
        reason = paste0(
          "Parameter '", param_name,
          "' is not available on the requested host channel"
        )
      ))
    }
  }

  list(supported = TRUE, reason = "Parameters are available")
}

.extract_endpoint_parts <- function(endpoint) {
  parsed <- httr2::url_parse(endpoint)
  scheme <- .null_coalesce(parsed$scheme, "https")
  hostname <- .null_coalesce(parsed$hostname, "")
  port <- parsed$port
  full_path <- .null_coalesce(parsed$path, "")
  query <- parsed$query

  has_port <- !is.null(port) && !is.na(port) && nzchar(as.character(port))
  host_origin <- paste0(scheme, "://", hostname, if (has_port) paste0(":", port) else "")

  api_prefix <- stringr::str_extract(full_path, "^/api/v[0-9]+")
  host <- if (is.na(api_prefix)) host_origin else paste0(host_origin, api_prefix)

  normalized_path <- if (is.na(api_prefix)) {
    full_path
  } else {
    sub("^/api/v[0-9]+", "", full_path)
  }

  if (identical(normalized_path, "")) {
    normalized_path <- "/"
  }

  list(
    host = .remove_trailing_slash(host),
    normalized_path = normalized_path,
    method = NULL,
    query = query
  )
}

.safe_raw_request <- function(endpoint, parameters = NULL, body = NULL, credentials = NULL,
                              method = "GET", refresh_credentials = TRUE) {
  req <- endpoint |>
    httr2::request()

  if (!is.null(body)) {
    req <- req |>
      httr2::req_body_json(body)
  }

  if (!is.null(method)) {
    req <- req |>
      httr2::req_method(method)
  }

  if (!is.null(parameters)) {
    req <- req |>
      httr2::req_url_query(!!!parameters)
  }

  if (!is.null(credentials)) {
    if (refresh_credentials) {
      credentials$refresh(force = FALSE)
    }
    req <- req |>
      httr2::req_auth_bearer_token(credentials$access_token)
  }

  .fetch_body_data(req)
}

.safe_api_info <- function(host) {
  url <- paste0(.remove_trailing_slash(host), "/sys/info")
  tryCatch(.safe_raw_request(url, method = "GET"), error = function(e) NULL)
}

.host_online <- function(host) {
  url <- paste0(.remove_trailing_slash(host), "/sys/ping")
  isTRUE(tryCatch({
    .safe_raw_request(url, method = "GET")
    TRUE
  }, error = function(e) FALSE))
}

.detect_host_channel <- function(host, info = NULL) {
  host_lower <- tolower(host)
  info_url <- if (!is.null(info) && !is.null(info$meta_info)) {
    .null_coalesce(info$meta_info$url, "")
  } else {
    ""
  }
  info_lower <- tolower(info_url)

  if (grepl("medinfo-dev\\.", host_lower) || grepl("medinfo-dev\\.", info_lower)) {
    return("medinfo-dev")
  }
  if (grepl("medinfo\\.", host_lower) || grepl("medinfo\\.", info_lower)) {
    return("medinfo")
  }
  "unknown"
}

.extract_api_version <- function(info = NULL) {
  if (!is.null(info) && !is.null(info$meta_info)) {
    return(.null_coalesce(info$meta_info$version, NA_character_))
  }
  NA_character_
}

.version_matches <- function(version, min_version = NA_character_, max_version = NA_character_) {
  if (is.na(version) || is.na(min_version) && is.na(max_version)) {
    return(TRUE)
  }

  parsed <- tryCatch(numeric_version(version), error = function(e) NULL)
  if (is.null(parsed)) {
    return(TRUE)
  }

  if (!is.na(min_version)) {
    min_parsed <- tryCatch(numeric_version(min_version), error = function(e) NULL)
    if (!is.null(min_parsed) && parsed < min_parsed) {
      return(FALSE)
    }
  }

  if (!is.na(max_version)) {
    max_parsed <- tryCatch(numeric_version(max_version), error = function(e) NULL)
    if (!is.null(max_parsed) && parsed > max_parsed) {
      return(FALSE)
    }
  }

  TRUE
}

.endpoint_supported <- function(method, path, channel, version) {
  method <- toupper(.null_coalesce(method, "GET"))
  reg <- .endpoint_registry()
  rows <- reg[reg$method == method & reg$path == path, , drop = FALSE]

  if (nrow(rows) == 0) {
    return(list(supported = FALSE, reason = "Endpoint is not supported by this client"))
  }

  overrides <- .endpoint_channel_overrides()
  key <- paste(method, path)
  allowed_channels <- .null_coalesce(overrides[[key]], c("medinfo", "medinfo-dev", "unknown"))

  if (!(channel %in% allowed_channels)) {
    return(list(supported = FALSE, reason = "Endpoint is not available on the requested host channel"))
  }

  version_ok <- any(apply(rows, 1, function(r) {
    .version_matches(version, r[["min_version"]], r[["max_version"]])
  }))

  if (!version_ok) {
    return(list(supported = FALSE, reason = "Endpoint is not available for the requested API version"))
  }

  list(supported = TRUE, reason = "Endpoint is available")
}

.check_endpoint_compatibility <- function(endpoint, method = "GET", credentials = NULL) {
  method <- toupper(.null_coalesce(method, "GET"))
  parts <- .extract_endpoint_parts(endpoint)
  host <- if (!is.null(credentials)) credentials$host else parts$host
  host <- .remove_trailing_slash(host)

  online <- .host_online(host)
  info <- if (online) .safe_api_info(host) else NULL
  channel <- .detect_host_channel(host, info = info)
  version <- .extract_api_version(info = info)
  support <- if (online) {
    .endpoint_supported(method = method, path = parts$normalized_path, channel = channel, version = version)
  } else {
    list(supported = FALSE, reason = "Host is offline or unreachable")
  }

  list(
    host = host,
    online = online,
    channel = channel,
    version = version,
    method = method,
    path = parts$normalized_path,
    supported = support$supported,
    reason = support$reason
  )
}

.request <- function(endpoint, parameters = NULL, body = NULL, credentials = NULL, method = NULL) {
  method <- toupper(.null_coalesce(method, "GET"))
  preflight <- .check_endpoint_compatibility(
    endpoint = endpoint,
    method = method,
    credentials = credentials
  )

  if (!preflight$online) {
    stop("API host is offline or unreachable.", call. = FALSE)
  }

  if (!preflight$supported) {
    stop(paste0("Endpoint compatibility check failed: ", preflight$reason), call. = FALSE)
  }

  param_support <- .parameter_supported(
    method = method,
    path = preflight$path,
    parameters = parameters,
    channel = preflight$channel,
    version = preflight$version
  )

  if (!param_support$supported) {
    stop(paste0("Parameter compatibility check failed: ", param_support$reason), call. = FALSE)
  }

  .safe_raw_request(
    endpoint = endpoint,
    parameters = parameters,
    body = body,
    credentials = credentials,
    method = method,
    refresh_credentials = TRUE
  )
}
