# Retrieve API Information

This function retrieves information about a specified API.

## Usage

``` r
api_info(x)
```

## Arguments

- x:

  A character string specifying the API host for which information is to
  be retrieved or an object of class
  [ApiCredentials](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/ApiCredentials.md).

## Value

A list containing information about the specified API. Throws an error
if the API is not available.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

[`api_ping()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_ping.md)
to check if the API is available.

## Examples

``` r
if (FALSE) { # \dontrun{
api_info("https://api.example.com")

creds <- api_login("https://api.example.com", "username", "password")
api_info(creds)
} # }
```
