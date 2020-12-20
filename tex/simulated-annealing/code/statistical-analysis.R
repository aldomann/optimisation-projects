library(data.table)
library(tidyverse)
library(lubridate)

my.data <- fread('C:/Users/SAMSUNG/Desktop/ASP PART2 project/hurdat2-oisst-1981-2016-asp.csv') 

my.data <- my.data %>% 
	dplyr::filter(basin == "NATL") %>% 
	dplyr::select(date.time, wind, pressure, sst) %>% 
	mutate(date.time = ymd_hms(date.time))

my.data <- arrange(my.data, date.time)

# Clean NA data
my.data <- my.data[complete.cases(my.data), ]

# Filter data for 2013-2016
my.data.all <- my.data %>% 
	dplyr::filter(year(date.time) %in% 2013:2016)

# Filter data for 2016
my.data.2016 <- my.data %>% 
	dplyr::filter(year(date.time) == 2016)

# Filter data for 2015
my.data.2015 <- my.data %>% 
	dplyr::filter(year(date.time) == 2015)

# Filter data for 2014
my.data.2014 <- my.data %>% 
	dplyr::filter(year(date.time) == 2014)

# Filter data for 2013
my.data.2013 <- my.data %>% 
	dplyr::filter(year(date.time) == 2013)

# Selecting the data from the data frame (2013-2016)
wind.all <- my.data.all$wind
sst.all <- my.data.all$sst

# Selecting the data from the data frame (2016)
wind.2016 <- my.data.2016$wind
sst.2016 <- my.data.2016$sst

# Selecting the data from the data frame (2015)
wind.2015 <- my.data.2015$wind
sst.2015 <- my.data.2015$sst

# Selecting the data from the data frame (2014)
wind.2014 <- my.data.2014$wind
sst.2014 <- my.data.2014$sst

# Selecting the data from the data frame (2013)
wind.2013 <- my.data.2013$wind
sst.2013 <- my.data.2013$sst


# Statistical Properties --------------------------------------------------

# WIND
summary(wind.all)
sd(wind.all)

summary(wind.2016)
sd(wind.2016)

summary(wind.2015)
sd(wind.2015)

summary(wind.2014)
sd(wind.2014)

summary(wind.2013)
sd(wind.2013)

#SST
summary(sst.all)
sd(sst.all)

summary(sst.2016)
sd(sst.2016)

summary(sst.2015)
sd(sst.2015)

summary(sst.2014)
sd(sst.2014)

summary(sst.2013)
sd(sst.2013)