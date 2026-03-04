# Create a user

This function creates a user in the system.

## Usage

``` r
api_create_user(creds, mail, first_name, last_name, org, role = NULL)
```

## Arguments

- creds:

  A list with the access token and the host.

- mail:

  The email of the user.

- first_name:

  The first name of the user.

- last_name:

  The last name of the user.

- org:

  The organization of the user.

- role:

  The role of the user. Any of "user" or "admin".

## Value

A message with the result of the operation.

## See also

[`api_login()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_login.md)
to retrieve the login object.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- api_login("https://api.example.com", "user", "password", "user")
api_create_user(
  creds, "test-service@precisiondosing.de",
  "Test", "Service", "Precision Dosing", "password"
)
} # }
```
