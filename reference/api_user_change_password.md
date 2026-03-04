# Change password

Changes the password for the currently authenticated user. The new
password becomes active on the next login.

## Usage

``` r
api_user_change_password(credentials, old_password, new_password)
```

## Arguments

- credentials:

  An `ApiCredentials` object from
  [`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md).

- old_password:

  The current password.

- new_password:

  The new password.

## Value

A named list with the API response message.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve credentials.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "user@example.com", "password")
api_user_change_password(creds, "old_pass", "new_pass")
} # }
```
