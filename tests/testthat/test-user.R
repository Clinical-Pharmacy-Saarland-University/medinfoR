test_that("api_user_profile returns named list with profile fields", {
  local_mocked_bindings(
    .get = function(...) list(
      email = "user@example.com", first_name = "Joe", last_name = "Doe",
      organization = "ACME", role = "user", last_login = "2024-06-15T10:30:00Z"
    ),
    .package = "medinfoR"
  )
  result <- api_user_profile(make_fake_creds())
  expect_type(result, "list")
  expect_equal(result$email, "user@example.com")
  expect_equal(result$first_name, "Joe")
  expect_equal(result$role, "user")
})

test_that("api_user_profile calls correct endpoint", {
  captured_endpoint <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_endpoint <<- endpoint
      list()
    },
    .package = "medinfoR"
  )
  api_user_profile(make_fake_creds())
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/profile")
})

# --- api_user_update_profile ---

test_that("api_user_update_profile sends correct body", {
  captured_body <- NULL
  local_mocked_bindings(
    .patch = function(endpoint, body, credentials = NULL) {
      captured_body <<- body
      list(message = "updated")
    },
    .package = "medinfoR"
  )
  api_user_update_profile(make_fake_creds(), first_name = "Alice", organization = "Org")
  expect_equal(captured_body$first_name, "Alice")
  expect_equal(captured_body$organization, "Org")
  expect_null(captured_body$last_name)
})

test_that("api_user_update_profile calls correct endpoint", {
  captured_endpoint <- NULL
  local_mocked_bindings(
    .patch = function(endpoint, body, credentials = NULL) {
      captured_endpoint <<- endpoint
      list()
    },
    .package = "medinfoR"
  )
  api_user_update_profile(make_fake_creds(), last_name = "Smith")
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/profile")
})

test_that("api_user_update_profile errors when no fields provided", {
  expect_error(
    api_user_update_profile(make_fake_creds()),
    "At least one"
  )
})

test_that("api_user_update_profile validates min char length", {
  expect_error(
    api_user_update_profile(make_fake_creds(), first_name = "A"),
    regexp = "first_name"
  )
})

# --- api_user_change_password ---

test_that("api_user_change_password sends correct body", {
  captured_body <- NULL
  captured_endpoint <- NULL
  local_mocked_bindings(
    .patch = function(endpoint, body, credentials = NULL) {
      captured_body <<- body
      captured_endpoint <<- endpoint
      list(message = "changed")
    },
    .package = "medinfoR"
  )
  api_user_change_password(make_fake_creds(), "old", "new")
  expect_equal(captured_body$old_password, "old")
  expect_equal(captured_body$new_password, "new")
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/password")
})

# --- api_user_request_email_change ---

test_that("api_user_request_email_change sends correct body and endpoint", {
  captured_body <- NULL
  captured_endpoint <- NULL
  local_mocked_bindings(
    .patch = function(endpoint, body, credentials = NULL) {
      captured_body <<- body
      captured_endpoint <<- endpoint
      list(message = "token sent")
    },
    .package = "medinfoR"
  )
  api_user_request_email_change(make_fake_creds(), "new@example.com")
  expect_equal(captured_body$email, "new@example.com")
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/email")
})

# --- api_user_confirm_email_change ---

test_that("api_user_confirm_email_change sends correct body and endpoint", {
  captured_body <- NULL
  captured_endpoint <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_body <<- body
      captured_endpoint <<- endpoint
      list(message = "confirmed")
    },
    .package = "medinfoR"
  )
  api_user_confirm_email_change(make_fake_creds(), "abc123token")
  expect_equal(captured_body$token, "abc123token")
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/email/confirm")
})

# --- api_user_delete ---

test_that("api_user_delete calls correct endpoint", {
  captured_endpoint <- NULL
  local_mocked_bindings(
    .delete = function(endpoint, credentials = NULL) {
      captured_endpoint <<- endpoint
      list(message = "deleted")
    },
    .package = "medinfoR"
  )
  api_user_delete(make_fake_creds())
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user")
})

# --- api_user_request_password_reset ---

test_that("api_user_request_password_reset sends correct body and endpoint", {
  captured_body <- NULL
  captured_endpoint <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_body <<- body
      captured_endpoint <<- endpoint
      list(message = "token sent")
    },
    .package = "medinfoR"
  )
  api_user_request_password_reset("https://test.example.com/api/v1", "user@example.com")
  expect_equal(captured_body$email, "user@example.com")
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/password/reset")
})

test_that("api_user_request_password_reset strips trailing slash from host", {
  captured_endpoint <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_endpoint <<- endpoint
      list()
    },
    .package = "medinfoR"
  )
  api_user_request_password_reset("https://test.example.com/api/v1/", "user@example.com")
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/password/reset")
})

# --- api_user_confirm_password_reset ---

test_that("api_user_confirm_password_reset sends correct body and endpoint", {
  captured_body <- NULL
  captured_endpoint <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_body <<- body
      captured_endpoint <<- endpoint
      list(message = "password reset")
    },
    .package = "medinfoR"
  )
  api_user_confirm_password_reset(
    "https://test.example.com/api/v1", "user@example.com", "reset_token", "new_pass"
  )
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/password/reset/confirm")
  expect_equal(captured_body$email, "user@example.com")
  expect_equal(captured_body$token, "reset_token")
  expect_equal(captured_body$password, "new_pass")
})

test_that("api_user_confirm_password_reset strips trailing slash", {
  captured_endpoint <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_endpoint <<- endpoint
      list()
    },
    .package = "medinfoR"
  )
  api_user_confirm_password_reset(
    "https://test.example.com/api/v1/", "u@e.com", "tok", "pwd"
  )
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/user/password/reset/confirm")
})
