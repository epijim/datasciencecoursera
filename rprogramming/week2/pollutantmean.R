  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)

setwd("/Users/Jimmy/datasciencecoursera/rprogramming/week2/")

pollutantmean <- function(directory, pollutant, id = 1:332) {
  # id is integer
    id <- as.integer(id)
  # directory and pollutant are character
    directory <- as.character(directory)
    pollutant <- as.character(pollutant)
  # Set directory  
  data <- numeric()
  for (i in id) {
    temp <- read.csv(paste(directory, 
                           "/", 
                           formatC(i, 
                                   width = 3, 
                                   flag = "0"),
                           ".csv", 
                           sep = ""))
    data <- c(data, temp[[pollutant]])
  }
  return(mean(data, na.rm = TRUE))
}

