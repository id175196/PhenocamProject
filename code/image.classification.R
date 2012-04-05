image.classification <- function(classes=12){

# load required libraries
require(caTools)
require(pixmap)
require(graphics)
require(ReadImages)
require(fpc)

# get files and file info out of the directory
f <- system("ls *.jpg | sort -n",intern=T)
doy <- system("ls *.jpg | sort -n | cut -d'-' -f1",intern=T)
year <- system("ls *.jpg | sort -n | cut -d'-' -f2",intern=T)

# get the number of files in the directory
l <- length(f)

# get file dimensions
x <- dim(read.jpeg(f[1]))[2]
y <- dim(read.jpeg(f[1]))[1]

# create an output array a based upon the number of files
# and file dimensions
a <- array(NA,dim=c(x,y,l))

# for every file in the directory do...
for (i in f){
	loc <- which(i == f)
	
	# procesing which file?
	print(i)

	# read in jpeg images
	img <- read.jpeg(i)

	# extract RGB channel data	
	red.veg <-img[,,1]*255
	green.veg <-img[,,2]*255
	blue.veg <-img[,,3]*255

	# calculate overall brightness
	#brightness <- red.veg + green.veg + blue.veg

	# correct channels for brightness
	#red.per <- red.veg/brightness
	#green.per <- green.veg/brightness
	#blue.per <- blue.veg/brightness

	# calculate the exg and EXG
	#exg <- 2*green.per - red.per - blue.per
	EXG <- 2*green.veg - red.veg - blue.veg

	# a[,,loc] <- exg
	a[,,loc] <- EXG
	# a[,,loc] <- green.per
}

# calculate matrix size parameter
nrrows <- x*y

# reshape the 3d array into a 2d matrix
a <- matrix(a,nrrows,l)

# classify using a kmeans classifier with # classes
b <- kmeans(a,classes) # <- CLASSIFICATION STEP

# output the classification results to a vector 
c <- matrix(b$cluster,y,x)

# write output to txt files

# write classification results to a file
write.table(as.vector(c),paste('labels-',unique(year),'.txt',sep=''),quote=F,row.names=F,col.names=F)

# write classification input data to file
write.table(a,paste('data-matrix-',unique(year),'.txt',sep=''),quote=F,row.names=F,col.names=F)

# write dates file
dates <- strptime(paste(year,doy,sep='-'),'%Y-%j')
write.table(dates,paste('dates-',unique(year),'.txt',sep=''),quote=F,row.names=F,col.names=F)

# plot classification result
pdf(file="classification.pdf",height=6, width=7)
image(t(c[ nrow(c):1, ]),col=rainbow(classes))
op <- par(bg="white")
legend("topleft", as.character(seq(1,classes,1)), pch=15, col=rainbow(classes),cex=0.7)
par(op)
dev.off()

}

# execute function
# in image directory load using source() will execute the procedure
image.classification()
