get.data.array <- function(classes=12){

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

# create an output array a based upon the dimensions of the image
# and 365 days in a year. The array will be filled with data
# when data is available for that given day.
a <- array(NA,dim=c(x,y,365))

# for every file in the directory do.
for (i in f){
	loc <- which(i == f)
	
  # find the corresponding doy in the doy matrix
  currentdoy <- doy[loc]
  
	# procesing which file?
	print(i)

	# read in jpeg images
	img <- read.jpeg(i)

	# extract RGB channel data	
	red <-img[,,1]*255
	green <-img[,,2]*255
	blue <-img[,,3]*255

	# calculate overall brightness
	brightness <- red + green + blue

	# calculate green percentage or gcc Sonnentag et al.
	green.per <- green/brightness

	# write to matrix
	a[,,currentdoy] <- green.per
}

# calculate matrix size parameter
nrrows <- x*y

# reshape the 3d array into a 2d matrix
a <- matrix(a,nrrows,l)

# write output to txt files

# write classification input data to file
write.table(a,paste('data-matrix-',unique(year),'.txt',sep=''),quote=F,row.names=F,col.names=F)

# write dates file
dates <- strptime(paste(year,doy,sep='-'),'%Y-%j')
write.table(dates,paste('dates-',unique(year),'.txt',sep=''),quote=F,row.names=F,col.names=F)

}

# execute function
# in image directory load using source() will execute the procedure
get.data.array()
