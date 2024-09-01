magnit <-function(sampline){
    cp=fft(sampline)
    sqrt(Im(cp)^2+Re(cp)^2)
}

# Function to safely sum values, including handling of matrix boundaries

filterMatrix <- function(mat){
  # Get dimensions of the matrix
  nrows <- nrow(mat)
  ncols <- ncol(mat)
  
  safeMean <- function(row, col) {
      values <- c()
      # Add current cell value
      values <- c(values, mat[row, col])
      # Add neighbor cells if they exist
      if (row > 1) values <- c(values, mat[row-1, col])  # Top
      if (row < nrows) values <- c(values, mat[row+1, col])  # Bottom
      if (col > 1) values <- c(values, mat[row, col-1])  # Left
      if (col < ncols) values <- c(values, mat[row, col+1])  # Right
      # Return the mean
      return(mean(values))
  }
  # Copy matrix to keep the original unchanged
  result <- matrix(0, nrow = nrows, ncol = ncols)

  # Apply the filter to each cell
  for (row in 1:nrows) {
    for (col in 1:ncols) {
      result[row, col] <- safeMean(row, col)
    }
  }
  
  return(result)
}



getMagnitude <- function(folder,tenSlice=TRUE){
    allfiles=list.files(pattern="output_.*.txt",path=folder,full.names=TRUE)
    if(tenSlice)allres=sapply(allfiles,function(i){tryCatch({data=read.csv(i,sep=" ",header=F);all(nrow(data)==10,ncol(data)==256)},error=function(e)FALSE)})
    else allres=sapply(allfiles,function(i){tryCatch({data=read.csv(i,sep=" ",header=F);all(nrow(data)==10,ncol(data)==256)},error=function(e)FALSE)})
    allproper=lapply(allfiles[allres],function(i)read.csv(i,sep=" ",header=F))
    do.call("cbind",lapply(allproper,apply,1,magnit))
}

image(filterMatrix(log(t(getMagnitude("./"))[,129:1])))


plotOneSector <- function(mainfolder,filter=T){

    allsides=list.dirs(mainfolder)[-1]
    allcomput=lapply(allsides,function(side){
                         if(filter) tryCatch(filterMatrix(getMagnitude(side)),error=function(e)NULL)
                         else tryCatch(getMagnitude(side),error=function(e)NULL)
})
    names(allcomput)=basename(allsides)
    allcomput=allcomput[lengths(allcomput)>0]
    zlim=log(range(allcomput))
    rnd=round(sqrt(length(allcomput)))
    print(allcomput)
    if((rnd*rnd)>length(allcomput))
        par(mfrow=c(rnd,rnd+1))
    else
        par(mfrow=c(rnd,rnd))
    na=lapply(names(allcomput),function(nz)tryCatch(image(log(t(allcomput[[nz]])[,129:1]),zlim=zlim,main=nz),error=function(e)plot.new()))
    return(allcomput)
}
plot(t(lapply(allproper,apply,2,mean)[[1]],type="l"))
apply(allproper[[2]],1,function(u)lines(u,type="l",col="red"))
lines(lapply(allproper,apply,2,mean)[[2]],type="l",col="red")
vec=lapply(allproper,apply,2,mean)[[4]]
fft(vec)
aa=read.csv("output_20240718-120943.txt")
image(log(t(getMagnitude("./test/"))[,129:1]))
image(log(t(getMagnitude("./sector2/"))[,129:1]))
i.mage(log(t(getMagnitude("../../"))[,129:1]))
