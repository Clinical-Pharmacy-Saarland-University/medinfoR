# List users

This function lists all users in the system. Admin only.

## Usage

``` r
api_get_users(creds)
```

## Arguments

- creds:

  A list with the access token and the host.

## Value

A message with the result of the operation.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "user", "password", "user")
api_get_users(creds)
} # }
```
