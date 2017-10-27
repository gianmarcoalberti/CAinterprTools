#' Malinvaud's test for significance of the CA dimensions
#'
#' This function allows you to perform the Malinvaud's test, which assesses the significance of the CA dimensions. The function returns both a table in the R console and a plot. The former lists some values, among which the significance of each CA dimension. Dimensions whose p-value is below the 0.05 threshold (displayed in RED in the returned plot) are significant. 
#' @param data: name fo the datset (must be in dataframe format).
#' @keywords Malinvaud test
#' @export
#' @examples
#' data(greenacre_data)
#' malinvaud(greenacre_data)
#' 
malinvaud <- function(data) {
  grandtotal <- sum(data)
  nrows <- nrow(data)
  ncols <- ncol(data)
  numb.dim.cols<-ncol(data)-1
  numb.dim.rows<-nrow(data)-1
  a <- min(numb.dim.cols, numb.dim.rows) #dimensionality of the table
  labs<-c(1:a) #set the number that will be used as x-axis' labels on the scatterplots
  res.ca<-CA(data, ncp=a, graph=FALSE)
  
  malinv.test.rows <- a
  malinv.test.cols <- 6
  malinvt.output <-matrix(ncol= malinv.test.cols, nrow=malinv.test.rows)
  colnames(malinvt.output) <- c("K", "Dimension", "Eigen value", "Chi-square", "df", "p value")
  
  malinvt.output[,1] <- c(0:(a-1))
  malinvt.output[,2] <- c(1:a)
  
  for(i in 1:malinv.test.rows){
    k <- -1+i
    malinvt.output[i,3] <- res.ca$eig[i,1]
    malinvt.output[i,5] <- (nrows-k-1)*(ncols-k-1)
  }
  
  malinvt.output[,4] <- rev(cumsum(rev(malinvt.output[,3])))*grandtotal
  malinvt.output[,6] <- round(pchisq(malinvt.output[,4], malinvt.output[,5], lower.tail=FALSE), digits=6)
  
  print(malinvt.output)
  
  dotchart2(malinvt.output[,6], labels=malinvt.output[,2], sort=FALSE,lty=2, xlim=c(0,1), xlab=paste("p-value after Malinvaud's test"), ylab="Dimensions")
  abline(v=0.05, lty=2, col="RED")
}