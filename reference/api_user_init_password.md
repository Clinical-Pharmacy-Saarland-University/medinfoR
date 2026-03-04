# Initialize password This function is used to set the password for a new user account.

Initialize password This function is used to set the password for a new
user account.

## Usage

``` r
api_user_init_password(host, user, token, password)
```

## Arguments

- host:

  The host of the API

- user:

  The username/email

- token:

  The token received from the sign-up email

- password:

  The new password

## Value

A list with the response and the host

## Examples

``` r
if (FALSE) { # \dontrun{
api_user_init_password("https://api.example.com", "test@user.com", "token", "password")
} # }
```
