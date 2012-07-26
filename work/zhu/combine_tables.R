#for (j in seq(along=tl)) {
#assign( paste(tl[[j]],"$V3",sep=''), v1)
#assign( paste(tl[[j]],"$V1",sep=''), v2)
#   v <- tl[[j]]
#   plot(col="red",pch="o",get(v)$V3, get(v)$V1, xlab=parse(text=v), ylab="V1-V3")
#}
x <- 1:20
for (k in seq(along=x)) {
    pat <- paste("s\\d+t",x[k],"$",sep='')
    tl = ls(pattern=pat)
    y <- get(tl[[1]])
    for (j in seq(2:length(tl))) {
        y <- rbind(y,get(tl[[j]]))
    }
    t_name <- paste("allt",x[k],sep='')
    assign(t_name, y)
}
rm(y, x, t_name,j ,k,pat, tl)
