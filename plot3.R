library(dplyr)
#use only two dates from the whole dataset
#this time instead of filtering I will use the skip parameter of read.table
#2 days are 2*24*60 = 2880 minutes, exclude the last, which is 00:00:00 2007/02/03
#so 2879 are left for further plotting

power <- read.table('household_power_consumption.txt', sep = ';', 
                    skip = grep('1/2/2007', readLines('household_power_consumption.txt')),
                    nrows = 2*24*60 - 1)
#read.table crashes the columns names, give them back
colnames(power) <- c('Date', 'Time', 'Global_active_power', 'Global_reactive_power', 
                     'Voltage', 'Global_intensity', 'Sub_metering_1', 'Sub_metering_2', 
                     'Sub_metering_3')

#convert dates and times
power$Date <- as.Date(power$Date, format = '%d/%m/%Y')
power$Time <- format(strptime(power$Time, '%T'), '%T')

#full datetime column
power$DateTime <- as.POSIXct(paste(power$Date, power$Time), format="%Y-%m-%d %H:%M:%S")

#plot
#this part causes problems with legend position, so I use png() instead of dev.copy()
png(filename = 'plot3.png', width = 480, height = 480)
plot(power$DateTime, power$Sub_metering_1, type = 'n',
     xlab = '', ylab = 'Energy sub metering')
lines(power$DateTime, power$Sub_metering_1, pch = '.', lty = 1)
lines(power$DateTime, power$Sub_metering_2, pch = '.', lty = 1, col = 'red')
lines(power$DateTime, power$Sub_metering_3, pch = '.', lty = 1, col = 'blue')
legend('topright', inset = 0, col = c('black', 'red', 'blue'), 
       legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       lty = 1)

#dev.copy(png, 'plot3.png')
dev.off()