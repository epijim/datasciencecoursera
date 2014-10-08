## Run this file from readme.rmd

## Get data - data was downloaded and formatted in 'readme.rmd'
data <- read.csv("proj1data.csv")
data$DateTime <- as.POSIXlt(data$DateTime)
## Plot it
# set png device
png(filename = "plot1.png", width = 480, height = 480, units = "px")
# plot
hist(data$Global_active_power, 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", 
     col="red")
# close
dev.off()