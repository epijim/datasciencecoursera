# Codebook
James Black  
21 September 2014  

Codebook was generated on 2014-09-21 17:13:43 during the same process that generated the dataset. See `run_analysis.r`.

# Source

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. 
Smartlab - Non Linear Complex Systems Laboratory 
DITEN - UniversitÃ  degli Studi di Genova, Genoa I-16145, Italy. 
activityrecognition '@' smartlab.ws 
www.smartlab.ws 

# About the contents of the repo

The Codebook rmd is an r markdown file that explains the data, and **from that markdown file the analysis script is called**. The data is also contained in this repo. 

The script merges the training and test datasets, and outputs a tidy dataset which has an observation for sd, average for every combination of features.

**This Readme is derived from Codebook.Rmd.**

# Methods for collection

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

# Attribute Information

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

#Citation Request:

> Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

# Variable list and descriptions

Variable name    | Description
-----------------|------------
subject          | An identifier of the subject who carried out the experiment
activity         | Activity label
varDomain        | Time or domain signal
varInstrument    | Accelerometer or Gyroscope
varAcceleration  | Body or Gravity
varVariable      | Mean or SD
varJerk          | Jerk signal
varMagnitude     | Magnitude of the signals calculated using the Euclidean norm
varAxis          | 3-axial signals in the X, Y and Z directions (X, Y, or Z)
varCount         | Number of datapoints in the average
varAverage       | The computed variable

# The set up script


```r
  setwd("~/datasciencecoursera/getdata/CourseProject")
  
  source("run_analysis.r", echo=T)
```

```
## 
## > packages <- c("data.table", "reshape2")
## 
## > sapply(packages, require, character.only = TRUE, quietly = TRUE)
## data.table   reshape2 
##       TRUE       TRUE 
## 
## > path <- getwd()
## 
## > path
## [1] "/Users/Jimmy/datasciencecoursera/getdata/CourseProject"
## 
## > pathIn <- file.path(path, "UCI HAR Dataset")
## 
## > list.files(pathIn, recursive = TRUE)
##  [1] "activity_labels.txt"                         
##  [2] "features_info.txt"                           
##  [3] "features.txt"                                
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"                           
## 
## > fileToDataTable <- function(f) {
## +     df <- read.table(f)
## +     dt <- data.table(df)
## + }
## 
## > dtSubjectTrain <- fileToDataTable(file.path(pathIn, 
## +     "train", "subject_train.txt"))
## 
## > dtSubjectTest <- fileToDataTable(file.path(pathIn, 
## +     "test", "subject_test.txt"))
## 
## > dtActivityTrain <- fileToDataTable(file.path(pathIn, 
## +     "train", "Y_train.txt"))
## 
## > dtActivityTest <- fileToDataTable(file.path(pathIn, 
## +     "test", "Y_test.txt"))
## 
## > dtTrain <- fileToDataTable(file.path(pathIn, "train", 
## +     "X_train.txt"))
## 
## > dtTest <- fileToDataTable(file.path(pathIn, "test", 
## +     "X_test.txt"))
## 
## > dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
## 
## > setnames(dtSubject, "V1", "subject")
## 
## > dtActivity <- rbind(dtActivityTrain, dtActivityTest)
## 
## > setnames(dtActivity, "V1", "activityNum")
## 
## > dt <- rbind(dtTrain, dtTest)
## 
## > dtSubject <- cbind(dtSubject, dtActivity)
## 
## > dt <- cbind(dtSubject, dt)
## 
## > setkey(dt, subject, activityNum)
## 
## > dtFeatures <- fread(file.path(pathIn, "features.txt"))
## 
## > setnames(dtFeatures, names(dtFeatures), c("featureNum", 
## +     "featureName"))
## 
## > dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", 
## +     featureName)]
## 
## > dtFeatures$featureCode <- dtFeatures[, paste0("V", 
## +     featureNum)]
## 
## > select <- c(key(dt), dtFeatures$featureCode)
## 
## > dt <- dt[, select, with = FALSE]
## 
## > dtActivityNames <- fileToDataTable(file.path(pathIn, 
## +     "activity_labels.txt"))
## 
## > setnames(dtActivityNames, names(dtActivityNames), 
## +     c("activityNum", "activityName"))
## 
## > dt <- merge(dt, dtActivityNames, by = "activityNum", 
## +     all.x = TRUE)
## 
## > setkey(dt, subject, activityNum, activityName)
## 
## > dt <- data.table(melt(dt, key(dt), variable.name = "featureCode"))
## 
## > dt <- merge(dt, dtFeatures[, list(featureNum, featureCode, 
## +     featureName)], by = "featureCode", all.x = TRUE)
## 
## > dt$activity <- factor(dt$activityName)
## 
## > dt$feature <- factor(dt$featureName)
## 
## > grepthis <- function(regex) {
## +     grepl(regex, dt$feature)
## + }
## 
## > n <- 2
## 
## > y <- matrix(seq(1, n), nrow = n)
## 
## > x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol = nrow(y))
## 
## > dt$varDomain <- factor(x %*% y, labels = c("Time", 
## +     "Freq"))
## 
## > x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), 
## +     ncol = nrow(y))
## 
## > dt$varInstrument <- factor(x %*% y, labels = c("Accelerometer", 
## +     "Gyroscope"))
## 
## > x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), 
## +     ncol = nrow(y))
## 
## > dt$varAcceleration <- factor(x %*% y, labels = c(NA, 
## +     "Body", "Gravity"))
## 
## > x <- matrix(c(grepthis("mean()"), grepthis("std()")), 
## +     ncol = nrow(y))
## 
## > dt$varVariable <- factor(x %*% y, labels = c("Mean", 
## +     "SD"))
## 
## > dt$varJerk <- factor(grepthis("Jerk"), labels = c(NA, 
## +     "Jerk"))
## 
## > dt$varMagnitude <- factor(grepthis("Mag"), labels = c(NA, 
## +     "Magnitude"))
## 
## > n <- 3
## 
## > y <- matrix(seq(1, n), nrow = n)
## 
## > x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), 
## +     ncol = nrow(y))
## 
## > dt$varAxis <- factor(x %*% y, labels = c(NA, "X", 
## +     "Y", "Z"))
## 
## > r1 <- nrow(dt[, .N, by = c("feature")])
## 
## > r2 <- nrow(dt[, .N, by = c("varDomain", "varAcceleration", 
## +     "varInstrument", "varJerk", "varMagnitude", "varVariable", 
## +     "varAxis")])
## 
## > r1 == r2
## [1] TRUE
## 
## > setkey(dt, subject, activity, varDomain, varAcceleration, 
## +     varInstrument, varJerk, varMagnitude, varVariable, varAxis)
## 
## > dtTidy <- dt[, list(count = .N, average = mean(value)), 
## +     by = key(dt)]
## 
## > f <- file.path(path, "HARUS_tidydata.txt")
## 
## > write.table(dtTidy, f, quote = FALSE, sep = "\t", 
## +     row.names = FALSE)
```

