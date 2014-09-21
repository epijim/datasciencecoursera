complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
  
  # directory and pollutant are character
  directory <- as.character(directory)

  df <- data.frame(id=NA,
                   nobs=NA
                   )[numeric(0),]
  for (i in id) {
    temp <- read.csv(paste(directory, 
                           "/", 
                           formatC(i, 
                                   width = 3, 
                                   flag = "0"),
                           ".csv", 
                           sep = ""))
    complete <- NULL
    complete <- c(i,sum(complete.cases(temp)))
    df[nrow(df)+1,] <- complete
  }
  return(df) 
}