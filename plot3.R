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
png(file = "plot3.png",480,480)

plot(plotData$ptime,plotData$Sub_metering_1,type="l",
     ylab="Energy sub metering",
     xlab="")
lines(plotData$ptime,plotData$Sub_metering_2,col="red")
lines(plotData$ptime,plotData$Sub_metering_3,col="blue")
legend("topright", lwd=1,col = c("black","red","blue"),
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3")) 


dev.off()
