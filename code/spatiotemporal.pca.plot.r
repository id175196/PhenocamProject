spatiotemporal.pca.plot <- function(correlation=TRUE){
  
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

# calculate matrix size parameter
nrrows <- x*y

# create an output array a based upon the dimensions of the image
# and 365 days in a year. The array will be filled with data
# when data is available for that given day.
a <- matrix(NA,l,1)
b <- matrix(NA,l,1)

# for every file in the directory do.
for (i in f){
  loc <- which(i == f)
	
  # find the corresponding doy in the doy matrix
  #currentdoy <- doy[loc]
  
	# procesing which file?
	print(i)

	# read in jpeg images
	img <- read.jpeg(i)

	# extract RGB channel data	
	red <-img[,,1]*255
	green <-img[,,2]*255
	blue <-img[,,3]*255

  # reshape every matrix into a 1 column vector
  red <- matrix(red,nrrows,1)
  green <- matrix(green,nrrows,1)
  blue <- matrix(blue,nrrows,1)

  # merge channels into a 3 column feature vector
  RGB <- cbind(red,green,blue)

  # calcute PCA on the RGB channels
  pca.results <- princomp(RGB,cor=correlation)

  # extract scores and get the first PCA component
  pca.1 <- pca.results$scores[,1]
  
  # convert the first pca component back into a matrix
  pca.matrix <- matrix(pca.1,480,640)
  pca.matrix <- t(pca.matrix[nrow(pca.matrix):1,])

  pca.matrix <- mean(pca.matrix[200:350,],na.rm=T)

  ExG <- mean(2*green - red - blue , na.rm=T)

	a[loc,1] <- pca.matrix
  b[loc,1] <- ExG

}

png('~/Dropbox/testa.png')
plot(a)
dev.off()
png('~/Dropbox/testb.png')
plot(b)
dev.off()

}
spatiotemporal.pca.plot()