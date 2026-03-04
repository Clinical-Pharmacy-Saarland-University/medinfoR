# Request password reset

Sends a password reset token to the specified email address. This is a
public endpoint that does not require authentication. Use
[`api_user_confirm_password_reset()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_confirm_password_reset.md)
to set the new password with the received token.

## Usage

``` r
api_user_request_password_reset(host, email)
```

## Arguments

- host:

  The API base URL.

- email:

  The email address of the account to reset.

## Value

A named list with the API response message.

## See also

[`api_user_confirm_password_reset()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_confirm_password_reset.md)
to confirm the reset with the token.

## Examples

``` r
if (FALSE) { # \dontrun{
api_user_request_password_reset("https://api.example.com", "user@example.com")
} # }
```
