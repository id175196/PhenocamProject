permuted.difference <- function(){

source('/data/Dropbox/phenocam_classification/code/image.plot.R')

labels.2006 <- read.table('../all-labels-2006.txt')
labels.2007 <- read.table('../all-labels-2007.txt')
labels.2008 <- read.table('../all-labels-2008.txt')
labels.2009 <- read.table('../all-labels-2009.txt')
labels.2010 <- read.table('../all-labels-2010.txt')

nrows <- dim(labels.2006)[1]
ncols <- dim(labels.2006)[2]

outputmatrix <- matrix(NA,nrows,ncols)

# for every class extract col from matrics

for (k in 1:ncols){

tmp <- matrix(NA,nrows,25)
x <- matrix(NA,nrows,5)

x[,1] <- labels.2006[,k]
x[,2] <- labels.2007[,k]
x[,3] <- labels.2008[,k]
x[,4] <- labels.2009[,k]
x[,5] <- labels.2010[,k]

#x[x == 15] <- NA 

	for (i in 1:5){
		for (j in 1:5){
		diff <- abs(x[,i] - x[,j])
		diff[diff > 0 ] <- 1
		tmp[,i*j] <- diff
		}
	}

tmp <- as.matrix(rowSums(tmp,na.rm=T)/25)
outputmatrix[,k] <- tmp

}

outputmatrix <- apply(outputmatrix,1,function(x)1-mean(x,na.rm=T))
outputmatrix <- matrix(outputmatrix,480,640)
myImagePlot(outputmatrix)
write.table(outputmatrix,'permuted.differences.txt',quote=F,row.names=F,col.names=F)

}
permuted.difference()


