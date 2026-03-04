# Delete user account

Soft-deletes the currently authenticated user's account. The last admin
account cannot be deleted.

## Usage

``` r
api_user_delete(credentials)
```

## Arguments

- credentials:

  An `ApiCredentials` object from
  [`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md).

## Value

A named list with the API response message.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve credentials.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "user@example.com", "password")
api_user_delete(creds)
} # }
```
