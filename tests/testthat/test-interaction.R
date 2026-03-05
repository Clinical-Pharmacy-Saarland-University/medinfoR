mock_interactions <- list(
  list(
    compound1 = "Metformin", compound2 = "Ibuprofen",
    credibility = "high", relevance = "moderate",
    frequency = "rare", direction = "unidirectional", plausibility = "plausible"
  ),
  list(
    compound1 = "Metformin", compound2 = "Aspirin",
    credibility = "medium", relevance = "low",
    frequency = "very rare", direction = "bidirectional", plausibility = "theoretical"
  )
)

mock_batch_response <- list(
  list(id = "1", status = 200L, interactions = mock_interactions),
  list(id = "2", status = 200L, interactions = list())
)

# --- api_interaction_pzn ---

test_that("api_interaction_pzn returns a data frame with interaction columns", {
  local_mocked_bindings(
    .get = function(...) mock_interactions,
    .package = "medinfoR"
  )
  creds <- make_fake_creds()
  result <- api_interaction_pzn(creds, c("12345678", "87654321"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true(all(c("compound1", "compound2", "relevance") %in% names(result)))
})

test_that("api_interaction_pzn returns empty data frame when no interactions", {
  local_mocked_bindings(
    .get = function(...) list(),
    .package = "medinfoR"
  )
  result <- api_interaction_pzn(make_fake_creds(), "12345678")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("api_interaction_pzn passes details parameter", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_interaction_pzn(make_fake_creds(), "12345678", details = TRUE)
  expect_equal(captured_params$details, "true")
})

test_that("api_interaction_pzn passes text parameter", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_interaction_pzn(make_fake_creds(), "12345678", text = TRUE)
  expect_equal(captured_params$text, "true")
})

test_that("api_interaction_pzn passes pzns as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_interaction_pzn(make_fake_creds(), c("11111111", "22222222", "33333333"))
  expect_equal(captured_params$pzns, "11111111,22222222,33333333")
})

# --- api_interaction_pzn_batch ---

test_that("api_interaction_pzn_batch returns list with id, status, interactions df", {
  local_mocked_bindings(
    .post = function(...) mock_batch_response,
    .package = "medinfoR"
  )
  batches <- list(
    list(pzns = c("12345678", "87654321"), id = 1, details = FALSE),
    list(pzns = c("11111111"), id = 2, details = FALSE)
  )
  result <- api_interaction_pzn_batch(make_fake_creds(), batches)
  expect_type(result, "list")
  expect_equal(length(result), 2)
  expect_equal(result[[1]]$id, "1")
  expect_equal(result[[1]]$status, 200L)
  expect_s3_class(result[[1]]$interactions, "data.frame")
  expect_equal(nrow(result[[1]]$interactions), 2)
  expect_equal(nrow(result[[2]]$interactions), 0)
})

test_that("api_interaction_pzn_batch coerces id to character", {
  captured_body <- NULL
  local_mocked_bindings(
    .post = function(endpoint, body, credentials = NULL) {
      captured_body <<- body
      list()
    },
    .package = "medinfoR"
  )
  api_interaction_pzn_batch(
    make_fake_creds(),
    list(list(pzns = c("12345678"), id = 42L, details = FALSE))
  )
  expect_type(captured_body[[1]]$id, "character")
  expect_equal(captured_body[[1]]$id, "42")
})

# --- api_interaction_compound ---

test_that("api_interaction_compound returns a data frame", {
  local_mocked_bindings(
    .get = function(...) mock_interactions,
    .package = "medinfoR"
  )
  result <- api_interaction_compound(make_fake_creds(), c("Aspirin", "Ibuprofen"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
})

test_that("api_interaction_compound passes doses, details and text parameters", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_interaction_compound(make_fake_creds(), c("Aspirin"), details = TRUE, doses = FALSE, text = TRUE)
  expect_equal(captured_params$details, "true")
  expect_equal(captured_params$doses, "false")
  expect_equal(captured_params$text, "true")
})

# --- api_interaction_compound_batch ---

test_that("api_interaction_compound_batch returns list with id, status, interactions df", {
  local_mocked_bindings(
    .post = function(...) mock_batch_response,
    .package = "medinfoR"
  )
  batches <- list(
    list(compounds = c("Aspirin", "Ibuprofen"), id = 1, details = FALSE, doses = TRUE),
    list(compounds = c("Metformin"), id = 2, details = FALSE, doses = FALSE)
  )
  result <- api_interaction_compound_batch(make_fake_creds(), batches)
  expect_type(result, "list")
  expect_equal(length(result), 2)
  expect_s3_class(result[[1]]$interactions, "data.frame")
})
