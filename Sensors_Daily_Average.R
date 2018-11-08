library(readr)
library(dplyr)
library(lubridate)

datadirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Water sensor data/"
writedirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Water sensor data/Daily Averages/"

# Read in the CommonColumns csv file
commoncolumns <- read_csv(sprintf("%sCommonColumns.csv", datadirectory), col_names = FALSE)
# Make list of common columns
comcolslist <- c(commoncolumns)

waterstation <- c('BDC', 'BEF', 'DCF', 'GOF', 'HBF', 'LMP', 'MCQ', 'SBM', 'TPB', 'WHB')

for (i in 1:10){

  data <- read_csv(sprintf("%s%s_WQual_Level4.csv", datadirectory, waterstation[i]))
  
  # Some numeric columns get read in as characters, so they have to be converted to numeric
  cols.num <- c("RECORD", "Nitrate_mg", "TempC", "Conductivity", "SpConductivity", "pH", "ODOPerCent",
                "ODOMGL", "TurbidityFNU",  "TurbidityRaw",  "FDOMRFU", "FDOMQSU", "UNH.ID..",
                "NPOC..mg.C.L.", "TDN..mg.N.L.", "Cl..mg.Cl.L.", "NO3..mg.N.L.", "SO4..mg.S.L.",
                "Abs254", "SUVA", "Na..mg.Na.L.", "K..mg.K.L.", "Mg..mg.Mg.L.", "Ca..mg.Ca.L.",
                "Closed.Cell.pH", "TSS..mg.L.", "NH4..ug.N.L.", "DON", "PO4..ug.P.L.", "Stage", 
                "Q", "NO3_corrected_mgL", "PAR", "FDOM_corrected_QSU")
  data[cols.num] <- sapply(data[cols.num],as.numeric)

  # Create new dataframe that only has the columns common to water sensors from all sites
  df <- select(data, comcolslist$X1)
  
  # Set the date format for the date column
  df$Date = ymd_hms(df$Date)

  require(tidyverse)
  df2 <-df %>% 
    group_by(Year=year(Date), Month=month(Date), Day=day(Date)) %>% 
    summarise_all(funs(mean(., na.rm=TRUE)))


  # Change date format from ymd_hms to ymd
  df2$Date <- date(df2$Date)
  
  # Put site name in Site column
  df2$Site <- waterstation[i]

  # Write to csv files
  write.csv(df2, file = sprintf("%s%s_Daily_WQual.csv", writedirectory, waterstation[i]), row.names = FALSE)
}
