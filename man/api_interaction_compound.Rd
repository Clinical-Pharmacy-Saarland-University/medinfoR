% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interaction.R
\name{api_interaction_compound}
\alias{api_interaction_compound}
\title{Get interactions for a list of Compounds}
\usage{
api_interaction_compound(creds, compounds, details = FALSE, doses = TRUE)
}
\arguments{
\item{creds}{A list containing the access token and host}

\item{compounds}{A vector with the Compound names}

\item{details}{A boolean indicating if detailed information should be returned}

\item{doses}{A boolean indicating if doses should be returned}
}
\value{
A data frame with the interactions
}
\description{
Get interactions for a list of Compounds
}
\examples{
\dontrun{
creds <- api_login("https://api.example.com", "username", "password", "user")
api_interaction_compound(creds, c("Aspirin", "Paracetamol"), details = TRUE)
}
}
\seealso{
\code{\link[=api_login]{api_login()}} to retrieve the login object.
}
