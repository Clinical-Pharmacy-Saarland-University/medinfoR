# medinfoR ![](medinfo_logo.svg)

R package to access the medinfo API. The API is created via
<https://github.com/Clinical-Pharmacy-Saarland-University/abdataapi-go>.

## Installation

1.  Install the **devtools** package from CRAN:

``` r
install.packages("devtools")
```

2.  Install the **medinfoR** package from GitHub:

``` r
devtools::install_github("Clinical-Pharmacy-Saarland-University/medinfoR")
```

## Usage

### Set password

Upon registration, you will receive an initial token via email. Use this
token to set your password:

``` r
api_user_init_password("https://medinfo.precisiondosing.de/api/v1", "your_username", "init_token", "new_password")
```

### Login

To login, use your username and password:

``` r
library(medinfoR)

creds <- api_login("https://medinfo.precisiondosing.de/api/v1", "your_username", "your_password")
```

### Functionality

You can check all available functions by typing `?medinfoR` in the R
console or via
<https://clinical-pharmacy-saarland-university.github.io/medinfoR/>.
