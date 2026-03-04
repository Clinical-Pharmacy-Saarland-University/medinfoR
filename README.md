# medinfoR <img src="medinfo_logo.svg" align="right" width="150" />

R client for the **medinfo API** — a pharmaceutical information service built by the [Clinical Pharmacy Saarland University](https://github.com/Clinical-Pharmacy-Saarland-University/abdataapi-go). It provides drug interaction checks, adverse drug reactions (ADRs), pharmacogenetic guidelines, PRISCUS classifications, QT prolongation risk, product information, and more.

## Installation

```r
# install.packages("pak")
pak::pak("Clinical-Pharmacy-Saarland-University/medinfoR")
```

Or with devtools:

```r
# install.packages("devtools")
devtools::install_github("Clinical-Pharmacy-Saarland-University/medinfoR")
```

## Getting started

### 1. Set your password

New accounts receive an initial token by email. Use it to set your password:

```r
library(medinfoR)

api_user_init_password(
  host     = "https://medinfo.precisiondosing.de/api/v1",
  user     = "your@email.com",
  token    = "token-from-email",
  password = "your-new-password"
)
```

### 2. Login

```r
creds <- api_login(
  host     = "https://medinfo.precisiondosing.de/api/v1",
  user     = "your@email.com",
  password = "your-password"
)
```

`api_login()` returns an `ApiCredentials` object that is passed to every API function. It handles token refresh automatically.

---

## Functions

### Drug interactions

```r
# Single query by PZN (Pharmazentralnummer)
api_interaction_pzn(creds, pzns = c("02208615", "00558736"))

# Single query by compound name
api_interaction_compound(creds, compounds = c("Warfarin", "Aspirin"))

# Batch queries (multiple independent sets at once)
api_interaction_pzn_batch(creds, pzn_batches = list(
  list(pzns = c("02208615", "00558736"), id = 1, details = FALSE),
  list(pzns = c("01234567"), id = 2, details = TRUE)
))

api_interaction_compound_batch(creds, compound_batches = list(
  list(compounds = c("Warfarin", "Aspirin"), id = 1, details = FALSE, doses = TRUE)
))
```

### Adverse drug reactions (ADRs)

```r
api_adr_pzn(creds, pzns = c("02208615", "00558736"), lang = "english")
# lang: "english" | "german" | "german-simple"
```

### Pharmacogenetic guidelines

```r
api_compound_guideline(creds, compounds = c("Warfarin", "Clopidogrel"))
# Returns a list; each element has $input and $guidelines (data frame)
```

### Compound name lookup

```r
api_compound_name(creds, compounds = c("Aspirin", "Paracetamol"))
# Returns a list; each element has $input and $matches (data frame with name/type)
```

### Product information

```r
# Active compounds for PZNs
api_product_compounds_pzn(creds, pzns = c("02208615"))

# Product info (combination status, category)
api_product_info_pzn(creds, pzns = c("02208615", "00558736"))

# Available formulation codes
api_formulations(creds)
```

### Safety classifications

```r
# PRISCUS list (potentially inappropriate medications for elderly patients)
api_priscus_pzn(creds, pzns = c("02208615", "00558736"))

# QT prolongation risk
api_qt_pzn(creds, pzns = c("02208615", "00558736"))
```

### System

```r
api_ping(creds)   # health check
api_info(creds)   # API version and query limits
```

---

## Account management

### Profile

```r
# Get your profile
api_user_profile(creds)

# Update profile (at least one field required)
api_user_update_profile(creds, first_name = "Jane", organization = "Uni Saarland")
```

### Password

```r
# Change password (requires current password)
api_user_change_password(creds, old_password = "old", new_password = "new")

# Request a password reset token by email (no login required)
api_user_request_password_reset(
  host  = "https://medinfo.precisiondosing.de/api/v1",
  email = "your@email.com"
)

# Confirm the reset with the token from the email
api_user_confirm_password_reset(
  host     = "https://medinfo.precisiondosing.de/api/v1",
  email    = "your@email.com",
  token    = "token-from-email",
  password = "new-password"
)
```

### Email

```r
# Request an email change (sends confirmation token to new address)
api_user_request_email_change(creds, email = "new@email.com")

# Confirm the change with the token
api_user_confirm_email_change(creds, token = "token-from-email")
```

### Account deletion

```r
api_user_delete(creds)
```

### Admin functions

```r
# List all users (admin role required)
api_get_users(creds)

# Create a regular user (admin role required)
api_create_user(creds, mail = "new@email.com", first_name = "Jane",
                last_name = "Doe", org = "Uni Saarland")

# Create a service user with a fixed password (admin role required)
api_create_service_user(creds, mail = "svc@email.com", first_name = "Service",
                        last_name = "Account", org = "Uni Saarland",
                        password = "service-password")
```

---

## Full reference

Full function documentation is available at <https://clinical-pharmacy-saarland-university.github.io/medinfoR/>.

---

## Development

### Running tests

Unit tests use mocked HTTP calls and require no credentials:

```r
devtools::test()
```

Integration tests call the live API. They are skipped automatically unless the required environment variables are set. Create a `.env` file in the package root:

```sh
# .env  (gitignored — never commit this file)
MEDINFO_HOST=https://medinfo.precisiondosing.de/api/v1
MEDINFO_USER=your@email.com
MEDINFO_PASSWORD=your-password

# Set to "true" to also run admin-only integration tests
MEDINFO_ADMIN=false
```

Then run:

```r
devtools::test()                          # all tests including integration
devtools::test(filter = "integration")    # integration tests only
```

### Other useful commands

```r
roxygen2::roxygenise()   # regenerate documentation after editing roxygen2 comments
devtools::check()        # full R CMD check
pkgdown::build_site()    # build the pkgdown reference site
```
