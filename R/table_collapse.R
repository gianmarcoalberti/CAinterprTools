#' Collapse rows and columns of a table on the basis of hiererchical clustering
#'
#' This function allows to collapse the rows and columns of the input contingency table on the basis of the results of a hierarchical clustering.\cr
#' The function returns a list containing the input table, the rows-collapsed table, the columns-collapsed table, and a table with both rows and columns collapsed.
#' It optionally returns two dendrograms (one for the row profiles, one for the column profiles) representing the clusters. \cr
#' The hierarchical clustering is obtained using the FactoMineR's 'HCPC()' function.\cr
#' Rationale: clustering rows and/or columns of a table could interest the users who want to know where a "significant association is concentrated" by "collecting together similar rows (or columns) in discrete groups" (Greenacre M, Correspondence Analysis in Practice, Boca Raton-London-New York, Chapman&Hall/CRC 2007, pp. 116, 120).
#' Rows and/or columns are progressively aggregated in a way in which every successive merging produces the smallest change in the table’s inertia. The underlying logic lies in the fact that rows (or columns) whose merging produces a small change in table’s inertia have similar profiles. This procedure can be thought of as maximizing the between-group inertia and minimizing the within-group inertia.\cr
#' A method essentially similar is that provided by the 'FactoMineR' package (Husson F, Le S, Pages J, Exploratory Multivariate Analysis by Example Using R, Boca Raton-London-New York, CRC Press, pp. 177-185). The cluster solution is based on the following rationale: a division into Q (i.e., a given number of) clusters is suggested when the increase in between-group inertia attained when passing from a Q-1 to a Q partition is greater than that from a Q to a Q+1 clusters partition. In other words, during the process of rows (or columns) merging, if the following agggregation raises highly the within-group inertia, it means that at the further step very different profiles are being aggregated.
#' 
#' @param data: name of the datset (must be in dataframe format)
#' @param graph: logical (TRUE/FALSE). It takes TRUE if the user wants the row and colum profiles dendrograms to be produced. 
#' @keywords table hierarchical clustering rows columns collapsing
#' @export
#' @examples
#' data(greenacre_data)
#' res <- table.collapse(greenacre_data, graph=TRUE) #collapse the table, store the results into an object called 'res', and return 2 dendrograms
#' 
table.collapse <- function (data, graph=FALSE) {
  clst.rows <- HCPC(data, nb.clust=-1, cluster.CA="rows", graph=FALSE)
  clst.cols <- HCPC(as.data.frame(t(data)), nb.clust=-1, cluster.CA="rows", graph=FALSE)
  rows.clust <- clst.rows$data.clust
  cols.clust <- clst.cols$data.clust
  
  row.collaps.table <- aggregate(. ~ clust, data=rows.clust, sum)
  row.nms <- tapply(rownames(data), rows.clust$clust, paste, collapse = "-")
  rownames(row.collaps.table) <- row.nms
  final.row.table <- row.collaps.table[-c(1)]
  
  col.collaps.table <- aggregate(. ~ clust, data=cols.clust, sum)
  col.nms <- tapply(colnames(data), cols.clust$clust, paste, collapse = "-")
  rownames(col.collaps.table) <- col.nms
  pre.final.table <- subset(col.collaps.table, select = -c(clust))
  final.col.table <- as.data.frame(t(pre.final.table))
  
  final.col.table$clust <- rows.clust$clust
  collaps.table.all <- aggregate(. ~ clust, data=final.col.table, sum)
  rownames(collaps.table.all) <- row.nms
  collaps.table.all <- collaps.table.all[-c(1)]  
  
  if(graph==TRUE){
    plot(clst.rows, choice="tree") | plot(clst.cols, choice="tree")
  } else {}
  
  results <- list("original.table"=data,
                  "rows.collaps.table"=final.row.table, 
                  "cols.collaps.table" =subset(final.col.table, select = -c(clust)), 
                  "all.collaps.table"=collaps.table.all)
  return(results)
}