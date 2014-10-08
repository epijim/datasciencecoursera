## Run this file from readme.rmd

## Get data - data was downloaded and formatted in 'readme.rmd'
data <- read.csv("proj1data.csv")
data$DateTime <- as.POSIXlt(data$DateTime)
## Plot it
# set png device
png(filename = "plot2.png", width = 480, height = 480, units = "px")
# plot
plot(data$DateTime, data$Global_active_power, 
     type="l",
     xlab="", 
     ylab="Global Active Power (kilowatts)") 
# close
dev.off()