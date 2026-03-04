test_that("api_login returns an ApiCredentials object", {
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      list(
        access_token = "token123",
        refresh_token = "refresh456",
        token_type = "Bearer",
        access_expires_in = "2099-01-01T00:00:00Z",
        refresh_expires_in = "2099-01-02T00:00:00Z",
        role = "user",
        last_login = "2024-01-01T00:00:00Z"
      )
    },
    .package = "medinfoR"
  )
  result <- api_login("https://example.com/api/v1", "user@test.com", "password")
  expect_s3_class(result, "ApiCredentials")
  expect_equal(result$access_token, "token123")
  expect_equal(result$refresh_token, "refresh456")
  expect_equal(result$role, "user")
  expect_equal(result$host, "https://example.com/api/v1")
})

test_that("api_login strips trailing slash from host", {
  captured_endpoint <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_endpoint <<- endpoint
      list(
        access_token = "t", refresh_token = "r", token_type = "Bearer",
        access_expires_in = "2099-01-01T00:00:00Z",
        refresh_expires_in = "2099-01-02T00:00:00Z",
        role = "user", last_login = "2024-01-01T00:00:00Z"
      )
    },
    .package = "medinfoR"
  )
  api_login("https://example.com/api/v1/", "user", "pass")
  expect_equal(captured_endpoint, "https://example.com/api/v1/user/login")
})

test_that("api_login validates host is a string", {
  expect_error(api_login(123, "user", "pass"))
})

test_that("api_login validates user is a string", {
  expect_error(api_login("https://example.com", 123, "pass"))
})

test_that("api_login validates password is a string", {
  expect_error(api_login("https://example.com", "user", 123))
})

test_that("api_login rejects invalid role", {
  expect_error(api_login("https://example.com", "user", "pass", role = "superadmin"))
})

test_that("api_user_init_password posts to correct endpoint", {
  captured_endpoint <- NULL
  captured_body <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_endpoint <<- endpoint
      captured_body <<- body
      list(message = "Password set successfully")
    },
    .package = "medinfoR"
  )
  api_user_init_password("https://example.com/api/v1", "user@test.com", "init-token", "newpassword")
  expect_equal(captured_endpoint, "https://example.com/api/v1/user/password/init")
  expect_equal(captured_body$email, "user@test.com")
  expect_equal(captured_body$token, "init-token")
  expect_equal(captured_body$password, "newpassword")
})
