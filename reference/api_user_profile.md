# Get user profile

Retrieves the profile information of the currently authenticated user.

## Usage

``` r
api_user_profile(credentials)
```

## Arguments

- credentials:

  An `ApiCredentials` object from
  [`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md).

## Value

A named list with fields: `email`, `first_name`, `last_name`,
`organization`, `role`, `last_login`.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve credentials.

[`api_user_update_profile()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_update_profile.md)
to update profile information.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "user@example.com", "password")
api_user_profile(creds)
} # }
```
