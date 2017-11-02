#' Scatterplot for column categories contribution to dimensions
#'
#' This function allows to plot a scatterplot of the contribution of column categories to two selected dimensions. Two references lines (in RED) indicate the threshold above which the contribution can be considered important for the determination of the dimensions. A diagonal line (in BLACK) is a visual aid to eyeball whether a category is actually contributing more (in relative terms) to either of the two dimensions.
#' The column categories' labels are coupled with + or - symbols within round brackets indicating which to side of the two selected dimensions the contribution values that can be read off from the chart are actually referring. 
#' The first symbol (i.e., the one to the left), either + or -, refers to the first of the selected dimensions (i.e., the one reported on the x-axis). The second symbol (i.e., the one to the right) refers to the second of the selected dimensions (i.e., the one reported on the y-axis).   
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: first dimension for which the contributions are reported (x=1 by default).
#' @param y: second dimension for which the contributions are reported (y=2 by default).
#' @param filter: filter the categories in order to only display those who have a major contribution to the definition of the selected dimensions.
#' @param cex.labls: adjust the size of the categories' labels
#' @keywords scatterplot column categories contribution
#' @export
#' @examples
#' data(greenacre_data) #load the sample dataset
#' cols.cntr.scatter(greenacre_data,1,2) #Plots the scatterplot of the column categories contribution to dimensions 1&2.
#' 
cols.cntr.scatter <- function (data, x = 1, y = 2, filter=FALSE, cex.labls=3) {
  ncols <- ncol(data)
  nrows <- nrow(data)
  numb.dim.cols <- ncol(data) - 1
  numb.dim.rows <- nrow(data) - 1
  a <- min(numb.dim.cols, numb.dim.rows)
  pnt_labls <- colnames(data)
  res <- CA(data, ncp = a, graph = FALSE)
  dfr <- data.frame(lab = pnt_labls, cntr1 = res$col$contrib[,x] * 10, cntr2 = res$col$contrib[, y] * 10, coord1=res$col$coord[,x], coord2=res$col$coord[,y])
  dfr$labels1 <- ifelse(dfr$coord1 < 0, "-", "+")
  dfr$labels2 <- ifelse(dfr$coord2 < 0, "-", "+")
  dfr$labels.final <- paste0(dfr$lab, " (",dfr$labels1,",",dfr$labels2, ")")
  xmax <- max(dfr[, 2]) + 10
  ymax <- max(dfr[, 3]) + 10
  limit <- max(xmax, ymax)
  ifelse(filter==FALSE, dfr <- dfr, dfr <- subset(dfr, cntr1>(100/ncols)*10 | cntr2>(100/ncols)*10))
  p <- ggplot(dfr, aes(x = cntr1, y = cntr2)) + geom_point(alpha = 0.8) + 
    geom_hline(yintercept = round((100/ncols) * 10, digits = 0), 
               colour = "red", linetype = "dashed") + geom_vline(xintercept = round((100/ncols) * 10, digits = 0), colour = "red", linetype = "dashed") + 
    scale_y_continuous(limit = c(0, limit)) + scale_x_continuous(limit = c(0,limit)) + geom_abline(intercept = 0, slope = 1) + theme(panel.background = element_rect(fill="white", colour="black")) + 
    geom_text_repel(data = dfr, aes(label = labels.final), size = cex.labls) + labs(x = paste("Column categories' contribution (permills) to Dim.",x), y = paste("Column categories' contribution (permills) to Dim.", y))
  return(p)
}