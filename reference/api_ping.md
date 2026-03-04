# Ping the API

This function pings the API to check if it is available.

## Usage

``` r
api_ping(x)
```

## Arguments

- x:

  A character string specifying the API host to be pinged or an object
  of class
  [ApiCredentials](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/ApiCredentials.md).

## Value

A list containing the response from the API. Throws an error if the API
is not available.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

[`api_info()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_info.md)
to retrieve information about the API.

## Examples

``` r
if (FALSE) { # \dontrun{
api_ping("https://api.example.com")

creds <- api_login("https://api.example.com", "username", "password")
api_ping(creds)
} # }
```
