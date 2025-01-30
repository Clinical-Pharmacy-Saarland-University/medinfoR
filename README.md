# medinfoR <img src="medinfo_logo.svg" align="right" width="150" />

R package to access the  medinfo API

## Installation
1. Install the **devtools** package from CRAN:
```R
install.packages("devtools")
```
2. Install the **medinfoR** package from GitHub:
```R
devtools::install_github("Clinical-Pharmacy-Saarland-University/medinfoR")
```

## Usage

### Set password
Upon registration, you will receive an initial token via email. Use this token to set your password:
```R
api_user_init_password("https://medinfo.precisiondosing.de/api/v1", "your_username", "init_token", "new_password")
```

### Login
To login, use your username and password:
```R
library(medinfoR)

creds <- api_login("https://medinfo.precisiondosing.de/api/v1", "your_username", "your_password")
```

### Get formulations (e.g. to test the API connection)
```R
formulations <- api_formulations(creds)
print(formulations)
```

### Drug-drug interactions (using PZNs)
```R
pzns <- c("03041347", "05538454", "13880764", "00189747", "01970060", "00054065", "17145955", "00592733", "13981502")
ddis <- api_interaction_pzn(creds, pzns)
print(ddis)
```

