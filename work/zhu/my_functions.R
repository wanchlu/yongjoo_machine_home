my_plot_V1_V_ <- function(table, vlist) {
    attach(table)
    #dev.off()
    if (length(vlist) <= 1) {
        par(mfrow=c(1,1))
    } else if (length(vlist) <= 4) {
        par(mfrow=c(2,2))
    } else if (length(vlist) <= 9) {
        par(mfrow=c(3,3))
    } else if (length(vlist) <= 16) {
        par(mfrow=c(4,4))
    } else {
        par(mfrow=c(5,5))
    }
    for (i in seq(along=vlist)) {
        #v_name <- paste(deparse(substitute(table)),"$V",vlist[[i]],sep='')
        v_name <- paste("V",vlist[[i]],sep='')
        #plot(col="blue",pch="o", get(table)$V1 ~ get(table)$Vget(vlist[[i]]), xlab=(text=v_name))

        plot(col="blue",pch="o", V1 ~ get(v_name))
        # table$Vget(vlist[[i]]))
    }
    detach(table)
}

my_lm_V1_V_ <- function (table, vlist, pl=FALSE) {
    attach(table)
    par(mfrow=c(2,2))
    for (i in seq(along=vlist)) {
        v_name <- paste("V",vlist[[i]],sep='')
        my_lm <-lm( V1 ~ get(v_name))
            print(summary(my_lm))
        if (pl == TRUE) {
            plot(my_lm, xlab=parse(text=v_name))
        }
    }
    detach(table)
}
