# Get pharmacogenetic guidelines for a list of compound names

Get pharmacogenetic guidelines for a list of compound names

## Usage

``` r
api_compound_guideline(creds, compounds)
```

## Arguments

- creds:

  A list containing the access token and host

- compounds:

  A vector with the compound names

## Value

A list of data frames with the corresponding pharmacogenetic guidelines

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_compound_guideline(creds, compounds = c("Aspirin", "Paracetamol"))
} # }
```
