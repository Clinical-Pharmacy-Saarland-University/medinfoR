# --- api_priscus_pzn ---

test_that("api_priscus_pzn returns a data frame with pzn and priscus columns", {
  local_mocked_bindings(
    .get = function(...) list(
      list(pzn = "12345678", priscus = TRUE),
      list(pzn = "87654321", priscus = FALSE)
    ),
    .package = "medinfoR"
  )
  result <- api_priscus_pzn(make_fake_creds(), c("12345678", "87654321"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("pzn" %in% names(result))
  expect_true("priscus" %in% names(result))
  expect_true(result$priscus[result$pzn == "12345678"])
  expect_false(result$priscus[result$pzn == "87654321"])
})

test_that("api_priscus_pzn returns empty data frame when no results", {
  local_mocked_bindings(
    .get = function(...) list(),
    .package = "medinfoR"
  )
  result <- api_priscus_pzn(make_fake_creds(), "00000000")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("api_priscus_pzn passes pzns as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_priscus_pzn(make_fake_creds(), c("11111111", "22222222"))
  expect_equal(captured_params$pzns, "11111111,22222222")
})

test_that("api_priscus_compound passes compounds as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_priscus_compound(make_fake_creds(), c("Aspirin", "Metoprolol"))
  expect_equal(captured_params$compounds, "Aspirin,Metoprolol")
})

# --- api_qt_pzn ---

test_that("api_qt_pzn returns a data frame with pzn and qt_category columns", {
  local_mocked_bindings(
    .get = function(...) list(
      list(pzn = "12345678", qt_category = "unknown"),
      list(pzn = "87654321", qt_category = "none")
    ),
    .package = "medinfoR"
  )
  result <- api_qt_pzn(make_fake_creds(), c("12345678", "87654321"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("pzn" %in% names(result))
  expect_true("qt_category" %in% names(result))
})

test_that("api_qt_pzn returns empty data frame when no results", {
  local_mocked_bindings(
    .get = function(...) list(),
    .package = "medinfoR"
  )
  result <- api_qt_pzn(make_fake_creds(), "00000000")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("api_qt_compound passes compounds as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_qt_compound(make_fake_creds(), c("Aspirin", "Metoprolol"))
  expect_equal(captured_params$compounds, "Aspirin,Metoprolol")
})

# --- api_adr_pzn ---

test_that("api_adr_pzn returns a data frame", {
  local_mocked_bindings(
    .get = function(...) list(
      list(pzn = "12345678", description = "Nausea", frequency_code = "common"),
      list(pzn = "12345678", description = "Headache", frequency_code = "very_common")
    ),
    .package = "medinfoR"
  )
  result <- api_adr_pzn(make_fake_creds(), "12345678")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
})

test_that("api_adr_pzn defaults to english language", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_adr_pzn(make_fake_creds(), "12345678")
  expect_equal(captured_params$lang, "english")
})

test_that("api_adr_pzn passes lang parameter correctly", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_adr_pzn(make_fake_creds(), "12345678", lang = "german")
  expect_equal(captured_params$lang, "german")

  api_adr_pzn(make_fake_creds(), "12345678", lang = "german-simple")
  expect_equal(captured_params$lang, "german-simple")
})

test_that("api_adr_pzn passes details parameter", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_adr_pzn(make_fake_creds(), "12345678", details = TRUE)
  expect_equal(captured_params$details, "true")
})

test_that("api_adr_pzn rejects invalid lang", {
  expect_error(
    api_adr_pzn(make_fake_creds(), "12345678", lang = "french"),
    "'arg' should be one of"
  )
})

test_that("api_adr_pzn returns empty data frame for unknown PZN", {
  local_mocked_bindings(
    .get = function(...) list(),
    .package = "medinfoR"
  )
  result <- api_adr_pzn(make_fake_creds(), "00000000")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("api_adr_compound returns a data frame", {
  local_mocked_bindings(
    .get = function(...) list(
      list(compound = "Aspirin", description = "Nausea", frequency_code = "common"),
      list(compound = "Ibuprofen", description = "Headache", frequency_code = "very_common")
    ),
    .package = "medinfoR"
  )
  result <- api_adr_compound(make_fake_creds(), c("Aspirin", "Ibuprofen"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
})

test_that("api_adr_compound passes compounds as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_adr_compound(make_fake_creds(), c("Aspirin", "Metoprolol"))
  expect_equal(captured_params$compounds, "Aspirin,Metoprolol")
})

test_that("api_adr_compound defaults to english language", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_adr_compound(make_fake_creds(), "Aspirin")
  expect_equal(captured_params$lang, "english")
})

test_that("api_adr_compound passes details parameter", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_adr_compound(make_fake_creds(), "Aspirin", details = TRUE)
  expect_equal(captured_params$details, "true")
})

test_that("api_adr_compound rejects invalid lang", {
  expect_error(
    api_adr_compound(make_fake_creds(), "Aspirin", lang = "french"),
    "'arg' should be one of"
  )
})

test_that("api_adr_compound returns empty data frame for unknown compound", {
  local_mocked_bindings(
    .get = function(...) list(),
    .package = "medinfoR"
  )
  result <- api_adr_compound(make_fake_creds(), "NotARealCompound")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})
