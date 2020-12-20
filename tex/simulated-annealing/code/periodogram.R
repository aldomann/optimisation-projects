#WIND DATA
#=============

#Plot periodogram in normal and log scale
#each year
par(oma=c(0,0,2,0))
par(mfrow=c(2,2))
a <- spec.pgram(wind.2013, kernel("daniell",m=10), main="WIND-2013")
b <- spec.pgram(wind.2014, kernel("daniell",m=10), main="WIND-2014")
c <- spec.pgram(wind.2015, kernel("daniell",m=10), main="WIND-2015")
d <- spec.pgram(wind.2016, kernel("daniell",m=10), main="WIND-2016")
title(main="Periodogram in normal for WIND",outer=T)

par(mfrow=c(2,2))
a$freq = log(a$freq)
a$spec = log(a$spec)
plot(a$freq,a$spec, main="Wind-2013")

b$freq = log(b$freq)
b$spec = log(b$spec)
plot(b$freq,b$spec, main="Wind-2014")

c$freq = log(c$freq)
c$spec = log(c$spec)
plot(c$freq,c$spec, main="Wind-2015")

d$freq = log(d$freq)
d$spec = log(d$spec)
plot(d$freq,d$spec,main="Wind-2016")
title(main="Periodogram in Log Scale for WIND",outer=T)

#all
par(oma=c(0,0,0,0))
par(mfrow=c(1,1))
wind.per <- spec.pgram(wind.all, kernel("daniell",m=10), main="Periodogram in normal of WIND 2013-2016")
wind.per$freq = log(wind.per$freq)
wind.per$spec = log(wind.per$spec)
plot(wind.per$freq, wind.per$spec, main="Periodogram in Log Scale of WIND 2013-2016")

#SST DATA
#=============

#Plot periodogram in normal and log scale
#each year
par(oma=c(0,0,2,0))
par(mfrow=c(2,2))
m <- spec.pgram(sst.2013, kernel("daniell",m=10), main="SST-2013")
n <- spec.pgram(sst.2014, kernel("daniell",m=10), main="SST-2014")
l <- spec.pgram(sst.2015, kernel("daniell",m=10), main="SST-2015")
q <- spec.pgram(sst.2016, kernel("daniell",m=10), main="SST-2016")
title(main="Periodogram in normal for SST",outer=T)

par(mfrow=c(2,2))
m$freq = log(m$freq)
m$spec = log(m$spec)
plot(m$freq,m$spec, main="SST-2013")

n$freq = log(n$freq)
n$spec = log(n$spec)
plot(n$freq,n$spec, main="SST-2014")

l$freq = log(l$freq)
l$spec = log(l$spec)
plot(l$freq,l$spec, main="SST-2015")

q$freq = log(q$freq)
q$spec = log(q$spec)
plot(q$freq,q$spec, main="SST-2016")
title(main="Periodogram in Log Scale for SST",outer=T)

#all
par(oma=c(0,0,0,0))
par(mfrow=c(1,1))
sst.per <- spec.pgram(sst.all, kernel("daniell",m=10), main="Periodogram in normal of SST 2013-2016")
sst.per$freq = log(sst.per$freq)
sst.per$spec = log(sst.per$spec)
plot(sst.per$freq, sst.per$spec, main="Periodogram in Log Scale of SST 2013-2016")