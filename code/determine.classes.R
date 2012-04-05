determine.classes <- function(classes=12,x=640,y=480){

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

# create an output array
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
	brightness <- red.veg + green.veg + blue.veg

	# correct channels for brightness
	red.per <- red.veg/brightness
	green.per <- green.veg/brightness
	blue.per <- blue.veg/brightness

	# calculate the exg and EXG
	exg <- 2*green.per - red.per - blue.per
	EXG <- 2*green.veg - red.veg - blue.veg

	exg[exg == "NaN"] <- 0
	green.per[green.per == "NaN"] <- 0
	
	# a[,,loc] <- exg
	a[,,loc] <- EXG
	# a[,,loc] <- green.per
}

# calculate matrix size parameter
nrrows <- x*y

# reshape the 3d array into a 2d matrix
a <- matrix(a,nrrows,l)

wss <- (nrow(a)-1)*sum(apply(a,2,var))

for (i in 2:15) wss[i] <- sum(kmeans(a,centers=i)$withinss)


pdf(file="classes.pdf",height=6, width=7)
plot(1:15, wss, type="b", xlab="Number of Clusters",
  ylab="Within groups sum of squares") 
dev.off()

system(' cp classes.pdf ~/Dropbox/')

}
determine.classes()
