best <- function(state, outcome) {
  setwd("~/datasciencecoursera/rprogramming/week4")
  loc_data <- "rprog-data-ProgAssignment3-data/"
  ## Read outcome data
  ocm <- read.csv(paste0(loc_data,"outcome-of-care-measures.csv"), colClasses = "character")     
  ocmForState <- subset(ocm, ocm$State == state)
  
  if (nrow(ocmForState) == 0) {
    stop("invalid state")
  }
  
  HospitalsInState <- ocmForState$Hospital.Name
  
  if (outcome == "heart attack") {
    MortalityRate <- ocmForState[,11]
  } else if (outcome == "heart failure") {
    MortalityRate <- ocmForState[,17]
  } else if (outcome == "pneumonia") {
    MortalityRate <- ocmForState[,23]
  }
  
  df <- cbind(HospitalsInState, MortalityRate)
  dfwona <- subset(df, df[,2] != "Not Available")
  HospsWithLeast30DayMR <- subset(dfwona, as.numeric(dfwona[,2]) == min(as.numeric(dfwona[,2])))
  
  if (nrow(HospsWithLeast30DayMR) > 1) {
    retval <- sort(HospsWithLeast30DayMR[,1])
    retval <- retval[[1]]
  } else {
    retval <- HospsWithLeast30DayMR[[1,1]]
  }
  
  return(retval)
}
   