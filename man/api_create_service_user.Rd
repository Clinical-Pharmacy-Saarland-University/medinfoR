% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/admin.R
\name{api_create_service_user}
\alias{api_create_service_user}
\title{Create a service user}
\usage{
api_create_service_user(
  creds,
  mail,
  first_name,
  last_name,
  org,
  password,
  role = "user"
)
}
\arguments{
\item{creds}{A list with the access token and the host.}

\item{mail}{The email of the user.}

\item{first_name}{The first name of the user.}

\item{last_name}{The last name of the user.}

\item{org}{The organization of the user.}

\item{password}{The password of the user.}

\item{role}{The role of the user. Any of "user" or "admin".}
}
\value{
A message with the result of the operation.
}
\description{
This function creates a service user in the system. Admin only.
}
\examples{
\dontrun{
creds <- api_login("https://api.example.com", "user", "password", "user")
api_create_service_user(
  creds, "test-service@precisiondosing.de",
  "Test", "Service", "Precision Dosing", "password"
)
}
}
\seealso{
\code{\link[=api_login]{api_login()}} to retrieve the login object.
}
