# --- api_product_info_pzn ---

test_that("api_product_info_pzn returns a data frame", {
  local_mocked_bindings(
    .get = function(...) list(
      list(pzn = "12345678", is_combination = FALSE, category = "analgesic"),
      list(pzn = "87654321", is_combination = TRUE, category = "anti-inflammatory")
    ),
    .package = "medinfoR"
  )
  result <- api_product_info_pzn(make_fake_creds(), c("12345678", "87654321"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("pzn" %in% names(result))
  expect_true("is_combination" %in% names(result))
})

test_that("api_product_info_pzn returns empty data frame for no results", {
  local_mocked_bindings(
    .get = function(...) list(),
    .package = "medinfoR"
  )
  result <- api_product_info_pzn(make_fake_creds(), "00000000")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("api_product_info_pzn passes pzns as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_product_info_pzn(make_fake_creds(), c("11111111", "22222222"))
  expect_equal(captured_params$pzns, "11111111,22222222")
})

# --- api_product_compounds_pzn ---

test_that("api_product_compounds_pzn returns a tibble", {
  # Empty list → empty tibble (tests the rbindlist/as_tibble pipeline)
  local_mocked_bindings(
    .get = function(...) list(),
    .package = "medinfoR"
  )
  result <- api_product_compounds_pzn(make_fake_creds(), "12345678")
  expect_s3_class(result, "tbl_df")
})

test_that("api_product_compounds_pzn passes pzns as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_product_compounds_pzn(make_fake_creds(), c("11111111", "22222222"))
  expect_equal(captured_params$pzns, "11111111,22222222")
})
