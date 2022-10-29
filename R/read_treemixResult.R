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
#' read_treemixResult(inStem)
#' @export
read_treemixResult <- function(stem, ...) {
  # check if all the files of treemix result exist
  ff <- sapply(c("cov.gz","modelcov.gz","treeout.gz","vertices.gz","edges.gz","llik"), function(f) paste0(stem, ".", f))
  if (!all(sapply(ff, file.exists))) {
    stop(paste0("Can't find all outputs from TreeMix run with prefix '",stem,"'"))
  }
  # read the covariance matrix
  cov <- as.matrix( read.table(gzfile(ff[1]), as.is = TRUE, head = TRUE, quote = "", comment.char = "") )
  closeAllConnections()
  mod <- as.matrix( read.table(gzfile(ff[2]), as.is = TRUE, head = TRUE, quote = "", comment.char = "") )
  closeAllConnections()
  # compute the residual
  resid <- mod - cov
  # filter the matrix to only the lower triangle to plot
  i <- upper.tri(resid, diag = FALSE)
  # compute r2
  sse <- sum( (resid[i] - mean(resid[i]))^2 )
  ssm <- sum( (mod[i] - mean(mod[i]))^2 )
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
  closeAllConnections()
  e <- read.table(gzfile(e), as.is  = TRUE, comment.char = "", quote = "")
  closeAllConnections()
  e[,3] <- e[,3]*e[,4]
  #e[,3] <- e[,3]*e[,4]
  # read the tree as an phylo object
  conn <- gzfile(ff[3])
  tree <- ape::read.tree(text = readLines(conn, n = 1))
  close(conn)
  # aggregate in an obj
  obj <- list(cov = cov, cov.est = mod, resid = resid,
              sse = sse, ssm = ssm, r2 = r2, llik = llik, m = m,
              tree = tree, vertices = d, edges = e)
  # return the obj in a list
  return(obj)
}
