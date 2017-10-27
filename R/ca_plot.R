#' Intepretation-oriented Correspondence Analysis scatterplots, with informative and flexible (non-overlapping) labels.
#'
#' This function allows to plot different types of CA scatterplots, adding information that are relevant to the CA interpretation. Thanks to the 'ggrepel' package, the labels tends to not overlap so producing a nicely readable chart.
#' 
#' ca.plot() provides the facility to produce: \cr
#' (1) a 'regular' (symmetric) scatterplot, in which points' labels only report the categories' names.
#' 
#' (2) a scatterplot with advanced labels. If the user's interest lies (for instance) in interpreting the rows in the space defined by the column categories, by setting the parameter 'cntr' to "columns" 
#' the columns' labels will be coupled with two asterisks within round brackets; each asterisk (if present) will indicate if the category is a major contributor to the definition of the first selected dimension (if the first asterisk to the left is present) and/or if the same category is also a major contributor to the definition of the second selected dimension (if the asterisk to the right is present). The rows' labels will report the correlation (i.e., sqrt(COS2)) with the selected dimensions; the correlation values are reported between square brackets; the left-hand side value refers to the correlation with the first selected dimensions, while the right-hand side value refers to the correlation with the second selected dimension. If the parameter 'cntr' is set to "rows", the row categories' labels will indicate the contribution, and the column categories' labels will report the correlation values.
#' 
#' (3) a perceptual map, in which axes' poles are given names according to the categories (either rows or columns, as specified by the user) having a major contribution to the definition of the selected dimensions; rows' (or columns') labels will report the correlation with the selected dimensions.
#' 
#' The function returns a dataframe containing data about row and column points: \cr
#' (a) coordinates on the first selected dimension \cr
#' (b) coordinates on the second selected dimension \cr 
#' (c) contribution to the first selected dimension \cr
#' (d) contribution to the second selected dimension \cr
#' (e) quality on the first selected dimension \cr
#' (f) quality on the second selected dimension \cr
#' (g) correlation with the first selected dimension \cr
#' (h) correlation with the second selected dimension \cr
#' (j) (k) asterisks indicating whether the corresponding category is a major contribution to the first and/or second selected dimension.
#' @param data: contingency table, in dataframe format.
#' @param x: first of the two desired dimensions to be plotted. 1 is the default.
#' @param y: second of the two desired dimensions to be plotted. 2 is the default.
#' @param adv.labls: logical value, which takes TRUE (default) or FALSE if the user wants or does not want advanced labels to be displayed.
#' @param cntr: if adv.labls is TRUE, the 'cntr' parameter takes "rows" or "columns" if the user wants the rows' or columns' contribution to the selected dimensions to be shown in the scatterplot.
#' @param percept: takes TRUE or FALSE (default) if the user does or doesn't want the scatterplot to be turned into a perceptual map.
#' @param qlt.thres: sets the quality of the display's threshold under which points will not be given labels. NULL is the default.
#' @param dot.size: sets the size of the scatterplot's dots. 2.5 is the default.
#' @param cex.labls: sets the size of the scatterplot dots' labels. 3 is the default.
#' @param cex.percept: sets the size of the characters displayed in the axes' labels featuring the perceptual map. 3 is the default.
#' @keywords correspondence analysis scatterplot advanced labelling
#' @export
#' @examples
#' #data(brand_coffee)
#' #res <- ca.plot(brand_coffee,1,2,adv.labls=FALSE)
#' #displays a 'regular' (symmetric) CA scatterplot, with row and column categories displayed in the same space, and with points' labels just reporting the categories' names. Relevant information (see description above) are stored in the variable 'res'.
#'
#' #ca.plot(brand_coffee,1,2,cntr="columns")
#' #displays the CA scatterplot, with the columns' labels indicating which category has a major contribution to the definition of the selected dimensions. Rows' labels report the correlation (i.e., sqrt(COS2)) with the selected dimensions.
#'
#' #ca.plot(brand_coffee,1,2,cntr="rows")
#' #displays the CA scatterplot, with the rows' labels indicating which category has a major contribution to the definition of the selected dimensions. Columns' labels report the correlation (i.e., sqrt(COS2)) with the selected dimensions.
#'
#' #ca.plot(brand_coffee,1,2,cntr="columns", percept=TRUE)
#' #displays the CA scatterplot as a perceptual map; the poles of the selected dimensions will be given names according to the column categories that have a major contribution to the definition of the selected dimensions. Rows' labels report the correlation (i.e., sqrt(COS2)) with the selected dimensions.
ca.plot <- function(data, x=1, y=2, adv.labls=TRUE, cntr="columns", percept=FALSE, qlt.thres=NULL, dot.size=2.5, cex.labls=3, cex.percept=3) {
  dimensionality <- min(ncol(data), nrow(data))-1 
  ca.res <- CA(data, ncp=dimensionality, graph=FALSE)
  
  dtf.rows <- data.frame(Categories="rows", labls=row.names(ca.res$row$coord), coord.x=ca.res$row$coord[,x], coord.y=ca.res$row$coord[,y], cntr.x=ca.res$row$contrib[,x], cntr.y=ca.res$row$contrib[,y], qlt.x= ca.res$row$cos2[,x], qlt.y=ca.res$row$cos2[,y], corr.x=sqrt(ca.res$row$cos2[,x]), corr.y=sqrt(ca.res$row$cos2[,y]))
  dtf.cols <- data.frame(Categories="columns", labls=row.names(ca.res$col$coord), coord.x=ca.res$col$coord[,x], coord.y=ca.res$col$coord[,y], cntr.x=ca.res$col$contrib[,x], cntr.y=ca.res$col$contrib[,y], qlt.x= ca.res$col$cos2[,x], qlt.y=ca.res$col$cos2[,y], corr.x=sqrt(ca.res$col$cos2[,x]), corr.y=sqrt(ca.res$col$cos2[,y]))
  
  if(cntr=="columns"){
    dtf.cols$majorcntr.x <- ifelse(dtf.cols$cntr.x>100/ncol(data), "*","") 
    dtf.cols$majorcntr.y <- ifelse(dtf.cols$cntr.y>100/ncol(data), "*","")
    dtf.cols$labls.final <- ifelse(dtf.cols$majorcntr.x == "" & dtf.cols$majorcntr.y == "", rownames(dtf.cols), paste0(dtf.cols$labls, " (", dtf.cols$majorcntr.x, ",",dtf.cols$majorcntr.y, ")"))
    
    dtf.rows$majorcntr.x <- ""
    dtf.rows$majorcntr.y <- ""
    dtf.rows$labls.final <- paste0(dtf.rows$labls, "\n[", round(dtf.rows$corr.x, 2), ", ", round(dtf.rows$corr.y, 2), "]")
    
  } else {
    dtf.rows$majorcntr.x <- ifelse(dtf.rows$cntr.x>100/nrow(data), "*","") 
    dtf.rows$majorcntr.y <- ifelse(dtf.rows$cntr.y>100/nrow(data), "*","")
    dtf.rows$labls.final <- ifelse(dtf.rows$majorcntr.x == "" & dtf.rows$majorcntr.y == "", rownames(dtf.rows), paste0(dtf.rows$labls, " (", dtf.rows$majorcntr.x, ",",dtf.rows$majorcntr.y, ")"))
    
    dtf.cols$majorcntr.x <- ""
    dtf.cols$majorcntr.y <- ""
    dtf.cols$labls.final <- paste0(dtf.cols$labls, "\n[", round(dtf.cols$corr.x, 2), ", ", round(dtf.cols$corr.y, 2), "]")
  }
  
  binded.dtf <- rbind(dtf.rows, dtf.cols)
  binded.dtf$qlt.sum <- binded.dtf$qlt.x + binded.dtf$qlt.y
  
  if(percept==TRUE){
    cntr.thresh <- ifelse(cntr == "columns", 100 / ncol(data), 100 / nrow(data))
    
    if(cntr=="columns"){
      binded.dtf$labls.final[(nrow(data)+1):nrow(binded.dtf)] <- colnames(data)
    } else {
      binded.dtf$labls.final[1:nrow(data)]  <- rownames(data)
    }
    
    bindeddtf.subs <- binded.dtf[which(binded.dtf$Categories == cntr),]
    sub1 <- paste(subset(bindeddtf.subs, coord.x < 0 & cntr.x > cntr.thresh)[,2], collapse = "\n")
    sub2 <- paste(subset(bindeddtf.subs, coord.x > 0 & cntr.x > cntr.thresh)[,2], collapse = "\n")
    sub3 <- paste(subset(bindeddtf.subs, coord.y < 0 & cntr.y > cntr.thresh)[,2], collapse = "\n")
    sub4 <- paste(subset(bindeddtf.subs, coord.y > 0 & cntr.y > cntr.thresh)[,2], collapse = "\n")
    x.neg.lim <- min(subset(binded.dtf, Categories!=cntr)$coord.x) # get the min and max coordinates of the space in which one has to represent the categories opposite than the one selected under 'cntr'
    x.pos.lim <- max(subset(binded.dtf, Categories!=cntr)$coord.x)
    y.neg.lim <- min(subset(binded.dtf, Categories!=cntr)$coord.y)
    y.pos.lim <- max(subset(binded.dtf, Categories!=cntr)$coord.y)
    p <- ggplot(subset(binded.dtf, Categories!=cntr), aes(x=coord.x, y=coord.y)) + 
      geom_point(aes(colour=Categories, shape=Categories), size=dot.size) + 
      geom_vline(xintercept = 0, linetype=2, color="gray") + 
      geom_hline(yintercept = 0, linetype=2, color="gray") + 
      geom_text_repel(data=subset(binded.dtf, Categories!=cntr), aes(colour=Categories, label = labls.final), size = cex.labls) +
      labs(x=paste0("Dim. ", x, " (", round(ca.res$eig[x,1],3), "; ", round(ca.res$eig[x,2],2), "%)"), y=paste0("Dim. ", y, " (", round(ca.res$eig[y,1],3), "; ", round(ca.res$eig[y,2],2), "%)"))  +  
      theme(panel.background = element_rect(fill="white", colour="black")) + scale_color_manual(values=c("black", "red")) + 
      geom_label(x = x.neg.lim + 0.01, y = 0.005, label = sub1, colour = "red", size = cex.percept) +
      geom_label(x = x.pos.lim - 0.01, y = 0.005, label = sub2,colour = "red", size = cex.percept) +
      geom_label(x = 0.005, y = y.neg.lim, label = sub3, colour = "red", size = cex.percept) +
      geom_label(x = 0.005, y = y.pos.lim, label = sub4, colour = "red", size = cex.percept) + 
      coord_fixed(ratio = 1, xlim = NULL, ylim = NULL, expand = TRUE)
    print(p)
    colnames(binded.dtf) <- sub("x", paste0(as.character(x),"Dim"), colnames(binded.dtf))
    colnames(binded.dtf) <- sub("y", paste0(as.character(y),"Dim"), colnames(binded.dtf))
    return(subset(binded.dtf, , -c(labls, labls.final, qlt.sum)))
    
  } else {
    
    if(adv.labls==TRUE){
      p <- ggplot(binded.dtf, aes(x=coord.x, y=coord.y)) + 
        geom_point(aes(colour=Categories, shape=Categories), size=dot.size) + 
        geom_vline(xintercept = 0, linetype=2, color="gray") + 
        geom_hline(yintercept = 0, linetype=2, color="gray") + 
        labs(x=paste0("Dim. ", x, " (", round(ca.res$eig[x,1],3), "; ", round(ca.res$eig[x,2],2), "%)"), y=paste0("Dim. ", y, " (", round(ca.res$eig[y,1],3), "; ", round(ca.res$eig[y,2],2), "%)"))  +  
        theme(panel.background = element_rect(fill="white", colour="black")) + scale_color_manual(values=c("black", "red")) + 
        coord_fixed(ratio = 1, xlim = NULL, ylim = NULL, expand = TRUE)
      if(is.null(qlt.thres)){
        p1 <- p + geom_text_repel(data=binded.dtf, aes(colour=Categories, label = labls.final), size = cex.labls) 
      } else {
        p1 <- p + geom_text_repel(data=binded.dtf[which(binded.dtf$qlt.sum > qlt.thres),], aes(colour=Categories, label = labls.final), size = cex.labls)
      }
      print(p1)
      colnames(binded.dtf) <- sub("x", paste0(as.character(x),"Dim"), colnames(binded.dtf))
      colnames(binded.dtf) <- sub("y", paste0(as.character(y),"Dim"), colnames(binded.dtf))
      return(subset(binded.dtf, , -c(labls, labls.final, qlt.sum)))
    } else {
      p <- ggplot(binded.dtf, aes(x=coord.x, y=coord.y)) + 
        geom_point(aes(colour=Categories, shape=Categories), size=dot.size) +
        geom_vline(xintercept = 0, linetype=2, color="gray") + 
        geom_hline(yintercept = 0, linetype=2, color="gray") + 
        labs(x=paste0("Dim. ", x, " (", round(ca.res$eig[x,1],3), "; ", round(ca.res$eig[x,2],2), "%)"), y=paste0("Dim. ", y, " (", round(ca.res$eig[y,1],3), "; ", round(ca.res$eig[y,2],2), "%)"))  +  
        theme(panel.background = element_rect(fill="white", colour="black")) + 
        scale_color_manual(values=c("black", "red")) + 
        coord_fixed(ratio = 1, xlim = NULL, ylim = NULL, expand = TRUE)
      if(is.null(qlt.thres)){
        p1 <- p + geom_text_repel(data=binded.dtf, aes(colour=Categories, label = labls), size = cex.labls)
      } else {
        p1 <- p + geom_text_repel(data=binded.dtf[which(binded.dtf$qlt.sum > qlt.thres),], aes(colour=Categories, label = labls), size = cex.labls)
      }
      print(p1)
      colnames(binded.dtf) <- sub("x", paste0(as.character(x),"Dim"), colnames(binded.dtf))
      colnames(binded.dtf) <- sub("y", paste0(as.character(y),"Dim"), colnames(binded.dtf))
      return(subset(binded.dtf, , -c(labls, labls.final, qlt.sum)))
    }
  }
}