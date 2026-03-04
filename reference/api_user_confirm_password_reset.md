# Confirm password reset

Sets a new password using the reset token received by email after
calling
[`api_user_request_password_reset()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_request_password_reset.md).
This is a public endpoint that does not require authentication.

## Usage

``` r
api_user_confirm_password_reset(host, email, token, password)
```

## Arguments

- host:

  The API base URL.

- email:

  The email address of the account.

- token:

  The reset token received by email.

- password:

  The new password to set.

## Value

A named list with the API response message.

## See also

[`api_user_request_password_reset()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_request_password_reset.md)
to request the reset token.

## Examples

``` r
if (FALSE) { # \dontrun{
api_user_confirm_password_reset(
  "https://api.example.com", "user@example.com", "my_reset_token", "new_password"
)
} # }
```
