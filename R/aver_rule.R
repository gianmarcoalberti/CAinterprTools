#' Average Rule chart
#'
#' This function allows you to locate the number of dimensions which are important for CA interpretation, according to the so-called average rule. The reference line showing up in the returned histogram indicates the threshold of an optimal dimensionality of the solution according to the average rule.
#' @param data: Name of the dataset (must be in dataframe format).
#' @keywords average rule
#' @export
#' @examples
#' data(greenacre_data)
#' aver.rule(greenacre_data)
#' 
aver.rule <- function (data){
  mydataasmatrix<-as.matrix(data)
  dataframe.after.ca<- summary(ca(data))
  nrows <- nrow(data)
  ncols <- ncol(data)
  c.dim<-round(100/(ncols-1), digits=1)
  r.dim<-round(100/(nrows-1), digits=1)
  thresh.sig.dim<-(max(c.dim, r.dim))
  n.dim.average.rule <- length(which(dataframe.after.ca$scree[,3]>=thresh.sig.dim))
  mydataasmatrix<-as.matrix(data)
  barplot(dataframe.after.ca$scree[,3], xlab="Dimensions", ylab="% of Inertia", names.arg=dataframe.after.ca$scree[,1])
  abline(h=thresh.sig.dim)
  title (main="Percentage of inertia explained by the dimensions", sub="reference line: threshold of an optimal dimensionality of the solution, according to the average rule", cex.main=0.80, cex.sub=0.80)
}