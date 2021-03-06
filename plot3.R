## Custom function for downloading raw data and reading in a subset of *.txt file 
get.data <- function() {
  ## Checks to see if the data folder exists already
  if (!dir.exists(data.dir)) {
    download.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    zip.name <- "/power_consumption.zip"
    dir.create(data.dir)
    
    download.file(download.url, paste(data.dir, zip.name, sep = ""), method = "curl")
    unzip(paste(data.dir, zip.name, sep = ""), exdir = "./data")
  }
  
  file.path <- paste(data.dir, list.files(data.dir, pattern = "*.txt"), sep = "/")
  
  data <- read.table(file.path, header = F, sep = ";", na.strings = "?", stringsAsFactors = F, colClasses = c("character", "character", rep("numeric",7)), skip = 66637, nrows = 2880)
  headers <- read.table(file.path, header = 1, sep = ";", na.strings = "?", stringsAsFactors = F, colClasses = c("character", "character", rep("numeric",7)), nrows = 1)
  colnames(data) <- colnames(headers)
  
  data <- data[which(data$Date == "2/2/2007" | data$Date == "1/2/2007"), ]
  data$date.time <- strptime(paste(data$Date, data$Time, sep = " "), format = "%d/%m/%Y %H:%M:%S")
  
  data
  
}

## Initializing workspace
data.dir <- "./data" # Determmine where you want your data to reside
data <- get.data()

## Generating the PNG graphic
png(file = "plot3.png", height = 480, width = 480)
with(data, plot(data$date.time, data$Sub_metering_1, type = "l", pch = "", col = 1, ylab = "Energy sub metering", xlab = "", main = ""))
lines(data$date.time, data$Sub_metering_2, type = "l", pch = "", col = 2)
lines(data$date.time, data$Sub_metering_3, type = "l", pch = "", col = 4)
legend("topright", lwd = 1, legend = colnames(data[,7:9]), col = c(1,2,4))
dev.off()

# plot(data$date.time, data$Global_active_power, pch = "", type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
