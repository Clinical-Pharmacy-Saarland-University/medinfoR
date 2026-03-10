test_that("dev-only endpoints are blocked on medinfo channel", {
  res <- medinfoR:::.endpoint_supported(
    method = "GET",
    path = "/qt/compounds",
    channel = "medinfo",
    version = "1.0.0"
  )
  expect_false(res$supported)
})

test_that("text parameter is blocked on medinfo channel", {
  called <- FALSE
  local_mocked_bindings(
    .check_endpoint_compatibility = function(endpoint, method = "GET", credentials = NULL) {
      list(
        host = "https://medinfo.precisiondosing.de/api/v1",
        online = TRUE,
        channel = "medinfo",
        version = "1.0.0",
        method = "GET",
        path = "/interactions/pzns",
        supported = TRUE,
        reason = "Endpoint is available"
      )
    },
    .safe_raw_request = function(...) {
      called <<- TRUE
      list()
    },
    .package = "medinfoR"
  )

  expect_error(
    medinfoR:::.request(
      "https://medinfo.precisiondosing.de/api/v1/interactions/pzns",
      parameters = list(pzns = "12345678", details = "false", text = "true"),
      method = "GET"
    ),
    "Parameter compatibility check failed"
  )
  expect_false(called)
})

test_that("text parameter is allowed on medinfo-dev channel", {
  called <- FALSE
  local_mocked_bindings(
    .check_endpoint_compatibility = function(endpoint, method = "GET", credentials = NULL) {
      list(
        host = "https://medinfo-dev.precisiondosing.de/api/v1",
        online = TRUE,
        channel = "medinfo-dev",
        version = "1.0.0",
        method = "GET",
        path = "/interactions/pzns",
        supported = TRUE,
        reason = "Endpoint is available"
      )
    },
    .safe_raw_request = function(...) {
      called <<- TRUE
      list()
    },
    .package = "medinfoR"
  )

  medinfoR:::.request(
    "https://medinfo-dev.precisiondosing.de/api/v1/interactions/pzns",
    parameters = list(pzns = "12345678", details = "false", text = "true"),
    method = "GET"
  )
  expect_true(called)
})

test_that("compound ADR endpoint is blocked on medinfo channel", {
  res <- medinfoR:::.endpoint_supported(
    method = "GET",
    path = "/adrs/compounds",
    channel = "medinfo",
    version = "1.0.0"
  )
  expect_false(res$supported)
})

test_that("compound ADR endpoint is allowed on medinfo-dev channel", {
  res <- medinfoR:::.endpoint_supported(
    method = "GET",
    path = "/adrs/compounds",
    channel = "medinfo-dev",
    version = "1.0.0"
  )
  expect_true(res$supported)
})
