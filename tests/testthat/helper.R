# Shared test helpers

make_fake_creds <- function(
    host = "https://test.example.com/api/v1",
    role = "user",
    expired_access = FALSE,
    expired_refresh = FALSE) {
  now <- Sys.time()
  access_exp <- if (expired_access) now - 3600 else now + 3600
  refresh_exp <- if (expired_refresh) now - 86400 else now + 86400
  fmt <- function(t) format(t, "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")

  ApiCredentials$new(
    access_token = "fake_access_token",
    refresh_token = "fake_refresh_token",
    token_type = "Bearer",
    access_expires_in = fmt(access_exp),
    refresh_expires_in = fmt(refresh_exp),
    role = role,
    last_login = fmt(now - 60),
    host = host
  )
}

skip_if_no_creds <- function() {
  skip_if(
    Sys.getenv("MEDINFO_HOST") == "",
    "Set MEDINFO_HOST, MEDINFO_USER, MEDINFO_PASSWORD to run integration tests"
  )
}

get_test_creds <- function() {
  api_login(
    Sys.getenv("MEDINFO_HOST"),
    Sys.getenv("MEDINFO_USER"),
    Sys.getenv("MEDINFO_PASSWORD")
  )
}
