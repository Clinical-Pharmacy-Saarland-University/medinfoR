# Integration tests — require a live API connection.
#
# Set these environment variables (or add them to a gitignored .env file):
#   MEDINFO_HOST     e.g. https://medinfo.precisiondosing.de/api/v1
#   MEDINFO_USER     your username / email
#   MEDINFO_PASSWORD your password
#   MEDINFO_ADMIN    set to "true" if your account has admin role
#
# Run: devtools::test(filter = "integration")

# Two PZNs with verified checksums that exist in the ABDA database:
#   02208615 = ASS-ratiopharm (Acetylsalicylsäure), priscus = TRUE
#   00558736 = NovoRapid Penfill (insulin), priscus = FALSE
KNOWN_PZNS <- c("02208615", "00558736")
KNOWN_COMPOUNDS <- c("Aspirin", "Ibuprofen")
PGXTABLE_COMPOUND <- "Warfarin"

# Memoized credentials — login once, reuse across tests.
# Unlike `local({creds <<- ...})`, this doesn't depend on global state
# from previous sessions, so stale tokens from prior runs can't leak in.
get_creds <- local({
  .creds <- NULL
  function() {
    if (is.null(.creds)) {
      .creds <<- get_test_creds()
    }
    .creds
  }
})

# --- sys ---

test_that("[integration] api_ping returns a response", {
  skip_if_no_creds()
  result <- api_ping(Sys.getenv("MEDINFO_HOST"))
  expect_type(result, "list")
})

test_that("[integration] api_info returns meta_info and api_limits", {
  skip_if_no_creds()
  result <- api_info(Sys.getenv("MEDINFO_HOST"))
  expect_type(result, "list")
  expect_true(!is.null(result$meta_info))
  expect_true(!is.null(result$api_limits))
  expect_true(!is.null(result$meta_info$version))
})

# --- login ---

test_that("[integration] api_login returns valid ApiCredentials", {
  skip_if_no_creds()
  result <- api_login(
    Sys.getenv("MEDINFO_HOST"),
    Sys.getenv("MEDINFO_USER"),
    Sys.getenv("MEDINFO_PASSWORD")
  )
  expect_s3_class(result, "ApiCredentials")
  expect_true(result$access_token_valid())
  expect_true(result$refresh_token_valid())
})

# --- interactions (no interaction between these two compounds) ---

test_that("[integration] api_interaction_pzn returns a data frame", {
  skip_if_no_creds()
  result <- api_interaction_pzn(get_creds(), KNOWN_PZNS)
  expect_s3_class(result, "data.frame")
})

test_that("[integration] api_interaction_pzn with details does not error", {
  skip_if_no_creds()
  result <- api_interaction_pzn(get_creds(), KNOWN_PZNS, details = TRUE)
  expect_s3_class(result, "data.frame")
})

test_that("[integration] api_interaction_pzn_batch returns one result per batch", {
  skip_if_no_creds()
  # Always use 2+ PZNs per batch entry; single-element vectors get JSON auto-unboxed to strings
  batches <- list(
    list(pzns = KNOWN_PZNS, id = 1, details = FALSE),
    list(pzns = KNOWN_PZNS, id = 2, details = FALSE)
  )
  result <- api_interaction_pzn_batch(get_creds(), batches)
  expect_equal(length(result), 2)
  expect_true("id" %in% names(result[[1]]))
  expect_true("interactions" %in% names(result[[1]]))
  expect_equal(result[[1]]$id, "1")
  expect_equal(result[[2]]$id, "2")
  # interactions may be an empty data frame when there are no interactions
  expect_s3_class(result[[1]]$interactions, "data.frame")
})

test_that("[integration] api_interaction_compound returns a data frame", {
  skip_if_no_creds()
  result <- api_interaction_compound(get_creds(), KNOWN_COMPOUNDS)
  expect_s3_class(result, "data.frame")
})

