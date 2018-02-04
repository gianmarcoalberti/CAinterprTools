#' Rescaling row/column categories coordinates between a minimum and maximum value
#'
#' This function allows to rescale the coordinates of a selected dimension to be constrained between a minimum and a maximum user-defined value.
#' 
#' The rationale of the function is that users may wish to use the coordinates on a given dimension to devise a scale, along the lines of what is accomplished in:\cr
#' Greenacre M 2002, "The Use of Correspondence Analysis in the Exploration of Health Survey Data", Documentos de Trabajo 5, Fundacion BBVA, pp. 7-39\cr
#' The function returns a chart representing the row/column categories against the rescaled coordinates from the selected dimension. A dataframe is also returned containing the original values (i.e., the coordinates) and the corresponding rescaled values.
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: dimension for which the row categories contribution is returned (1st dimension by default).
#' @param which: speficy if rows ("rows", default) or columns ("cols") must be grouped.
#' @param min.v: minimum value of the new scale (0 by default).
#' @param max.v: maximum value of the new scale (100 by default).
#' @keywords
#' @export
#' @examples
#' data(greenacre_data)
#' res <- rescale(greenacre_data, which="rows", min.v=0, max.v=10)
#' 
rescale <- function (data, x=1, which="rows", min.v=0, max.v=100) {
  res <- CA(data, graph=FALSE)
  ifelse(which=="rows",
         coord.x <- res$row$coord[,x],
         coord.x <- res$col$coord[,x])
  resc.v <- ((coord.x-min(coord.x))*(max.v-min.v)/(max(coord.x)-min(coord.x)))+min.v
  df <- data.frame(category=rownames(as.data.frame(coord.x)), orignal.v=coord.x, rescaled.v=resc.v)
  plot(sort(df$rescaled.v), 
       xaxt="n", 
       xlab="categories", 
       ylab=paste0(x, " Dim. rescaled coordinates"), 
       pch=20, 
       type="b",
       main=paste0("Plot of ", ifelse(which=="rows", "row", "column"), " categories against ", x, " Dim. coordinates rescaled between ", min.v, " and ", max.v),
       cex.main=0.95)
  axis(1, at=1:nrow(df), labels=df$category)
  return(subset(df, , -c(category)))
}
