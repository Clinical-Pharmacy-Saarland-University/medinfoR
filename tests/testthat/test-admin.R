# --- api_get_users ---

test_that("api_get_users returns a data frame with user fields", {
  local_mocked_bindings(
    .get = function(...) list(
      list(
        email = "admin@example.com", first_name = "Admin", last_name = "User",
        organization = "Test Org", role = "admin", last_login = NA
      ),
      list(
        email = "user@example.com", first_name = "Regular", last_name = "User",
        organization = "Test Org", role = "user",
        last_login = "2024-06-15T10:30:00Z"
      )
    ),
    .package = "medinfoR"
  )
  result <- api_get_users(make_fake_creds(role = "admin"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("email" %in% names(result))
  expect_true("last_login" %in% names(result))
})

test_that("api_get_users formats last_login as string in local timezone", {
  local_mocked_bindings(
    .get = function(...) list(
      list(
        email = "user@example.com", first_name = "A", last_name = "B",
        organization = "C", role = "user",
        last_login = "2024-06-15T10:30:00Z"
      )
    ),
    .package = "medinfoR"
  )
  result <- api_get_users(make_fake_creds(role = "admin"))
  expect_type(result$last_login, "character")
})

test_that("api_get_users handles NA last_login without error", {
  local_mocked_bindings(
    .get = function(...) list(
      list(
        email = "new@example.com", first_name = "New", last_name = "User",
        organization = "Org", role = "user", last_login = NA
      )
    ),
    .package = "medinfoR"
  )
  result <- api_get_users(make_fake_creds(role = "admin"))
  expect_s3_class(result, "data.frame")
  expect_true(is.na(result$last_login[1]))
})

test_that("api_get_users returns empty data frame when no users", {
  local_mocked_bindings(
    .get = function(...) list(),
    .package = "medinfoR"
  )
  result <- api_get_users(make_fake_creds(role = "admin"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

# --- api_create_user (known bug) ---

test_that("api_create_user fails due to undefined 'res' variable (known bug)", {
  # Bug: api_create_user assigns result to `req` but returns `res` (which is undefined).
  # This test documents the bug so it is caught if the bug is ever fixed.
  local_mocked_bindings(
    .post = function(...) list(message = "user created"),
    .package = "medinfoR"
  )
  expect_error(
    api_create_user(
      make_fake_creds(role = "admin"),
      "new@example.com", "New", "User", "Test Org"
    ),
    "object 'res' not found"
  )
})

# --- api_create_service_user ---

test_that("api_create_service_user posts to /admin/users/service", {
  captured_endpoint <- NULL
  captured_body <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_endpoint <<- endpoint
      captured_body <<- body
      list(message = "service user created")
    },
    .package = "medinfoR"
  )
  result <- api_create_service_user(
    make_fake_creds(role = "admin"),
    "svc@example.com", "Service", "Account", "Test Org", "secret123"
  )
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/admin/users/service")
  expect_equal(captured_body$email, "svc@example.com")
  expect_equal(captured_body$first_name, "Service")
  expect_equal(captured_body$password, "secret123")
  expect_equal(result$message, "service user created")
})

test_that("api_create_service_user defaults role to 'user'", {
  captured_body <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_body <<- body
      list(message = "ok")
    },
    .package = "medinfoR"
  )
  api_create_service_user(
    make_fake_creds(role = "admin"),
    "svc@example.com", "Svc", "Acct", "Org", "pass"
  )
  expect_equal(captured_body$role, "user")
})
