# review rating prediction
# one line in dataset
# rid, nap, nan, sp, sn, tp, tn, len, stars
# 2016.07.16

rm(list=ls(all=TRUE))
.libPaths('d:/qjt/R/mylibrary')
library(ordinal)

source('myfunctions.r')

for(k in 1:1){
    # ftrain<-paste('D:/qjt/data/rating-prediction/vector-train',k,'.txt',sep='')
    # ftest<- paste('D:/qjt/data/rating-prediction/vector-test',k,'.txt',sep='')
    # ftrain <- 'D:/qjt/data/rating-prediction/vector.txt'
    # ftest<- 'D:/qjt/data/rating-prediction/vector.txt'
    ftrain <- 'D:/qjt/data/douban/clm/vector.txt'
    ftest<- 'D:/qjt/data/douban/clm/vector.txt'
    
    dat<-read.csv(ftrain,header=FALSE, sep=',')
    tdat<-read.csv(ftest,header=FALSE, sep=',')
    
    dat$rating<-as.factor(dat$V9)
    x0<-dat$V3+dat$V2+2
    dat$x1<-(dat$V2+1)/x0
    dat$x2<-(dat$V3+1)/x0
    x0<-dat$V4+dat$V5+2
    dat$x3<-(dat$V4+1)/x0
    dat$x4<-(dat$V5+1)/x0
    x0<-dat$V6+dat$V7+2
    dat$x5<-(dat$V6+1)/x0
    dat$x6<-(dat$V7+1)/x0
    dat$x7<-log(dat$V8+1)
    
    fm1 <- clm(rating ~ x1+x2+x3+x4+x5+x6+x7, data = dat)
    # fm1 <- clm(rating ~ x1+x2+x3+x4, data = dat)
    
    # for test set
    tdat$rating<-as.factor(tdat$V9)
    x0<-tdat$V3+tdat$V2+2
    tdat$x1<-(tdat$V2+1)/x0
    tdat$x2<-(tdat$V3+1)/x0
    x0<-tdat$V4+tdat$V5+2
    tdat$x3<-(tdat$V4+1)/x0
    tdat$x4<-(tdat$V5+1)/x0
    x0<-tdat$V6+tdat$V7+2
    tdat$x5<-(tdat$V6+1)/x0
    tdat$x6<-(tdat$V7+1)/x0
    tdat$x7<-log(tdat$V8+1)
    
    p<-predict(newdata=tdat, fm1,type="class")
    r1<-mae(as.numeric(p$fit),as.numeric(tdat$rating))
    r2<-rmse(as.numeric(p$fit),as.numeric(tdat$rating))
    print(paste(r1,r2))
    result<-avgmeasure(as.numeric(p$fit),as.numeric(tdat$rating))
    print(paste("avg mae:",result$mae," avg rmse:", result$rmse))
    print(paste('----',k,'---', sep=''))
}

summary(fm1)


r<-predict(newdata=tdat[1:100,], fm1, type="class")
