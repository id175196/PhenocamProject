plot.pca.image <- function(pcascores,classes=12){

# takes pca scores from a pca on the data
# matrix in bartlett20xx as input:
# pcadata = princomp(datamatrix)
# pcascores = pcadata$scores
# needs more tweaking for descent plotting

source('~/Dropbox/phenocam_classification/code/image.plot.R')

print('printing the pca images for')
print(classes)
print('classes')

#par(ask=T)
par(mfrow=c(3,1))
par(mar=c(0,2,2,2))
for (i in 1:3){

c <- matrix(pcascores[,i],480,640)
#myImagePlot(c)

image(t(c[ nrow(c):1, ]),col=rainbow(classes),main=paste('PCA ',i,sep=''),xaxt='n',yaxt='n')

}

}
plot.pca.image(res,12)
