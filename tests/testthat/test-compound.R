# --- api_compound_name ---

test_that("api_compound_name returns a list with input and matches", {
  # Each element of `matches` is itself a list-of-rows (a table), since
  # api_compound_name calls purrr::map(.x$matches, .listToDf) over each match.
  local_mocked_bindings(
    .get = function(...) list(
      list(
        input = "Aspirin",
        matches = list(
          list(
            list(name = "Acetylsalicylsäure", type = "preferred"),
            list(name = "ASS", type = "synonym")
          )
        )
      )
    ),
    .package = "medinfoR"
  )
  result <- api_compound_name(make_fake_creds(), "Aspirin")
  expect_type(result, "list")
  expect_equal(length(result), 1)
  expect_equal(result[[1]]$input, "Aspirin")
  expect_s3_class(result[[1]]$matches[[1]], "data.frame")
  expect_equal(nrow(result[[1]]$matches[[1]]), 2)
})

test_that("api_compound_name handles multiple compounds", {
  local_mocked_bindings(
    .get = function(...) list(
      list(input = "Aspirin", matches = list(list(list(name = "ASS", type = "preferred")))),
      list(input = "Ibuprofen", matches = list(list(list(name = "Ibuprofen", type = "preferred"))))
    ),
    .package = "medinfoR"
  )
  result <- api_compound_name(make_fake_creds(), c("Aspirin", "Ibuprofen"))
  expect_equal(length(result), 2)
  expect_equal(result[[2]]$input, "Ibuprofen")
})

test_that("api_compound_name passes names as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_compound_name(make_fake_creds(), c("Aspirin", "Ibuprofen", "Warfarin"))
  expect_equal(captured_params$names, "Aspirin,Ibuprofen,Warfarin")
})

test_that("api_compound_name returns empty matches as empty data frame", {
  local_mocked_bindings(
    .get = function(...) list(
      list(input = "UnknownDrug", matches = list())
    ),
    .package = "medinfoR"
  )
  result <- api_compound_name(make_fake_creds(), "UnknownDrug")
  expect_equal(result[[1]]$input, "UnknownDrug")
  expect_type(result[[1]]$matches, "list")
  expect_equal(length(result[[1]]$matches), 0)
})

# --- api_compound_guideline ---

test_that("api_compound_guideline returns a list with input and guidelines df", {
  local_mocked_bindings(
    .get = function(...) list(
      list(
        input = "Warfarin",
        guidelines = list(
          list(gene = "CYP2C9", recommendation = "dose_reduction", strength = "strong"),
          list(gene = "VKORC1", recommendation = "dose_reduction", strength = "strong")
        )
      )
    ),
    .package = "medinfoR"
  )
  result <- api_compound_guideline(make_fake_creds(), "Warfarin")
  expect_type(result, "list")
  expect_equal(result[[1]]$input, "Warfarin")
  expect_s3_class(result[[1]]$guidelines, "data.frame")
  expect_equal(nrow(result[[1]]$guidelines), 2)
  expect_true("gene" %in% names(result[[1]]$guidelines))
})

test_that("api_compound_guideline returns empty guidelines df when none exist", {
  local_mocked_bindings(
    .get = function(...) list(
      list(input = "Ibuprofen", guidelines = list())
    ),
    .package = "medinfoR"
  )
  result <- api_compound_guideline(make_fake_creds(), "Ibuprofen")
  expect_s3_class(result[[1]]$guidelines, "data.frame")
  expect_equal(nrow(result[[1]]$guidelines), 0)
})

test_that("api_compound_guideline passes names as comma-separated string", {
  captured_params <- NULL
  local_mocked_bindings(
    .get = function(endpoint, parameters = NULL, credentials = NULL) {
      captured_params <<- parameters
      list()
    },
    .package = "medinfoR"
  )
  api_compound_guideline(make_fake_creds(), c("Warfarin", "Clopidogrel"))
  expect_equal(captured_params$names, "Warfarin,Clopidogrel")
})
