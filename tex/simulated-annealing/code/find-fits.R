library(tidyverse)
library(lubridate)
library(data.table)
library(MASS)
library(stabledist)

my.data <- fread('../tropical-cyclones-plus/data/hurdat2-oisst-1981-2016.csv')

my.data <- my.data %>%
	dplyr::filter(basin == "NATL")


# Test functions -------------------------------------------

plot_weibull <- function(df, years) {
	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
					 is.na(wind) != TRUE)

	fit.params <- fitdistr(df$wind, 'weibull')

	gg <- ggplot(df, aes(x = wind)) +
		geom_histogram(aes(y = ..density..), binwidth = 5, fill = "white", colour = "black") +
		geom_line(aes(x = wind , y = dweibull(wind, scale=fit.params$estimate["scale"], shape=fit.params$estimate["shape"])))

	return(gg)
}

plot_gamma <- function(df, years) {
	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
					 is.na(wind) != TRUE)

	fit.params <- fitdistr(df$wind, 'gamma')

	gg <- ggplot(df, aes(x = wind)) +
		geom_histogram(aes(y = ..density..), binwidth = 5, fill = "white", colour = "black") +
		geom_line(aes(x = wind , y = dgamma(wind, shape=fit.params$estimate["shape"], rate=fit.params$estimate["rate"])))

	return(gg)
}

plot_lognorm <- function(df, years) {
	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
					 is.na(wind) != TRUE)

	fit.params <- fitdistr(df$wind, 'log-normal')

	gg <- ggplot(df, aes(x = wind)) +
		geom_histogram(aes(y = ..density..), binwidth = 5, fill = "white", colour = "black") +
		geom_line(aes(x = wind , y = dlnorm(wind, meanlog=fit.params$estimate["meanlog"], sdlog=fit.params$estimate["sdlog"])))

	return(gg)
}

# plot_weibull(my.data, 2000:2016)
# plot_gamma(my.data, 2000:2016)
# plot_lognorm(my.data, 2000:2016)

# Find best fit --------------------------------------------

plot_wind_fits <- function(df, years) {
	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
					 is.na(wind) != TRUE)

	fit.wei <- fitdistr(df$wind, 'weibull')
	fit.gamma <- fitdistr(df$wind, 'gamma')
	fit.lnorm <- fitdistr(df$wind, 'log-normal')

	gg <- ggplot(df, aes(x = wind)) +
		geom_histogram(aes(y = ..density..), binwidth = 5, fill = "white", colour = "black") +
		geom_line(aes(x = wind , y = dweibull(wind, scale=fit.wei$estimate["scale"], shape=fit.wei$estimate["shape"]), colour = "weibull")) +
		geom_line(aes(x = wind , y = dgamma(wind, shape=fit.gamma$estimate["shape"], rate=fit.gamma$estimate["rate"]), colour = "gamma")) +
		geom_line(aes(x = wind , y = dlnorm(wind, meanlog=fit.lnorm$estimate["meanlog"], sdlog=fit.lnorm$estimate["sdlog"]), colour = "log-norm")) +
		labs(x = "Wind Speed (knot)", y = "Density", colour = "Fit Model")

	print(fit.wei)
	print(fit.gamma)
	print(fit.lnorm)

	return(gg)
}

plot_sst_fits <- function(df, years) {
	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
									is.na(sst) != TRUE)

	fit.wei <- fitdistr(df$sst, 'weibull')
	fit.gamma <- fitdistr(df$sst, 'gamma')
	fit.lnorm <- fitdistr(df$sst, 'log-normal')

	gg <- ggplot(df, aes(x = sst)) +
		geom_histogram(aes(y = ..density..), binwidth = 0.5, fill = "white", colour = "black") +
		geom_line(aes(x = sst , y = dweibull(sst, scale=fit.wei$estimate["scale"], shape=fit.wei$estimate["shape"]), colour = "weibull")) +
		geom_line(aes(x = sst , y = dgamma(sst, shape=fit.gamma$estimate["shape"], rate=fit.gamma$estimate["rate"]), colour = "gamma")) +
		geom_line(aes(x = sst , y = dlnorm(sst, meanlog=fit.lnorm$estimate["meanlog"], sdlog=fit.lnorm$estimate["sdlog"]), colour = "log-norm")) +
		labs(x = "SST (deg C)", y = "Density", colour = "Fit Model")

	print(fit.wei)
	print(fit.gamma)
	print(fit.lnorm)

	return(gg)
}


