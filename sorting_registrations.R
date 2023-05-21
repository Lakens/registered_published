###########################################################################
### Sorting registrations based on whether the project is public or not ###
###########################################################################

library(httr)
library(jsonlite)

## Load relevant data
load("registration_data.RData")


## Check whether projects are public or not

project_public <- c()              # vector with booleans to store whether a project is public (true) or not (false)
project_i <- 1                     # project index for the loop


for (project_i in 1:length(project_id))           # loop over all projects
{
  res <- GET(paste("https://api.osf.io/v2/nodes/?filter[id]=", project_id[project_i], sep = "")) # access node (project) i
  projects <- fromJSON(rawToChar(res$content))
  if (projects$links$meta$total == 0) {           # in this case, the project is not public (in total, zero results)
    project_public <- c(project_public, "false")
  }
  else {                                          # in this case, the project is public
    project_public <- c(project_public, "true")
  }
  project_i <- project_i+1    # update project index
}

print(project_public)         # show whether projects are public (true) or not (false) in same order as IDs


## Sort registrations based on whether the project is public or not

group1_IDs <- c()             # vector with all registration IDs where the project is public
group2_IDs <- c()             # vector with all registration IDs where the project is not public
reg_i <- 1                    # registration index for the loop


for (reg_i in 1:length(registration_id))          # loop over all registrations
{
  if (project_public[reg_i] == "true") {          # registration should be added to group 1
    group1_IDs <- c(group1_IDs, registration_id[reg_i])
  }
  else {                                          # registration should be added to group 2
    group2_IDs <- c(group2_IDs, registration_id[reg_i])
  }
  reg_i <- reg_i+1            # update registration index
}

print(group1_IDs)             # show all registrations where the project is public
print(group2_IDs)             # show all registrations where the project is not public


## Save IDs from both groups
save(group1_IDs, group2_IDs, file = "group1_and_2_IDs.RData")
