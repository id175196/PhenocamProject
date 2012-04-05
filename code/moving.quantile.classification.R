moving.quantile <- function(inputfile,windowsize=3, percentile=0.9){

# load the required libraries
require(caTools)

# set the padding based upon the window size
padding <- (windowsize - 1) / 2

# read in the datafile
data <- inputfile

# pull variables out of data file for further evaluation
	date<- as.Date(data[,1],"%Y-%m-%d")
	VEG1 <- data[,2]

#get the number of years covered by the time series
	days.to.evaluate <- min(date,na.rm=T):(max(date,na.rm=T))

# create output matrix
	outputmatrix <- matrix(NA,length(days.to.evaluate)+1,2)

# run through all these days subsetting the data and
# calculating a running quantile
	loc <- 2

#get the percentile on the indices
for (i in seq(min(days.to.evaluate,na.rm=T), max(days.to.evaluate,na.rm=T), 3)){
	VEG1.subset <- VEG1[date >= (i - padding) & date <= (i + padding)]		
	outputmatrix[loc,1] <- days.to.evaluate[loc]
	outputmatrix[loc,2] <- quantile(VEG1.subset,probs=percentile,na.rm=TRUE)
	loc <- loc+3

}
		

	#convert to DOY
	t <- as.Date(outputmatrix[,1], origin="1970-01-01")
	outputmatrix[,1] <- (as.POSIXlt(t)$yday)+1
		
	return(outputmatrix)
}

