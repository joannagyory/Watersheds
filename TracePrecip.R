datadirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Raw weather data/"
weatherstation <- 64773


library(readr)
library(dplyr)
library(lubridate)
library(stringr)

# Read in data file
df <- read_csv(sprintf("%s%i.csv", datadirectory, weatherstation))

# The houlry temperature columns have artificial NAs that occur once every
# 24 hours because those rows are for the daily average. They can be identified
# in the REPORTTYPE column as "SOD". They need to be excluded from the hourly data.

hourlydata <- filter(df, df$HOURLYDRYBULBTEMPC!="SOD")

# Store the station name, date, and hourly precipitation in a dataframe
df2 <- data.frame(matrix(ncol = 3, nrow = dim(hourlydata)[1]))
colnames(df2) <- (c("STATION","DATE","HOURLYPrecip"))
df2[1] <- hourlydata$STATION
df2[2] <- hourlydata$DATE
df2[3] <- hourlydata$HOURLYPrecip

# Set the date format for the date column
df2$DATE = ymd_hms(df2$DATE)

# Use rle to count how many consecutive times a value appears. We do this so we can
# identify how many consecutive hours had "T" (trace amounts) of rainfall.
a <- rle(df2$HOURLYPrecip)
# Get the first part of the list, which has the frequency
b <- a$lengths
# Get the second part of the list, which holds the values
c <- a$values
# Find the indices of values in list b that have "T"s
d <- str_which(c,"T")
# Get the frequencies for the matching indices
e<-b[d]

# Find the maximum number of consecutive times that T appears
max_e <- max(e)

# Show a histogram of the length of the "runs" of consecutive Ts
hist(e,breaks=20,main="Histogram of consecutive hourly Trace rain events",xlab="Consecutive hours of Trace rain")


# Count the NAs
nacount <- sum(is.na(df2$HOURLYPrecip))

# Count the overall Ts
tcount <- length(str_which(df2$HOURLYPrecip,"T"))


# Precipitation gets a value of "T" if it is less than 0.01 inches.
# Replace the "T"s with the value 0.005.
df2$HOURLYPrecip <- str_replace(df2$HOURLYPrecip, "T", "0.005")
# Convert from string to numeric
df2$HOURLYPrecip <- as.numeric(df2$HOURLYPrecip)


# Daily precips: Group the data by year, month, and day, and sum, ignoring NAs.
dailyprecips <- df2 %>%
  group_by(Year=year(DATE), Month=month(DATE), Day=day(DATE)) %>%
  summarise(DailySum=sum(HOURLYPrecip,na.rm = TRUE))


# Write to csv files
write.csv(dailyprecips, file = sprintf("%s%i_Daily_precips.csv", datadirectory, weatherstation))
