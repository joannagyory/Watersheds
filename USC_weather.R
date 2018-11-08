library(readr)
library(dplyr)
library(lubridate)

# Read in the data file
df <- read_csv("C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Raw weather data/USC00272800.csv")

# Convert from degrees F to degrees C
df2 <- df
df2$TOBS <- (df2$TOBS - 32) * 5/9
df2$TMIN <- (df2$TMIN - 32) * 5/9
df2$TMAX <- (df2$TMAX - 32) * 5/9

# Drop unnecessary columns
df3 <- df2[ -c(1,2,5,6,7,8,9,11,13,15) ]
# Re-order columns
df3 <- df3[c(1,5,4,3,2)]

# Rename columns
colnames(df3)[1] <- 'Date'
colnames(df3)[2] <- 'MeanTemp'
colnames(df3)[3] <- 'MinTemp'
colnames(df3)[4] <- 'MaxTemp'
colnames(df3)[5] <- 'Precip'

# Write to csv
write.csv(df3, "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Raw weather data/USC00272800_Daily_Weather.csv", row.names = FALSE)