test_that("[integration] api_interaction_compound_batch returns one result per batch", {
  skip_if_no_creds()
  batches <- list(
    list(compounds = KNOWN_COMPOUNDS, id = "A", details = FALSE, doses = FALSE)
  )
  result <- api_interaction_compound_batch(get_creds(), batches)
  expect_equal(length(result), 1)
  expect_equal(result[[1]]$id, "A")
  expect_s3_class(result[[1]]$interactions, "data.frame")
})

# --- product ---

test_that("[integration] api_product_info_pzn returns a data frame with rows", {
  skip_if_no_creds()
  result <- api_product_info_pzn(get_creds(), KNOWN_PZNS)
  expect_s3_class(result, "data.frame")
  expect_gt(nrow(result), 0)
})

test_that("[integration] api_product_compounds_pzn returns a tibble", {
  skip_if_no_creds()
  result <- api_product_compounds_pzn(get_creds(), KNOWN_PZNS)
  expect_s3_class(result, "tbl_df")
})

# --- compound ---

test_that("[integration] api_compound_name returns matches for known compounds", {
  skip_if_no_creds()
  result <- api_compound_name(get_creds(), KNOWN_COMPOUNDS)
  expect_equal(length(result), length(KNOWN_COMPOUNDS))
  expect_equal(result[[1]]$input, KNOWN_COMPOUNDS[1])
  # Each match group is a data frame
  expect_s3_class(result[[1]]$matches[[1]], "data.frame")
})

test_that("[integration] api_compound_guideline returns list with guidelines df", {
  skip_if_no_creds()
  result <- api_compound_guideline(get_creds(), PGXTABLE_COMPOUND)
  expect_equal(length(result), 1)
  expect_s3_class(result[[1]]$guidelines, "data.frame")
})

# --- safety ---

test_that("[integration] api_priscus_pzn returns a data frame with PZN and priscus columns", {
  skip_if_no_creds()
  result <- api_priscus_pzn(get_creds(), KNOWN_PZNS)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  # API returns PZN in uppercase
  expect_true("PZN" %in% names(result))
  expect_true("priscus" %in% names(result))
  expect_type(result$priscus, "logical")
  # 02208615 (ASS) is on the PRISCUS list; 00558736 (NovoRapid) is not
  expect_true(result$priscus[result$PZN == "02208615"])
  expect_false(result$priscus[result$PZN == "00558736"])
})

test_that("[integration] api_qt_pzn returns a data frame with pzn and qt_category columns", {
  skip_if_no_creds()
  result <- api_qt_pzn(get_creds(), KNOWN_PZNS)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("pzn" %in% names(result))
  expect_true("qt_category" %in% names(result))
})

test_that("[integration] api_adr_pzn returns english ADRs by default", {
  skip_if_no_creds()
  result <- api_adr_pzn(get_creds(), KNOWN_PZNS)
  expect_s3_class(result, "data.frame")
})

test_that("[integration] api_adr_pzn returns german ADRs when requested", {
  skip_if_no_creds()
  result <- api_adr_pzn(get_creds(), KNOWN_PZNS, lang = "german")
  expect_s3_class(result, "data.frame")
})

# --- formulations ---

test_that("[integration] api_formulations returns a data frame with formulation column", {
  skip_if_no_creds()
  result <- api_formulations(get_creds())
  expect_s3_class(result, "data.frame")
  expect_true("formulation" %in% names(result))
  expect_true("description" %in% names(result))
  expect_gt(nrow(result), 0)
})

# --- admin ---

test_that("[integration] api_get_users returns a data frame (admin only)", {
  skip_if_no_creds()
  skip_if(
    Sys.getenv("MEDINFO_ADMIN") != "true",
    "Set MEDINFO_ADMIN=true to run admin integration tests"
  )
  result <- api_get_users(get_creds())
  expect_s3_class(result, "data.frame")
  expect_true("email" %in% names(result))
})
