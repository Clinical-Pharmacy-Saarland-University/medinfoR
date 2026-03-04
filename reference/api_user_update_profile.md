# Update user profile

Updates profile information for the currently authenticated user. At
least one field must be provided.

## Usage

``` r
api_user_update_profile(
  credentials,
  first_name = NULL,
  last_name = NULL,
  organization = NULL
)
```

## Arguments

- credentials:

  An `ApiCredentials` object from
  [`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md).

- first_name:

  New first name (optional, minimum 2 characters).

- last_name:

  New last name (optional, minimum 2 characters).

- organization:

  New organization name (optional, minimum 2 characters).

## Value

A named list with the API response message.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve credentials.

[`api_user_profile()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_profile.md)
to retrieve current profile information.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "user@example.com", "password")
api_user_update_profile(creds, first_name = "John", organization = "ACME")
} # }
```
