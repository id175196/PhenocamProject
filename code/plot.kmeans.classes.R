plot.kmeans.classes <- function(x,top){

classes = unique(x[,1])
nrclasses = length(classes)

write.table(x[,1],"classes.txt",quote=F,row.names=F,col.names=F)

# only for bartlett change for other sites
dates <- system("ls *.jpg | cut -c 10-17",intern=T) 
#dates <- system("ls ../original/*.pnm | cut -c 22-29",intern=T)
dates <- paste("20",dates,sep="")
print(length(dates))


dates <- strptime(dates,"%Y-%m-%d")
print(dates)

VEG1 <- colMeans(x[x[,1]==1,])
VEG1 <- VEG1[2:length(VEG1)]

pdf(file="phenology.profiles.pdf",height=10,width=20)

plot(dates,VEG1,ylim=c(0,top),type="n")

for (i in classes){

VEG1 <- colMeans(x[x[,1]==i,])
VEG1 <- VEG1[2:length(VEG1)]

output <- cbind(rep(i,length(VEG1)),dates$yday,VEG1)
write.table(output,file=paste("class-",i,"-VEG1.txt",sep=""),quote=F,col.names=F,row.names=F)
points(dates,VEG1,pch=20,col=rainbow(nrclasses)[i])

}

op <- par(bg="white")
legend("topleft", as.character(sort(classes)), pch=15, col=rainbow(nrclasses),cex=0.7)
par(op)

dev.off()

}