datadirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Raw weather data/"
weatherstation <- 64773


library(readr)
library(dplyr)
library(lubridate)

df <- read_csv(sprintf("%s%i_Daily_Temps.csv", datadirectory, weatherstation))
df2 <- read_csv(sprintf("%s%i_Daily_precips.csv", datadirectory, weatherstation))

df$Precip <- df2$DailySum
colnames(df)[5] <- 'Precip'

# Write to csv files
write.csv(df, file = sprintf("%s%i_Daily_Weather.csv", datadirectory, weatherstation), row.names = FALSE)