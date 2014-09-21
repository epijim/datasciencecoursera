rankall <- function(outcome, num = "best") {
  # location
  setwd("~/datasciencecoursera/rprogramming/week4")
  loc_data <- "rprog-data-ProgAssignment3-data/"
  # Read outcome data
  data <- read.csv(paste0(loc_data,"outcome-of-care-measures.csv"), colClasses = "character") 
  
  if (outcome != "heart attack" && outcome != "heart failure" && outcome != "pneumonia") {
    stop("invalid outcome")
  }
  
  if (outcome == "heart attack") {
    Column <- 11
  } else if (outcome == "heart failure") {
    Column <- 17
  } else if (outcome == "pneumonia") {
    Column <- 23
  }
  
  HospitalStates <- data$State
  Hospitals <- data$Hospital.Name
  Outcome <- data[,Column]
  data_all <- cbind(HospitalStates, Hospitals, Outcome)
  
  data_with <- subset(data_all, data_all[,3] != "Not Available")
  
  # by hospo name
  d <- data_with[order(data_with[,2]),]
  
  # by mortality rate
  df <- d[order(as.numeric(d[,3])),]
  
  States <- sort(unique(df[,1]))
  hospitals <- vector()
  for (state in States) {
    d <- subset(df, df[,1] == state)
    
    if (num != "best" && num != "worst" && num > nrow(d)) {
      hospName <- "<NA>"
    } else {
      if (num == "best") {
        hospName <- d[[1,2]]
      } else if (num == "worst") {
        hospName <- d[[nrow(d),2]]
      } else {
        hospName <- d[[num,2]]
      }
    }
    hospitals <- append(hospitals, hospName)
  }
  
  return(data.frame(hospital=hospitals, state=States))
}

head(rankall("heart attack", 20), 10)
# hospital                                  state
# <NA>                                      AK
# D W MCMILLAN MEMORIAL HOSPITAL            AL
# ARKANSAS METHODIST MEDICAL CENTER         AR
# AZ JOHN C LINCOLN DEER VALLEY HOSPITAL    AZ
# SHERMAN OAKS HOSPITAL                     CA
# SKY RIDGE MEDICAL CENTER                  CO
# MIDSTATE MEDICAL CENTER                   CT
# <NA>                                      DC
# <NA>                                      DE
# SOUTH FLORIDA BAPTIST HOSPITAL            FL

tail(rankall("pneumonia", "worst"), 3)
# hospital                                      state
# WI MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC    WI
# WV                     PLATEAU MEDICAL CENTER    WV
# WY           NORTH BIG HORN HOSPITAL DISTRICT    WY

tail(rankall("heart failure"), 10)
# hospital                                                            state
# WELLMONT HAWKINS COUNTY MEMORIAL HOSPITAL    TN
# FORT DUNCAN MEDICAL CENTER    TX
# UT VA SALT LAKE CITY HEALTHCARE - GEORGE E. WAHLEN VA MEDICAL CENTER    UT
# SENTARA POTOMAC HOSPITAL    VA
# GOV JUAN F LUIS HOSPITAL & MEDICAL CTR    VI
# SPRINGFIELD HOSPITAL    VT
# HARBORVIEW MEDICAL CENTER    WA
# AURORA ST LUKES MEDICAL CENTER    WI
# FAIRMONT GENERAL HOSPITAL    WV
# CHEYENNE VA MEDICAL CENTER    WY