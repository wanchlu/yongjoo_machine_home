#!/usr/bin/env r

## create tables named "s*t*", s - sample number, t - train size

dirs <- list.files(pattern="Tue*")
for (i in seq(along=dirs)) {
    files <- list.files (path=dirs[i], pattern="*table",)
    #    print(dirs[[i]])

    for (j in seq(along=files)) {
        var_name <- paste(c("s"), i, files[j], sep='')
        var_name <- gsub("\\.table", "", var_name, perl=TRUE)
        var_name <- gsub("rain", "", var_name, perl=TRUE)
        #        print (var_name)
        x <- read.table (paste(dirs[i], c("/"), files[j], sep=''), sep="\t", header=F)
        assign (var_name, x);
    }
}
rm(dirs,files,i,j,var_name,x)
table_list <- ls()
