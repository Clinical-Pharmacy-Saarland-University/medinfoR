# Get formulations

Get formulations

## Usage

``` r
api_formulations(creds)
```

## Arguments

- creds:

  A list containing the access token and host

## Value

A data frame with the formulations

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_formulations(creds)
} # }
```
