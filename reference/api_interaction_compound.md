# Get interactions for a list of Compounds

Get interactions for a list of Compounds

## Usage

``` r
api_interaction_compound(creds, compounds, details = FALSE, doses = TRUE)
```

## Arguments

- creds:

  A list containing the access token and host

- compounds:

  A vector with the Compound names

- details:

  A boolean indicating if detailed information should be returned

- doses:

  A boolean indicating if doses should be returned

## Value

A data frame with the interactions

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_interaction_compound(creds, c("Aspirin", "Paracetamol"), details = TRUE)
} # }
```
