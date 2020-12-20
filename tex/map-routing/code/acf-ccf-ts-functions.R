library(tidyverse)
library(lubridate)
library(data.table)


# Load and clean data --------------------------------------

my.data <- fread('../tropical-cyclones-plus/data/hurdat2-oisst-1981-2016.csv')


my.data <- my.data %>%
	dplyr::filter(basin == "NATL") %>%
	dplyr::select(date.time, wind, sst) %>%
	mutate(date.time = ymd_hms(date.time)) %>%
	dplyr::filter(year(date.time) %in% 2013:2016)

my.data <- arrange(my.data, date.time)

# Delete duplicate rows
# my.data <- my.data[!duplicated(my.data), ]


# ACF & CDF  -----------------------------------------------

plot_acf <- function(df, col_name, years, conf.level = 0.95, max.lag = NULL, min.lag = 0) {
	# col_name <- as.name(col_name)

	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
									is.na(df[[col_name]]) != TRUE)
	x <- df[[col_name]]

	ciline <- qnorm((1 - conf.level)/2)/sqrt(length(x))
	bacf <- acf(x, plot = FALSE, lag.max = max.lag)
	bacfdf <- with(bacf, data.frame(lag, acf))
	if (min.lag > 0) {
		bacfdf <- bacfdf[-seq(1, min.lag), ]
	}
	gg <- ggplot(data=bacfdf, aes(x=lag, y=acf)) +
		geom_errorbar(aes(x=lag, ymax=acf, ymin=0), width=0) +
		geom_hline(yintercept = -ciline, color = "blue", size = 0.4, linetype="dashed") +
		geom_hline(yintercept = ciline, color = "blue", size = 0.4, linetype="dashed") +
		geom_hline(yintercept = 0) +
		labs(x = "Lag", y = "ACF")

	return(gg)
}

plot_ccf = function(df, years, conf.level = 0.95, lag.min=-100, lag.max=100) {
	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
									is.na(sst) != TRUE,
									is.na(wind) != TRUE)

	x <- df$sst
	y <- df$wind
	ccf.data = ccf(x, y, plot=F)

	indices = which(ccf.data$lag[,1,1] %in% lag.min:lag.max)
	ccf.df = data.frame(lag = ccf.data$lag[indices,1,1],
											correlation = ccf.data$acf[indices,1,1])

	ciline <- qnorm((1 - conf.level)/2)/sqrt(length(x))

	gg <- ggplot(ccf.df, aes(x = lag, y = correlation)) +
		geom_errorbar(aes(x=lag, ymax=correlation, ymin=0), width=0) +
		geom_hline(yintercept = -ciline, color = "blue", size = 0.4, linetype="dashed") +
		geom_hline(yintercept = ciline, color = "blue", size = 0.4, linetype="dashed") +
		geom_hline(yintercept = 0) +
		labs(x = "Lag", y = "CCF")

	return(gg)
}

# SST and wind time series (with averages) -----------------

plot_mean_sst_ts <- function(df, years, months = 6:10){
	df <- df %>%
		dplyr::filter(is.na(sst) != T,
									year(date.time) %in% years,
									month(date.time) %in% months) %>%
		group_by(date.time) %>%
		summarise(sst = mean(sst)) %>%
		mutate(year = as.factor(year(date.time)))

	df <- df %>%
		group_by(year) %>%
		mutate(lag = 1:length(sst))

	gg <- ggplot(df, aes(x = lag, y = sst, colour = year)) +
		geom_line() +
		# geom_point() +
		facet_grid(facets = year(date.time) ~ .) +
		labs(x = "Lag", y = "SST (deg C)")

	return(gg)
}

