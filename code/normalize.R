normalize <- function(data,subroutine=1,maxv=0,quantilerange=0.01){

# normalize matrixcolumn between 0 and 1
# rescaling can easily be done afterwords
# use a quantile instead of min max to get
# the range as this limits outlier effects
# quantiles are set at the upper and lower
# 1% of the range.

# read in data (adjust to either accept .txt data or already read in data)
# depending on the subroutine parameter

if (subroutine == 1){

dataset <- data

}else{

dataset <- read.table(data)

}

if (maxv == 0){

# get ~lowest value (don't use min as this will select outliers rather than the general trend)
floorvalue <- quantile(dataset,probs=quantilerange,na.rm=TRUE)

# get ~highest value (don't use max as this will select outliers rather than the general trend)
ceilvalue <- quantile(dataset,probs=1-quantilerange,na.rm=TRUE)

}else{

floorvalue <- min(dataset,na.rm=TRUE)
ceilvalue <- max(dataset,na.rm=TRUE)

}

# normalize
output <- (dataset - floorvalue) / (ceilvalue - floorvalue)
return(output)

}