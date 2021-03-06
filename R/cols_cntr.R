#' Columns contribution chart
#'
#' This function allows to calculate the contribution of the column categories to the selected dimension.
#' 
#' The function displays the contribution of the categories as a dotplot. A reference line indicates the threshold above which a contribution can be considered important for the determination of the selected dimension. 
#' The parameter sort=TRUE sorts the categories in descending order of contribution to the inertia of the selected dimension. 
#' At the left-hand side of the plot, the categories' labels are given a symbol (+ or -) according to wheather each category is actually contributing to the definition of the positive or negative side of the dimension, respectively.
#' The categories are grouped into two groups: 'major' and 'minor' contributors to the inertia of the selected dimension. 
#' At the right-hand side, a legend (which is enabled/disabled using the 'leg' parameter) reports the correlation (sqrt(COS2)) of the row categories with the selected dimension. A symbol (+ or -) indicates with which side of the selected dimension each row category is correlated.
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: dimension for which the column categories contribution is returned (1st dimension by default).
#' @param sort: logical value (TRUE/FALSE) which allows to sort the categories in descending order of contribution to the inertia of the selected dimension. TRUE is set by default.
#' @param corr.thrs: threshold above which the row categories correlation will be displayed in the plot's legend.
#' @param leg: enable (TRUE; default) or disable (FALSE) the legend at the right-hand side of the dotplot.
#' @param cex.labls: adjust the size of the dotplot's labels.
#' @param dotprightm: increases the empty space between the right margin of the dotplot and the left margin of the legend box.
#' @param cex.leg: adjust the size of the legend's characters.
#' @param leg.x.spc: adjust the horizontal space of the chart's legend. See more info from the 'legend' function's help (?legend).
#' @param leg.y.spc: adjust the y interspace of the chart's legend. See more info from the 'legend' function's help (?legend).
#' @keywords columns contribution
#' @export
#' @examples
#' data(greenacre_data)
#' cols.cntr(greenacre_data, 2, cti=TRUE, sort=TRUE) # Plots the contribution of the column categories to the 2nd CA dimension, and also displays the contribution to the total inertia. The categories are sorted in descending order of contribution to the inertia of the selected dimension.
#'  
cols.cntr <- function (data, x = 1, sort = TRUE, corr.thrs=0.0, leg=TRUE, cex.labls=0.75, dotprightm=5, cex.leg=0.6, leg.x.spc=1, leg.y.spc=1){
  ncols <- ncol(data)
  cadataframe <- CA(data, graph = FALSE)
  res.ca <- summary(ca(data))
  df <- data.frame(cntr = cadataframe$col$contrib[, x] * 10, cntr.tot = res.ca$columns[, 4], coord=cadataframe$col$coord[,x])
  df$labels <- ifelse(df$coord<0,paste(rownames(df), " -", sep = ""), paste(rownames(df), " +", sep = ""))
  df.row.corr <- data.frame(coord=cadataframe$row$coord[,x], corr=round(sqrt(cadataframe$row$cos2[,x]), 3))
  df.row.corr$labels <- ifelse(df.row.corr$coord<0,paste(rownames(df.row.corr), " - ", sep = ""), paste(rownames(df.row.corr), " + ", sep = ""))
  df.row.corr$specif <- paste0(df.row.corr$labels, "(", df.row.corr$corr, ")")
  ifelse(corr.thrs==0.0, df.row.corr <- df.row.corr, df.row.corr <- subset(df.row.corr, corr>=corr.thrs))
  ifelse(sort == TRUE, df.to.use <- df[order(-df$cntr), ], df.to.use <- df)
  df.to.use$majcontr <- ifelse(df.to.use$cntr>round(((100/ncols) * 10)), "maj. contr.", "min. contr.")
  if(leg==TRUE){ 
    par(oma=c(0,0,0,dotprightm))
  } else {}
  dotchart2(df.to.use$cntr, 
            labels = df.to.use$labels,
            groups=df.to.use$majcontr,
            sort = FALSE, 
            lty = 2, 
            xlim = c(0, 1000), 
            cex.labels=cex.labls, 
            xlab = paste("Column categories' contribution to Dim. ", x, " (in permills)"))
  if(leg==TRUE){ 
  par(oma=c(0,0,0,0))
  legend(x="topright", 
         legend=df.row.corr[order(-df.row.corr$corr),]$specif, 
         xpd=TRUE, 
         cex=cex.leg, 
         x.intersp = leg.x.spc, 
         y.intersp = leg.y.spc)
  par(oma=c(0,0,0,dotprightm))
  } else {}
  abline(v = round(((100/ncols) * 10), digits = 0), lty = 2, col = "RED")
  par(oma=c(0,0,0,0))
}