plot_mean_wind_ts <- function(df, years, months = 6:10){
	df <- df %>%
		dplyr::filter(is.na(wind) != T,
									year(date.time) %in% years,
									month(date.time) %in% months) %>%
		group_by(date.time) %>%
		summarise(wind = mean(wind)) %>%
		mutate(year = as.factor(year(date.time)))

	df <- df %>%
		group_by(year) %>%
		mutate(lag = 1:length(wind))

	gg <- ggplot(df, aes(x = lag, y = wind, colour = year)) +
		geom_line() +
		# geom_point() +
		facet_grid(facets = year(date.time) ~ .) +
		labs(x = "Lag", y = "Wind Speed (knot)")

	return(gg)
}


# SST and wind time series for all data --------------------

plot_sst_ts <- function(df, all = F, years, months = 6:10){
	df <- df %>%
		dplyr::filter(is.na(sst) != T,
									year(date.time) %in% years,
									month(date.time) %in% months) %>%
		mutate(year = as.factor(year(date.time)))

	df <- arrange(df, date.time)

	if (all == F){
		df <- df %>%
			group_by(year) %>%
			mutate(lag = 1:length(sst))
	} else {
		df <- df %>%
			mutate(lag = 1:length(sst))
	}

	gg <- ggplot(df, aes(x = lag, y = sst)) +
		geom_line() +
		labs(x = "Lag", y = "SST (deg C)")

	if (all == F) {
		gg <- gg +
			aes(colour = year) +
			facet_grid(facets = year(date.time) ~ .)
	}

	return(gg)
}

plot_wind_ts <- function(df, all = F, years, months = 6:10){
	df <- df %>%
		dplyr::filter(is.na(wind) != T,
									year(date.time) %in% years,
									month(date.time) %in% months) %>%
		mutate(year = as.factor(year(date.time)))

	df <- arrange(df, date.time)

	if (all == F){
		df <- df %>%
			group_by(year) %>%
			mutate(lag = 1:length(wind))
	} else {
		df <- df %>%
			mutate(lag = 1:length(wind))
	}

	gg <- ggplot(df, aes(x = lag, y = wind)) +
		geom_line() +
		labs(x = "Lag", y = "Wind Speed (knot)")

	if (all == F) {
		gg <- gg +
			aes(colour = year) +
			facet_grid(facets = year(date.time) ~ .)
	}

	return(gg)
}


# Plots ----------------------------------------------------

source('ruth/multiplot.R')
library(GGally)

ggmatrix(list(plot_acf(my.data, "sst", 2013), plot_acf(my.data, "sst", 2014),
							plot_acf(my.data, "sst", 2015), plot_acf(my.data, "sst", 2016)),
				 nrow = 4, ncol = 1,
				 yAxisLabels = c("2013", "2014", "2015", "2016"),
				 xlab = "Lag",
				 ylab = "ACF") +
	theme(strip.placement = "outside")

plot_acf(my.data, "sst", 2013:2016)

ggmatrix(list(plot_acf(my.data, "wind", 2013), plot_acf(my.data, "wind", 2014),
							plot_acf(my.data, "wind", 2015), plot_acf(my.data, "wind", 2016)),
				 nrow = 4, ncol = 1,
				 yAxisLabels = c("2013", "2014", "2015", "2016"),
				 xlab = "Lag",
				 ylab = "ACF") +
	theme(strip.placement = "outside")

plot_acf(my.data, "wind", 2013:2016)


ggmatrix(list(plot_ccf(my.data, 2013), plot_ccf(my.data, 2014),
							plot_ccf(my.data, 2015), plot_ccf(my.data, 2016)),
				 nrow = 4, ncol = 1,
				 yAxisLabels = c("2013", "2014", "2015", "2016"),
				 xlab = "Lag",
				 ylab = "CCF") +
	theme(strip.placement = "outside")

plot_ccf(my.data, 2013:2016)

# plot_mean_sst_ts(my.data, years = 2013:2016)
# plot_mean_wind_ts(my.data, years = 2013:2016)

plot_sst_ts(my.data, years = 2013:2016)

plot_sst_ts(my.data, years = 2013:2016, all = T)

plot_wind_ts(my.data, years = 2013:2016)

plot_wind_ts(my.data, years = 2013:2016, all = T)

