.listToDf <- function(list) {
  list <- purrr::map(list, ~ purrr::map(.x, ~ ifelse(is.null(.x), NA, .x)))
  dplyr::bind_rows(list)
}