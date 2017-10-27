#' Clustering row/column categories on the basis of Correspondence Analysis coordinates from a space of user-defined dimensionality.
#'
#' This function allows to plot the result of cluster analysis performed on the results of Correspondence Analysis, providing the facility to plot a dendrogram, a silouette plot depicting the "quality" of the clustering solution, and a scatterplot with points coded according to the cluster membership.
#' 
#' ca.cluster() provides the facility to perform hierarchical cluster analysis of row and/or column categories on the basis of Correspondence Analysis result.
#' The clustering is based on the row and/or colum categories' coordinates from: \cr
#' (1) a high-dimensional space corresponding to the whole dimensionality of the input contingency table; \cr
#' (2) a high-dimensional space of dimensionality smaller than the full dimensionality of the input dataset; \cr
#' (3) a bi-dimensional space defined by a pair of user-defined dimensions. \cr
#' To obtain (1), the 'dim' parameter must be left in its default value (NULL); \cr
#' To obtain (2), the 'dim' parameter must be given an integer (needless to say, smaller than the full dimensionality of the input data); \cr
#' To obtain (3), the 'dim' parameter must be given a vector (e.g., c(1,3)) specifying the dimensions the user is interested in.
#' 
#' The method by which the distance is calculated is specified using the 'dist.meth' parameter, while the agglomerative method is speficied using the 'aggl.meth' parameter. By default, they are set to "euclidean" and "ward.D2" respectively.
#' 
#' The user may want to specify beforehand the desired number of clusters (i.e., the cluster solution). This is accomplished feeding an integer into the 'part' parameter.
#' A dendrogram (with rectangles indicating the clustering solution), a silhouette plot (indicating the "quality" of the cluster solution), and a CA scatterplot (with points given colours on the basis of their cluster membership) are returned. Please note that, when a high-dimensional space is selected, the scatterplot will  use the first 2 CA dimensions; the user must keep in mind that the clustering based on a higher-dimensional space may not be well reflected on the subspace defined by the first two dimensions only.\cr
#' Also note: \cr
#' -if both row and column categories are subject to the clustering, the column categories will be flagged by an asterisk (*) in the dendrogram (and in the silhouette plot) just to make it easier to identify rows and columns; \cr
#' -the silhouette plot displays the average silhouette width as a dashed vertical line; the dimensionality of the CA space used is reported in the plot's title; if a pair of dimensions has been used, the individual dimensions are reported in the plot's title; \cr
#' -the silhouette plot's labels end with a number indicating the cluster to which each category is closer.
#' 
#' An optimal clustering solution can be obtained setting the 'opt.part' parameter to TRUE. The optimal partition is selected by means of an iterative routine which locates at which cluster solution the highest average silhouette width is achieved.
#' If the 'opt.part' parameter is set to TRUE, an additional plot is returned along with the silhouette plot. It displays a scatterplot in which the cluster solution (x-axis) is plotted against the average silhouette width (y-axis). A vertical reference line indicate the cluster solution which maximize the silhouette width, corresponding to the suggested optimal partition.
#' 
#' The function returns a list storing information about the cluster membership (i.e., which categories belong to which cluster).
#' 
#' Further info and Disclaimer: \cr
#' The silhouette plot is obtained from the silhouette() function out from the 'cluster' package (https://cran.r-project.org/web/packages/cluster/index.html).
#' For a detailed description of the silhouette plot, its rationale, and its interpretation, see: \cr 
#' -Rousseeuw P J. 1987. "Silhouettes: A graphical aid to the interpretation and validation of cluster analysis", Journal of Computational and Applied Mathematics 20, 53-65 (http://www.sciencedirect.com/science/article/pii/0377042787901257)
#' 
#' For the idea of clustering categories on the basis of the CA coordinates from a full high-dimensional space (or from a subset thereof), see: \cr
#' -Ciampi et al. 2005. "Correspondence analysis and two-way clustering", SORT 29 (1), 27-4 \cr
#' -Beh et al. 2011. "A European perception of food using two methods of correspondence analysis", Food Quality and Preference 22(2), 226-231
#' 
#' Please note that the interpretation of the clustering when both row AND column categories are used must procede with caution due to the issue of inter-class points' distance interpretation. For a full description of the issue (also with further references), see: \cr
#' -Greenacre M. 2007. "Correspondence Analysis in Practice", Boca Raton-London-New York, Chapman&Hall/CRC, 267-268.
#' 
#' @param data: contingency table, in dataframe format.
#' @param which: "both" to cluster both row and column categories; "rows" or "columns" to cluster only row or column categories respectivily
#' @param dim: sets the dimensionality of the space whose coordinates are used to cluster the CA categories; it can be an integer or a vector (e.g., c(2,3)) specifying the first and second selected dimension. NULL is the default; it will make the clustering to be based on the maximum dimensionality of the dataset. 
#' @param dist.meth: sets the distance method used for the calculation of the distance between categories; "euclidean" is the default (see the help of the help if the dist() function for more info and other methods available).
#' @param aggl.meth: sets the agglomerative method to be used in the dendrogram construction; "ward.D2" is the default (see the help of the hclust() function for more info and for other methods available).
#' @param opt.part: takes TRUE or FALSE (default) if the user wants or doesn't want an optimal partition to be suggested; the latter is based upon an iterative process that seek for the maximizition of the average silhouette width.
#' @param opt.part.meth: sets whether the optimal partition method will try to maximize the average ("mean") or median ("median") silhouette width. The former is the default.
#' @param part: integer which sets the number of desired clusters (NULL is default); this will override the optimal cluster solution.
#' @param cex.dndr.lab: sets the size of the dendrogram's labels. 0.85 is the default.
#' @param cex.sil.lab: sets the size of the silhouette plot's s labels. 0.75 is the default.
#' @param cex.sctpl.lab: sets the size of the Correspondence Analysis scatterplot's labels. 3.5 is the default.
#' @keywords correspondence analysis clustering method chart silhouette
#' @export
#' @examples
#' #data(brand_coffee)
#' #ca.cluster(brand_coffee, opt.part=FALSE)
#' #displays a dendrogram of row AND column categories
#'
#' #res <- ca.cluster(brand_coffee, opt.part=TRUE)
#' #displays a dendrogram for row AND column categories; the clustering is based on the CA coordinates from a full high-dimensional space. Rectangles indicating the clusters defined by the optimal partition method (see Details). A silhouette plot, a scatterplot, and a CA scatterplot with indication of cluster membership are also produced (see Details). The cluster membership is stored in the object 'res'.
#'
#' #res <- ca.cluster(brand_coffee, which="rows", dim=4, opt.part=TRUE)
#' #displays a dendrogram for row categories, with rectangles indicating the clusters defined by the optimal partition method (see Details). The clustering is based on a space of dimensionality 4. A silhouette plot, a scatterplot, and a CA scatterplot with indication of cluster membership are also produced (see Details). The cluster membership is stored in the object 'res'.
#'
#' #res <- ca.cluster(brand_coffee, which="rows", dim=c(1,4), opt.part=TRUE)
#' #like the above example, but the clustering is based on the coordinates on the sub-space defined by a pair of dimensions (i.e., 1 and 4).
ca.cluster <- function(data, which="both", dim=NULL, dist.meth="euclidean", aggl.meth="ward.D2", opt.part=FALSE, opt.part.meth="mean", part=NULL, cex.dndr.lab=0.85, cex.sil.lab=0.75, cex.sctpl.lab=3.5){
  dimensionality <- min(ncol(data), nrow(data))-1 # calculate the dimensionality of the input table
  ifelse(is.null(dim), dimens.to.report <- paste0("from a space of dimensionality: ", dimensionality), ifelse(length(dim)==1, dimens.to.report <- paste0("from a space of dimensionality: ", dim), dimens.to.report <- paste0("from the subspace defin. by the ", dim[1], " and ", dim[2], " dim.")))
  ifelse(is.null(dim), sil.plt.title <- paste0("Silhouette plot for CA (dimensionality: ", dimensionality, ")"), ifelse(length(dim)==1, sil.plt.title <- paste0("Silhouette plot for CA (dimensionality: ", dim, ")"), sil.plt.title <- paste0("Silhouette plot for CA (dim. ", dim[1], " + ", dim[2], ")")))
  ifelse(is.null(dim), ca.plt.title <- paste0("Clusters based on CA coordinates from a space of dimensionality: ", dimensionality), ifelse(length(dim)==1, ca.plt.title <- paste0("Clusters based on CA coordinates from a space of dimensionality: ", dim), ca.plt.title <- paste0("Clusters based on CA coordinates from the sub-space defined by dim. ", dim[1], " + ", dim[2])))
  res.ca <- CA(data, ncp = dimensionality, graph = FALSE) # get the CA results from the CA command of the FactoMiner package
  ifelse(which=="rows", binded.coord<-res.ca$row$coord, ifelse(which=="cols", binded.coord<-res.ca$col$coord, binded.coord <- rbind(res.ca$col$coord, res.ca$row$coord))) # get the columns and/or rows coordinates for all the dimensions and save them in a new table
  binded.coord <- as.data.frame(binded.coord)
  #binded.coord <- rbind(res.ca$col$coord, res.ca$row$coord) # get the columns and rows coordinates and bind them in a table
  if(which=="both"){
    rownames(binded.coord)[1:nrow(res.ca$col$coord)] <- paste(rownames(binded.coord)[1:nrow(res.ca$col$coord)], "*", sep = "") # add an asterisk to the dataframe row names corresponding to the column categories
    dendr.title <- paste("Clusters of Row and Column (*) categories \nclustering based on Correspondence Analysis' coordinates", dimens.to.report)
  } else {ifelse(which=="rows", dendr.title <- paste("Clusters of Row categories \nclustering based on Correspondence Analysis' coordinates", dimens.to.report), dendr.title <- paste("Clusters of Column categories \nclustering based on Correspondence Analysis' coordinates", dimens.to.report))}
  max.ncl <- nrow(binded.coord)-1 # calculate the max number of clusters, 1 less than the number of objects (i.e., the binded table's rows)
  sil.width.val <- numeric(max.ncl-1) # create an empty vector to store the average value of the silhouette width at different cluster solutions
  sil.width.step <- c(2:max.ncl) # create an empty vector to store the progressive number of clusters for which silhouettes are calculated
  ifelse(is.null(dim), d <- dist(binded.coord, method = dist.meth), ifelse(length(dim)==1, d <- dist(subset(binded.coord, select=1:dim)), d <- dist(subset(binded.coord, select=dim), method = dist.meth))) # calculate the distance matrix on the whole coordinate dataset if 'dim' is not entered by the user; otherwise, the matrix is calculated on a subset of the coordinate dataset
  
  if (is.null(dim) | length(dim)==1) { # condition to extract the coordinates to be used later for plooting a scatterplot with cluster membership
    first.setcoord <- 1
    second.setcoord <- 2
    dim.labelA <- "Dim. 1"
    dim.labelB <- "Dim. 2"
  } else {
    first.setcoord <- dim[1]
    second.setcoord <- dim[2]
    dim.labelA <- paste0("Dim. ", dim[1])
    dim.labelB <- paste0("Dim. ", dim[2])
  }
  #d <- dist(binded.coord, method = dist.meth) 
  fit <- hclust(d, method=aggl.meth) # perform the hierc agglomer clustering
  if (is.null(part) & opt.part==TRUE) {
    for (i in 2:max.ncl){
      counter <- i-1
      clust <- silhouette(cutree(fit, k=i),d)  # calculate the silhouettes for increasing numbers of clusters; requires the 'cluster' package
      sil.width.val[counter] <- ifelse(opt.part.meth=="mean", mean(clust[,3]), ifelse(opt.part.meth=="median", median(clust[,3]))) # store the mean or median of the silhouette width distribution at increasing cluster solutions
    }
    sil.res <- as.data.frame(cbind(sil.width.step, sil.width.val)) # store the results of the preceding loop binding the two vectors into a dataframe
    select.clst.num <- sil.res$sil.width.step[sil.res$sil.width.val==max(sil.res$sil.width.val)] # from a column of the dataframe extract the cluster solution that corresponds to the maximum mean or median silhouette width
    plot(fit, main=dendr.title, sub=paste("Distance method:", dist.meth, "\nAgglomeration method:", aggl.meth), xlab="", cex=cex.dndr.lab, cex.main=0.9, cex.sub=0.75) # display the dendogram when the optimal partition is desired, not the user-defined one
    solution <- rect.hclust(fit, k=select.clst.num, border=1:select.clst.num) # create the cluster partition on the dendrogram using the optimal number of clusters stored in 'select.clst.num'
    binded.coord$membership <- assignCluster(binded.coord, binded.coord, cutree(fit, k=select.clst.num)) # store the cluster membership in the 'binded.coord' dataframe; requires 'RcmdrMisc’
    par(mfrow=c(1,2)) 
    final.sil.data <- silhouette(cutree(fit, k=select.clst.num),d) # store the silhouette data related to the selected cluster solution
    row.names(final.sil.data) <- row.names(binded.coord) # copy the objects names to the rows' name of the object created in the above step
    rownames(final.sil.data) <- paste(rownames(final.sil.data), final.sil.data[,2], sep = "_") # append a suffix to the objects names corresponding to the neighbor cluster; the latter info is got from the 'final.sil.data' object
    par(oma=c(0,4,0,0)) # enlarge the left outer margin of the plot area to leave room for long objects' labels
    plot(final.sil.data, cex.names=cex.sil.lab, max.strlen=30, nmax.lab=nrow(binded.coord)+1, main=sil.plt.title) # plot the final silhouette chart, allowing for long objects'labels
    abline(v=mean(final.sil.data[,3]), lty=2) # add a reference line for the average silhouette width of the optimal partition
    plot(sil.res, xlab="number of clusters", ylab="silhouette width", ylim=c(0,1), xaxt="n", type="b", main="Silhouette width vs. number of clusters", sub=paste("values on the y-axis represent the", opt.part.meth, "of the silhouettes' width distribution at each cluster solution"), cex.sub=0.75) # plot the scatterplot
    axis(1, at = 0:max.ncl, cex.axis=0.70) # set the numbers for the x-axis labels starting from 2, which is the min number of clusters
    text(x=sil.res$sil.width.step, y=sil.res$sil.width.val, labels = round(sil.res$sil.width.val, 3), cex = 0.65, pos = 3, offset = 1, srt=90) # add the average width values on the top of the dots in the scatterplot
    abline(v=select.clst.num, lty=2, col="red") # add a red reference line indicating the number of selected clusters
    par(mfrow=c(1,1)) # reset the default plot layout
    
    p <- ggplot(binded.coord, aes(x=binded.coord[,first.setcoord], y=binded.coord[,second.setcoord], color=membership)) + 
      labs(x=dim.labelA, y=dim.labelB, colour="Clusters") + 
      geom_point() + 
      geom_vline(xintercept = 0, linetype=2, color="gray") + 
      geom_hline(yintercept = 0, linetype=2, color="gray") + 
      theme(panel.background = element_rect(fill="white", colour="black")) + 
      geom_text_repel(aes(x=binded.coord[,first.setcoord], y=binded.coord[,second.setcoord], label = rownames(binded.coord)), size=cex.sctpl.lab) + 
      coord_fixed(ratio = 1, xlim = NULL, ylim = NULL, expand = TRUE) +
      ggtitle(ca.plt.title)
    print(p)
    return(solution)
  } else {
    if(is.null(part) & opt.part==FALSE){
      plot(fit, main=dendr.title, sub=paste("Distance method:", dist.meth, "\nAgglomeration method:", aggl.meth), xlab="", cex=cex.dndr.lab, cex.main=0.9, cex.sub=0.75) # display the dendogram if neither a user-defined partition nor an optimal partition is desired
    } else { 
      plot(fit, main=dendr.title, sub=paste("Distance method:", dist.meth, "\nAgglomeration method:", aggl.meth), xlab="", cex=cex.dndr.lab, cex.main=0.9, cex.sub=0.75) # display the dendogram if a user-defined partition is desired
      select.clst.num <- part
      solution <- rect.hclust(fit, k=select.clst.num, border=1:select.clst.num)
      binded.coord$membership <- assignCluster(binded.coord, binded.coord, cutree(fit, k=select.clst.num))
      final.sil.data <- silhouette(cutree(fit, k=select.clst.num),d) 
      row.names(final.sil.data) <- row.names(binded.coord) 
      rownames(final.sil.data) <- paste(rownames(final.sil.data), final.sil.data[,2], sep = "_") 
      plot(final.sil.data, cex.names=cex.sil.lab, max.strlen=30, nmax.lab=nrow(binded.coord)+1, main=sil.plt.title) # plot the final silhouette chart, allowing for long objects'labels
      abline(v=mean(final.sil.data[,3]), lty=2)
      
      p <- ggplot(binded.coord, aes(x=binded.coord[,first.setcoord], y=binded.coord[,second.setcoord], color=membership)) + 
        labs(x=dim.labelA, y=dim.labelB, colour="Clusters") + 
        geom_point() + 
        geom_vline(xintercept = 0, linetype=2, color="gray") + 
        geom_hline(yintercept = 0, linetype=2, color="gray") + 
        theme(panel.background = element_rect(fill="white", colour="black"))  + 
        geom_text_repel(aes(x=binded.coord[,first.setcoord], y=binded.coord[,second.setcoord], label = rownames(binded.coord)), size=cex.sctpl.lab) + 
        coord_fixed(ratio = 1, xlim = NULL, ylim = NULL, expand = TRUE) + 
        ggtitle(ca.plt.title)
      print(p)
      
      return(solution)
    }
  }
}