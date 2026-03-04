# Confirm email change

Confirms an email change request using the token sent to the new
address. The new email becomes active on the next login.

## Usage

``` r
api_user_confirm_email_change(credentials, token)
```

## Arguments

- credentials:

  An `ApiCredentials` object from
  [`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md).

- token:

  The confirmation token received by email.

## Value

A named list with the API response message.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve credentials.

[`api_user_request_email_change()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_request_email_change.md)
to initiate the email change.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "user@example.com", "password")
api_user_confirm_email_change(creds, "my_change_token")
} # }
```
