EGU.plot.timeseries <- function(){

source('../code/moving.quantile.classification.R')
source('../code/normalize.R')

# read data
understory <- read.table('birch.understory-2007-tseries.txt')
birch <- read.table('birch-2007-tseries.txt')
beech <- read.table('beech-2007-tseries.txt')
s.maple <- read.table('sugar.maple-2007-tseries.txt')
red.maple <- read.table('red.maple-2007-tseries.txt')
sky <- read.table('sky-2007-tseries.txt')
conif <-read.table('conif-2007-tseries.txt')

# smooth using moving quantile
beech <- na.omit(moving.quantile(beech))
birch <- na.omit(moving.quantile(birch))
s.maple <- na.omit(moving.quantile(s.maple))
red.maple <- na.omit(moving.quantile(red.maple))
understory <- na.omit(moving.quantile(understory))
sky <- na.omit(moving.quantile(sky))
conif <- na.omit(moving.quantile(conif))

# plot everything

plot(beech[,1],beech[,2],
xaxt='n',
yaxt='n',
xlab='DOY (2007)',
ylab='ExG',
type='n',
cex.lab=1.2,
ylim=c(0.32,0.45)
)

lines(sky[,1],sky[,2],lwd=1.5,pch=6,lty=6,type='b',col='grey75')
lines(beech[,1],beech[,2],lwd=1.5,pch=1,lty=1,type='b',col='orange')
#lines(birch[,1],birch[,2],lwd=1.5,pch=2,lty=2,type='b',col='yellow')
lines(red.maple[,1],red.maple[,2],lwd=1.5,pch=3,lty=3,type='b',col='red')
#lines(s.maple[,1],s.maple[,2],lwd=1.5,pch=4,lty=4,type='b')
lines(understory[,1],understory[,2],lwd=1.5,pch=5,lty=5,type='b')
lines(conif[,1],conif[,2],pch=7,lty=7,type='b',col='lightgreen')

legend('topright',legend=c('birch/understory','beech','red maple','sky','coniferous'),lty=c(5,1,3,6,7),pch=c(5,1,3,6,7),col=c('black','orange','red','grey75','lightgreen'),cex=1.2,bty='n')

legend('topleft',legend=c('ExG = 2G - R - B'),cex=1.2,bty='n')

axis(1,label=T,lwd=1.5,cex.axis=1.5)
axis(2,label=T,lwd=1.5,cex.axis=1.5)
box(lwd=1.5)
}
EGU.plot.timeseries()

