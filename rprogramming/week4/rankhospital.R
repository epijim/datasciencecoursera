rankhospital <- function(state, outcome, num) {
  # location
    setwd("~/datasciencecoursera/rprogramming/week4")
    loc_data <- "rprog-data-ProgAssignment3-data/"
  # Read outcome data
    data <- read.csv(paste0(loc_data,"outcome-of-care-measures.csv"), colClasses = "character")  
  # State level data
    data_state <- subset(data, data$State == state)
  
  if (nrow(data_state) == 0) {
    stop("invalid state")
  }
  
  if (num != "best" && num != "worst" && num > nrow(data_state)) {
    return("NA")
    stop()
  }
  
  if (outcome != "heart attack" && outcome != "heart failure" && outcome != "pneumonia") {
    stop("invalid outcome")
  }
  
  state_hospitals <- data_state$Hospital.Name
  
  if (outcome == "heart attack") {
    MortalityRate <- data_state[,11]
  } else if (outcome == "heart failure") {
    MortalityRate <- data_state[,17]
  } else if (outcome == "pneumonia") {
    MortalityRate <- data_state[,23]
  }
  
  data_outcomespec <- cbind(state_hospitals, MortalityRate)
  # Drop missing
  data_outcomespec <- subset(data_outcomespec, 
                             data_outcomespec[,2] != "Not Available")
  
  # order by alpha
  data_outcomespec <- data_outcomespec[order(data_outcomespec[,1]),]
  
  # order by rate
  data_outcomespec <- data_outcomespec[order(as.numeric(data_outcomespec[,2])),]
  
  if (num == "best") {
    return(data_outcomespec[[1,1]])
  } else if (num == "worst") {
    return(data_outcomespec[[nrow(data_outcomespec),1]])
  } else {
    return(data_outcomespec[[num,1]])
  }
}