#' Scatterplot for column categories correlation with dimensions
#'
#' This function allows to plot a scatterplot of the correlation (sqrt(COS2)) of column categories with two selected dimensions. A diagonal line (in BLACK) is a visual aid to eyeball whether a category is actually more correlated (in relative terms) to either of the two dimensions.
#' The column categories' labels are coupled with two + or - symbols within round brackets indicating to which side of the two selected dimensions the correlation values that can be read off from the chart are actually referring. 
#' The first symbol (i.e., the one to the left), either + or -, refers to the first of the selected dimensions (i.e., the one reported on the x-axis). The second symbol (i.e., the one to the right) refers to the second of the selected dimensions (i.e., the one reported on the y-axis).  
#' @param data: Name of the dataset (must be in dataframe format).
#' @param x: first dimension for which the correlations are reported (x=1 by default).
#' @param y: second dimension for which the correlations are reported (y=2 by default).
#' @param cex.labls: adjust the size of the categories' labels
#' @keywords scatterplot column categories correlation
#' @export
#' @examples
#' data(greenacre_data) #load the sample dataset
#' cols.corr.scatter(greenacre_data,1,2) #Plots the scatterplot of the column categories correlation with dimensions 1&2.
#' 
cols.corr.scatter <- function (data, x = 1, y = 2, cex.labls=3) {
  ncols <- ncol(data)
  nrows <- nrow(data)
  numb.dim.cols <- ncol(data) - 1
  numb.dim.rows <- nrow(data) - 1
  a <- min(numb.dim.cols, numb.dim.rows)
  pnt_labls <- colnames(data)
  res <- CA(data, ncp = a, graph = FALSE)
  dfr <- data.frame(lab = pnt_labls, corr1 = round(sqrt(res$col$cos2[,x]), digits = 3), corr2 = round(sqrt(res$col$cos2[, y]), digits = 3), coord1=res$col$coord[,x], coord2=res$col$coord[,y])
  dfr$labels1 <- ifelse(dfr$coord1 < 0, "-",  "+")
  dfr$labels2 <- ifelse(dfr$coord2 < 0, "-", "+")
  dfr$labels.final <- paste0(dfr$lab, " (",dfr$labels1,",",dfr$labels2, ")")
  p <- ggplot(dfr, aes(x = corr1, y = corr2)) + geom_point(alpha = 0.8) + scale_y_continuous(limit = c(0, 1)) + scale_x_continuous(limit = c(0,1)) + geom_abline(intercept = 0, slope = 1) + theme(panel.background = element_rect(fill="white", colour="black")) + 
    geom_text_repel(data = dfr, aes(label = labels.final), size = cex.labls) + labs(x = paste("Column categories' correlation with Dim.", x), y = paste("Column categories' correlation with Dim.",y))
  return(p)
}