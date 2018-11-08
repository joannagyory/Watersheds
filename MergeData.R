library(readr)
library(dplyr)
library(lubridate)

# Directory for water sensor data
wsdatadirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Water sensor data/Daily Averages/"
# Directory for weather station data
weatherdatadirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Daily Weather/"
# Write directory
writedirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Merged Data/Daily/"

# List of water sensor stations
waterstations <- c('BDC', 'BEF', 'DCF', 'GOF', 'HBF', 'LMP', 'MCQ', 'SBM', 'TPB', 'WHB')
# List of weather stations
weatherstations <- c('54795', 'USR_US1', 'USC00272800', '14710', '64773', '54795', '14710', 'USC00272800', '54791', '54795')

# Location of watershed physiography data
physiography <- read_csv("C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Physiography/NH Aquatic Sensors Meta Data2.csv")

# For each watershed, merge water sensor data with weather station data and physiography information
for (i in 1:10){
  
  df <- data.frame(matrix(ncol = 53, nrow = 0))
  
  water <- read_csv(sprintf("%s%s_Daily_WQual.csv", wsdatadirectory, waterstations[i]))
  weather <- read_csv(sprintf("%s%s_Daily_Weather.csv", weatherdatadirectory, waterstations[i]))
  
  # merge the dfs. Do an inner join.
  joined <- merge(water, weather, by='Date')
  
  # Add columns for physiography data
  joined$Area <- physiography$Area[i]
  joined$Dev <- physiography$Dev[i]
  joined$Ag <- physiography$Ag[i]
  joined$Forest <- physiography$Forest[i]
  joined$Channel_Slope <- physiography$Channel_Slope[i]
  joined$Stream_Order <- physiography$Stream_Order[i]
  joined$Elevation <- physiography$Elevation[i]
  joined$Lat <- physiography$Lat[i]
  joined$Long <- physiography$Long[i]
  
  a <- colnames(joined)
  colnames(df) <- a
  
  # Append to df
  df <- rbind(df, joined)

  # Write to csv
  write.csv(df, sprintf("%s%s.csv", writedirectory, waterstations[i]), row.names = FALSE)
}