# Plots ----------------------------------------------------

source('ruth/multiplot.R')
library(GGally)

plot_wind_fits(my.data, 2013:2016) +
	facet_wrap(facets = ~ year(date.time), nrow = 2)

plot_wind_fits(my.data, 2013:2016)

plot_sst_fits(my.data, 2013:2016) +
	facet_wrap(facets = ~ year(date.time), nrow = 2)

plot_sst_fits(my.data, 2013:2016)


# Find best fit (including Stable Distribution) ------------

plot_wind_fits_alt <- function(df, years) {
	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
									is.na(wind) != TRUE)

	fit.wei <- fitdistr(df$wind, 'weibull')
	fit.gamma <- fitdistr(df$wind, 'gamma')
	fit.lnorm <- fitdistr(df$wind, 'log-normal')

	stable.df <- data.frame()

	gg <- ggplot(df, aes(x = wind)) +
		geom_histogram(aes(y = ..density..), binwidth = 5, fill = "white", colour = "black") +
		geom_line(aes(x = wind , y = dweibull(wind, scale=fit.wei$estimate["scale"], shape=fit.wei$estimate["shape"]), colour = "weibull")) +
		geom_line(aes(x = wind , y = dgamma(wind, shape=fit.gamma$estimate["shape"], rate=fit.gamma$estimate["rate"]), colour = "gamma")) +
		geom_line(aes(x = wind , y = dlnorm(wind, meanlog=fit.lnorm$estimate["meanlog"], sdlog=fit.lnorm$estimate["sdlog"]), colour = "log-norm")) +
		geom_line(aes(x = wind , y = dstable(wind, alpha = 1.25654, beta  = 1, gamma = 9.01023, delta = 34.7015), colour = "stable")) +
		# geom_line(aes(x = wind , y = dstable(wind, alpha = 1.54546, beta  = 1, gamma = 6.44239, delta = 33.9795), colour = "stable")) +
		# geom_line(aes(x = wind , y = dstable(wind, alpha = 1.20208, beta  = 1, gamma = 11.0818, delta = 37.3789), colour = "stable")) +
		# geom_line(aes(x = wind , y = dstable(wind, alpha =  1.2353, beta  = 1, gamma = 8.29162, delta = 33.5942), colour = "stable")) +
		# geom_line(aes(x = wind , y = dstable(wind, alpha = 1.22843, beta  = 1, gamma = 10.2862, delta = 37.7231), colour = "stable")) +
		labs(x = "Wind Speed (knot)", y = "Density", colour = "Fit Model")

	return(gg)
}

