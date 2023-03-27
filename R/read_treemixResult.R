#' Read treemix result
#'
#' Check if files exist and read treemix result into a list
#'
#' @param inStem Stem of the path to the treemix result
#'
#' @return a list of treemix result
#'
#' @examples
#' infiles <- system.file('extdata', package='treemixTools') |> list.files(full.names=TRUE)
#' inStem <- infiles[1] |> gsub(pattern=".cov.gz", replacement="")
#' obj <- read_treemixResult(inStem)
#' @export
read_treemixResult <- function(stem, ...) {
  # check if all the files of treemix result exist
  ff <- sapply(c("cov.gz","modelcov.gz","treeout.gz","vertices.gz","edges.gz","llik"), function(f) paste0(stem, ".", f))
  if (!all(sapply(ff, file.exists))) {
    stop(paste0("Can't find all outputs from TreeMix run with prefix '",stem,"'"))
  }
  # read the covariance matrix and order based on names
  ## covariance matrix
  cov <- as.matrix( read.table(gzfile(ff[1]), as.is = TRUE, head = TRUE, quote = "", comment.char = "") )
  cov <- cov[order(rownames(cov)), order(colnames(cov))]
  ## model covariance matrix
  mod <- as.matrix( read.table(gzfile(ff[2]), as.is = TRUE, head = TRUE, quote = "", comment.char = "") )
  mod <- mod[order(rownames(mod)), order(colnames(mod))]
  # read the covariance standard error
  covse <- as.matrix( read.table(gzfile(paste0(stem, '.covse.gz')), as.is=TRUE, head = TRUE, quote="", comment.char="") )
  # compute the residual matrix
  resid <- cov - mod
  # filter the matrix to only the lower triangle to compute other params
  i <- upper.tri(resid, diag = FALSE)
  # compute mean standard error of covariance matrix estimated from genetic data
  # this can be use to plot the standard error bar on the plot
  mse <- mean( covse )
  # compute r2 # Variance relatedness between populations explained by the model
  sse <- sum( (resid[i] - mean(resid[i]))^2 ) # numerator of eq.30
  ssm <- sum( (mod[i] - mean(mod[i]))^2 ) # denominator of eq.30
  r2 <- 1 - sse/ssm
  # number of migration event from .llik file
  llik.raw <- readLines(ff[6], n = 2)[2]
  llik.matched <- stringr::str_match(llik.raw, "with (.+) migration events: (.+)\\s+")
  llik <- as.double(llik.matched[,3])
  m <- as.integer(llik.matched[,2])
  # read the vertice and edge data frame
  d <- paste0(stem, ".vertices.gz")
  e <- paste0(stem, ".edges.gz")
  d <- read.table(gzfile(d), as.is = TRUE, comment.char = "", quote = "")
  e <- read.table(gzfile(e), as.is  = TRUE, comment.char = "", quote = "")
  e[,3] <- e[,3]*e[,4]
  #e[,3] <- e[,3]*e[,4]
  # read the tree as an phylo object
  conn <- gzfile(ff[3])
  tree <- ape::read.tree(text = readLines(conn, n = 1))
  close(conn)
  # aggregate in an obj
  obj <- list(cov = cov, covse = covse,
              mod = mod, resid = resid,
              mse = mse, sse = sse, ssm = ssm, r2 = r2, llik = llik, m = m,
              tree = tree, vertices = d, edges = e)
  # return the obj in a list
  return(obj)
}

#' Parse vertices table from treemix object
#'
#' this is only a reminder with named data frame
#'
#' @param obj object from read_treemixResult function
#'
#' @return a named data frame of df.vertices
#'
#' @examples
#' parse_verDf_fromObj(obj_treemix)
#' @export
parse_verDf_fromObj <- function(obj, ...) {
  df.ver = obj$vertices |>
    dplyr::rename(node = 1, lab = 2, is.root = 3, is.mig = 4, is.tip = 5,
           par = 6, chi1 = 7, ntip.clade1 = 8, chi2 = 9, ntip.clade2 = 10, newick = 11)
  return(df.ver)
}
