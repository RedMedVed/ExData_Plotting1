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

#plot
hist(power$Global_active_power, col = 'red', 
     main = 'Global Active Power', xlab = 'Global Active Power (kilowatts)')

dev.copy(png, 'plot1.png')
dev.off()