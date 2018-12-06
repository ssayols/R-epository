#' ---
#' title: "Imputation of missing values"
#' output:
#'   html_document:
#'     toc: true
#'     toc_float:
#'       collapsed: false
#'       smooth_scroll: false
#' ---
#/* Note: compile with rmarkdown::render() since knitr::spin() cannot deal with the metadata */

#' Fill in missing values with the closest neighbors (unsupervised, KNN, k=10).
#'

#' Parameters used:
#+ parameters
NA0.split     <- .9  # number of NA in the table that we assume that it's because the protein is not there
NA0.roughtfix <- .5  # times the min(train$pro) to substitute NA. Considered the detection limit of the machine
KNN.neighbors <- 10  # number of neighbors used for impute.knn
STEPS         <- 100 # number of iterations

#' The strategy to follow assumes most NA (75%) are due to values below the
#' detection limit. Thus, `r NA0.split` of the NA will take a value of `r NA0.roughtfix` * min(x),
#' and like this, we don't overestimate the quantification of missing proteins.
#' We repeat this process `r STEPS` times and we take the average.
#'

#' In order to estimate the remaining missing values, we'll use KNN imputation
#' taking the average of the closest `r KNN.neighbors` neighbors.
#'

#' *Note*: points to improve:
#'   -75%-25% split, but we don't have info of how many drop-outs are due to
#'    protein not there.
#'   -Averaging the 100 folds. Would be nice to apply some Bayes here and determine
#'    from which distribution (the 75% rought fixed values or the 25% imputed)
#'    the real value comes from.
#'   -Optimize the number of neighbors.
#'   -Optimize the number of proteins taken at each fold for the imputation.
#' All this optimizations sound reasonable, but may mean a lot of hands-on coding
#' to get just little benefits, if the assumption that 'most drop-outs are due to
#' protein not there' holds.

#+ setup, include=FALSE
library(knitr)
opts_knit$set(root.dir="/home/sayolspu/src/PrecisionFDA_Sample_Mislabeling_Correction_Challenge")

#+ preamble, message=FALSE
library(impute)
library(randomForest)
library(ggplot2)
library(RColorBrewer)
library(biomaRt)
library(pheatmap)

set.seed(666)
options(stringsAsFactors=FALSE)
pal <- brewer.pal(9, "Set1")
pal.alpha <- paste0(pal, "80")

#' ## Load data
train <- lapply(c(sum ="./data/sum_tab_1.tsv",
                  sum2="./data/sum_tab_2.tsv",
                  cli ="./data/train_cli.tsv",
                  pro ="./data/train_pro.tsv",
                  rna ="./data/train_rna.tsv"),
                read.delim)
test  <- lapply(c(cli="./data/test_cli.tsv",
                  pro="./data/test_pro.tsv",
                  rna="./data/test_rna.tsv"),
                read.delim)
