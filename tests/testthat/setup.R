# Load credentials from .env (gitignored) if present.
# Supports both devtools::test() (cwd = package root) and
# running test files directly (cwd = tests/testthat/).
for (.env_path in c(".env", file.path("..", "..", ".env"))) {
  if (file.exists(.env_path)) {
    readRenviron(.env_path)
    break
  }
}
rm(.env_path)
