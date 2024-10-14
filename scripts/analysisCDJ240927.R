library(RGPR)

"CDJ240927"

for(area in list.files("CDJ240927",pattern="area")){
    allf=list.files(file.path("CDJ240927",area),pattern="output_",full.names = T)
    print(allf)
    if(length(allf)==2){
        png(paste0("analysys_",area,".png"),width=1200,height=600,pointsize=15)
        par(mfrow=c(1,2))
    }
    if(length(allf)==4){
        png(paste0("analysys_",area,".png"),width=1200,height=1200,pointsize=15)
        par(mfrow=c(2,2))
    }
    for(dsnf in allf){
        ld <- readGPR(dsn=dsnf)
        ld  <- dewow(ld, type = "gaussian", w = 350)
        plot(ld)
    }
    dev.off()
}
    


