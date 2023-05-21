load("registration_data.RData")

#1. Creating the dataframe through the OSF API
# Lists of 3 elements
head(registration_date_created)
head(registration_id)
head(project_id)

library(httr)
library(jsonlite)

res_df <- data.frame(matrix(ncol = 19, nrow = length(registration_id)))

for (project_i in 1:length(registration_id)){ # loop over all projects
  # Start from the registration list we have.
  # This retrieves a specific registration
  id <- registration_id[project_i]
  single_reg <- GET(paste("https://api.osf.io/v2/registrations/?filter[id]=",id, sep = ""))
  registration <- fromJSON(rawToChar(single_reg$content))
  reg_id <- registration$data$id
  reg_date_created <- registration$data$attributes$date_created
  reg_date_modified <- registration$data$attributes$date_modified
  reg_date_registered <- registration$data$attributes$date_registered
  category <- registration$data$attributes$category
  description <- registration$data$attributes$description
  fork <- registration$data$attributes$fork
  public <- registration$data$attributes$public #must be true
  reg_withdrawn <- registration$data$attributes$withdrawn
  reg_withdrawal_justification <- registration$data$attributes$withdrawal_justification
  has_project <- registration$data$attributes$has_project
  parent_project <- registration$data$relationships$registered_from$data$id
  # Get parent project
  parent_node <- GET(paste(registration$data$relationships$registered_from$links$related$href))
  project <- fromJSON(rawToChar(parent_node$content))
  # If the parent project is closed we can not get the info below - stored as NA is not open
  project_id <- ifelse(is.null(project$data$id), "NA", project$data$id)
  web_address <- ifelse(is.null(project$data$links$html), "NA", project$data$links$html)
  project_created <- ifelse(is.null(project$data$attributes$date_created), "NA", project$data$attributes$date_created)
  project_modified <- ifelse(is.null(project$data$attributes$date_modified), "NA", project$data$attributes$date_modified)
  project_title <- ifelse(is.null(project$data$attributes$title), "NA", project$data$attributes$title)
  project_public <- ifelse(is.null(project$data$attributes$public), "NA", project$data$attributes$public)

  results <- c(reg_id, reg_date_created, reg_date_modified, reg_date_registered, reg_date_registered, category, description, fork, public, reg_withdrawn, reg_withdrawal_justification, has_project, parent_project, project_id, web_address, project_created, project_modified, project_title, project_public)
  res_df[project_i,] <- results
  print(project_i) #print i to see progress (code runs for a few hours)
}

save(res_df,
     file = "res_df_data.RData")

#2. Get authors of preregs

author_df <- data.frame(matrix(ncol = 10, nrow = length(registration_id)))

for (project_i in 1:length(registration_id)){ # loop over all projects
  id <- registration_id[project_i]
  contributor_info <- GET(paste("https://api.osf.io/v2/registrations/",id,"/contributors/", sep = ""))
  contributors <- fromJSON(rawToChar(contributor_info$content))
  author <- contributors[["data"]][["embeds"]][["users"]][["data"]][["attributes"]][["full_name"]]
  #If user has deleted OSF account, no longer available, catch error
  if(is.null(author)){author <- "DELETED"}
  author_df[project_i, 1:length(author)] <- author
  print(project_i) #print i to see progress (code runs for an hour or so)
}

save(author_df,
     file = "author_df.RData")

#3. Descriptives

load("res_df_data.RData")
load("author_df.RData")

colnames(res_df) <-  c("reg_id", "reg_date_created", "reg_date_modified", "reg_date_registered", "reg_date_registered", "category", "description", "fork", "public", "reg_withdrawn", "reg_withdrawal_justification", "has_project", "parent_project", "project_id", "web_address", "project_created", "project_modified", "project_title", "project_public")

tot_res <- cbind(res_df, author_df)

# What is the number of unique parent projects?
length(unique(res_df$parent_project))
# 14811

# Number of non-unique parent projects
length(res_df$parent_project)
sum(res_df$project_id == "NA")
sum(res_df$project_public == TRUE)

# How many unique authors preregistered?
all_authors <- data.frame(x=unlist(author_df))
length(unique(all_authors$x))
# 9058

# How many preregistrations are mine?
length(which(all_authors$x == "Daniel Lakens"))

length(which(all_authors$x == "Marek A. Vranka"))
length(which(all_authors$x == "John Protzko"))
length(which(all_authors$x == "Johanna Cohoon"))
# Dealing with non-UTF is difficult (e.g., "Å tÄ›pÃ¡n BahnÃ­k" which should be Štěpán Bahník)

# Note this includes users OSF Tester1 and OSF Tester2 and DELETED accounts
length(which(all_authors$x == "DELETED"))
length(which(all_authors$x == "OSF Tester1"))
length(which(all_authors$x == "OSF Tester2"))
length(which(all_authors$x == "OSF Tester3"))
length(which(all_authors$x == "OSF Tester4"))
length(which(all_authors$x == "OSF Tester5"))
length(which(all_authors$x == "OSF Tester6"))
length(which(all_authors$x == "OSF Tester7"))

# How many registrations are withdrawn?
sum(res_df$reg_withdrawn == TRUE)
# 679

# New dataframe, only unique parent projects
tot_res_unique <- tot_res[!duplicated(tot_res$parent_project),]
# How many are public?
sum(tot_res_unique$project_id == "NA")
# 8413 projects closed
sum(tot_res_unique$project_public == TRUE)
# 6398 - and check: 8413+6398=14811



all_authors$x[3103]
View(all_authors)
View(res_df)
