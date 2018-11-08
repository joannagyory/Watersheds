datadirectory <- "C:/Users/Joanna/Desktop/Analytics/Fall Semester/Watershed Analytics Project/Weather Data/Raw weather data/"
weatherstation <- 64773


library(readr)
library(dplyr)
library(lubridate)

# Read in the data files
df <- read_csv(sprintf("%s%i.csv", datadirectory, weatherstation))

# The houlry temperature columns have artificial NAs that occur once every
# 24 hours because those rows are for the daily average. They can be identified
# in the REPORTTYPE column as "SOD". They need to be excluded from the hourly data.

hourlydata <- filter(df, df$HOURLYDRYBULBTEMPC!="SOD")

# Store the station name, date, and hourly dry bulb temp (C) in a dataframe
df2 <- data.frame(matrix(ncol = 3, nrow = dim(hourlydata)[1]))
colnames(df2) <- (c("STATION","DATE","HOURLYDRYBULBTEMPC"))
df2[1] <- hourlydata$STATION
df2[2] <- hourlydata$DATE
df2[3] <- hourlydata$HOURLYDRYBULBTEMPC
# Set the date format for the date column
df2$DATE = ymd_hms(df2$DATE)

# Daily mean temps: Group the data by year, month, and day, and calculate the mean, ignoring NAs.
dailymeantemps <- df2 %>% 
  group_by(Year=year(DATE), Month=month(DATE), Day=day(DATE)) %>%
  summarise(DailyMean=mean(HOURLYDRYBULBTEMPC,na.rm = TRUE))

# Daily min temps: Group the data by year, month, and day, and calculate the min, ignoring NAs.
dailymintemps <- df2 %>% 
  group_by(Year=year(DATE), Month=month(DATE), Day=day(DATE)) %>%
  summarise(DailyMin=min(HOURLYDRYBULBTEMPC,na.rm = TRUE))

# Daily max temps: Group the data by year, month, and day, and calculate the max, ignoring NAs.
dailymaxtemps <- df2 %>% 
  group_by(Year=year(DATE), Month=month(DATE), Day=day(DATE)) %>%
  summarise(DailyMax=max(HOURLYDRYBULBTEMPC,na.rm = TRUE))


dailymeantemps$DailyMin <- dailymintemps$DailyMin
dailymeantemps$DailyMax <- dailymaxtemps$DailyMax

df3 <- data.frame(matrix(ncol = 4, nrow = dim(dailymeantemps)[1]))
df3[1] <- paste(dailymeantemps$Year, dailymeantemps$Month, dailymeantemps$Day, sep="-") %>% ymd() %>% as.Date()
df3[2] <- dailymeantemps[4]
df3[3] <- dailymeantemps[5]
df3[4] <- dailymeantemps[6]

colnames(df3)[1] <- 'Date'
colnames(df3)[2] <- 'MeanTemp' 
colnames(df3)[3] <- 'MinTemp'
colnames(df3)[4] <- 'MaxTemp'

# Write to csv files
write.csv(df3, file = sprintf("%s%i_Daily_Temps.csv", datadirectory, weatherstation), row.names = FALSE)