#' Permuted significance of CA dimensions
#'
#' This function allows you to calculate the permuted significance of selected CA dimensions. Number of permutation set at 999 by default, but can be increased by the user. 
#' Since the function returns a scatterplot, the function requires that two dimensions are entered.
#' @param data: name of the dataset (must be in dataframe format).
#' @param x: first dimension whose significance is calculated (x=1 by default).
#' @param y: second dimension whose significance is calculated (y=2 by default).
#' @param B: number of permutations (1000 by default).
#' @keywords permuted significance dimensions
#' @export
#' @examples
#' data(greenacre_data)
#' sig.dim.perm(greenacre_data, 1,2) #Returns a scatterplot of the permuted inertia of the 1 CA dimension against the permuted inertia of the 2 CA dimension. Observed inertia of the selected dimensions and 95th percentile of the permuted inertias are also displayed for testing the significance of the observed inertias.
#' 
sig.dim.perm <- function(data, x=1, y=2, B=1000) {
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
  perm.pvalues <- round(colSums(d[-1,] > d[1,][col(d[-1,])]) / B, 4)
  pvalues.toreport <- ifelse(perm.pvalues < 0.001, "< 0.001", ifelse(perm.pvalues < 0.01, "< 0.01", ifelse(perm.pvalues < 0.05, "< 0.05",round(perm.pvalues, 3))))
  plot(d[,x], d[,y], 
       main=" Scatterplot of permuted dimensions' inertia", 
       sub="large red dot: observed inertia", 
       xlab=paste0("inertia of permuted ", x," Dim. (p-value: ", pvalues.toreport[x],")"), 
       ylab=paste0("inertia of permuted ", y," Dim. (p-value: ", pvalues.toreport[y],")"), 
       cex.sub=0.75, 
       pch=20,
       col="#00000088") # hex code for 'black'; last two digits set the transparency
  par(new=TRUE)
  plot(d[1,x], d[1,y], xlim=c(min(d[,x]), max(d[,x])), ylim=c(min(d[,y]), max(d[,y])), pch=20, cex=1.5, col="red", xaxt = "n", xlab = "", ylab = "", sub = "") #add the observed inertia as a large red dot
}