#R Script file to create plot 2
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

#Plot 2, Line chart of Global Active Power vs. time

#create png for plot 2
png(file="plot2.png",width=400,height=400,res=72)
plot(powerconsumption$DateTime, powerconsumption$Global_active_power, type = "l",  col = "black", xlab = "", ylab = "Global Active Power (kilowatts)")
#close the png device
dev.off()




