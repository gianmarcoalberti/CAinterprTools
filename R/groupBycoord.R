#' Define groups of categories on the basis of a selected partition into k groups employing the Jenks' natural break method on the selected dimension's coordinates
#'
#' The function allows to group the row/column categories into k user-defined partitions.
#' 
#' K groups are created employing the Jenks' natural break method applied on the selected dimension's coordinates. 
#' A dotchart is returned representing the categories grouped into the selected partitions. At the bottom of the chart, the Goodness of Fit statistic is also reported.
#' The function also returns a dataframe storing the categories' coordinates on the selected dimension and the group each category belongs to.
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: dimension whose coordinates are used to build the partitions.
#' @param which: speficy if rows ("rows"; default) or columns ("cols") must be grouped.
#' @param cex.labls: set the size of the labels of the dotchart (0.75 by default).
#' @keywords columns contribution
#' @export
#' @examples
#' data(greenacre_data)
#' res <- groupBycoord(greenacre_data, x=1, k=3, which="rows") # divide the row categories into 3 groups on the basis of the coordinates of the 1st dimension, and store the result into a 'res' object
#'  
groupBycoord <- function (data, x=1, k=3, which="rows", cex.labls=0.75){
  res <- CA(data, graph=FALSE)
  ifelse(which=="rows", 
         dtf <- data.frame(categ=row.names(res$row$coord), coord.x=res$row$coord[,x]), 
         dtf <- data.frame(categ=row.names(res$col$coord), coord.x=res$col$coord[,x]))
  dtf <- dtf[order(dtf$coord.x),]
  Jclassif <- classInt::classIntervals(dtf$coord.x, k, style = "jenks")
  GoFtest <- jenks.tests(Jclassif) 
  dtf$group <- as.factor(cut(dtf$coord.x, unique(Jclassif$brks), labels=FALSE, include.lowest=TRUE))
  dotchart2(dtf$coord.x, 
            labels=dtf$categ, 
            groups=as.factor(paste0("group ", dtf$group)), 
            lty=2, 
            cex.labels=cex.labls,
            xlab=paste0("coordinate on the ", x, " dim."),
            main=paste0(ifelse(which=="rows", "Row", "Column"), " categories clustered into ", k, " groups (Jenks' natural breaks on the coord. of the selected dim.)"),
            cex.main=0.90,
            sub=paste0("Goodness of Fit: ", round(GoFtest[2],2)),
            cex.sub=0.7)
  colnames(dtf)[2] <- paste0("coord.", x,".Dim")
  return(subset(dtf, , -c(categ)))
}