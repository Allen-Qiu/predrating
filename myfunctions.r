# function for rating prediction


mae<-function(plist, rlist){
    m<-abs(plist-rlist)
    n<-length(m)
    return (sum(m)/n)
}

rmse<-function(plist, rlist){
    return (sqrt(sum((plist-rlist)^2)/length(plist)))
}

mypred<-function(trainset,testset){
    fm1 <- clm(rating ~ contact + temp, data = trainset)
    p<-predict(fm1, newdata=testset,type="class")
    plist<-as.numeric(p$fit)
    rlist<-as.numeric(testset$rating)
    r1<-mae(plist,rlist)
    r2<-rmse(plist,rlist)
    return (c(mae=r1, rmse=r2))
}

aggr<-function(w){
    a<-0
    for(i in 1:length(w)){
        a<-c(a,w[i]+a[i])
    }
    return (a[2:length(a)])
}
sampling<-function(w){
    return(which(w>runif(1))[[1]])
}

# calculate mae for every rating
# rlist must be the ratings of trainset
# plist must be prediction
# 2016.07
avgmeasure<-function(plist, rlist){
  plist<-unlist(plist)
  rlist<-unlist(rlist)
  ratings<-sort(as.numeric(unique(rlist)))
  msum<-0
  rsum<-0
  for (r in ratings){
    ind<-which(rlist%in%r)
    pl<-plist[ind]
    rl<-rlist[ind]
    mm<-mae(pl,rl)
    mr<-rmse(pl,rl)
    print(paste(r,': mae:',mm,' rmse:',mr))
    msum<-msum+mm
    rsum<-rsum+mr
  }
  return(list(mae=msum/length(ratings),rmse=rsum/length(ratings)))
}

# sampling
mysampling<-function(dweight, dat, idx, num){
  # normalize weights
  dweight[idx]<-dweight[idx]/sum(dweight[idx])
  
  dist<-rep(0,length(idx))
  for(i in 1:length(idx)){
      if(i==1){
          dist[i]<-dweight[idx[i]]
      }else{
          dist[i]<-dist[i-1]+dweight[idx[i]]
      }
  }
  # browser()
  # sapply(seq(1:length(dweight)), function(x) dist<-c(dist,dist[x]+dweight[x]))
  rand<-runif(num,min=0,max=1)
  index<-sapply(rand,function(x) which.max(dist>x))
  return (list(t=dat[idx[index],],weight=dweight))
}

# update weight, but not normalize them
# because dweight reserve weights of all instances
# we finish normalization in mysampling function
updateweight<-function(dweight, plist, rlist){
  # idx<-which((plist-rlist)>1)
  idx<-which(plist!=rlist)
  erate<-length(idx)/length(plist)
  print(paste("erate=",erate))
  dweight[idx]<-dweight[idx]*(1+erate)
  # dweight<-dweight/sum(dweight)
  return(dweight)
}

add<-function(a){
    a<-a+1
}




