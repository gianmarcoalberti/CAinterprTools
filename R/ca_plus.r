#' Facility for interpretation-oriented CA scatterplot
#' 
#' This function allows to plot Correspondence Analysis scatterplots modified to help interpreting the analysis' results. 
#' In particular, the function aims at making easier to understand in the same visual context (a) which (say, column) categories are actually contributing to the definition of given pairs of dimensions, and (b) to eyeball which (say, row) categories are more correlated to which dimension.
#' @param data: object returned by the FactoMineR's CA() function (see example provided below); if supplementary data (i.e., rows and/or columns) are present, when using CA(), the analyst has to use the proper settings required by that function.
#' @param x: first dimensions to be plotted (x=1 by default).
#' @param y: second dimensions to be plotted (y=2 by default).
#' @param focus: takes "R" if the interest is in assessing the contribution of rows to the definition of the dimensions, "C" if the interest is on the columns. 
#' @param row.suppl: takes TRUE or FALSE if supplementary row data are present or absent (FALSE is the default value).
#' @param col.suppl: takes TRUE or FALSE if supplementary column data are present or absent (FALSE is the default value).
#' @param oneplot: takes TRUE or FALSE if the analyst wants the four returned charts on the same page (recommended) or on four separate windows (FALSE is the default value).
#' @param inches: numerical value used to resize the size of the points' bubbles (see below); the default value is 0.35.
#' @param cex: numerical value used to set the size of labels' font; the default value is 0.50.
#' @keywords correspondence analysis scatterplots
#' @export
#' @examples
#' data(greenacre_data)
#' resCA <- CA(greeacre_data, graph=FALSE) #performs CA by means of FactoMineR's CA command, and store the result in the object named resCA. If supplementary data are present, the user has to specify which rows and/or columns are supplmentary into this function (see FactoMineR's documentation).
#' caPlus(resCA, 1, 2, focus="C", row.suppl="FALSE", col.suppl="FALSE", oneplot="TRUE")
#' 
caPlus <- function(data, x=1, y=2, focus, row.suppl=FALSE, col.suppl=FALSE, oneplot=FALSE, inches=0.35, cex=0.5){
  inrt.perc.x <- round(data$eig[x,2],1)
  inrt.perc.y <- round(data$eig[y,2],1)
  if (focus=="R") {
    cntr.x <- data$row$contrib[,x]
    cntr.y <- data$row$contrib[,y]
    coord.row.x <- data$row$coord[,x]
    coord.row.y <- data$row$coord[,y]
    if (col.suppl=="FALSE") {
    coord.col.x <- data$col$coord[,x]
    coord.col.y <- data$col$coord[,y]
    corr.x <- sqrt(data$col$cos2[,x])
    corr.y <- sqrt(data$col$cos2[,y])
    labs.col <- rownames(data$col$cos2)
    } else {
      coord.col.x <- rbind(data$col$coord, data$col.sup$coord)[,x]
      coord.col.y <- rbind(data$col$coord, data$col.sup$coord)[,y]
      corr.x <- sqrt(rbind(data$col$cos2, data$col.sup$cos2))[,x]
      corr.y <- sqrt(rbind(data$col$cos2, data$col.sup$cos2))[,y]
      labs.col <- rownames(rbind(data$col$cos2, data$col.sup$cos2))
    }
    radius.cntr.x <- sqrt(cntr.x/pi)
    radius.cntr.y <- sqrt(cntr.y/pi)
    radius.corr.x <- sqrt(corr.x/pi)
    radius.corr.y <- sqrt(corr.y/pi)
    labs.row <- rownames(data$row$contrib)
    title.cntr.x <- paste("CA rows scatterplot: points proportional to the contrib. to Dim", x)
    title.cntr.y <- paste("CA rows scatterplot: points proportional to the contrib. to Dim", y)
    title.corr.x <- paste("CA columns scatterplot: points proportional to the correl. with Dim", x)
    title.corr.y <- paste("CA columns scatterplot: points proportional to the correl. with Dim", y)
    
    if (oneplot=="TRUE") {
      par(mfrow=c(2,2))
    } else {}
    
    symbols(coord.row.x, coord.row.y, circles=radius.cntr.x, inches=inches, fg="white", bg="red", xlab=paste("Dim",x," (", inrt.perc.x, "%)"), ylab=paste("Dim",y, " (", inrt.perc.y, "%)"), main=title.cntr.x, cex.main=0.70)
    text(coord.row.x, coord.row.y, labs.row, cex=cex)
    abline(v=0, lty=2, col="grey")
    abline(h=0, lty=2, col="grey")
    if (row.suppl=="TRUE") {
      points(data$row.sup$coord[,x],data$row.sup$coord[,y])
      text(data$row.sup$coord[,x],data$row.sup$coord[,y], rownames(data$row.sup$coord), cex=cex, pos=3)
    } else {}
    symbols(coord.row.x, coord.row.y, circles=radius.cntr.y, inches=inches, fg="white", bg="red", xlab=paste("Dim",x," (", inrt.perc.x, "%)"), ylab=paste("Dim",y, " (", inrt.perc.y, "%)"), main=title.cntr.y, cex.main=0.70)
    text(coord.row.x, coord.row.y, labs.row, cex=cex)
    abline(v=0, lty=2, col="grey")
    abline(h=0, lty=2, col="grey")
    if (row.suppl=="TRUE") {
      points(data$row.sup$coord[,x],data$row.sup$coord[,y])
      text(data$row.sup$coord[,x],data$row.sup$coord[,y], rownames(data$row.sup$coord), cex=cex, pos=3)
    } else {}
    
    symbols(coord.col.x, coord.col.y, circles=radius.corr.x, inches=inches, fg="white", bg="green", xlab=paste("Dim",x," (", inrt.perc.x, "%)"), ylab=paste("Dim",y, " (", inrt.perc.y, "%)"), main=title.corr.x, cex.main=0.70)
    text(coord.col.x, coord.col.y, labs.col, cex=cex)
    abline(v=0, lty=2, col="grey")
    abline(h=0, lty=2, col="grey")
    symbols(coord.col.x, coord.col.y, circles=radius.corr.y, inches=inches, fg="white", bg="green", xlab=paste("Dim",x," (", inrt.perc.x, "%)"), ylab=paste("Dim",y, " (", inrt.perc.y, "%)"), main=title.corr.y, cex.main=0.70)
    text(coord.col.x, coord.col.y, labs.col, cex=cex)
    abline(v=0, lty=2, col="grey")
    abline(h=0, lty=2, col="grey")
    
    par(mfrow=c(1,1))
    
  } else {
    cntr.x <- data$col$contrib[,x]
    cntr.y <- data$col$contrib[,y]
    coord.col.x <- data$col$coord[,x]
    coord.col.y <- data$col$coord[,y]
    if (row.suppl=="FALSE") {
    coord.row.x <- data$row$coord[,x]
    coord.row.y <- data$row$coord[,y]
    corr.x <- sqrt(data$row$cos2[,x])
    corr.y <- sqrt(data$row$cos2[,y])
    labs.row <- rownames(data$row$cos2)
    } else {
      coord.row.x <- rbind(data$row$coord, data$row.sup$coord)[,x]
      coord.row.y <- rbind(data$row$coord, data$row.sup$coord)[,y]
      corr.x <- sqrt(rbind(data$row$cos2, data$row.sup$cos2))[,x]
      corr.y <- sqrt(rbind(data$row$cos2, data$row.sup$cos2))[,y]
      labs.row <- rownames(rbind(data$row$cos2, data$row.sup$cos2))
    }
    radius.cntr.x <- sqrt(cntr.x/pi)
    radius.cntr.y <- sqrt(cntr.y/pi)
    radius.corr.x <- sqrt(corr.x/pi)
    radius.corr.y <- sqrt(corr.y/pi)
    labs.col <- rownames(data$col$contrib)
    title.cntr.x <- paste("CA cols scatterplot: points proportional to the contrib. to Dim", x)
    title.cntr.y <- paste("CA cols scatterplot: points proportional to the contrib. to Dim", y)
    title.corr.x <- paste("CA rows scatterplot: points proportional to the correl. with Dim", x)
    title.corr.y <- paste("CA rows scatterplot: points proportional to the correl. with Dim", y)
    
    if (oneplot=="TRUE") {
      par(mfrow=c(2,2))
    } else {}
    
    symbols(coord.col.x, coord.col.y, circles=radius.cntr.x, inches=inches, fg="white", bg="red", xlab=paste("Dim",x," (", inrt.perc.x, "%)"), ylab=paste("Dim",y, " (", inrt.perc.y, "%)"), main=title.cntr.x, cex.main=0.70)
    text(coord.col.x, coord.col.y, labs.col, cex=cex)
    abline(v=0, lty=2, col="grey")
    abline(h=0, lty=2, col="grey")
    if (col.suppl=="TRUE") {
      points(data$col.sup$coord[,x],data$col.sup$coord[,y])
      text(data$col.sup$coord[,x],data$col.sup$coord[,y], rownames(data$col.sup$coord), cex=cex, pos=3)
    } else {}
    symbols(coord.col.x, coord.col.y, circles=radius.cntr.y, inches=inches, fg="white", bg="red", xlab=paste("Dim",x," (", inrt.perc.x, "%)"), ylab=paste("Dim",y, " (", inrt.perc.y, "%)"), main=title.cntr.y, cex.main=0.70)
    text(coord.col.x, coord.col.y, labs.col, cex=cex)
    abline(v=0, lty=2, col="grey")
    abline(h=0, lty=2, col="grey")
    if (col.suppl=="TRUE") {
      points(data$col.sup$coord[,x],data$col.sup$coord[,y])
      text(data$col.sup$coord[,x],data$col.sup$coord[,y], rownames(data$col.sup$coord), cex=cex, pos=3)
    } else {}
    
    symbols(coord.row.x, coord.row.y, circles=radius.corr.x, inches=inches, fg="white", bg="green", xlab=paste("Dim",x," (", inrt.perc.x, "%)"), ylab=paste("Dim",y, " (", inrt.perc.y, "%)"), main=title.corr.x, cex.main=0.70)
    text(coord.row.x, coord.row.y, labs.row, cex=cex)
    abline(v=0, lty=2, col="grey")
    abline(h=0, lty=2, col="grey")
    symbols(coord.row.x, coord.row.y, circles=radius.corr.y, inches=inches, fg="white", bg="green", xlab=paste("Dim",x," (", inrt.perc.x, "%)"), ylab=paste("Dim",y, " (", inrt.perc.y, "%)"), main=title.corr.y, cex.main=0.70)
    text(coord.row.x, coord.row.y, labs.row, cex=cex)
    abline(v=0, lty=2, col="grey")
    abline(h=0, lty=2, col="grey")
    
    par(mfrow=c(1,1))
  }
}