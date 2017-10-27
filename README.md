# CAinterprTools
vers 0.14

A number of interesting packages are available to perform Correspondence Analysis in R. At the best of my knowledge, however, they lack some tools to help users to eyeball some critical CA aspects (e.g., contribution of rows/cols categories to the principal axes, quality of the display,correlation of rows/cols categories with dimensions, etc). Besides providing those facilities, this package allows calculating the significance of the CA dimensions by means of the 'Average Rule', the Malinvaud test, and by permutation test. Further, it allows to also calculate the permuted significance of the CA total inertia. 

The package comes with three datasets:
greenacre_data: after Greenacre, "Correspondence Analysis in Practice"", Boca Raton-London-New York, Chapman&Hall/CRC 2007 (exhibit 12.1)

brand_coffee: after Kennedy et al, Practical Applications of Correspondence Analysis to Categorical Data in Market Research, in Journal of Targeting Measurement and Analysis for Marketing, 1996

diseases: after Velleman-Hoaglin, "Applications, Basics, and Computing of Exploratory Data Analysis", Wadsworth Pub Co 1984 (Exhibit 8-1)


## List of implemented functions
to load the sample dataset:
```r
data("greenacre_data")
```

to display a bar plot of the strength of the correlation between rows and columns of the input contingency table:
```r
ca.corr(greenacre_data)
```

to calculate the significance of the CA total inertia via permutation test; a density curve of the permuted total inertia is displayed along with the observed total inertia and the 95th percentile of the permuted total inertia. The latter can be regarded as a 0.05 alpha threshold for the observed total inertia's significance:
```r
sig.tot.inertia.perm(greenacre_data)
```

to return a chart suggesting which CA dimension is important for data structure interpretation, according to the so-called 'average rule':
```r
aver.rule(greenacre_data)
```

to perform the Malinvaud test and to print on screen the test's result (among which the significance of the CA dimensions); a plot is also provided, wherein a reference line (in RED) indicates the 0.05 threshold:
```r
malinvaud(greenacre_data)
```

to calculate the significance of the 1 and 2 CA dimensions via permutation test, and to display the results as a scatterplot; reference lines provide information about the significance of the selected dimensions:
```r
sig.dim.perm(greenacre_data,1,2)
```

to display the contribution of the row categories to the 1 CA dimension; a reference line  indicates the threshold above which a contribution can be considered important for the determination of the dimension. The parameter 'T' specifies that the categories' contribution to the total inertia is also shown (hollow circle):
```r
rows.cntr(greenacre_data,1,cti=TRUE,sort=TRUE)
```

to display a scatterplot for the row categories contribution to dimension 1&2:
```r
rows.cntr.scatter(greenacre_data,1,2)
```

to chart the quality of row categories display on the sub-space determined by, say, the 1&2 CA dimensions:
```r
rows.qlt(greenacre_data,1,2)
```

to display the correlation of the row categories with the 1 CA dimension:
```r
rows.corr(greenacre_data,1) 
```

to display a scatterplot for row categories correlation with dimension 1&2:
```r
rows.corr.scatter(greenacre_data,1,2)
```

The column equivalent of the last five functions:
```r
cols.cntr(greenacre_data,1,cti=TRUE,sort=TRUE)
cols.cntr.scatter(greenacre_data,1,2)
cols.qlt(greenacre_data,3) 
cols.corr(greenacre_data,1) 
cols.corr.scatter(greenacre_data,1,2)
```

New in version 0.5:
ca.scater(): allows to get different types of CA scatterplots. It is just a wrapper for functions from the 'ca' and 'FactoMineR' packages.

ca.plus(): allows to plot Correspondence Analysis scatterplots modified to help interpreting the analysis' results. In particular, the function aims at making easier to understand in the same visual context (a) which (say, column) categories are actually contributing to the definition of given pairs of dimensions, and (b) to eyeball which (say, row) categories are more correlated to which dimension.

sig.dim.perm.scree(): allows to test the significance of the CA dimensions by means of permutation of the input contingency table. The number of permutations used is entered by the user. The function return a scree plot displaying for each dimension the observed eigenvalue and the 95th percentile of the permuted distribution of the corresponding eigenvalue. Observed eigenvalues that are larger than the corresponding 95th percentile are significant at alpha 0.05.

New in version 0.6:
'ggplot2' and 'ggrepel' are used to produce the charts returned by the functions: cols.cntr.scatter(), rows.cntr.scatter(), cols.corr.scatter(), rows.corr.scatter(). The two packages have been preferred over R base plotting facitily for their ability to plot non overlapping point labels. This will allow complex charts to have no-to-less cluttered labels.

New in version 0.7:
'ca.percept' has been added to the package. The 'brand_coffee' dataset has been also included. The dataset is after Kennedy et al, Practical Applications of Correspondence Analysis to Categorical Data in Market Research, in Journal of Targeting Measurement and Analysis for Marketing, 1996.
Minor corrections have been done to the help documentation of a handfull of commands.

New in version 0.8:
the facility has been added to the rows.cntr() and cols.contr() functions to sort the categories in descending order of contribution to the inertia of the selected dimension. 
Minor corrections have been done to the help documentation of a handfull of commands.

New in version 0.9:
the facility has been added to the sig.dim.perm.scree() function to display p values directly into the chart.

New in version 0.10:
the facility has been added to the rows.corr(), cols.corr(), rows.qlt(), and cols.qlt() functions to sort the categories in descending order of correlation to the selected dimension and of quality of the representation on the subspace defined by the selected pair of dimensions. 
Minor corrections have been done to the help documentation of a handfull of commands.

New in version 0.11: the functions rows.cntr(), cols.cntr(), rows.corr(), and cols.corr() have been improved; symbols have been added to the dotplot's labels indicating with which side of the selected dimension the row/column categories are actually contributing (for the rows.cntr() and cols.cntr() functions) or with which side of the selected dimension the categories are correlated (for the rows.corr() and cols.corr() function). A legend has been added containing information crucial to the interpretation of the CA results.

New in version 0.12: the functions rows.cntr.scatter() and cols.cntr.scatter() have been improved by adding more informative labels to the categories' points.

New in version 0.13: the functions ca.plot() and ca.cluster(), and the 'deseases' dataset, have been added. The latter is from Velleman-Hoaglin, "Applications, Basics, and Computing of Exploratory Data Analysis", Wadsworth Pub Co (1984), Exhibit 8-1.

New in version 0.14: the functions sig.dim.perm(), sig.dim.perm.scree(), and sig.tot.inertia.perm() do not rely on functions from the 'InPosition' package anymore. The latter has beed dropped from the dependencies of the 'CAinterprTools' package. 'Reshape2' has been added among this package's dependencies since one of its functions is used by the sig.dim.perm.scree() function. A rug plot has been added to the bottom of the density chart returned by the sig.tot.inertia.perm(). The reference lines in the chart returned by the sig.dim.perm() function have been dropped: the observed inertia is indicated by a larger red dot to improve the chart's aestetic and readability.


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
install_github("gianmarcoalberti/CAinterprTools")
```
4) load the package: 
```r
library(CAinterprTools)
```
5) enjoy!


## Companion website
[Correspondence Analysis in Archaeology](http://cainarchaeology.weebly.com)
