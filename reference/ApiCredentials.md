# ApiCredentials: API Authentication Credentials

This R6 class manages API authentication credentials, including token
storage, expiration checks, and token refreshing.

## Public fields

- `access_token`:

  Access token for API authentication.

- `refresh_token`:

  Refresh token for obtaining a new access token.

- `token_type`:

  Type of token, usually "Bearer".

- `access_expires_in`:

  Timestamp when the access token expires.

- `refresh_expires_in`:

  Timestamp when the refresh token expires.

- `role`:

  User role assigned by the API (e.g., "admin").

- `last_login`:

  Timestamp of the last successful login.

- `host`:

  API base URL. Initialize the API credentials.

## Methods

### Public methods

- [`ApiCredentials$new()`](#method-ApiCredentials-new)

- [`ApiCredentials$access_token_valid()`](#method-ApiCredentials-access_token_valid)

- [`ApiCredentials$refresh_token_valid()`](#method-ApiCredentials-refresh_token_valid)

- [`ApiCredentials$refresh()`](#method-ApiCredentials-refresh)

- [`ApiCredentials$print()`](#method-ApiCredentials-print)

- [`ApiCredentials$clone()`](#method-ApiCredentials-clone)

------------------------------------------------------------------------

### Method `new()`

#### Usage

    ApiCredentials$new(
      access_token,
      refresh_token,
      token_type,
      access_expires_in,
      refresh_expires_in,
      role,
      last_login,
      host
    )

#### Arguments

- `access_token`:

  Access token string.

- `refresh_token`:

  Refresh token string.

- `token_type`:

  Token type (default: "Bearer").

- `access_expires_in`:

  Expiration timestamp for access token.

- `refresh_expires_in`:

  Expiration timestamp for refresh token.

- `role`:

  User role (e.g., "admin").

- `last_login`:

  Timestamp of the last login.

- `host`:

  API base URL.

#### Returns

A new `ApiCredentials` object. Check if the access token is still valid.

------------------------------------------------------------------------

### Method `access_token_valid()`

#### Usage

    ApiCredentials$access_token_valid()

#### Returns

`TRUE` if the access token is valid, `FALSE` otherwise. Check if the
refresh token is still valid.

------------------------------------------------------------------------

### Method `refresh_token_valid()`

#### Usage

    ApiCredentials$refresh_token_valid()

#### Returns

`TRUE` if the refresh token is valid, `FALSE` otherwise. Refresh the API
tokens. This method updates the access token and refresh token using the
refresh token.

------------------------------------------------------------------------

### Method `refresh()`

#### Usage

    ApiCredentials$refresh(force = FALSE)

#### Arguments

- `force`:

  Force the refresh even if the access token is still valid.

#### Returns

None (updates object fields). Print the API credentials (without
exposing tokens).

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

#### Usage

    ApiCredentials$print()

#### Returns

None (prints object summary).

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ApiCredentials$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Create an instance with API credentials
creds <- ApiCredentials$new(
  access_token = "your_access_token",
  refresh_token = "your_refresh_token",
  token_type = "Bearer",
  access_expires_in = "2025-02-26T11:16:04.020256331Z",
  refresh_expires_in = "2025-02-27T11:01:04.020409021Z",
  role = "admin",
  last_login = "2025-02-26T11:00:30Z",
  host = "https://medinfo.precisiondosing.de/api/v1"
)

# Check token validity
creds$access_token_valid()
#> [1] FALSE

# Refresh tokens
if (FALSE) { # \dontrun{
creds$refresh(
  "new_access_token", "new_refresh_token",
  "2025-03-01T12:00:00Z", "2025-03-02T12:00:00Z"
)
} # }
```
