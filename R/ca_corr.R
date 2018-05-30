#' Chart of correlation between rows and columns categories
#'
#' This function allows you to calculate the strenght of the correlation between rows and columns of the contingency table. 
#' A reference line indicates the threshold above which the correlation can be considered important.
#' @param data: name of the dataset (must be in dataframe format).
#' @keywords correlation contingency table
#' @export
#' @examples
#' data(greenacre_data)
#' ca.corr(greenacre_data)
#' 
caCorr <- function (data){
  mydataasmatrix<-as.matrix(data)
  dataframe.after.ca<- summary(ca(data))
  perf.corr<-(1.0)
  sqr.trace<-round(sqrt(sum(dataframe.after.ca$scree[,2])), digits=3)
  barplot(c(perf.corr, sqr.trace), main=paste("Correlation coefficient between rows & columns (=square root of the inertia):", sqr.trace), sub="reference line: threshold of important correlation ", ylab="correlation coeff.", names.arg=c("correlation coeff. range", "correlation coeff. bt rows & cols"), cex.main=0.80, cex.sub=0.80, cex.lab=0.80)
  abline(h=0.20)
}