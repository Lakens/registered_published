########################################
### Importing data from the OSF in R ###
########################################

install.packages(c("httr", "jsonlite"))

library(httr)
library(jsonlite)


number_of_pages <- 1773            # total number of pages up to date_created 18-11-2017
page_i <- 1                        # page index for the loop
registration_id <- c()             # vector with all registration IDs (empty at this point)
project_id <- c()                  # vector with all project IDs (empty at this point)
res_temp <- c()                    # temporary vector used to store data in loop (empty at this point)
registration_date_created <- c()   # vector with date_created of all registrations


for (page_i in 1:number_of_pages)  # loop over all pages up to date_created 18-11-2017
{
  res <- GET(paste("https://api.osf.io/v2/registrations/?sort=date_created&page=", page_i, sep = "")) # access page i
  registrations <- fromJSON(rawToChar(res$content))
  res_temp <- registrations$data   # temporarily store data of current page
  registration_id <- c(registration_id, res_temp$id) # add registration IDs of current page
  registration_date_created <- c(registration_date_created, res_temp$attributes$date_created) # add date_created of these registrations
  project_id <- c(project_id, res_temp$relationships$registered_from$data$id) # add project IDs of these registrations

  page_i <- page_i+1               # update page index
}

print(registration_id)             # show registration IDs
print(project_id)                  # show project IDs
print(registration_date_created)   # show date_created of all registrations

## Manually check date_registered > 4 years (first 17729 items)

registration_id <- head(registration_id, -1)
project_id <- head(project_id, -1)
registration_date_created <- registration_date_created <- head(registration_date_created, -1)


## Save relevant data
save(registration_id, project_id, registration_date_created, file = "registration_data.RData")
