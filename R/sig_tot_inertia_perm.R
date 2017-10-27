#' Permuted significance of the CA total inertia
#'
#' This function allows you to calculate the permuted significance of CA total inertia. Number of permutation set at 1000 by default, but can be increased by the user.
#' @param data: name of the dataset (must be in dataframe format).
#' @param B: number of permutations (1000 by default).
#' @keywords permuted significance total inertia
#' @export
#' @examples
#' data(greenacre_data)
#' sig.tot.inertia.perm(greenacre_data, 10000) #Returns the density curve of the permuted total inertia (using 10000 permutations). Observed total inertia and the 95th percentile of the permuted inertia are also displayed for testing the significance of the observed total inertia.
#'
sig.tot.inertia.perm <- function (data, B = 1000) {
  rowTotals <- rowSums(data)
  colTotals <- colSums(data)
  obs.totinrt <- round(sum(ca(data)$rowinertia), 3)
  tot.inrt <- function(x) sum(ca(x)$rowinertia)
  perm.totinrt <- sapply(r2dtable(1000, rowTotals, colTotals), tot.inrt)
  thresh <- round(quantile(perm.totinrt, c(0.95)), 5)
  perm.p.value <- length(which(perm.totinrt > obs.totinrt)) / B
  p.to.report <- ifelse(perm.p.value < 0.001, "< 0.001", ifelse(perm.p.value < 0.01, "< 0.01", ifelse(perm.p.value < 0.05, "< 0.05", round(perm.p.value, 3))))
  d <- density(perm.totinrt)
  plot(d, xlab = "",
       main = "Kernel density of Correspondence Analysis permuted total inertia", 
       sub = paste0("solid line: obs. inertia (", obs.totinrt, "); dashed line: 95th percentile of the permut. distrib. (",thresh, ")", "\np-value: ", p.to.report, " (number of permutations: ", B, ")"), 
       cex.sub = 0.8)
  polygon(d, col = "#BCD2EE88", border = "blue")
  abline(v = obs.totinrt)
  abline(v = thresh, lty = 2, col = "blue")
  rug(perm.totinrt, col="#0000FF") #hex code for 'blue'; last two digits set the transparency
}