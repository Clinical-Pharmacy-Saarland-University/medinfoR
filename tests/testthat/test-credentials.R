test_that("ApiCredentials stores fields correctly", {
  creds <- make_fake_creds()
  expect_equal(creds$access_token, "fake_access_token")
  expect_equal(creds$refresh_token, "fake_refresh_token")
  expect_equal(creds$role, "user")
  expect_equal(creds$host, "https://test.example.com/api/v1")
  expect_s3_class(creds$access_expires_in, "POSIXct")
  expect_s3_class(creds$refresh_expires_in, "POSIXct")
  expect_s3_class(creds$last_login, "POSIXct")
})

test_that("access_token_valid returns TRUE for valid token", {
  expect_true(make_fake_creds(expired_access = FALSE)$access_token_valid())
})

test_that("access_token_valid returns FALSE for expired token", {
  expect_false(make_fake_creds(expired_access = TRUE)$access_token_valid())
})

test_that("refresh_token_valid returns TRUE for valid refresh token", {
  expect_true(make_fake_creds(expired_refresh = FALSE)$refresh_token_valid())
})

test_that("refresh_token_valid returns FALSE for expired refresh token", {
  expect_false(make_fake_creds(expired_refresh = TRUE)$refresh_token_valid())
})

test_that("refresh is a no-op when access token is still valid", {
  creds <- make_fake_creds(expired_access = FALSE)
  original_token <- creds$access_token
  creds$refresh(force = FALSE)
  expect_equal(creds$access_token, original_token)
})

test_that("refresh errors when refresh token is expired", {
  creds <- make_fake_creds(expired_access = TRUE, expired_refresh = TRUE)
  expect_error(creds$refresh(), "Refresh token has expired")
})

test_that("print outputs key fields without exposing tokens", {
  creds <- make_fake_creds()
  output <- capture.output(print(creds))
  expect_true(any(grepl("ApiCredentials", output)))
  expect_true(any(grepl("user", output)))
  expect_true(any(grepl("test.example.com", output)))
  expect_false(any(grepl("fake_access_token", output)))
})
