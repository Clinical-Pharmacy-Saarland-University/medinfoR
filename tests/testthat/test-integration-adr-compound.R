test_that("[integration] api_adr_compound returns english ADRs by default", {
  skip_if_no_creds()
  skip_if_not_dev_host()
  result <- api_adr_compound(get_test_creds(), KNOWN_COMPOUNDS)
  expect_s3_class(result, "data.frame")
})

test_that("[integration] api_adr_compound returns german ADRs when requested", {
  skip_if_no_creds()
  skip_if_not_dev_host()
  result <- api_adr_compound(get_test_creds(), KNOWN_COMPOUNDS, lang = "german")
  expect_s3_class(result, "data.frame")
})
