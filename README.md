# Watersheds
An exploration of New Hampshire rivers


## Step 1: Cleaning and processing water sensor data

The main challenge here was that not all water sensors measured the same variables. I used a python script (CommonColumns.ipynb) to find the variables that were common to all water sensors. Then, I used another script (Sensors_Daily_Average.R) to subset the data from each water sensors to the common variables, then computed their daily averages.


## Step 2: Cleaning and processing weather data

USR_US1_Weather.R combines daily temperature data from NOAA station USR0000NWMT and daily precipitation data from NOAA station US1NHCR0012.

USC_Weather.R processes data from NOAA station USC00272800. It converts daily temperature from degrees F to degrees C.

TracePrecip.R computes the daily precipitation for the "WBAN" NOAA stations (54795, 64773, 14710, and 54791), which have hourly weather data. The complication with these data files is that if the amount of rain in a given hour was less than 0.01 inches, the amount of rainfall was recorded as "T", whichs stands for "trace amount". For a few time periods, there were several consecutive hours that each had a T amount of rainfall, so those could potentially add up to a substantial daily amount. This code addresses that situation.

WBAN_Daily_temps.R calculates the daily mean, min, and max temperatures for WBAN NOAA stations

WBAN_Daily_temp_precip.R combines daily temperature and precipitation data for a given WBAN NOAA station

## Step 3: Merging water sensor data, weather station data, and information on watershed physiography

MergeData.R accomplishes this task

## Step 4: Average daily data by week, month, quarter, and year

AveragedOverTimePeriods.R accomplishes this task
