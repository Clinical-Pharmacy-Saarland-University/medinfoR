# Get product info for a list of PZNs

Get product info for a list of PZNs

## Usage

``` r
api_product_info_pzn(creds, pzns)
```

## Arguments

- creds:

  A list containing the access token and host

- pzns:

  A vector with the PZNs

## Value

A data frame with the product info

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_product_info_pzn(creds, c("PZN1", "PZN2"))
} # }
```
