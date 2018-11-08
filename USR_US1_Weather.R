library(readr)
library(dplyr)
library(lubridate)

temps <- read_csv("C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Raw weather data/USR0000NWMT.csv")
precips <- read_csv("C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Raw weather data/US1NHCR0012.csv")



precips2 <- precips[c(3,4)]
temps2 <- temps[c(3,4,6,8)]

# Inner join on DATE
df <- merge(precips2, temps2, by='DATE')


df3 <- df[c(1,3,5,4,2)]

# Rename columns
colnames(df3)[1] <- 'Date'
colnames(df3)[2] <- 'MeanTemp'
colnames(df3)[3] <- 'MinTemp'
colnames(df3)[4] <- 'MaxTemp'
colnames(df3)[5] <- 'Precip'

write.csv(df3, "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Raw weather data/USR_US1_Daily_Weather.csv", row.names = FALSE)