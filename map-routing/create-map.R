# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Ruth Kristianingsih <ruth.kristianingsih@mathmods.eu>

# Libraries ------------------------------------------------

library(tidyverse)
library(data.table)
library(ggmap)

setwd("map-routing/")

# Read solution --------------------------------------------
solution <- fread("solution.csv")
solution.uab <- fread("solution-uab.csv")

# Map functions --------------------------------------------

spain <- get_map(location = c(lon = mean(solution$Lon),
															lat = mean(solution$Lat)),
								 zoom = 6, maptype = "roadmap", source = "google")

uab <- get_map(location = c(lon = mean(solution.uab$Lon),
														lat = mean(solution.uab$Lat)),
							 zoom = 11, maptype = "roadmap", source = "google")

scale_x_longitude <- function(xmin = -180, xmax = 180, step = 1, xtra.lim = 1.5, ...) {
	xbreaks <- seq(xmin,xmax,step)
	xlabels <- unlist(lapply(xbreaks, function(x) ifelse(x < 0, parse(text=paste0(-x,"^o", "*W")),
																											 ifelse(x > 0, parse(text=paste0(x,"^o", "*E")), x))))
	return(scale_x_continuous("Longitude", breaks = xbreaks, labels = xlabels,
														expand = c(0, 0), limits = c(xmin-xtra.lim, xmax+xtra.lim), ...))
}

scale_y_latitude <- function(ymin = -90, ymax = 90, step = 0.5, xtra.lim = 1.5, ...) {
	ybreaks <- seq(ymin,ymax,step)
	ylabels <- unlist(lapply(ybreaks, function(x) ifelse(x < 0, parse(text=paste0(-x,"^o", "*S")),
																											 ifelse(x > 0, parse(text=paste0(x,"^o", "*N")), x))))
	return(scale_y_continuous("Latitude", breaks = ybreaks, labels = ylabels,
														expand = c(0, 0), limits = c(ymin-xtra.lim, ymax+xtra.lim), ...))
}

# Plot map -------------------------------------------------

lon.data <- solution$Lon
lat.data <- solution$Lat

lon.data.uab <- solution.uab$Lon
lat.data.uab <- solution.uab$Lat

node.start <- 1
node.goal <- nrow(solution)
node.goal.uab <- nrow(solution.uab)

map <- ggmap(spain) +
	geom_path(data=solution, aes(x=Lon, y=Lat),
						color = "royalblue1", size = 1) +
	# Starting node
	geom_point(aes(x = lon.data[node.start],
								 y = lat.data[node.start]),
						 colour = "lightsalmon", size = 8, alpha =0.1) +
	geom_point(aes(x = lon.data[node.start],
								 y = lat.data[node.start]),
						 colour = "white", fill = "lightsalmon", stroke = 1, shape=21, size = 5) +
	# Goal node
	geom_point(aes(x = lon.data[node.goal],
								 y = lat.data[node.goal]),
						 colour = "lightsalmon", size = 8, alpha =0.1) +
	geom_point(aes(x = lon.data[node.goal],
								 y = lat.data[node.goal]),
						 colour = "white", fill = "lightsalmon", stroke = 1, shape=21, size = 5) +
	labs(x = "Longitude", y = "Latitude") +
	scale_x_longitude(xmin = floor(min(lon.data)) - 1, xmax = ceiling(max(lon.data)),
										step = 2, xtra.lim = 0.2) +
	scale_y_latitude(ymin = floor(min(lat.data)), ymax = ceiling(max(lat.data)),
									 step = 1, xtra.lim = 0.1)


map.uab <- ggmap(uab) +
	geom_path(data=solution.uab, aes(x=Lon, y=Lat),
						color = "royalblue1", size = 1) +
	# Starting node
	geom_point(aes(x = lon.data.uab[node.start],
								 y = lat.data.uab[node.start]),
						 colour = "lightsalmon", size = 8, alpha =0.1) +
	geom_point(aes(x = lon.data.uab[node.start],
								 y = lat.data.uab[node.start]),
						 colour = "white", fill = "lightsalmon", stroke = 1, shape=21, size = 5) +
	# Goal node
	geom_point(aes(x = lon.data.uab[node.goal.uab],
								 y = lat.data.uab[node.goal.uab]),
						 colour = "lightsalmon", size = 8, alpha =0.1) +
	geom_point(aes(x = lon.data.uab[node.goal.uab],
								 y = lat.data.uab[node.goal.uab]),
						 colour = "white", fill = "lightsalmon", stroke = 1, shape=21, size = 5) +
	labs(x = "Longitude", y = "Latitude") +
	scale_x_longitude(xmin = floor(min(lon.data.uab)), xmax = ceiling(max(lon.data.uab))-0.7,
										step = 0.1, xtra.lim = 0) +
	scale_y_latitude(ymin = floor(min(lat.data.uab))+0.35, ymax = ceiling(max(lat.data.uab))-0.45,
									 step = 0.05, xtra.lim = 0)

map + theme_bw() #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "solution.pdf", width = 6, height = 4, dpi = 96, device = cairo_pdf)

map.uab + theme_bw() #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "solution-uab.pdf", width = 5, height = 4, dpi = 96, device = cairo_pdf)

