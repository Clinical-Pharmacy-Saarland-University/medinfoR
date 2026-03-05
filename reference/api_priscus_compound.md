# Get PRISCUS status for a list of compound names

Get PRISCUS status for a list of compound names

## Usage

``` r
api_priscus_compound(creds, compounds)
```

## Arguments

- creds:

  A list containing the access token and host

- compounds:

  A vector with compound names

## Value

A data frame with the priscus status

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_priscus_compound(creds, c("Metoprolol", "Aspirin"))
} # }
```
