# Get interactions for a list of PZN batches

Get interactions for a list of PZN batches

## Usage

``` r
api_interaction_pzn_batch(creds, pzn_batches)
```

## Arguments

- creds:

  A list containing the access token and host

- pzn_batches:

  A list of lists containing PZNs, id and a `details` boolean

## Value

A list of data frames with the interactions

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_interaction_pzn_batch(creds, list(list(pzns = c("PZN1", "PZN2"), id = 1, details = TRUE)))
} # }
```
