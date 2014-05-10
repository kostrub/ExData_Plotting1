PATH <- dirname(sys.frame(1)$ofile)
setwd(PATH)
if(!file.exists("household_power_consumption.zip")){
    stop("Couldn't find household_power_consumption.zip")
}
file<-unz("household_power_consumption.zip","household_power_consumption.txt")
classes<-c(rep("character",2),rep("numeric",7))
data <- read.csv(file,sep=";",header=TRUE,colClasses=classes,na.strings="?")
data <- within(data, ptime <- paste(Date, Time, sep = ' '))
data$ptime <- strptime(data$ptime,"%d/%m/%Y %H:%M:%S")
data$Date <- as.Date(data$Date,"%d/%m/%Y") 
datesVector <- data$Date==as.Date("2007-02-01") | data$Date==as.Date("2007-02-02")
plotData<-subset(data, datesVector)

Sys.setlocale("LC_TIME", "English")
png(file = "plot4.png",480,480)
par(mfrow = c(2, 2))
# par(mar=c(2, 2, 2, 2))
plot(plotData$ptime,plotData$Global_active_power,
     ylab="Global Active Power",
     xlab="",
     type="l")

plot(plotData$ptime,plotData$Voltage,
           xlab="datetime",
           ylab="Voltage",
           type="l")

plot(plotData$ptime,plotData$Sub_metering_1,type="l",
     ylab="Energy sub metering",
     xlab="")
lines(plotData$ptime,plotData$Sub_metering_2,col="red")
lines(plotData$ptime,plotData$Sub_metering_3,col="blue")
legend("topright", bty="n",lwd=1,col = c("black","red","blue"),
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3")) 

plot(plotData$ptime,plotData$Global_reactive_power,
     xlab="datetime",
     ylab="Global_reactive_power",
     type="l")

dev.off()
