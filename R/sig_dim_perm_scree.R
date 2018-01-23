#' Scree plot to test the significance of CA dimensions by means of a randomized procedure
#' 
#' This function allows to test the significance of the CA dimensions by means of permutation of the input contingency table. Number of permutation set at 1000 by default, but can be increased by the user.
#' The function return a scree-plot displaying for each dimension the observed eigenvalue and the 95th percentile of the permuted distribution of the corresponding eigenvalue. Observed eigenvalues that are larger than the corresponding 95th percentile are significant at least at alpha 0.05. P values are displayed into the chart.
#' @param data: name of the contingency table (must be in dataframe format).
#' @param B: number of permutations to be used (1000 by default).
#' @param cex: controls the size of the labels reporting the p values; see the help documentation of the text() function by typing ?text.
#' @param pos: controls the position of the labels reporting the p values; see the help documentation of the text() function by typing ?text.
#' @param offset: controls the offset of the labels reporting the p values; see the help documentation of the text() function by typing ?text.
#' @keywords dimensions significance permutation
#' @export
#' @examples
#' data(greenacre_data)
#' sig.dim.perm.scree(greenacre_data, 10000)
#' 
sig.dim.perm.scree <- function(data, B=1000, cex=0.7, pos=4, offset=0.5){
  options(scipen = 999)
  nIter <- B+1
  numb.dim.cols <- ncol(data) - 1
  numb.dim.rows <- nrow(data) - 1
  table.dim <- min(numb.dim.cols, numb.dim.rows)
  d <- as.data.frame(matrix(nrow=nIter, ncol=table.dim)) 
  res <- CA(data, graph=FALSE)
  d[1,]<- rbind(res$eig[,1])
  pb <- txtProgressBar(min = 0, max = nIter, style = 3)                                     #set the progress bar to be used inside the loop
  for (i in 2:nIter){
    rand.table <- as.data.frame(r2dtable(1, apply(data, 1,sum), apply(data, 2, sum)))  
    res <- CA(rand.table, graph=FALSE)
    d[i,] <- rbind(res$eig[,1])
    setTxtProgressBar(pb, i)
  }
  target.percent <- apply(d[-c(1),],2, quantile, probs = 0.95) #calculate the 95th percentile of the randomized eigenvalues, excluding the first row (which store the observed eigenvalues)
  max.y.lim <- max(d[1,], target.percent)
  obs.eig <- as.matrix(d[1,])
  obs.eig.to.plot <- melt(obs.eig) #requires reshape2
  perm.p.values <- round(colSums(d[-1,] > d[1,][col(d[-1,])]) / B, 4)
  perm.pvalues.to.report <- ifelse(perm.p.values < 0.001, "< 0.001", ifelse(perm.p.values < 0.01, "< 0.01", ifelse(perm.p.values < 0.05, "< 0.05", round(perm.p.values, 3))))
  plot(obs.eig.to.plot$value, type = "o", ylim = c(0, max.y.lim), xaxt = "n", xlab = "Dimensions", ylab = "Eigenvalue", pch=20)
  text(obs.eig.to.plot$value, labels = perm.pvalues.to.report, cex = cex, pos = pos, offset = offset)
  axis(1, at = 1:table.dim)
  title(main = "Correspondence Analysis: \nscree-plot of observed and permuted eigenvalues", sub = paste0("Black dots=observed eigenvalues; blue dots=95th percentile of the permutated eigenvalues' distribution. Number of permutations: ", B), cex.sub = 0.8)
  par(new = TRUE)
  percentile.to.plot <- melt(target.percent)
  plot(percentile.to.plot$value, type = "o", lty = 2, col = "blue", ylim = c(0, max.y.lim), xaxt = "n", xlab = "", ylab = "", sub = "")
  #return(d)
}