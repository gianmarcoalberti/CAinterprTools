#' Chart of rows correlation with a selected dimension
#'
#' This function allows to calculate the correlation (sqrt(COS2)) of the row categories with the selected dimension.
#'  
#' The function displays the correlation of the row categories with the selected dimension; the parameter sort=TRUE arrange the categories in decreasing order of correlation. 
#' At the left-hand side, the categories' labels show a symbol (+ or -) according to which side of the selected dimension they are correlated, either positive or negative. 
#' The categories are grouped into two groups: categories correlated with the positive ('pole +') or negative ('pole -') pole of the selected dimension.
#' At the right-hand side, a legend (which is enabled/disabled using the 'leg' parameter) indicates the column categories' contribution (in permills) to the selected dimension (value enclosed within round brackets), and a symbol (+ or -) indicating whether they are actually contributing to the definition of the positive or negative side of the dimension, respectively. 
#' Further, an asterisk (*) flags the categories which can be considered major contributors to the definition of the dimension.
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: dimension for which the row categories correlation is returned (1st dimension by default).
#' @param sort: logical value (TRUE/FALSE) which allows to sort the categories in descending order of correlation with the selected dimension. TRUE is set by default.
#' @param filter: filter the column categories listed in the top-right legend, only showing those who have a major contribution to the definition of the selected dimension.
#' @param leg: enable (TRUE; default) or disable (FALSE) the legend at the right-hand side of the dotplot.
#' @param dotprightm: increases the empty space between the right margin of the dotplot and the left margin of the legend box.
#' @param cex.leg: adjust the size of the legend's characters.
#' @param cex.labls: adjust the size of the dotplot's labels.
#' @param leg.x.spc: adjust the horizontal space of the chart's legend. See more info from the 'legend' function's help (?legend).
#' @param leg.y.spc: adjust the y interspace of the chart's legend. See more info from the 'legend' function's help (?legend).
#' @keywords rows correlation
#' @export
#' @examples
#' data(greenacre_data)
#' rows.corr(greenacre_data, 1, sort=TRUE) #Plots the correlation of the row categories with the 1st CA dimension.
#' 
rows.corr <- function (data, x = 1, sort = TRUE, filter= FALSE, leg=TRUE, dotprightm=5, cex.leg=0.6, cex.labls=0.75, leg.x.spc=1, leg.y.spc=1) {
  cadataframe <- CA(data, graph = FALSE)
  df <- data.frame(corr = round(sqrt((cadataframe$row$cos2[, x])), digits = 3), coord=cadataframe$row$coord[,x])
  df$labels <- ifelse(df$coord < 0,
                      paste(rownames(df), " - ", sep = ""), 
                      paste(rownames(df), " + ", sep = ""))
  df.col.cntr <- data.frame(coord=cadataframe$col$coord[,x], cntr=(cadataframe$col$contrib[,x]*10))
  df.col.cntr$labels <- ifelse(df.col.cntr$coord < 0,
                               paste(rownames(df.col.cntr), " - ", sep = ""), 
                               paste(rownames(df.col.cntr), " + ", sep = ""))
  df.col.cntr$specif <- ifelse(df.col.cntr$cntr > (100/ncol(data)) * 10, 
                               "*", 
                               "")
  df.col.cntr$specif2 <- paste0(df.col.cntr$specif, df.col.cntr$labels, "(", round(df.col.cntr$cntr,2), ")")
  ifelse(sort == TRUE, 
         df.to.use <- df[order(-df$corr), ], 
         df.to.use <- df)
  df.to.use$pole <- ifelse(df.to.use$coord > 0, 
                           "pole +", 
                           "pole -")
  ifelse(filter== FALSE, 
         df.col.cntr <- df.col.cntr, 
         df.col.cntr <- subset(df.col.cntr, cntr>(100/ncol(data))*10))
  if(leg==TRUE){ 
    par(oma=c(0,0,0,dotprightm))
  } else {}
  dotchart2(df.to.use$corr, 
            labels = df.to.use$labels, 
            groups=df.to.use$pole,
            sort = FALSE,
            lty = 2, 
            xlim = c(0, 1), 
            cex.labels=cex.labls, 
            xlab = paste("Row categories' correlation with Dim. ", x))
  par(oma=c(0,0,0,0))
  if(leg==TRUE){ 
  legend(x="topright", 
         legend=df.col.cntr[order(-df.col.cntr$cntr),]$specif2, 
         xpd=TRUE, 
         cex=cex.leg, 
         x.intersp = leg.x.spc, 
         y.intersp = leg.y.spc)
  } else {}
}