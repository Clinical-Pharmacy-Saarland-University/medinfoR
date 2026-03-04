# Get ADRs for a list of PZNs

Get ADRs for a list of PZNs

## Usage

``` r
api_adr_pzn(
  creds,
  pzns,
  lang = c("english", "german", "german-simple"),
  details = FALSE
)
```

## Arguments

- creds:

  A list containing the access token and host

- pzns:

  A vector with the PZNs

- lang:

  A string with the language. One of `english`, `german` or
  `german-simple`

- details:

  Logical. Whether to return detailed ADR information. Default `FALSE`.

## Value

A data frame with the ADRs

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_adr_pzn(creds, c("PZN1", "PZN2"), lang = "english")
} # }
```
