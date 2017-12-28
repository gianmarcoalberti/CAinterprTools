# CAinterprTools
vers 0.17

A number of interesting packages are available to perform Correspondence Analysis in R. At the best of my knowledge, however, they lack some tools to help users to eyeball some critical CA aspects (e.g., contribution of rows/cols categories to the principal axes, quality of the display,correlation of rows/cols categories with dimensions, etc). Besides providing those facilities, this package allows calculating the significance of the CA dimensions by means of the 'Average Rule', the Malinvaud test, and by permutation test. Further, it allows to also calculate the permuted significance of the CA total inertia. 

The package comes with some datasets drawn from literature:

`greenacre_data`: after Greenacre M, *Correspondence Analysis in Practice*, Boca Raton-London-New York, Chapman&Hall/CRC 2007 (exhibit 12.1)

`brand_coffee`: after Kennedy R et al, *Practical Applications of Correspondence Analysis to Categorical Data in Market Research*, in Journal of Targeting Measurement and Analysis for Marketing, 1996

`diseases`: after Velleman P F, Hoaglin D C, *Applications, Basics, and Computing of Exploratory Data Analysis*, Wadsworth Pub Co 1984 (Exhibit 8-1)

`fire_loss`: after Li et al, *Influences of Time, Location, and Cause Factors on the Probability of Fire Loss in China: A Correspondence Analysis*, in Fire Technology 50(5), 2014, 1181-1200 (table 5)

`breakfast`: after Bendixen M, *A Practical Guide to the Use of Correspondence Analysis in Marketing Research*, in Research on-line 1, 1996, 16-38 (table 5)

<br>

## List of implemented functions
* `aver.rule`: average rule chart.
* `ca.cluster`: clustering row/column categories on the basis of Correspondence Analysis coordinates from a space of user-defined dimensionality.
* `ca.corr()`: chart of correlation between rows and columns categories.
* `ca.percept()`: perceptual map-like Correspondence Analysis scatterplot.
* `ca.plot()`: intepretation-oriented Correspondence Analysis scatterplots, with informative and flexible (non-overlapping) labels.
* `ca.plus()`: facility for interpretation-oriented CA scatterplot.
* `ca.scatter()`: basic scatterplot visualization facility.
* `cols.cntr()`: columns contribution chart.
* `cols.cntr.scatter()`: scatterplot for column categories contribution to dimensions.
* `cols.qlt()`: chart of columns quality of the display.
* `malinvaud()`: Malinvaud's test for significance of the CA dimensions.
* `rows.cntr()`: rows contribution chart.
* `rows.cntr.scatter()`: scatterplot for row categories contribution to dimensions.
* `rows.qlt()`: chart of rows quality of the display.
* `sig.dim.perm()`: permuted significance of CA dimensions.
* `sig.dim.perm.scree()`: scree plot to test the significance of CA dimensions by means of a randomized procedure.
* `sig.tot.inertia.perm()`: permuted significance of the CA total inertia.
* `table.collapse()`: collapse rows and columns of a table on the basis of hierarchical clustering.

<br>

