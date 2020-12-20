#WIND DATA
#=============

#Plot periodogram in normal and log scale
#each year
a <- spec.pgram(wind.2013, kernel("daniell",m=10), main="WIND-2013")
b <- spec.pgram(wind.2014, kernel("daniell",m=10), main="WIND-2014")
c <- spec.pgram(wind.2015, kernel("daniell",m=10), main="WIND-2015")
d <- spec.pgram(wind.2016, kernel("daniell",m=10), main="WIND-2016")

a$freq = log(a$freq)
a$spec = log(a$spec)

b$freq = log(b$freq)
b$spec = log(b$spec)

c$freq = log(c$freq)
c$spec = log(c$spec)

d$freq = log(d$freq)
d$spec = log(d$spec)

#all
wind.per <- spec.pgram(wind.all, kernel("daniell",m=10), main="Periodogram in normal of WIND 2013-2016")
wind.per$freq = log(wind.per$freq)
wind.per$spec = log(wind.per$spec)

#SST DATA
#=============

#Plot periodogram in normal and log scale
#each year
m <- spec.pgram(sst.2013, kernel("daniell",m=10), main="SST-2013")
n <- spec.pgram(sst.2014, kernel("daniell",m=10), main="SST-2014")
l <- spec.pgram(sst.2015, kernel("daniell",m=10), main="SST-2015")
q <- spec.pgram(sst.2016, kernel("daniell",m=10), main="SST-2016")

m$freq = log(m$freq)
m$spec = log(m$spec)

n$freq = log(n$freq)
n$spec = log(n$spec)

l$freq = log(l$freq)
l$spec = log(l$spec)

q$freq = log(q$freq)
q$spec = log(q$spec)

#all
sst.per <- spec.pgram(sst.all, kernel("daniell",m=10), main="Periodogram in normal of SST 2013-2016")
sst.per$freq = log(sst.per$freq)
sst.per$spec = log(sst.per$spec)


# Using ggplot ---------------------------------------------

per.wind.13 <- data.frame(freq = a$freq, spec = a$spec)
per.wind.14 <- data.frame(freq = b$freq, spec = b$spec)
per.wind.15 <- data.frame(freq = c$freq, spec = c$spec)
per.wind.16 <- data.frame(freq = d$freq, spec = d$spec)

per.wind.all <- data.frame(freq = wind.per$freq, spec = wind.per$spec)

per.sst.13 <- data.frame(freq = m$freq, spec = m$spec)
per.sst.14 <- data.frame(freq = n$freq, spec = n$spec)
per.sst.15 <- data.frame(freq = l$freq, spec = l$spec)
per.sst.16 <- data.frame(freq = q$freq, spec = q$spec)
per.sst.all <- data.frame(freq = sst.per$freq, spec = sst.per$spec)

source('ruth/multiplot.R')
library(GGally)

plot_periodogram <- function(df, colour = "black"){
	ggplot(df, aes(x = freq, y = spec)) +
		geom_line(colour = colour) +
		labs(x = "Frequency", y = "Spectrum")
}

plot_periodogram(per.sst.all)

plot_periodogram(per.wind.all)


ggmatrix(list(plot_periodogram(per.wind.13, "indianred1"), plot_periodogram(per.wind.14, "darkolivegreen3"),
							plot_periodogram(per.wind.15, "darkturquoise"), plot_periodogram(per.wind.16, "mediumorchid1")),
				 nrow = 4, ncol = 1,
				 yAxisLabels = c("2013", "2014", "2015", "2016"),
				 xlab = "Frequency",
				 ylab = "Spectrum") +
	theme(strip.placement = "outside")


ggmatrix(list(plot_periodogram(per.sst.13, "indianred1"), plot_periodogram(per.sst.14, "darkolivegreen3"),
							plot_periodogram(per.sst.15, "darkturquoise"), plot_periodogram(per.sst.16, "mediumorchid1")),
				 nrow = 4, ncol = 1,
				 yAxisLabels = c("2013", "2014", "2015", "2016"),
				 xlab = "Frequency",
				 ylab = "Spectrum") +
	theme(strip.placement = "outside")
