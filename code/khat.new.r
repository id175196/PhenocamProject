khat.new=function(h,p){ 
num=(1-((h^2+2)/h^2)^(-p/2))^2
din = ((h^2 + 4)/h^2)^(-p/2) - 2 * ((h^2 + 1)/h^2)^(-p/2) * 
        ((h^2 + 3)/h^2)^(-p/2) + ((h^2 + 2)/h^2)^(-p)
dof=num/din
return(p * (dof^(1/p) - 1)/2)
}

khat.direct=function(h,p,k) khat.new(h,p)-k

hvec=function(p,len=10){
kvec=seq(2,15,length.out=len)
h=rep(0,length=len)
for (i in 1:len){
h[i]=uniroot(khat.direct, c(0.1,7), p=p,k=kvec[i])$root
}
return(h)
}
