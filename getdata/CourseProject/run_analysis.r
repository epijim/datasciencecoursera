################################
### Instructions for project ###
################################
# You should create one R script called run_analysis.R that does the following. 
#
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement.
#   3. Uses descriptive activity names to name the activities in the data set.
#   4. Appropriately labels the data set with descriptive activity names.
#   5. Creates a second, independent tidy data set with the average of each variable 
#       for each activity and each subject. 

# This file should be called from the "Codebook.Rmd" file.
  
# Setup
  
  # Get the required packages
  packages <- c("data.table", "reshape2")
  sapply(packages, require, 
         character.only=TRUE, quietly=TRUE)

  # Set where we are (the codebook rmd sets wd)
    path <- getwd()
    path
  pathIn <- file.path(path, "UCI HAR Dataset")
    list.files(pathIn, recursive=TRUE)

# Pick up data

  # Function to read then datatable
  fileToDataTable <- function (f) {
    df <- read.table(f)
    dt <- data.table(df)
  }

  # Read the subject files
  dtSubjectTrain <- fileToDataTable(file.path(pathIn, "train", "subject_train.txt"))
  dtSubjectTest  <- fileToDataTable(file.path(pathIn, "test" , "subject_test.txt" ))

  # Read the activity files
  dtActivityTrain <- fileToDataTable(file.path(pathIn, "train", "Y_train.txt"))
  dtActivityTest  <- fileToDataTable(file.path(pathIn, "test" , "Y_test.txt" ))

  # Read the data files
  dtTrain <- fileToDataTable(file.path(pathIn, "train", "X_train.txt"))
  dtTest  <- fileToDataTable(file.path(pathIn, "test" , "X_test.txt" ))


# Merge the training and the test sets

 # Concatenate the data tables
  dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
  setnames(dtSubject, "V1", "subject")
  dtActivity <- rbind(dtActivityTrain, dtActivityTest)
  setnames(dtActivity, "V1", "activityNum")
  dt <- rbind(dtTrain, dtTest)

  # Merge columns
  dtSubject <- cbind(dtSubject, dtActivity)
  dt <- cbind(dtSubject, dt)

  # Set key
  setkey(dt, subject, activityNum)

# Extract only the mu and sd
  
  # What variable is what?
  dtFeatures <- fread(file.path(pathIn, "features.txt"))
  setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))

  # Take jus mu and sd
  dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]

  # Vector of column names
  dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]

  # Subset using these names
  select <- c(key(dt), dtFeatures$featureCode)
  dt <- dt[, select, with=FALSE]

# Use descriptive activity names
  
  # Read `activity_labels.txt` file
  dtActivityNames <- fileToDataTable(file.path(pathIn, "activity_labels.txt"))
  setnames(dtActivityNames, names(dtActivityNames), c("activityNum", "activityName"))

# Label with descriptive activity names
  
  # Merge activity labels.
  dt <- merge(dt, dtActivityNames, by="activityNum", all.x=TRUE)

  # Add `activityName` as a key.
  setkey(dt, subject, activityNum, activityName)

  # Melt the data table to reshape it from a short and wide format to a tall and narrow format.
  dt <- data.table(melt(dt, key(dt), 
                        variable.name="featureCode"))

# Merge activity names
  dt <- merge(dt, dtFeatures[, list(featureNum, 
                                    featureCode, 
                                    featureName)], 
              by="featureCode", all.x=TRUE)

  # Gen new variables that take factor names
  dt$activity <- factor(dt$activityName)
  dt$feature <- factor(dt$featureName)

  # Seperate features from `featureName` using the helper function `grepthis`.
  grepthis <- function (regex) {
    grepl(regex, dt$feature)
  }
  # Features with 2 categories
  n <- 2
  y <- matrix(seq(1, n), nrow=n)
  x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol=nrow(y))
  dt$varDomain <- factor(x %*% y, labels=c("Time", "Freq"))
  x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol=nrow(y))
  dt$varInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
  x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol=nrow(y))
  dt$varAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))
  x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol=nrow(y))
  dt$varVariable <- factor(x %*% y, labels=c("Mean", "SD"))
  ## Features with 1 category
  dt$varJerk <- factor(grepthis("Jerk"), labels=c(NA, "Jerk"))
  dt$varMagnitude <- factor(grepthis("Mag"), labels=c(NA, "Magnitude"))
  ## Features with 3 categories
  n <- 3
  y <- matrix(seq(1, n), nrow=n)
  x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol=nrow(y))
  dt$varAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))


# Check to make sure all possible combinations of `feature` are accounted for by all 
#   possible combinations of the factor class variables.
  r1 <- nrow(dt[, .N, by=c("feature")])
  r2 <- nrow(dt[, .N, by=c("varDomain", "varAcceleration", "varInstrument", "varJerk", 
                           "varMagnitude", "varVariable", "varAxis")])
  r1 == r2

# Create a tidy data set
  # Create a data set with the average of each variable for each activity and each subject.
  setkey(dt, 
         subject, activity, varDomain, varAcceleration, varInstrument, varJerk, 
         varMagnitude, varVariable, varAxis)
  dtTidy <- dt[, list(count = .N, average = mean(value)), by=key(dt)]
  f <- file.path(path, "HARUS_tidydata.txt")
  write.table(dtTidy, f, quote=FALSE, sep="\t", row.names=FALSE)