plot_sst_fits_alt <- function(df, years) {
	df <- df %>%
		dplyr::filter(year(date.time) %in% years,
									is.na(sst) != TRUE)

	fit.wei <- fitdistr(df$sst, 'weibull')
	fit.gamma <- fitdistr(df$sst, 'gamma')
	fit.lnorm <- fitdistr(df$sst, 'log-normal')

	stable.df <- data.frame()

	gg <- ggplot(df, aes(x = sst)) +
		geom_histogram(aes(y = ..density..), binwidth = 0.5, fill = "white", colour = "black") +
		geom_line(aes(x = sst , y = dweibull(sst, scale=fit.wei$estimate["scale"], shape=fit.wei$estimate["shape"]), colour = "weibull")) +
		geom_line(aes(x = sst , y = dgamma(sst, shape=fit.gamma$estimate["shape"], rate=fit.gamma$estimate["rate"]), colour = "gamma")) +
		geom_line(aes(x = sst , y = dlnorm(sst, meanlog=fit.lnorm$estimate["meanlog"], sdlog=fit.lnorm$estimate["sdlog"]), colour = "log-norm")) +
		# geom_line(aes(x = sst , y = dstable(sst, alpha = 1.10157, beta = -1        , gamma = 0.988021, delta = 28.0162), colour = "stable")) +
		geom_line(aes(x = sst , y = dstable(sst, alpha = 1.14585, beta = -1        , gamma = 0.88159 , delta = 27.9295), colour = "stable")) +
		# geom_line(aes(x = sst , y = dstable(sst, alpha = 0.778839, beta = -0.883931, gamma = 0.782382, delta = 28.1982), colour = "stable")) +
		# geom_line(aes(x = sst , y = dstable(sst, alpha = 1.12735 , beta = -1       , gamma = 0.872435, delta = 27.978), colour = "stable")) +
		# geom_line(aes(x = sst , y = dstable(sst, alpha = 1.14306, beta = -1        , gamma = 1.07727,  delta = 28.021), colour = "stable")) +
		labs(x = "SST (deg C)", y = "Density", colour = "Fit Model")

	return(gg)
}


# Plots ----------------------------------------------------

# Each year
plot_wind_fits_alt(my.data, 2013:2016) +
	facet_wrap(facets = ~ year(date.time), nrow = 2) +

# All years
plot_wind_fits_alt(my.data, 2013:2016) +

# Each year
plot_sst_fits_alt(my.data, 2013:2016) +
	facet_wrap(facets = ~ year(date.time), nrow = 2) +

# All years
plot_sst_fits_alt(my.data, 2013:2016) +

stable.wind.df <- data.frame(year = c("all", 2013:2016),
														 alpha = c(1.25654, 1.54546, 1.20208, 1.2353, 1.22843),
														 beta =  c(1, 1, 1, 1, 1),
														 gamma = c(9.01023, 6.44239, 11.0818, 8.29162, 10.2862),
														 delta = c(34.7015, 33.9795, 37.3789, 33.5942, 37.7231))

stable.sst.df <- data.frame(year = c("all", 2013:2016),
														alpha = c(1.10157 , 1.14585, 0.778839 , 1.12735 , 1.14306),
														beta =  c(-1      , -1     , -0.883931, -1      , -1),
														gamma = c(0.988021, 0.88159, 0.782382 , 0.872435, 1.07727),
														delta = c(28.0162 , 27.9295, 28.1982  , 27.978  , 28.021))


# Kolmogorov-Smirnov ---------------------------------------

my.sst.2013 <- my.data %>%
	dplyr::filter(year(date.time) %in% 2013,
								is.na(sst) != TRUE)

my.sst.all <- my.data %>%
	dplyr::filter(year(date.time) %in% 2013:2016,
								is.na(sst) != TRUE)

my.wind.2013 <- my.data %>%
	dplyr::filter(year(date.time) %in% 2013,
								is.na(wind) != TRUE)

my.wind.all <- my.data %>%
	dplyr::filter(year(date.time) %in% 2013:2016,
								is.na(wind) != TRUE)

ks.test(my.sst.2013$sst, "pstable", alpha = 1.14585, beta = -1 , gamma = 0.88159 , delta = 27.9295)
ks.test(my.sst.all$sst,  "pstable", alpha = 1.10157, beta = -1 , gamma = 0.988021, delta = 28.0162)

ks.test(my.wind.2013$wind, "pstable", alpha = 1.54546, beta = 1, gamma = 6.44239, delta = 33.9795)
ks.test(my.wind.all$wind,  "pstable", alpha = 1.25654, beta = 1, gamma = 9.01023, delta = 34.7015)
