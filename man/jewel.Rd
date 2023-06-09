% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/jewel.R
\name{jewel}
\alias{jewel}
\title{Estimate Gaussian graphical models from multiple datasets}
\usage{
jewel(
  X,
  lambda1,
  lambda2 = NULL,
  Theta = NULL,
  W = NULL,
  tol = 0.01,
  maxIter = 10000,
  stability = FALSE,
  stability_nsubsets = 25,
  stability_frac = 0.8,
  verbose = TRUE
)
}
\arguments{
\item{X}{a list of \code{K} numeric data matrices of \code{n_k} samples and 
\code{p} variables (\code{n_k} can be different for each matrix).}

\item{lambda1}{a number, first regularization parameter (of the common penalty).}

\item{lambda2}{an optional number, second regularization parameter 
(of the class-specific penalty). If NULL, set to \code{lambda_2 = lambda_1 * 1.4}}

\item{Theta}{an optional list of \code{K} regression coefficient matrices 
of the size \code{p} by \code{p}. User-provided initialization can be used 
for warm-start procedures. If NULL, initialized as all zeros.}

\item{W}{an optional list of \code{K} weights matrices of the size 
\code{p} by \code{p}. User-provided initialization can be used when some 
vertices are believed to be hubs. If NULL, initialized as all ones.}

\item{tol}{an optional number, convergence threshold controlling the relative 
error between iterations. The default value is 0.01.}

\item{maxIter}{an optional number, maximum allowed number of iterations. 
The default value is 10 000.}

\item{stability}{if stability = TRUE, stability selection procedure to reduce 
the number of false positives will be applied. \code{n_k / 2} samples are 
randomly chosen in each dataset \code{stability_nsubsets} times and then 
__jewel__ method is applied to each subset. In the final estimate, we include 
only the edges that appear in at least \code{stability_frac} proportion of the subsets. 
By default this procedure is disabled since it increases the running time.}

\item{stability_nsubsets}{an optional number, how many times to subsample 
datasets and apply __jewel__ for stability selection procedure. The default value is 25.}

\item{stability_frac}{an optional number, in what proportion of the stability 
results on subsampled data an edge has to be present to be included into the 
final estimate. The default value is 0.8.}

\item{verbose}{if verbose = FALSE, tracing information printing is disabled. 
The default value is TRUE.}
}
\value{
The following list is returned
\itemize{
  \item \code{CommonG} - an adjacency matrix of the common estimated graph (intersection of \code{K} estimated graphs).
  \item \code{G_list} - a list of \code{K} adjacency matrices for each estimated graph.
  \item \code{Theta} - a list of \code{K} estimated covariance matrices (when stability selection is disabled).
  \item \code{BIC} – a number, value of Bayesian information criterion for resulting graphs (when stability selection is disabled).
}
}
\description{
This function estimates Gaussian graphical models (i.e. networks of conditional dependencies, direct connections between variables) given multiple datasets. 
We assume that datasets contain measurements of the same variables collected under different conditions (different equipment, locations, even sub-types of disease).
}
\examples{
{
K <- 3
p <- 50
n <- 20
data <- generateData_rewire(K = K, p = p, n = n, ncores = 1, verbose = FALSE)
G_list_true <- data$Graphs
X <- data$Data
true_degrees <- rowSums(G_list_true[[1]])
cut <- sort(true_degrees, decreasing = TRUE)[ceiling(p * 0.03)]
apriori_hubs <- ifelse(true_degrees >= cut, 10, 1)
W <- constructWeights(apriori_hubs, K = K)
res <- jewel(X, lambda1 = 0.25, W = W, verbose = FALSE)
}
}
