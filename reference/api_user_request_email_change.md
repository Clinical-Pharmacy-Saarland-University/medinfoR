# Request email change

Sends an email-change confirmation token to the new email address. The
change must be confirmed via
[`api_user_confirm_email_change()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_confirm_email_change.md)
and becomes active on the next login.

## Usage

``` r
api_user_request_email_change(credentials, email)
```

## Arguments

- credentials:

  An `ApiCredentials` object from
  [`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md).

- email:

  The new email address.

## Value

A named list with the API response message.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve credentials.

[`api_user_confirm_email_change()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_confirm_email_change.md)
to confirm the email change.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "user@example.com", "password")
api_user_request_email_change(creds, "newemail@example.com")
} # }
```
