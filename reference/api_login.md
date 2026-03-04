# Login to the API

Login to the API

## Usage

``` r
api_login(host, user, password, role = c("default", "user", "admin"))
```

## Arguments

- host:

  The host of the API

- user:

  The username

- password:

  The password

- role:

  The role of the user. Any of "user" or "admin".

## Value

An `ApiCredentials` object with the login information.

## See also

[ApiCredentials](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/ApiCredentials.md)
for the object structure.

[`api_user_init_password()`](https://clinical-pharmacy-saarland-university.github.io/medinfoR/reference/api_user_init_password.md)
to set the password.

## Examples

``` r
if (FALSE) { # \dontrun{
api_login("https://api.example.com", "user", "password", "user")
} # }
```
