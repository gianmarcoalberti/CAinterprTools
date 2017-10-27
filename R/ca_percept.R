#' Perceptual map-like Correspondence Analysis scatterplot
#'
#' This command allows to plot a variant of the traditional Correspondence Analysis scatterplots that allows facilitating the interpretation of the results. It aims at producing what in marketing research is called perceptual map, a visual representation of the CA results that seeks to avoid the problem of interpreting inter-spatial distance. 
#' It represents only one type of points (say, column points), and "gives names to the axes" corresponding to the major row category contributors to the two selected dimensions.
#' @param data: contingency table, in dataframe format.
#' @param x: first dimensions to be plotted.
#' @param y: second dimensions to be plotted.
#' @param focus: takes "row" (default) if the interest is in assessing the contribution of the rows to the definition of the dimensions, "col" if the interest is on the columns.
#' @param dim.corr: dimension for which the points' correlation (column points if focus is set to "row", row points if focus is set to "col") will be computed and used as input value for the size of the points. The default value is the smaller of the two input dimensions (i.e., x).
#' @param guide: TRUE or FALSE (default) if the user does or doesn't want the points being given a color code indicating with which of the two selected dimension they have a higher relative correlation.
#' @param size.labls: adjust the size of the characters used in the labels that give names to the axes.
#' @keywords perceptual map
#' @export
#' @examples
#' #data(brand_coffee)
#' #ca.percept(brand_coffee,1,2,focus="col",dim.corr=1, guide=FALSE)
#' #In the returned plot, axes are given names according to the major contributing column categories (i.e., coffee brands in this datset), while the points correspond to the row categories (i.e., attributes). Points' size is proportional to the correlation of points with the 1st dimension.
#' #If 'guide' is set to TRUE, the returned plot is similar to the preceding one, but the points are given colour according to whether they are more correlated (in relative terms) to the first or to the second of the selected dimensions. In this example, points flagged with "->Dim 1" are more correlated to the 1st dimension, while those flagged with "->Dim 2" have a higher correlation with the 2nd dimension.
ca.percept <- function (data, x = 1, y = 2, focus="row", dim.corr=x, guide=FALSE, size.labls=3) {
  ncols <- ncol(data)
  nrows <- nrow(data)
  numb.dim.cols <- ncol(data) - 1
  numb.dim.rows <- nrow(data) - 1
  a <- min(numb.dim.cols, numb.dim.rows)
  res <- CA(data, ncp=a, graph=FALSE)
  percent.inr.xdim <- round(res$eig[x,2], digits=2)
  percent.inr.ydim <- round(res$eig[y,2], digits=2)
  
  if (focus=="col") {
    pnt_labls <- colnames(data)
    title <- paste("CA scatterplot: row points' correlation with Dim.", dim.corr,", and major column categories contributors (red)")
  } else {
    pnt_labls <- rownames(data)
    title <- paste("CA scatterplot: column points' correlation with Dim.", dim.corr, ", and major row categories contributors (red)")
  }
  
  if (focus=="col") {
    dfr <- data.frame(lab=pnt_labls,coord1=res$col$coord[,x], cntr1=res$col$contrib[,x], coord2=res$col$coord[,y], cntr2=res$col$contrib[,y])
    dfr.to.plot <- data.frame(coord1=res$row$coord[,x],coord2=res$row$coord[,y], corr=sqrt(res$row$cos2[,dim.corr]), corr.b=sqrt(res$row$cos2[,ifelse(dim.corr==x,y,x)]))
    col.data <<- dfr
    row.data <<- dfr.to.plot
  } else {
    dfr <- data.frame(lab = pnt_labls,coord1=res$row$coord[,x], cntr1=res$row$contrib[,x], coord2=res$row$coord[,y], cntr2=res$row$contrib[,y])
    dfr.to.plot <- data.frame(coord1=res$col$coord[,x],coord2=res$col$coord[,y], corr=sqrt(res$col$cos2[,dim.corr]), corr.b=sqrt(res$col$cos2[,ifelse(dim.corr==x,y,x)]))
    row.data <<- dfr
    col.data <<- dfr.to.plot
  }
  
  if (guide==TRUE) {
    dfr.to.plot$corr_guide <- ifelse(dfr.to.plot$corr>dfr.to.plot$corr.b,paste("->Dim",dim.corr), paste("->Dim",ifelse(dim.corr==x,y,x)))
  } else {}
  
  cntr.thresh <- ifelse(focus=="col", 100/ncols, 100/nrows)
  
  sub1 <- paste(subset(dfr, coord1<0 & cntr1>cntr.thresh)[,1], collapse="\n")
  sub2 <- paste(subset(dfr, coord1>0 & cntr1>cntr.thresh)[,1], collapse="\n")
  sub3 <- paste(subset(dfr, coord2<0 & cntr2>cntr.thresh)[,1], collapse="\n")
  sub4 <- paste(subset(dfr, coord2>0 & cntr2>cntr.thresh)[,1], collapse="\n")
  
  length.sub1 <- length(subset(dfr, coord1<0 & cntr1>cntr.thresh)[,1])
  length.sub2 <- length(subset(dfr, coord1>0 & cntr1>cntr.thresh)[,1])
  length.sub3 <- length(subset(dfr, coord2<0 & cntr2>cntr.thresh)[,1])
  length.sub4 <- length(subset(dfr, coord2>0 & cntr2>cntr.thresh)[,1])
  
  max.length <- max(length.sub1, length.sub2, length.sub3, length.sub4)
  
  x.neg.lim <- min(dfr.to.plot$coord1)
  x.pos.lim <- max(dfr.to.plot$coord1)
  y.neg.lim <- min(dfr.to.plot$coord2)
  y.pos.lim <- max(dfr.to.plot$coord2)
  
  p <- ggplot(dfr.to.plot, aes(x=coord1, y=coord2)) + theme(panel.background = element_rect(fill="white", colour="black")) + xlab(paste0("Dim.",x," (",percent.inr.xdim,"%)" )) + ylab(paste0("Dim.",y, " (", percent.inr.ydim, "%)")) + geom_hline(yintercept = 0, colour="grey", linetype = "dashed") + geom_vline(xintercept = 0, colour="grey", linetype = "dashed") + geom_label(x=x.neg.lim+0.01, y=0.005, label=sub1, colour = "red", size=size.labls) + geom_label(x=x.pos.lim-0.01, y=0.005, label=sub2, colour="red", size=size.labls) + geom_label(x=0.005, y=y.neg.lim, label=sub3, colour="red",size=size.labls) + geom_label(x=0.005, y=y.pos.lim, label=sub4, colour="red",size=size.labls) + geom_text_repel(data = dfr.to.plot, aes(label = rownames(dfr.to.plot)), size = 2.7, colour = "black", box.padding = unit(0.35, "lines"), point.padding = unit(0.3, "lines")) + ggtitle(title) + theme(plot.title = element_text(size = 12))
  
  if (guide==TRUE) {
    p1 <- p + geom_point(aes(size=corr, colour=corr_guide))
  } else {
    p1 <- p + geom_point(aes(size=corr))
  }
  return(p1)
}