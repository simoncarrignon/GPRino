library(RGPR)
source("tools.R")

testing=getMagnitude("./covanegra2024/sector4/planta/")[1:129,]
testing=rbind(1:ncol(testing),rep(0,ncol(testing)),testing)
uu=rbind(1:ncol(uu),rep(0,ncol(testing)),testing)

#Compare RGPR with simple/raw analysise
par(mfrow=c(1,2),mar=c(5,5,5,0))
image(log(t(getMagnitude("./covanegra2024/sector4/planta/"))[,129:1]),main="CNM24 sector 4 - planta")
testing=as.GPR.data.frame(getMagnitude("./covanegra2024/sector4/planta/")[1:129,])
x3  <- dewow(testing, type = "runmed", w = 50)
plot(x3)

#Generate heatmap for each sectors
res=plotOneSector("./covanegra2024/sector1/",filter=F)
res=plotOneSector("./covanegra2024/sector2/",filter=F)
res=plotOneSector("./covanegra2024/sector3/",filter=F)
res=plotOneSector("./covanegra2024/sector4/",filter=F)
