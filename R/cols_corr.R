#' Chart of columns correlation with a selected dimension
#'
#' This function allows to calculate the correlation of the column categories with the selected dimension. 
#' It displays the correlation of the column categories with the selected dimension; the parameter sort=TRUE arrange the categories in decreasing order of correlation. 
#' At the left-hand side, the categories' labels show a symbol (+ or -) according to which side of the selected dimension they are correlated, either positive or negative. 
#' At the right-hand side, a legend indicates the row categories' contribution to the selected dimension (value enclosed within round brackets), and a symbol (+ or -) indicating whether they are actually contributing to the definition of the positive or negative side of the dimension, respectively. 
#' Further, an asterisk (*) flags the categories which can be considered major contributors to the definition of the dimension.
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: dimension for which the column categories correlation is returned (1st dimension by default).
#' @param sort: logical value (TRUE/FALSE) which allows to sort the categories in descending order of correlation with the selected dimension. TRUE is set by default.
#' @param filter: filter the row categories listed in the top-right legend, only showing those who have a major contribution to the definition of the selected dimension.
#' @param dotprightm: increases the empty space between the right margin of the dotplot and the left margin of the legend box.
#' @param cex.leg: adjust the size of the legend's characters.
#' @param cex.labls: adjust the size of the dotplot's labels.
#' @param leg.x.spc: adjust the horizontal space of the chart's legend. See more info from the 'legend' function's help (?legend).
#' @param leg.y.spc: adjust the y interspace of the chart's legend. See more info from the 'legend' function's help (?legend).
#' @keywords cols correlation
#' @export
#' @examples
#' data(greenacre_data)
#' cols.corr(greenacre_data, 1, sort=TRUE) #Plots the correlation of the column categories with the 1st CA dimension.
#' 
cols.corr <- function (data, x = 1, sort = TRUE, filter= FALSE, dotprightm=5, cex.leg=0.6, cex.labls=0.75, leg.x.spc=1, leg.y.spc=1) {
  cadataframe <- CA(data, graph = FALSE)
  df <- data.frame(corr = round(sqrt((cadataframe$col$cos2[, x])), digits = 3), coord=cadataframe$col$coord[,x])
  df$labels <- ifelse(df$coord<0,paste(rownames(df), " - ", sep = ""), paste(rownames(df), " + ", sep = ""))
  df.row.cntr <- data.frame(coord=cadataframe$row$coord[,x], cntr=(cadataframe$row$contrib[,x]*10))
  df.row.cntr$labels <- ifelse(df.row.cntr$coord<0,paste(rownames(df.row.cntr), " - ", sep = ""), paste(rownames(df.row.cntr), " + ", sep = ""))
  df.row.cntr$specif <- ifelse(df.row.cntr$cntr>(100/nrow(data)) * 10, "*", "")
  df.row.cntr$specif2 <- paste0(df.row.cntr$specif, df.row.cntr$labels, "(", round(df.row.cntr$cntr,2), ")")
  ifelse(sort == TRUE, df.to.use <- df[order(-df$corr), ], df.to.use <- df)
  ifelse(filter== FALSE, df.row.cntr <- df.row.cntr, df.row.cntr <- subset(df.row.cntr, cntr>(100/nrow(data))*10))
  par(oma=c(0,0,0,dotprightm))
  dotchart2(df.to.use$corr, labels = df.to.use$labels, sort = FALSE,lty = 2, xlim = c(0, 1), cex.labels=cex.labls, xlab = paste("Column categories' correlation with Dim. ", x))
  par(oma=c(0,0,0,0))
  legend(x="topright", legend=df.row.cntr[order(-df.row.cntr$cntr),]$specif2, xpd=TRUE, cex=cex.leg, x.intersp = leg.x.spc, y.intersp = leg.y.spc)
}