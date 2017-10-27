#' Rows contribution chart
#'
#' This function allows to calculate the contribution of the row categories to the selected dimension. 
#' It displays the contribution of the categories as a dotplot. A reference line indicates the threshold above which a contribution can be considered important for the determination of the selected dimension. 
#' The parameter cti=TRUE specifies that the categories' contribution to the total inertia is also shown (hollow circle). 
#' The parameter sort=TRUE sorts the categories in descending order of contribution to the inertia of the selected dimension. 
#' At the left-hand side of the plot, the categories' labels are given a symbol (+ or -) according to wheather each category is actually contributing to the definition of the positive or negative side of the dimension, respectively. 
#' At the right-hand side, a legend reports the correlation of the column categories with the selected dimension. A symbol (+ or -) indicates with which side of the selected dimension each column category is correlated.
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: dimension for which the row categories contribution is returned (1st dimension by default).
#' @param cti: logical value (TRUE/FALSE) which specifies if the contribution to the total inertia must be displayed as well (FALSE by default).
#' @param sort: logical value (TRUE/FALSE) which allows to sort the categories in descending order of contribution to the inertia of the selected dimension. TRUE is set by default.
#' @param corr.thrs: threshold above which the column categories correlation will be displayed in the plot's legend.
#' @param cex.labls: adjust the size of the dotplot's labels.
#' @param dotprightm: increases the empty space between the right margin of the dotplot and the left margin of the legend box.
#' @param cex.leg: adjust the size of the legend's characters.
#' @param leg.x.spc: adjust the horizontal space of the chart's legend. See more info from the 'legend' function's help (?legend).
#' @param leg.y.spc: adjust the y interspace of the chart's legend. See more info from the 'legend' function's help (?legend).
#' @keywords rows contribution
#' @export
#' @examples
#' data(greenacre_data)
#' rows.cntr(greenacre_data, 2, cti=TRUE, sort=TRUE) # Plots the contribution of the row categories to the 2nd CA dimension, and also displays the contribnution to the total inertia. The categories are sorted in descending order of contribution to the inertia of the selected dimension.
#' 
rows.cntr <- function (data, x = 1, cti = FALSE, sort = TRUE, corr.thrs=0.0, cex.labls=0.75, dotprightm=5, cex.leg=0.6, leg.x.spc=1, leg.y.spc=1){
  nrows <- nrow(data)
  cadataframe <- CA(data, graph = FALSE)
  res.ca <- summary(ca(data))
  df <- data.frame(cntr = cadataframe$row$contrib[, x] * 10, cntr.tot = res.ca$rows[, 4], coord=cadataframe$row$coord[,x])
  df$labels <- ifelse(df$coord<0,paste(rownames(df), " -", sep = ""), paste(rownames(df), " +", sep = ""))
  df.col.corr <- data.frame(coord=cadataframe$col$coord[,x], corr=round(sqrt(cadataframe$col$cos2[,x]), 3))
  df.col.corr$labels <- ifelse(df.col.corr$coord<0,paste(rownames(df.col.corr), " - ", sep = ""), paste(rownames(df.col.corr), " + ", sep = ""))
  df.col.corr$specif <- paste0(df.col.corr$labels, "(", df.col.corr$corr, ")")
  ifelse(corr.thrs==0.0, df.col.corr <- df.col.corr, df.col.corr <- subset(df.col.corr, corr>=corr.thrs))
  ifelse(sort == TRUE, df.to.use <- df[order(-df$cntr), ], df.to.use <- df)
  par(oma=c(0,0,0,dotprightm))
  dotchart2(df.to.use$cntr, labels = df.to.use$labels, sort = FALSE, lty = 2, xlim = c(0, 1000), cex.labels=cex.labls, xlab = paste("Row categories' contribution to Dim. ", x, " (in permills)"))
  par(oma=c(0,0,0,0))
  legend(x="topright", legend=df.col.corr[order(-df.col.corr$corr),]$specif, xpd=TRUE, cex=cex.leg, x.intersp = leg.x.spc, y.intersp = leg.y.spc)
  par(oma=c(0,0,0,dotprightm))
  abline(v = round(((100/nrows) * 10), digits = 0), lty = 2, col = "RED")
  if (cti == T) {
    dotchart2(df.to.use$cntr.tot, pch = 1, xlim = c(0, 1000), add = TRUE)
    title(sub = "note: solid circle=contrib. to the dimension; hollow circle=contrib. to the total inertia", cex.sub = 0.75)
  }
}