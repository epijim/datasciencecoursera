## Run this file from readme.rmd

## Get data - data was downloaded and formatted in 'readme.rmd'
data <- read.csv("proj1data.csv")
data$DateTime <- as.POSIXlt(data$DateTime)
## Plot it
# set png device
png(filename = "plot3.png", width = 480, height = 480, units = "px")
# plot
plot(data$DateTime, data$Sub_metering_1, 
     type="l", 
     xlab="", 
     ylab="Energy sub metering", 
     col="Black")
lines(data$DateTime, data$Sub_metering_2, 
      type="l", 
      col="Red")
lines(data$DateTime, data$Sub_metering_3, 
      type="l", 
      col="Blue")
legend("topright", 
       lty=1, lwd=1, 
       col=c("Black","Red","Blue"), 
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
# close
dev.off()