# Dataset structure


```r
str(dtTidy)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject        : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity       : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ varDomain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
##  $ varAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ varInstrument  : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ varJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
##  $ varMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
##  $ varVariable    : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
##  $ varAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
##  $ count          : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average        : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
##  - attr(*, "sorted")= chr  "subject" "activity" "varDomain" "varAcceleration" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

# Several rows


```r
head(dtTidy)
```

```
##    subject activity varDomain varAcceleration varInstrument varJerk
## 1:       1   LAYING      Time              NA     Gyroscope      NA
## 2:       1   LAYING      Time              NA     Gyroscope      NA
## 3:       1   LAYING      Time              NA     Gyroscope      NA
## 4:       1   LAYING      Time              NA     Gyroscope      NA
## 5:       1   LAYING      Time              NA     Gyroscope      NA
## 6:       1   LAYING      Time              NA     Gyroscope      NA
##    varMagnitude varVariable varAxis count  average
## 1:           NA        Mean       X    50 -0.01655
## 2:           NA        Mean       Y    50 -0.06449
## 3:           NA        Mean       Z    50  0.14869
## 4:           NA          SD       X    50 -0.87354
## 5:           NA          SD       Y    50 -0.95109
## 6:           NA          SD       Z    50 -0.90828
```

# Summary of the variables


```r
summary(dtTidy)
```

```
##     subject                   activity    varDomain   varAcceleration
##  Min.   : 1.0   LAYING            :1980   Time:7200   NA     :4680   
##  1st Qu.: 8.0   SITTING           :1980   Freq:4680   Body   :5760   
##  Median :15.5   STANDING          :1980               Gravity:1440   
##  Mean   :15.5   WALKING           :1980                              
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                              
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                              
##        varInstrument  varJerk        varMagnitude  varVariable varAxis  
##  Accelerometer:7200   NA  :7200   NA       :8640   Mean:5940   NA:3240  
##  Gyroscope    :4680   Jerk:4680   Magnitude:3240   SD  :5940   X :2880  
##                                                                Y :2880  
##                                                                Z :2880  
##                                                                         
##                                                                         
##      count         average       
##  Min.   :36.0   Min.   :-0.9977  
##  1st Qu.:49.0   1st Qu.:-0.9621  
##  Median :54.5   Median :-0.4699  
##  Mean   :57.2   Mean   :-0.4844  
##  3rd Qu.:63.2   3rd Qu.:-0.0784  
##  Max.   :95.0   Max.   : 0.9745
```


