## Run this file from readme.rmd

## Get data - data was downloaded and formatted in 'readme.rmd'
  data <- read.csv("proj1data.csv")
  data$DateTime <- as.POSIXlt(data$DateTime)
## Plot it
  # set png device
  png(filename = "plot4.png", width = 480, height = 480, units = "px")
  # plot
  par(mfrow=c(2,2))
    # topleft
    with(data, plot(DateTime, 
                         Global_active_power, 
                         xlab="", type="l", ylab="Global Active Power"))
    # topright
    with(data, plot(DateTime,Voltage, type="l"))
    # bottom left
    with(data, plot(DateTime,Sub_metering_1, 
                      xlab="", type="l", ylab="Energy sub metering"))
    with(data,lines(DateTime,Sub_metering_2,
                         col="red"))
    with(data,lines(DateTime,Sub_metering_3,
                         col="blue"))
         legend("topright", col=c("black", "red", "blue"),
                cex=1, lwd=2,bty="n",
                #y.intersp=0.8,
                legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    # bottomright
    with(data, plot(DateTime, Global_reactive_power, type="l"))
  # close
  dev.off()
