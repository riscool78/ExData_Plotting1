#R Script file to create plot 4
library(lubridate)

#Download the data
if (!(file.exists("DataFiles")))
{ dir.create("DataFiles")}

if (!(file.exists("DataFiles/household_power_consumption.zip")))
{ download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile ="DataFiles/household_power_consumption.zip", method="curl")}

if (!(file.exists("DataFiles/household_power_consumption")))
{unzip("DataFiles/household_power_consumption.zip",exdir="DataFiles")}

#Read File (browsed file in a txt viewer to determine applicable rows for Feb 1-2, 2007)
powerconsumption <- read.table("./DataFiles/household_power_consumption.txt", header = TRUE ,sep = ";", skip = 66636, nrows = 69517-66638, na.strings = "?")

#Read in header names
headers <- read.table("./DataFiles/household_power_consumption.txt", header = TRUE ,sep = ";", nrows = 1, na.strings = "?")

#properly name columns
names(powerconsumption) <- names(headers)

#Combine date and time column into a date/time object (POSIXlt)
DateTime <- with(powerconsumption, paste(Date, Time))
DateTime <- strptime(DateTime, "%d/%m/%Y %H:%M:%OS")

#bind DateTime column and remove the individual date and time columns
powerconsumption <- cbind(DateTime, powerconsumption[, 3:9])

#create png for plot 4
png(file="plot4.png",width=400,height=400,res=72)

#set 2x2 Grid
par(mfcol = c(2, 2))

with(powerconsumption, {
  #UpperLeft Plot
  plot(DateTime, Global_active_power, type = "l",  col = "black", xlab = "", ylab = "Global Active Power")
  
  #LowerLeft Plot
  plot(DateTime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
  # Draw lines for each sub meter
  lines(DateTime, Sub_metering_1, col = "black")
  lines(DateTime, Sub_metering_2, col = "red")
  lines(DateTime, Sub_metering_3, col = "blue")
  legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
         col=c("black", "red", "blue"), lty=1, cex=0.8, bty = "n")
  
  #UpperRight Plot
  plot(DateTime, Voltage, type = "l",  col = "black", ylab = "Voltage")
  
  #LowerRight Plot
  plot(DateTime, Global_reactive_power, type = "l",  col = "black")}
  
)

#close the png device
dev.off()