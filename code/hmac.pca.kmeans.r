hmac.pca.kmeans=function(data,centers=400,sigma=seq(from=0.5,to=4,by=0.05),parallel=FALSE)
{
require('Modalclust')

pca.data <- princomp(data,cor=T)
kmeans.out=kmeans(pca.data$scores[,1:50],centers=centers)
center=kmeans.out$centers
cluster.kmeans=kmeans.out$cluster
hmac.out=phmac(dat=center,sigmaselect=sigma,npart=1,parallel=parallel)

#hmac.out=phmac(dat=pca.data$scores[,1:25],sigmaselect=sigma,npart=1,parallel=parallel)

#order=sort(cluster.kmeans)
#data.ordered=data[,]

ind=seq(1,dim(data)[1])
myorder=ind[order(kmeans.out$cluster)]
#data.ordered=data[myorder,]

memb.new.rightorder=memb.new=list(1:max(hmac.out$level))


for (i in 1 : max(hmac.out$level)){
       temp=seq(1,dim(data)[1])
	memb.new[[i]]=rep(hmac.out$membership[[i]], kmeans.out$size)
	temp[myorder]=memb.new[[i]]
        #cat(temp)
	memb.new.rightorder[[i]]=temp
}
	output=list() 
	output[["data"]]=data
	output[["mode"]]=hmac.out$mode
	output[["sigma"]]=hmac.out$sigmas
    	output[["n.cluster"]]=hmac.out$n.cluster
    	output[["level"]]=hmac.out$level	
    	output[["membership"]]=memb.new.rightorder
	class(output)="hmac"
	return(output)

}
