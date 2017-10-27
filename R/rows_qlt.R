#' Chart of rows quality of the display
#'
#' This function allows you to calculate the quality of the display of the row categories on pairs of selected dimensions.
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: first dimension for which the quality is calculated (x=1 by default).
#' @param y: second dimension for which the quality is calculated (y=2 by default).
#' @param sort: logical value (TRUE/FALSE) which allows to sort the categories in descending order of quality of the representation on the subspace defined by the selected dimensions. TRUE is set by default.
#' @param cex.labls: adjust the size of the dotplot's labels.
#' @keywords rows quality
#' @export
#' @examples
#' data(greenacre_data)
#' rows.qlt(greenacre_data,1,2,sort=TRUE) #Plots the quality of the display of the row categories on the 1&2 dimensions.
#' 
rows.qlt <- function (data, x=1, y=2,sort=TRUE, cex.labls=0.75){
  cadataframe <- CA(data, graph=FALSE)
  df <- data.frame(qlt=cadataframe$row$cos2[,x]*100+cadataframe$row$cos2[,y]*100, labels=rownames(data))
  ifelse(sort==TRUE, df.to.use <- df[order(-df$qlt),], df.to.use <- df)
  dotchart2(df.to.use$qlt, labels=df.to.use$labels, sort=FALSE,lty=2, xlim=c(0, 100), cex.labels=cex.labls, xlab=paste("Row categories' quality of the display (% of inertia) on Dim.", x, "+", y))
  }