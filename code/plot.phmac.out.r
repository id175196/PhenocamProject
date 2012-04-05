plot.phmac.out <- function(x){

levels <- length(x$membership)

image.array <- array(NA,c(640,480,levels))

for (i in 1:levels){
img <- matrix(as.matrix(x$membership[[i]]),480,640)
img <- t(img[nrow(img):1,])
image.array[,,i] <- img

}

par(mfrow=c(3,4))
for (i in 1:levels){
image(image.array[,,i],col=rainbow(30))
}

}