## Description of implemented functions
To load the sample dataset:
```r
data("greenacre_data")
```
<br><br>
`ca.corr()`: displays a bar plot of the strength of the correlation between rows and columns of the input contingency table:
```r
ca.corr(greenacre_data)
```
[![image.jpg](https://s1.postimg.org/8zluhdtp5r/image.jpg)](https://postimg.org/image/9a8oaj8xaz/)

<br><br>
`sig.tot.inertia.perm()`: calculates the significance of the CA total inertia via permutation test; a density curve of the permuted total inertia is displayed along with the observed total inertia and the 95th percentile of the permuted total inertia. The latter can be regarded as a 0.05 alpha threshold for the observed total inertia's significance:
```r
sig.tot.inertia.perm(greenacre_data)
```
[![image.jpg](https://s1.postimg.org/1i7jawtokf/image.jpg)](https://postimg.org/image/6bwe71ednf/)

<br><br>
`aver.rule()`: returns a chart suggesting which CA dimension is important for data structure interpretation, according to the so-called 'average rule':
```r
aver.rule(greenacre_data)
```
[![image.jpg](https://s1.postimg.org/8pojgl09wv/image.jpg)](https://postimg.org/image/2b9xkzidd7/)

<br><br>
`malinvaud()`: performs the Malinvaud test and returns the test's result (among which the significance of the CA dimensions); a plot is also provided, wherein a reference line (in RED) indicates the 0.05 threshold:
```r
malinvaud(greenacre_data)
```
[![image.jpg](https://s1.postimg.org/20n3ru82ov/image.jpg)](https://postimg.org/image/3vzokgkiaj/)

<br><br>
`sig.dim.perm()`: calculates the significance of a pair of selected dimensions via permutation test, and displays the results as a scatterplot; a large RED dot indicates the observed inertia. Permuted p-values are reported in the axes' labels:
```r
sig.dim.perm(greenacre_data,1,2)
```
[![image.jpg](https://s1.postimg.org/1c6llz9wnz/image.jpg)](https://postimg.org/image/7n1ljuyqhn/)

<br><br>
`sig.dim.perm.scree()`: tests the significance of the CA dimensions by means of permutation of the input contingency table. A scree-plot displays for each dimension the observed eigenvalue and the 95th percentile of the permuted distribution of the corresponding eigenvalue. Observed eigenvalues that are larger than the corresponding 95th percentile are significant at least at alpha 0.05. P values are displayed into the chart:
```r
sig.dim.perm.scree(greenacre_data)
```
[![image.jpg](https://s1.postimg.org/1fq7jpjhin/image.jpg)](https://postimg.org/image/9bayh25isr/)

<br><br>
`rows.cntr()`: calculates the contribution of the row categories to a selected dimension. It displays the contribution of the categories as a dotplot. A reference line indicates the threshold above which a contribution can be considered important for the determination of the selected dimension. The parameter `cti=TRUE` specifies that the categories' contribution to the total inertia is also shown (hollow circle). The parameter `sort=TRUE` sorts the categories in descending order of contribution to the inertia of the selected dimension. At the left-hand side of the plot, the categories' labels are given a symbol (+ or -) according to wheather each category is actually contributing to the definition of the positive or negative side of the dimension, respectively. At the right-hand side, a legend reports the correlation (sqrt(COS2)) of the column categories with the selected dimension. A symbol (+ or -) indicates with which side of the selected dimension each column category is correlated:
```r
rows.cntr(greenacre_data,1,cti=TRUE,sort=TRUE)
```
[![image.jpg](https://s1.postimg.org/6l46fhqi1b/image.jpg)](https://postimg.org/image/12m1zci9xn/)

<br><br>
`rows.cntr.scatter()`: plots a scatterplot of the contribution of row categories to two selected dimensions. Two references lines (in RED) indicate the threshold above which the contribution can be considered important for the determination of the dimensions. A diagonal line (in BLACK) is a visual aid to eyeball whether a category is actually contributing more (in relative terms) to either of the two dimensions. The row categories' labels are coupled with + or - symbols within round brackets indicating to which side of the two selected dimensions the contribution values that can be read off from the chart are actually referring. The first symbol (i.e., the one to the left), either + or -, refers to the first of the selected dimensions (i.e., the one reported on the x-axis). The second symbol (i.e., the one to the right) refers to the second of the selected dimensions (i.e., the one reported on the y-axis):
```r
rows.cntr.scatter(greenacre_data,1,2)
```
[![image.jpg](https://s1.postimg.org/3xrhjb9rb3/image.jpg)](https://postimg.org/image/7hdf94ch2z/)

<br><br>
`rows.qlt()`: plots the quality of row categories display on the sub-space determined by, say, the 1&2 CA dimensions:
```r
rows.qlt(greenacre_data,1,2)
```
[![image.jpg](https://s1.postimg.org/6p0jre1nov/image.jpg)](https://postimg.org/image/9qwfsm2zvv/)

<br><br>
`rows.corr()`: calculates and graphically displays the correlation (sqrt(COS2)) of the row categories with the selected dimension. The parameter sort=TRUE arranges the categories in decreasing order of correlation. In the returned chart, at the left-hand side, the categories' labels show a symbol (+ or -) according to which side of the selected dimension they are correlated, either positive or negative. At the right-hand side, a legend indicates the column categories' contribution (in permils) to the selected dimension (value enclosed within round brackets), and a symbol (+ or -) indicating whether they are actually contributing to the definition of the positive or negative side of the dimension, respectively. Further, an asterisk (*) flags the categories which can be considered major contributors to the definition of the dimension:
```r
rows.corr(greenacre_data,1) 
```
[![image.jpg](https://s1.postimg.org/41b3h1djtr/image.jpg)](https://postimg.org/image/1o8gztzqmz/)

<br><br>
`rows.corr.scatter()`: plots a scatterplot of the correlation (sqrt(COS2)) of row categories with two selected dimensions. A diagonal line (in BLACK) is a visual aid to eyeball whether a category is actually more correlated (in relative terms) to either of the two dimensions. The row categories' labels are coupled with two + or - symbols within round brackets indicating to which side of the two selected dimensions the correlation values that can be read off from the chart are actually referring. The first symbol (i.e., the one to the left), either + or -, refers to the first of the selected dimensions (i.e., the one reported on the x-axis). The second symbol (i.e., the one to the right) refers to the second of the selected dimensions (i.e., the one reported on the y-axis):
```r
rows.corr.scatter(greenacre_data,1,2)
```
[![image.jpg](https://s1.postimg.org/57vt8txpjj/image.jpg)](https://postimg.org/image/5iin1zcxor/)

<br><br>
`table.collapse()`: allows to collapse the rows and columns of the input contingency table on the basis of the results of a hierarchical clustering. The function returns a list containing the input table, the rows-collapsed table, the columns-collapsed table, and a table with both rows and columns collapsed. It optionally returns two dendrograms (one for the row profiles, one for the column profiles) representing the clusters. The hierarchical clustering is obtained using the `FactoMineR`s `HCPC()` function. *Rationale*: Clustering rows and/or columns of a table could interest the users who want to know where a *significant association is concentrated* by *collecting together similar rows (or columns) in discrete groups* (Greenacre M, *Correspondence Analysis in Practice*, Boca Raton-London-New York, Chapman&Hall/CRC 2007, pp. 116, 120). Rows and/or columns are progressively aggregated in a way in which every successive merging produces the smallest change in the table’s inertia. The underlying logic lies in the fact that rows (or columns) whose merging produces a small change in table’s inertia have similar profiles. This procedure can be thought of as maximizing the between-group inertia and minimizing the within-group inertia. A method essentially similar is that provided by the `FactoMineR` package (Husson F, Le S, Pages J, *Exploratory Multivariate Analysis by Example Using R*, Boca Raton-London-New York, CRC Press, pp. 177-185). The cluster solution is based on the following rationale: a division into Q (i.e., a given number of) clusters is suggested when the increase in between-group inertia attained when passing from a Q-1 to a Q partition is greater than that from a Q to a Q+1 clusters partition. In other words, during the process of rows (or columns) merging, if the following agggregation raises highly the within-group inertia, it means that at the further step very different profiles are being aggregated.

<br><br>
The column equivalent of some of the above functions are:
```r
cols.cntr(greenacre_data,1,cti=TRUE,sort=TRUE)
cols.cntr.scatter(greenacre_data,1,2)
cols.qlt(greenacre_data,3) 
cols.corr(greenacre_data,1) 
cols.corr.scatter(greenacre_data,1,2)
```

**Plotting facilities**

`ca.plus()`: plots Correspondence Analysis scatterplots modified to help interpreting the analysis' results. In particular, the function aims at making easier to understand in the same visual context (a) which (say, column) categories are actually contributing to the definition of given pairs of dimensions, and (b) to eyeball which (say, row) categories are more correlated to which dimension:
```r
resCA <- CA(greeacre_data, graph=FALSE) #performs CA by means of FactoMineR's CA command, and store the result in the object named resCA. If supplementary data are present, the user has to specify which rows and/or columns are supplmentary into this function (see FactoMineR's documentation).
ca.plus(resCA, 1, 2, focus="C", row.suppl="FALSE", col.suppl="FALSE", oneplot="TRUE")
```
<br><br>
`ca.percept()`: plots a variant of the traditional Correspondence Analysis scatterplots that allows facilitating the interpretation of the results. It aims at producing what in marketing research is called perceptual map, a visual representation of the CA results that seeks to avoid the problem of interpreting inter-spatial distance. It represents only one type of points (say, column points), and "gives names to the axes" corresponding to the major row category contributors to the two selected dimensions:
```r
ca.percept(greeacre_data,1,2,focus="col",dim.corr=1, guide=FALSE)
```
<br><br>
`ca.plot()`: plots different types of CA scatterplots, adding information that are relevant to the CA interpretation. Thanks to the `ggrepel` package, the labels tends to not overlap so producing a nicely readable chart. `ca.plot()` provides the facility to produce: 

(1) a *'regular'* (symmetric) scatterplot, in which points' labels only report the categories' names;

(2) a scatterplot with *advanced labels*. If the user's interest lies (for instance) in interpreting the rows in the space defined by the column categories, by setting the parameter 'cntr' to "columns" the columns' labels will be coupled with two asterisks within round brackets; each asterisk (if present) will indicate if the category is a major contributor to the definition of the first selected dimension (if the first asterisk to the left is present) and/or if the same category is also a major contributor to the definition of the second selected dimension (if the asterisk to the right is present). The rows' labels will report the correlation (i.e., sqrt(COS2)) with the selected dimensions; the correlation values are reported between square brackets; the left-hand side value refers to the correlation with the first selected dimensions, while the right-hand side value refers to the correlation with the second selected dimension. If the parameter 'cntr' is set to "rows", the row categories' labels will indicate the contribution, and the column categories' labels will report the correlation values.

(3) a *perceptual map*, in which axes' poles are given names according to the categories (either rows or columns, as specified by the user) having a major contribution to the definition of the selected dimensions; rows' (or columns') labels will report the correlation with the selected dimensions.

The function returns a dataframe containing data about row and column points:

* (a) coordinates on the first selected dimension 
* (b) coordinates on the second selected dimension 
* (c) contribution to the first selected dimension 
* (d) contribution to the second selected dimension 
* (e) quality on the first selected dimension 
* (f) quality on the second selected dimension 
* (g) correlation with the first selected dimension 
* (h) correlation with the second selected dimension 
* (j) (k) asterisks indicating whether the corresponding category is a major contribution to the first and/or second selected dimension.
```r
ca.plot(greenacre_data,1,2,cntr="columns")
```
[![image.jpg](https://s1.postimg.org/3nitnj40bz/image.jpg)](https://postimg.org/image/92hc5yj5pn/)

<br><br>
`ca.cluster()`: plots the result of cluster analysis performed on the results of Correspondence Analysis, and plots a dendrogram, a silouette plot depicting the "quality" of the clustering solution, and a scatterplot with points coded according to the cluster membership. `ca.cluster()` provides the facility to perform hierarchical cluster analysis of row and/or column categories on the basis of Correspondence Analysis result. The clustering is based on the row and/or colum categories' coordinates from:

* (1) a high-dimensional space corresponding to the whole dimensionality of the input contingency table; 
* (2) a high-dimensional space of dimensionality smaller than the full dimensionality of the input dataset; 
* (3) a bi-dimensional space defined by a pair of user-defined dimensions. 

To obtain (1), the `dim` parameter must be left in its default value (`NULL`); 
to obtain (2), the `dim` parameter must be given an integer (needless to say, smaller than the full dimensionality of the input data); 
to obtain (3), the `dim` parameter must be given a vector (e.g., c(1,3)) specifying the dimensions the user is interested in.

The method by which the distance is calculated is specified using the `dist.meth` parameter, while the agglomerative method is speficied using the `aggl.meth` parameter. By default, they are set to `euclidean` and `ward.D2` respectively.

The user may want to specify beforehand the desired number of clusters (i.e., the cluster solution). This is accomplished feeding an integer into the 'part' parameter. A dendrogram (with rectangles indicating the clustering solution), a silhouette plot (indicating the "quality" of the cluster solution), and a CA scatterplot (with points given colours on the basis of their cluster membership) are returned. Please note that, when a high-dimensional space is selected, the scatterplot will use the first 2 CA dimensions; the user must keep in mind that the clustering based on a higher-dimensional space may not be well reflected on the subspace defined by the first two dimensions only.

Also note:

* if both row and column categories are subject to the clustering, the column categories will be flagged by an asterisk (*) in the dendrogram (and in the silhouette plot) just to make it easier to identify rows and columns;

* the silhouette plot displays the average silhouette width as a dashed vertical line; the dimensionality of the CA space used is reported in the plot's title; if a pair of dimensions has been used, the individual dimensions are reported in the plot's title;

* the silhouette plot's labels end with a number indicating the cluster to which each category is closer.

An optimal clustering solution can be obtained setting the `opt.part` parameter to `TRUE`. The optimal partition is selected by means of an iterative routine which locates at which cluster solution the highest average silhouette width is achieved. If the `opt.part` parameter is set to `TRUE`, an additional plot is returned along with the silhouette plot. It displays a scatterplot in which the cluster solution (x-axis) is plotted against the average silhouette width (y-axis). A vertical reference line indicate the cluster solution which maximize the silhouette width, corresponding to the suggested optimal partition.

The function returns a list storing information about the cluster membership (i.e., which categories belong to which cluster).

```r
data("fire_loss")
ca.cluster(fire_loss, which="rows", opt.part=TRUE)
```

[![Rplot.jpg](https://s1.postimg.org/5dyyeutqi7/Rplot.jpg)](https://postimg.org/image/2xcpzxmuln/)

[![Rplot01.jpg](https://s1.postimg.org/1v2jhduthb/Rplot01.jpg)](https://postimg.org/image/1kfpo8flbv/)

[![Rplot02.jpg](https://s1.postimg.org/8yaex02tmn/Rplot02.jpg)](https://postimg.org/image/95dmsfoz23/)
Further info and Disclaimer about the `ca.cluster()` function: 

The silhouette plot is obtained from the `silhouette()` function out from the `cluster` package. For a detailed description of the silhouette plot, its rationale, and its interpretation, see:

* Rousseeuw P J. 1987. *Silhouettes: A graphical aid to the interpretation and validation of cluster analysis*, Journal of Computational and Applied Mathematics 20, 53-65

For the idea of clustering categories on the basis of the CA coordinates from a full high-dimensional space (or from a subset thereof), see:

* Ciampi et al. 2005. *Correspondence analysis and two-way clustering*, SORT 29 (1), 27-4
* Beh et al. 2011. *A European perception of food using two methods of correspondence analysis*, Food Quality and Preference 22(2), 226-231

Please note that the interpretation of the clustering when both row AND column categories are used must procede with caution due to the issue of inter-class points' distance interpretation. For a full description of the issue (also with further references), see:

* Greenacre M. 2007. *Correspondence Analysis in Practice*, Boca Raton-London-New York, Chapman&Hall/CRC, 267-268.


<br><br>
## History
New in `version 0.5`:

`ca.scatter()`: allows to get different types of CA scatterplots. It is just a wrapper for functions from the `ca` and `FactoMineR` packages.

`ca.plus()`: allows to plot Correspondence Analysis scatterplots modified to help interpreting the analysis' results. In particular, the function aims at making easier to understand in the same visual context (a) which (say, column) categories are actually contributing to the definition of given pairs of dimensions, and (b) to eyeball which (say, row) categories are more correlated to which dimension.

`sig.dim.perm.scree()`: allows to test the significance of the CA dimensions by means of permutation of the input contingency table. The number of permutations used is entered by the user. The function return a scree plot displaying for each dimension the observed eigenvalue and the 95th percentile of the permuted distribution of the corresponding eigenvalue. Observed eigenvalues that are larger than the corresponding 95th percentile are significant at alpha 0.05.

New in `version 0.6`:

`ggplot2` and `ggrepel` are used to produce the charts returned by the functions: `cols.cntr.scatter()`, `rows.cntr.scatter()`, `cols.corr.scatter()`, `rows.corr.scatter()`. The two packages have been preferred over R base plotting facitily for their ability to plot non overlapping point labels. This will allow complex charts to have no-to-less cluttered labels.

New in `version 0.7`:

`ca.percept()` has been added to the package. The `brand_coffee` dataset has been also included. The dataset is after Kennedy et al, Practical Applications of Correspondence Analysis to Categorical Data in Market Research, in Journal of Targeting Measurement and Analysis for Marketing, 1996.
Minor corrections have been done to the help documentation of a handfull of commands.

New in `version 0.8`:

the facility has been added to the `rows.cntr()` and `cols.contr()` functions to sort the categories in descending order of contribution to the inertia of the selected dimension. 
Minor corrections have been done to the help documentation of a handfull of commands.

New in `version 0.9`:

the facility has been added to the `sig.dim.perm.scree()` function to display p values directly into the chart.

New in `version 0.10`:

the facility has been added to the `rows.corr()`, `cols.corr()`, `rows.qlt()`, and `cols.qlt()` functions to sort the categories in descending order of correlation to the selected dimension and of quality of the representation on the subspace defined by the selected pair of dimensions. 
Minor corrections have been done to the help documentation of a handfull of commands.

New in `version 0.11`: 

the functions `rows.cntr()`, `cols.cntr()`, `rows.corr()`, and `cols.corr()` have been improved; symbols have been added to the dotplot's labels indicating with which side of the selected dimension the row/column categories are actually contributing (for the `rows.cntr()` and `cols.cntr()` functions) or with which side of the selected dimension the categories are correlated (for the `rows.corr()` and `cols.corr()` function). A legend has been added containing information crucial to the interpretation of the CA results.

New in `version 0.12`: 

the functions `rows.cntr.scatter()` and `cols.cntr.scatter()` have been improved by adding more informative labels to the categories' points.

New in `version 0.13`: 

the functions `ca.plot()` and `ca.cluster()`, and the `deseases` dataset, have been added. The latter is from Velleman-Hoaglin, "Applications, Basics, and Computing of Exploratory Data Analysis", Wadsworth Pub Co (1984), Exhibit 8-1.

New in `version 0.14`: 

the functions `sig.dim.perm()`, `sig.dim.perm.scree()`, and `sig.tot.inertia.perm()` do not rely on functions from the `InPosition` package anymore. The latter has beed dropped from the dependencies of the `CAinterprTools` package. `Reshape2` has been added among this package's dependencies since one of its functions is used by the `sig.dim.perm.scree()` function. A rug plot has been added to the bottom of the density chart returned by the `sig.tot.inertia.perm()`. The reference lines in the chart returned by the `sig.dim.perm()` function have been dropped: the observed inertia is indicated by a larger red dot to improve the chart's aestetic and readability.

New in `version 0.15`: 

minor adjustments to the plots' axes labels formatting; the `malinvaud()` function now returns the output table; the `fire_loss` and `breakfast` dataset have been added.

New in `version 0.16`: 

the charts returned by the `cols.cntr.scatter()`, `cols.corr.scatter()`, `rows.cntr.scatter()`, and `rows.corr.scatter()` have been modified in order to be set with a ratio of 1 (i.e., 1 unit on the x-axis is equal to 1 unit on the y-axis). In these same plots, the diagonal line has been given a transparent black colour.

New in `version 0.17`: 

the `table.collapse()` function has been added.


## Installation
To install the package  in R, just follow the few steps listed below:

1) install the 'devtools' package:  
```r
install.packages("devtools", dependencies=TRUE)
```
2) load that package: 
```r
library(devtools)
```
3) download the 'CAinterprTools' package  from GitHub via the 'devtools''s command: 
```r
install_github("gianmarcoalberti/CAinterprTools@v0.17")
```
4) load the package: 
```r
library(CAinterprTools)
```
5) enjoy!


## Companion website
[Correspondence Analysis in Archaeology](http://cainarchaeology.weebly.com)
