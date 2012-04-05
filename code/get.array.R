get.array <- function(){

# load required libraries
require(caTools)
require(pixmap)
require(graphics)
require(ReadImages)

# get files in directory
f <- system("ls *.jpg",intern=T)

# get the number of files
l <- length(f)

# get filenames without extension
noextension <- unlist(strsplit(f, split="\\."))

# loop over every file in the directory
for (i in f){
loc <- which(i == f)

# read in jpeg images
img <- read.jpeg(i)

# extract RGB channel data
red.veg <-img[,,1]
green.veg <-img[,,2]
blue.veg <-img[,,3]

# calculate overall brightness
brightness <- red.veg + green.veg + blue.veg

# correct channels for brightness
red.per <- red.veg/brightness
green.per <- green.veg/brightness
blue.per <- blue.veg/brightness

# calculate the exg and EXG
exg <- 2*green.per - red.per - blue.per

# truncate everything below 0
exg[exg<0] <- 0

# multiply by 255 to scale to integer range
exg <- 255*exg

# write as a pnm file
write.pnm(exg,file=paste())
}

}
