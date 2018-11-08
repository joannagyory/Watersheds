library(readr)
library(dplyr)
library(lubriDate)

# Specify data directory
datadirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Merged Data/Daily/"

# Specify write-to directories
weeklydirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Merged Data/Weekly/"
monthlydirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Merged Data/Monthly/"
quarterlydirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Merged Data/Quarterly/"
annualdirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Merged Data/Yearly/"

# List of water stations
waterstation <- c('BDC', 'BEF', 'DCF', 'GOF', 'HBF', 'LMP', 'MCQ', 'SBM', 'TPB', 'WHB')

# For each water station, calculate weekly, monthly, quarterly, and annual averages
for (i in 1:10){
  
  data <- read_csv(sprintf("%s%s.csv", datadirectory, waterstation[i]))

  # Weekly averages: Group the data by year and week and calculate the mean, ignoring NAs.
  weekly <- data %>% 
    group_by(Year=year(Date), Week=week(Date)) %>%
    summarise_all(funs(mean(., na.rm=TRUE)))
  weekly$Site <- waterstation[i]
  
  # Monthly averages: Group by year and month
  monthly <- data %>% 
    group_by(Year=year(Date), Month=month(Date)) %>%
    summarise_all(funs(mean(., na.rm=TRUE)))
  monthly$Site <- waterstation[i]
  
  # Quarterly averages: Group by quarters
  quarterly <- data %>% 
    group_by(Year=year(Date), Quarter=quarter(Date)) %>%
    summarise_all(funs(mean(., na.rm=TRUE)))
  quarterly$Site <- waterstation[i]
  
  # Annual averages: Group by years
  annual <- data %>% 
    group_by(Year=year(Date)) %>%
    summarise_all(funs(mean(., na.rm=TRUE)))
  annual$Site <- waterstation[i]
  
  # Write to csv files
  write.csv(weekly, file = sprintf("%s%s.csv", weeklydirectory, waterstation[i]), row.names = FALSE)
  write.csv(monthly, file = sprintf("%s%s.csv", monthlydirectory, waterstation[i]), row.names = FALSE)
  write.csv(quarterly, file = sprintf("%s%s.csv", quarterlydirectory, waterstation[i]), row.names = FALSE)
  write.csv(annual, file = sprintf("%s%s.csv", annualdirectory, waterstation[i]), row.names = FALSE)
  
  
}
