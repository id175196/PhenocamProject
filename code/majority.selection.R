majority.selection <- function(year=2006){

#######################################################
#
# numeric class values as arbitrairily assigned
#
# 15 undefined
# 20 hill.top
# 25 hill.base
# 30 conif
# 35 red.maple
# 40 grey.reference
# 45 beech
# 50 sugar.maple
# 55 birch.understory
# 60 sky
# 65 birch
#
# reassigned k-means classification values to the
# above value depending on the majority class of
# values within a predefined ROI (mask file)
#
#
#######################################################

# read in predefined regions of interest and their associated majority classes
print('reading in mask files...')
class.vector <- unlist(read.table('../mask_files/mask.file.vector.txt'))
classes <- as.matrix(unique(class.vector))

print(classes)

# read in labels from classification
print('reading in labels...')
labels <- unlist(read.table(paste('labels-',year,'.txt',sep='')))
labels[labels == 'NA'] <- 0

# read in dates file to output species specific time series
print('reading in raw classification feature vectors...')
dates <- unlist(read.table(paste('dates-',year,'.txt',sep='')))


num.classes <- seq(15,65,5)
names.classes <- c('undefined',
'hill.top',
'hill.base',
'conif',
'red.maple',
'grey.reference',
'beech',
'sugar.maple',
'birch.understory',
'sky',
'birch')

# read in complete data matrix
exg.data <- read.table(paste('data-matrix-',year,'.txt',sep=''))

for (i in classes){
	print('Evaluating:')
	print(i)
	
	# create temporary file to be overwrite the original (clean.labels)
	clean.labels <- as.matrix(labels)	
	tmp <- as.matrix(labels)

	max.val <- max(table(labels[class.vector==i]))
	all.val <- table(labels[class.vector==i])
	sel.val <- which(max.val == all.val)
	sel.class <- which(i == names.classes)

	print(num.classes[sel.class])

	# select majority class
	majority.class <- as.numeric(names(table(labels[class.vector==i])[sel.val]))
	print(majority.class)
	tmp[clean.labels == majority.class] <- num.classes[sel.class]
	tmp[clean.labels != majority.class] <- num.classes[1]	
	assign(i,tmp)

	# calcute average greenness value over selected pixels (class)		
	averaged.exg <- apply(exg.data[labels == majority.class,],2,function(x) median(x,na.rm=T))
	
	#plot(strptime(dates,'%Y-%m-%d'),averaged.exg,type='b')
	
	# make output matrix and print to file	
	output <- cbind(as.character(dates),averaged.exg)
	write.table(output,paste(i,year,'tseries.txt',sep='-'),quote=F,row.names=F,col.names=F)
}

all.labels <- cbind(undefined,hill.top,hill.base,conif,red.maple,grey.reference,beech,sugar.maple,birch.understory,sky,birch)
write.table(all.labels,paste('all-labels-',year,'.txt',sep=''),quote=F,row.names=F,col.names=F)

}

setwd('../bartlett2006')
majority.selection(2006)
setwd('../bartlett2007')
majority.selection(2007)
setwd('../bartlett2008')
majority.selection(2008)
setwd('../bartlett2009')
majority.selection(2009)
setwd('../bartlett2010')
majority.selection(2010)
