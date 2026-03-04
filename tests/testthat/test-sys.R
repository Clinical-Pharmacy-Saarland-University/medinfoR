test_that("api_ping returns response for string host", {
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) list(message = "pong"),
    .package = "medinfoR"
  )
  result <- api_ping("https://test.example.com/api/v1")
  expect_equal(result$message, "pong")
})

test_that("api_ping accepts ApiCredentials and extracts host", {
  captured_endpoint <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_endpoint <<- endpoint
      list(message = "pong")
    },
    .package = "medinfoR"
  )
  creds <- make_fake_creds(host = "https://test.example.com/api/v1")
  api_ping(creds)
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/sys/ping")
})

test_that("api_ping strips trailing slash from host string", {
  captured_endpoint <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_endpoint <<- endpoint
      list(message = "pong")
    },
    .package = "medinfoR"
  )
  api_ping("https://test.example.com/api/v1/")
  expect_equal(captured_endpoint, "https://test.example.com/api/v1/sys/ping")
})

test_that("api_ping rejects numeric input", {
  expect_error(api_ping(123), "must be an object of class")
})

test_that("api_ping rejects list input", {
  expect_error(api_ping(list(host = "x")), "must be an object of class")
})

test_that("api_info returns response for string host", {
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      list(version = "1.0.0", max_drugs = 30, max_batch = 100)
    },
    .package = "medinfoR"
  )
  result <- api_info("https://test.example.com/api/v1")
  expect_equal(result$version, "1.0.0")
  expect_equal(result$max_drugs, 30)
})

test_that("api_info accepts ApiCredentials", {
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      list(version = "2.0.0", max_drugs = 50, max_batch = 200)
    },
    .package = "medinfoR"
  )
  creds <- make_fake_creds()
  result <- api_info(creds)
  expect_equal(result$version, "2.0.0")
})

test_that("api_info rejects numeric input", {
  expect_error(api_info(42), "must be an object of class")
})
