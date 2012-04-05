plot.trees <- function(bartlettdatafile){

bf <- read.table(bartlettdatafile,sep=',',header=T)

length 	<- bf$Distance
angle 	<- bf$Bearing
dbh 	<- bf$DBH
subplot <- bf$Subplot
species <- bf$Species
health	<- bf$Status
x	<- bf$x
y	<- bf$y

#scaled.dbh <- (dbh - min(dbh)) / (max(dbh) - min(dbh))
scaled.dbh <- dbh/10

angle <- (360 - angle) + 90

# convert from polar to cartesian coordinates
x <- length*cos(angle*pi/180)
y <- length*sin(angle*pi/180)

# corrections for subplots
# plot layout:
# NW--------NE
# |          |
# |     C    |
# |          |
# SW--------SE

# NE
x[subplot == 'NE' ] <- x[subplot == 'NE' ] + 25
y[subplot == 'NE' ] <- y[subplot == 'NE' ] + 25

# SE
x[subplot == 'SE' ] <- x[subplot == 'SE' ] + 25
y[subplot == 'SE' ] <- y[subplot == 'SE' ] - 25

# SW
x[subplot == 'SW' ] <- x[subplot == 'SW' ] - 25
y[subplot == 'SW' ] <- y[subplot == 'SW' ] - 25

# NW
x[subplot == 'NW' ] <- x[subplot == 'NW' ] - 25
y[subplot == 'NW' ] <- y[subplot == 'NW' ] + 25

# C -> no corrections needed

# create color vector
species.col <- as.matrix(species)

species.col[species.col == "FAGR"]	<- rgb(255,70,0,99,maxColorValue=255)
species.col[species.col == 'BEAL'] 	<- rgb(255,162,0,99,maxColorValue=255) 
species.col[species.col == 'ACSA'] 	<- rgb(255,100,0,99,maxColorValue=255) 
species.col[species.col == 'BEPA'] 	<- rgb(236,205,0,99,maxColorValue=255) 
species.col[species.col == 'UNK'] 	<- rgb(99,99,99,99,maxColorValue=255) 
species.col[species.col == 'TSCA'] 	<- rgb(29,208,0,99,maxColorValue=255) 
species.col[species.col == 'ACRU'] 	<- rgb(255,0,0,99,maxColorValue=255) 
species.col[species.col == 'ASCA'] 	<- rgb(0,200,100,99,maxColorValue=255)

# create shape vector
species.pch <- as.matrix(species)

species.pch[species == "FAGR"]	<-  20
species.pch[species == 'BEAL'] 	<-  15 
species.pch[species == 'ACSA'] 	<-  8
species.pch[species == 'BEPA'] 	<-  15
species.pch[species == 'UNK'] 	<-  21
species.pch[species == 'TSCA'] 	<-  17
species.pch[species == 'ACRU'] 	<-  8
species.pch[species == 'ASCA'] 	<-  6

species.pch <- as.numeric(species.pch) 

plot(x-1,y+30,type='n',xlab='m E-W from tower',ylab='m N from tower',lwd.tick=2,cex.lab=1.2,ylim=c(-1,50))
#symbols(x,y,scaled.dbh,bg=species.col,fg=NA,inches=T, lwd=1,xlab='m E-W from tower',ylab='m N-S from tower')
points(x-1,y+30,pch=species.pch,col=species.col,cex=scaled.dbh,lwd=2)
box(lwd=2)

# camera symbols and FOV lines
points(0,-1,pch=22,cex=2,lwd=2)
points(0,0,pch=25,cex=1,lwd=2)
lines(c(1,10),c(1,17.2),lwd=2)
lines(c(-1,-10),c(1,17.2),lwd=2)

legend('topleft',legend=unique(species),pch=c(20,15,8,15,21,17,8,6),col=unique(species.col),cex=0.8,pt.cex=1.2,bty='n',horiz=T)
		
#legend('topleft',legend=unique(subplot),pch=c(20,15,8,15,21,17,8,6),col=unique(subplot),cex=0.8,pt.cex=1.2,bty='n',horiz=T)


}
plot.trees('Bartlett_Tower_2009.csv')
