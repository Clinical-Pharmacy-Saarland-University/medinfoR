# Get interactions for a list of PZNs

Get interactions for a list of PZNs

## Usage

``` r
api_interaction_pzn(creds, pzns, details = FALSE)
```

## Arguments

- creds:

  A list containing the access token and host

- pzns:

  A vector with the PZNs

- details:

  A boolean indicating if detailed information should be returned

## Value

A data frame with the interactions

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_interaction_pzn(creds, c("PZN1", "PZN2"), details = TRUE)
} # }
```
