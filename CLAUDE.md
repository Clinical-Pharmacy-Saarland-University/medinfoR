# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Package Does

`medinfoR` is an R client library for the **medinfo API** — a pharmaceutical information API built by the Clinical Pharmacy Saarland University. It queries drug information, interactions, adverse drug reactions (ADRs), formulations, and other pharmaceutical data from a Go-based backend.

API backend repo: https://github.com/Clinical-Pharmacy-Saarland-University/abdataapi-go

## Common Commands

```r
# Run all tests
devtools::test()

# Run a single test file
devtools::test(filter = "interaction")

# Run integration tests (requires env vars)
# Sys.setenv(MEDINFO_HOST="...", MEDINFO_USER="...", MEDINFO_PASSWORD="...")
devtools::test(filter = "integration")

# Regenerate documentation (run after editing roxygen2 comments)
roxygen2::roxygenise()

# Check the package
devtools::check()

# Build pkgdown site
pkgdown::build_site()
```

## Architecture

### Authentication Flow

1. User sets a password via `api_user_init_password()` (uses init token from email)
2. `api_login()` returns an `ApiCredentials` R6 object (defined in `R/login.R`)
3. The `ApiCredentials` object is passed as the `credentials` argument to every API function
4. `.request()` in `R/helper.R` calls `credentials$refresh(force = FALSE)` before each request, automatically refreshing the access token when expired

### HTTP Layer (`R/helper.R`)

All API calls flow through `.request()` → `.fetch_body_data()`:
- `.get()` / `.post()` → `.request()` → `.fetch_body_data()` → returns `data` field from JSON response
- Errors (HTTP 4xx/5xx) are handled by `.throw_error_body()`, which calls `.trow_api_error()` (note: typo in name is intentional, don't fix without updating all references)
- The response envelope is always `{ "data": ... }`; `.fetch_body_data()` plucks `data` automatically

### Function Naming Convention

All public functions follow `api_<noun>_<optional_qualifier>()`:
- `api_interaction_pzn()` / `api_interaction_compound()` — single query
- `api_interaction_pzn_batch()` / `api_interaction_compound_batch()` — batch queries (multiple PZNs/compounds at once)
- PZN = Pharmazentralnummer (German pharmaceutical product ID)

### Input Validation

Use `checkmate::assert_*()` at the start of every exported function before any API calls.

### Adding a New API Function

1. Create or add to the relevant `R/<topic>.R` file
2. Add roxygen2 documentation with `@export`, `@param`, `@return`, `@examples`
3. Run `roxygen2::roxygenise()` to update `NAMESPACE` and `man/`
4. The function signature should be: `api_<name> <- function(..., credentials)`

### Key Files

| File | Purpose |
|------|---------|
| `R/login.R` | `ApiCredentials` R6 class + `api_login()` |
| `R/helper.R` | All HTTP machinery (`.request`, `.get`, `.post`, `.fetch_body_data`) |
| `R/admin.R` | User management (requires admin role) |
| `R/compound.R` | Drug compound queries |
| `R/product.R` | PZN-based product queries |
| `R/interaction.R` | Drug interaction queries |
| `R/adrs.R` | Adverse drug reaction queries |
| `R/priscus.R` | PRISCUS list (inappropriate meds for elderly) |
| `R/qt_drugs.R` | QT prolongation risk queries |
