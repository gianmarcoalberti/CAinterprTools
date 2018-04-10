\name{CAinterprTools-package}
\alias{CAinterprTools-package}
\alias{CAinterprTools}
\docType{package}
\title{
Visual tools for Correspondence Analysis interpretation and hypothesis testing
}
\description{
A number of interesting packages are available to perform
    Correspondence Analysis in R. At the best of my knowledge, they lack some
    tools to help users to eyeball some critical CA aspects (e.g., contribution
    of rows/cols categories to the principal axes, quality of the
    display,correlation of rows/cols categories with dimensions, etc). Besides
    providing those facilities, this package allows the users to calculate the
    significance of the CA dimensions by means of the 'Average Rule', the
    Malinvaud test, and by permutation test. Further, it allows to also
    calculate the permuted significance of the CA total inertia. The package comes with a dataset (greenacre_data) after Greenacre 2007 (p. 90, exhibit 12.1).
}
\details{
\tabular{ll}{
Package: \tab CAinterprTools\cr
Type: \tab Package\cr
Version: \tab 0.21\cr
Date: \tab 2018-04\cr
License: \tab GPL\cr
}
The package allows to plot a number of Correspondence Analysis information such as the contribution of rows and columns categories to the principal axes, the quality of points display on selected dimensions, the correlation of row and column categories to selected dimensions, etc. It also allows to assess which dimension(s) is important for the data structure interpretation by means of the so called 'Average Rule'. Moreover, it implements the Malinvaud test, which test the significance of the table dimensions. The package also offers the facility to plot the permuted distribution of the table total inertia as well as of the inertia accounted for by pairs of selected dimensions. The two latter facilities allows to test the significance of the total inertia and of the dimensions the user is interest in. 
For more details about the rationale behind the use of the implemented CA interpretation facilities, see the journal article Alberti 2013 and Alberti 2015 cited below. As to the situations in which permutation test can be applied to CA (e.g., to assess the significance of the dimensions), see Greenacre 2007 (198-199).
}
\author{
Gianmarco ALBERTI

Maintainer: Gianmarco ALBERTI <gianmarco.alberti@um.edu.mt>
}
\references{
Alberti G. 2013, An R script to facilitate Correspondence Analysis. A guide to the use and the interpretation of results from an archaeological perspective, Archeologia e Calcolatori 24, 25-54.

Alberti G. 2015, CAinterprTools: An R package to help interpreting Correspondence Analysis’ results, SoftwareX 1-2, 26-31.

Benzecri J.P. 1992, Correspondence Analysis Handbook, New York, Marcel Dekker.

Blasius J., Greenacre M. 1998, Visualization of Categorical Data, San Diego-London, Academic Press.

Greenacre M. 2007, Correspondence Analysis in Practice, Boca Raton-London-New York, Chapman&Hall/CRC.

Le S., Josse J., Husson F. 2008, FactoMineR: An R package for multivariate analysis, Journal of Statistical Software, 25, 1-18.

Nenadic O., Greenacre M. 2007, Correspondence Analysis in R, with two- and three-dimensional graphics: The ca package, Journal of Statistical Software, 20, 1-13.

Saporta G. 2006, Probabilites, analyse des donnees et statistique (2e ed.), Paris, Editions Technip.
}
\keyword{ package }
\seealso{

ca,FactoMineR,InPosition,Hmisc,ggplot2,ggrepel
}
\examples{
data("greenacre_data") #loads the sample dataset
ca.aver.rule(greenacre_data) #returns a chart suggesting which CA dimension is important for data structure interpretation, according to the so-called average rule
malinvaud(greenacre_data) #performs the Malinvaud test and print on screen the test's result among which the significance of the CA dimensions
sig.ca.dim.perm(greenacre_data,1,2) #calculates the significance of the 1 and 2 CA dimensions via permutation test, and displays the results as a scatterplot
sig.tot.inertia.perm(greenacre_data) #calcultates the significance of the CA total inertia via permutation test; a density curve of the permuted total inertia is displayed along with the observed total inertia and the 95th percentiale of the permuted total inertia. The latter can be regarded as a 0.05 alpha threshold for the observed total inertia significance.
ca.corr(greenacre_data) #displays a bar plot of the strenght of the correlation between rows and columns of the input contingency table
ca.rows.cntr(greenacre_data,1) #displays the contribution of the row categories to the 1 CA dimension
ca.rows.qlt(greenacre_data,3) #displays the quality of row categories display on the sub-space determined by the 1&2 and 1&3 CA dimensions
ca.rows.corr(greenacre_data,1) #displays the correlation of the row categories with the 1 CA dimension
}
