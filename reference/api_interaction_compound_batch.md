# Get interactions for a list of compound batches

Get interactions for a list of compound batches

## Usage

``` r
api_interaction_compound_batch(creds, compound_batches)
```

## Arguments

- creds:

  A list containing the access token and host

- compound_batches:

  A list of lists containing compounds, id, a `details` boolean, and a
  `doses` boolean

## Value

A list of data frames with the interactions

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_interaction_compound_batch(creds, list(list(
  compounds = c("Aspirin", "Paracetamol"),
  id = 1, details = TRUE, doses = FALSE
)))
} # }
```
