setwd("~/datasciencecoursera/rprogramming/week4")

loc_data <- "rprog-data-ProgAssignment3-data/"

# Load in data
  outcome <- read.csv(paste0(loc_data,"outcome-of-care-measures.csv"), 
                      colClasses = "character")
# Look at data
  head(outcome)
  ncol(outcome)
  names(outcome)

# First histogram of 30-day death rates from MI
  outcome[, 11] <- as.numeric(outcome[, 11])
    ## You may get a warning about NAs being introduced; that is okay
  hist(outcome[, 11])
