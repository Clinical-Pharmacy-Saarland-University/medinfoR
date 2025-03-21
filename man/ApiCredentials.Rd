% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/login.R
\docType{class}
\name{ApiCredentials}
\alias{ApiCredentials}
\title{ApiCredentials: API Authentication Credentials}
\description{
This R6 class manages API authentication credentials, including token storage,
expiration checks, and token refreshing.
}
\examples{
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

# Refresh tokens
\dontrun{
creds$refresh(
  "new_access_token", "new_refresh_token",
  "2025-03-01T12:00:00Z", "2025-03-02T12:00:00Z"
)
}
}
\keyword{API,}
\keyword{authentication,}
\keyword{token}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{access_token}}{Access token for API authentication.}

\item{\code{refresh_token}}{Refresh token for obtaining a new access token.}

\item{\code{token_type}}{Type of token, usually "Bearer".}

\item{\code{access_expires_in}}{Timestamp when the access token expires.}

\item{\code{refresh_expires_in}}{Timestamp when the refresh token expires.}

\item{\code{role}}{User role assigned by the API (e.g., "admin").}

\item{\code{last_login}}{Timestamp of the last successful login.}

\item{\code{host}}{API base URL.
Initialize the API credentials.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-ApiCredentials-new}{\code{ApiCredentials$new()}}
\item \href{#method-ApiCredentials-access_token_valid}{\code{ApiCredentials$access_token_valid()}}
\item \href{#method-ApiCredentials-refresh_token_valid}{\code{ApiCredentials$refresh_token_valid()}}
\item \href{#method-ApiCredentials-refresh}{\code{ApiCredentials$refresh()}}
\item \href{#method-ApiCredentials-print}{\code{ApiCredentials$print()}}
\item \href{#method-ApiCredentials-clone}{\code{ApiCredentials$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ApiCredentials-new"></a>}}
\if{latex}{\out{\hypertarget{method-ApiCredentials-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ApiCredentials$new(
  access_token,
  refresh_token,
  token_type,
  access_expires_in,
  refresh_expires_in,
  role,
  last_login,
  host
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{access_token}}{Access token string.}

\item{\code{refresh_token}}{Refresh token string.}

\item{\code{token_type}}{Token type (default: "Bearer").}

\item{\code{access_expires_in}}{Expiration timestamp for access token.}

\item{\code{refresh_expires_in}}{Expiration timestamp for refresh token.}

\item{\code{role}}{User role (e.g., "admin").}

\item{\code{last_login}}{Timestamp of the last login.}

\item{\code{host}}{API base URL.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new \code{ApiCredentials} object.
Check if the access token is still valid.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ApiCredentials-access_token_valid"></a>}}
\if{latex}{\out{\hypertarget{method-ApiCredentials-access_token_valid}{}}}
\subsection{Method \code{access_token_valid()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ApiCredentials$access_token_valid()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{TRUE} if the access token is valid, \code{FALSE} otherwise.
Check if the refresh token is still valid.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ApiCredentials-refresh_token_valid"></a>}}
\if{latex}{\out{\hypertarget{method-ApiCredentials-refresh_token_valid}{}}}
\subsection{Method \code{refresh_token_valid()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ApiCredentials$refresh_token_valid()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{TRUE} if the refresh token is valid, \code{FALSE} otherwise.
Refresh the API tokens.
This method updates the access token and refresh token using the refresh token.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ApiCredentials-refresh"></a>}}
\if{latex}{\out{\hypertarget{method-ApiCredentials-refresh}{}}}
\subsection{Method \code{refresh()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ApiCredentials$refresh(force = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{force}}{Force the refresh even if the access token is still valid.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
None (updates object fields).
Print the API credentials (without exposing tokens).
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ApiCredentials-print"></a>}}
\if{latex}{\out{\hypertarget{method-ApiCredentials-print}{}}}
\subsection{Method \code{print()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ApiCredentials$print()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
None (prints object summary).
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ApiCredentials-clone"></a>}}
\if{latex}{\out{\hypertarget{method-ApiCredentials-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ApiCredentials$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
