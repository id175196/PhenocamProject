tseries.comparison <- function(){

# vegetation

birch <- read.table('birch.understory-R-input.txt')
beech <- read.table('beech-R-input.txt')
conif <- read.table('conif-R-input.txt')
red.maple <- read.table('red.maple-R-input.txt')

# non vegetation

sky <- read.table('sky-R-input.txt')
grey.ref <- read.table('grey.reference-R-input.txt')

# get dates

dates <- strptime(birch[,1],'%Y-%m-%d')

# PLOT FIGURE

# tickmarks
tickmarks <- c(as.numeric(strptime("2006-01-01","%Y-%m-%d")),
	as.numeric(strptime("2007-01-01","%Y-%m-%d")),
	as.numeric(strptime("2008-01-01","%Y-%m-%d")),
	as.numeric(strptime("2009-01-01","%Y-%m-%d")),
	as.numeric(strptime("2010-01-01","%Y-%m-%d")))

par(mfrow=c(2,1))
par(mar=c(0,4.1,4.1,2.1))

# limits
first.year <- as.numeric(strptime("2008-01-01","%Y-%m-%d"))
last.year <- as.numeric(strptime("2008-12-31","%Y-%m-%d"))

# set text weight
mycex=1.2

# draw empty box with right dimensions
plot(dates,birch[,2],
type='n',
xaxt='n',
bty='n',
ylab='ExG',
xlab='Year',
lwd.ticks=1.5,
main='',
cex.lab=mycex,
cex.axis=mycex,
xlim=c(first.year,last.year))

#axis(side=1,at=tickmarks,lwd=1.5,labels=F)

# plot points
#points(dates,birch[,2],
#pch=20,
#col='grey75',
#cex=0.5
#)

lines(dates,birch[,2],col='black',cex=0.5,lwd=1.5,type='c')
lines(dates,conif[,2],col='green',cex=0.5,lwd=1.5,type='c')
lines(dates,beech[,2],col='yellow',cex=0.5,lwd=1.5,type='c')
lines(dates,red.maple[,2],col='red',cex=0.5,lwd=1.5,type='c')

points(dates,birch[,2],col='black',cex=0.5,pch=20)
points(dates,conif[,2],col='green',cex=0.5,pch=3)
points(dates,beech[,2],col='yellow',cex=0.5,pch=4)
points(dates,red.maple[,2],col='red',cex=0.5,pch=8)

lines(dates,grey.ref[,2],col='black',cex=0.5,lwd=1.5)

#axis(side=2,lwd=1.5,at=c(0.25,0.375,0.5),labels=c(0.25,0.375,0.5),cex=mycex)
box(lwd=1.5)

par(mar=c(4.1,4.1,1,2.1))

# bottom plot

plot(dates,grey.ref[,2],
type='n',
bty='n',
ylab='ExG',
xlab='2008',
lwd.ticks=1.5,
main='',
cex.lab=mycex,
cex.axis=mycex,
xlim=c(first.year,last.year))

lines(dates,grey.ref[,2],col='black',cex=0.5,lwd=1.5)
lines(dates,sky[,2],col='blue',cex=0.5,lwd=1.5)

# create legend
#legend('topleft',legend=c('EVI','NDVI',expression(ExG[modis])),lty=c(1,2,3),lwd=c(1.5,1.5,1.5),horiz=T,bg='white',box.col='white',cex=1)

# plot axis and box
#axis(side=2,lwd=1.5,at=c(0.25,0.375,0.5),labels=c(0.25,0.375,0.5),cex=mycex)
box(lwd=1.5)



}
tseries.comparison()
