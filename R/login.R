#' ApiCredentials: API Authentication Credentials
#'
#' This R6 class manages API authentication credentials, including token storage,
#' expiration checks, and token refreshing.
#'
#' @docType class
#' @export
#' @keywords API, authentication, token
#' @examples
#' # Create an instance with API credentials
#' creds <- ApiCredentials$new(
#'   access_token = "your_access_token",
#'   refresh_token = "your_refresh_token",
#'   token_type = "Bearer",
#'   access_expires_in = "2025-02-26T11:16:04.020256331Z",
#'   refresh_expires_in = "2025-02-27T11:01:04.020409021Z",
#'   role = "admin",
#'   last_login = "2025-02-26T11:00:30Z",
#'   host = "https://medinfo.precisiondosing.de/api/v1"
#' )
#'
#' # Check token validity
#' creds$is_access_token_valid()
#'
#' # Refresh tokens
#' creds$refresh_tokens(
#'   "new_access_token", "new_refresh_token",
#'   "2025-03-01T12:00:00Z", "2025-03-02T12:00:00Z"
#' )
ApiCredentials <- R6::R6Class("ApiCredentials",
  public = list(

    #' @field access_token Access token for API authentication.
    access_token = NULL,

    #' @field refresh_token Refresh token for obtaining a new access token.
    refresh_token = NULL,

    #' @field token_type Type of token, usually "Bearer".
    token_type = NULL,

    #' @field access_expires_in Timestamp when the access token expires.
    access_expires_in = NULL,

    #' @field refresh_expires_in Timestamp when the refresh token expires.
    refresh_expires_in = NULL,

    #' @field role User role assigned by the API (e.g., "admin").
    role = NULL,

    #' @field last_login Timestamp of the last successful login.
    last_login = NULL,

    #' @field host API base URL.
    host = NULL,

    #' Initialize the API credentials.
    #'
    #' @param access_token Access token string.
    #' @param refresh_token Refresh token string.
    #' @param token_type Token type (default: "Bearer").
    #' @param access_expires_in Expiration timestamp for access token.
    #' @param refresh_expires_in Expiration timestamp for refresh token.
    #' @param role User role (e.g., "admin").
    #' @param last_login Timestamp of the last login.
    #' @param host API base URL.
    #' @return A new `ApiCredentials` object.
    initialize = function(access_token, refresh_token, token_type, access_expires_in,
                          refresh_expires_in, role, last_login, host) {
      self$access_token <- access_token
      self$refresh_token <- refresh_token
      self$token_type <- token_type
      self$access_expires_in <- as.POSIXct(access_expires_in, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
      self$refresh_expires_in <- as.POSIXct(refresh_expires_in, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
      self$role <- role
      self$last_login <- as.POSIXct(last_login, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
      self$host <- host
    },

    #' Check if the access token is still valid.
    #'
    #' @return `TRUE` if the access token is valid, `FALSE` otherwise.
    access_token_valid = function() {
      return(Sys.time() < self$access_expires_in)
    },

    #' Check if the refresh token is still valid.
    #'
    #' @return `TRUE` if the refresh token is valid, `FALSE` otherwise.
    refresh_token_valid = function() {
      return(Sys.time() < self$refresh_expires_in)
    },

    #' Refresh the API tokens.
    #' This method updates the access token and refresh token using the refresh token.
    #'
    #' @param force Force the refresh even if the access token is still valid.
    #' @return None (updates object fields).
    refresh = function(force = FALSE) {
      if (!force && self$access_token_valid()) {
        return()
      }

      if (!self$refresh_token_valid()) {
        stop("Refresh token has expired. Login again to obtain new tokens.", call. = FALSE)
      }

      refresh_url <- paste0(self$host, "/user/refresh-token")
      refresh <- .post(refresh_url, list(refresh_token = self$refresh_token))
      self$access_token <- refresh$access_token
      self$refresh_token <- refresh$refresh_token
      self$access_expires_in <- as.POSIXct(refresh$access_expires_in,
        format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC"
      )
      self$refresh_expires_in <- as.POSIXct(refresh$refresh_expires_in,
        format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC"
      )
      self$last_login <- as.POSIXct(refresh$last_login,
        format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC"
      )
    },

    #' Print the API credentials (without exposing tokens).
    #'
    #' @return None (prints object summary).
    print = function() {
      local_tz <- Sys.timezone()

      cat("<ApiCredentials>\n")
      cat("  Role:", self$role, "\n")
      cat("  Host:", self$host, "\n")
      cat(
        "  Last Login:",
        format(lubridate::with_tz(self$last_login, local_tz), "%Y-%m-%d %H:%M:%S %Z"), "\n"
      )
      cat(
        "  Access Token Expires:",
        format(lubridate::with_tz(self$access_expires_in, local_tz), "%Y-%m-%d %H:%M:%S %Z"), "\n"
      )
      cat(
        "  Refresh Token Expires:",
        format(lubridate::with_tz(self$refresh_expires_in, local_tz), "%Y-%m-%d %H:%M:%S %Z"), "\n"
      )
    }
  )
)


#' Login to the API
#'
#' @param host The host of the API
#' @param user The username
#' @param password The password
#' @param role The role of the user. Any of "user" or "admin".
#' @return An `ApiCredentials` object with the login information.
#' @seealso [ApiCredentials] for the object structure.
#' @seealso [api_user_init_password()] to set the password.
#' @export
#' @examples
#' \dontrun{
#' api_login("https://api.example.com", "user", "password", "user")
#' }
api_login <- function(host, user, password, role = c("default", "user", "admin")) {
  checkmate::assert_string(host)
  checkmate::assert_string(user)
  checkmate::assert_string(password)
  role <- match.arg(role)

  host <- .remove_traling_slash(host)
  if (role == "default") {
    role <- NULL
  }

  login_url <- paste0(host, "/user/login")
  login <- .post(login_url, list(login = user, password = password, role = role))
  creds <- ApiCredentials$new(
    access_token = login$access_token,
    refresh_token = login$refresh_token,
    token_type = login$token_type,
    access_expires_in = login$access_expires_in,
    refresh_expires_in = login$refresh_expires_in,
    role = login$role,
    last_login = login$last_login,
    host = host
  )

  return(creds)
}

#' Initialize password
#' This function is used to set the password for a new user account.
#'
#' @param host The host of the API
#' @param user The username/email
#' @param token The token received from the sign-up email
#' @param password The new password
#' @return A list with the response and the host
#' @export
#' @examples
#' \dontrun{
#' api_user_init_password("https://api.example.com", "test@user.com", "token", "password")
#' }
api_user_init_password <- function(host, user, token, password) {
  checkmate::assert_string(host)
  checkmate::assert_string(user)
  checkmate::assert_string(token)
  checkmate::assert_string(password)
  host <- .remove_traling_slash(host)

  login_url <- paste0(host, "/user/password/init")
  body <- list(token = token, email = user, password = password)

  return(.post(login_url, body))
}
