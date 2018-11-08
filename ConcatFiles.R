library(readr)
library(dplyr)
library(lubridate)

# Specify data and write directories
datadirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Merged Data/"
writedirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Merged Data/"

# For Daily, Monthly, and Yearly data, concat data from all stations
folders <- c("Daily/", "Monthly/", "Yearly/")

for(n in 1:3){
  waterstations <- c('BDC', 'BEF', 'DCF', 'GOF', 'HBF', 'LMP', 'MCQ', 'SBM', 'TPB', 'WHB')
  
  df2 <- data.frame(matrix(ncol = 53, nrow = 0))
  
  for (i in 1:10)
  {
    df <- read_csv(sprintf("%s%s%s.csv", datadirectory, folders[n], waterstations[i]))
    
    df2 <- rbind(df2, df)
    
    
    
  }
  # Write to csv
  write.csv(df2, sprintf("%s%sConcatenated.csv", writedirectory,folders[n]), row.names = FALSE)
}


# Quarterly and Weekly data have an extra column as a result of the groupby.
# Run the code below to concatenate files for them.
folders <- c("Quarterly/", "Weekly/")

for(n in 1:2){
  waterstations <- c('BDC', 'BEF', 'DCF', 'GOF', 'HBF', 'LMP', 'MCQ', 'SBM', 'TPB', 'WHB')
  
  df2 <- data.frame(matrix(ncol = 54, nrow = 0))
  
  for (i in 1:10)
  {
    df <- read_csv(sprintf("%s%s%s.csv", datadirectory, folders[n], waterstations[i]))
    
    df2 <- rbind(df2, df)
    
    
    
  }
  # Write to csv
  write.csv(df2, sprintf("%s%sConcatenated.csv", writedirectory,folders[n]), row.names = FALSE)
}

