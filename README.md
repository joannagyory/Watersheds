# Watersheds: An exploration of New Hampshire rivers

This repository contains code used to process and visualize data collected by sensors placed in ten New Hampshire rivers by the Watershed Informatics Pilot Research Partnership (WinPReP) team at the University of New Hampshire. As a member of this team, I plan to use the large volumes of data being collected by the high-frequency sensors to answer fundamental questions of watershed science by harnessing the power of predictive analytics and machine learning. 

## Step 1: Cleaning and processing water sensor data

The main challenge here was that not all water sensors measured the same variables. I used a python script (CommonColumns.ipynb) to find the variables that were common to all water sensors. Then, I used another script (Sensors_Daily_Average.R) to subset the data from each water sensors to the common variables, then computed their daily averages.


## Step 2: Cleaning and processing weather data

I searched through the National Oceanic and Atmospheric Administration's website to find the weather stations that were closest to the water sensors and that had data collection ranges that overlapped with those of the water sensors. Some stations had hourly records, other had daily records. Some measured both temperature and precipitation, while others measured only one of those variables. A substantial amount of work went into cleaning, oganizing, and merging all the data.

USR_US1_Weather.R combines daily temperature data from NOAA station USR0000NWMT and daily precipitation data from NOAA station US1NHCR0012.

USC_Weather.R processes data from NOAA station USC00272800. It converts daily temperature from degrees F to degrees C.

TracePrecip.R computes the daily precipitation for the "WBAN" NOAA stations (54795, 64773, 14710, and 54791), which have hourly weather data. The complication with these data files is that if the amount of rain in a given hour was less than 0.01 inches, the amount of rainfall was recorded as "T", whichs stands for "trace amount". For a few time periods, there were several consecutive hours that each had a T amount of rainfall, so those could potentially add up to a substantial daily amount. This code addresses that situation.

WBAN_Daily_temps.R calculates the daily mean, min, and max temperatures for WBAN NOAA stations

WBAN_Daily_temp_precip.R combines daily temperature and precipitation data for a given WBAN NOAA station

## Step 3: Merging water sensor data, weather station data, and information on watershed physiography

When the three types of information were finalized for each water sensor sampling station, they were merged.

MergeData.R accomplishes this task.

## Step 4: Average daily data by week, month, quarter, and year, and concatenate files for all stations

AveragedOverTimePeriods.R averages the data by the different time periods

ConcatFiles concatenates data from all stations for a given timestep (daily, weekly, etc.)

## Step 5: Build a Shiny app to visualize some of the data

ShinyRiverApp.R builds a Shiny app that displays a time series of air and water temperature at each site. The user can specify the date range of interest. It also displays a map with circles whose radii are proportional to the water flow during each week of the year 2015.

## Step 6: Explore the ability of XGBoost to predict different water flow and chemistry parameters at different time scales

XGBoost will not take into account any latency in the data. In fact, it will not consider time or sequences at all. Therefore, it is not likely to be the optimal method for forecasting from time series data. However, it will provide a useful comparison with methods that do incorporate sequential information.
