#' Plot a treemix graph
#'
#' Plot a treemix graph with ggplot from the treemixResult obj
#'
#' @param obj an object of class treemixResult
#'
#' @return a ggplot object
#'
#' @examples
#' infiles <- system.file('extdata', package='treemixTools') |> list.files(full.names=TRUE)
#' inStem <- infiles[1] |> gsub(pattern=".cov.gz", replacement="")
#' obj <- read_treemixResult(inStem)
#' plot_treemix_graph(obj)
#'
#'
#' @export
plot_treemix_graph <- function(obj){
  # check package requirement
  if(!requireNamespace(c('aphylo', 'ape'))) {
    stop("package \"aphylo\" must be installed")
  }
  # convert df.edge to phylo
  df.edge <- obj$edges %>%
    filter(V5!="MIG")
  mat.edge <- as.matrix(df.edge[,1:2])
  phylo <- aphylo:::as.phylo.matrix(mat.edge, edge.length=df.edge$V3)
  # create df.link from migration edge
  df.link <- obj$edges %>%
    dplyr::filter(V5=="MIG") %>%
    dplyr::rename(from=1, to=2, weight=4, type=5) %>%
    dplyr::mutate_at(c('from', 'to'), as.character)
  # replace label based on vertices value in phylo and df.link before plotting
  df.lab <- obj$vertices %>%
    dplyr::filter(V5=="TIP")
  phylo$tip.label <- df.lab$V2[match(phylo$tip.label, df.lab$V1)]
  df.link <- df.link %>%
    dplyr::mutate(from=plyr::mapvalues(from, from=df.lab$V1, to=df.lab$V2, warn_missing = FALSE),
                  to=plyr::mapvalues(to, from=df.lab$V1, to=df.lab$V2, warn_missing = FALSE))
  # plot tree with ggtree
  fig <- ggtree::ggtree(phylo) +
    ggtree::geom_tiplab() + ggtree::geom_nodepoint() +
    ggplot2::scale_x_continuous(expand=ggplot2::expansion(mult=c(0.02,0.1))) +
    ggtree::geom_taxalink(df.link, ggplot2::aes(taxa1=from, taxa2=to, color=weight),
                  arrow=grid::arrow(length=grid::unit(0.05, "npc")), size=1, alpha=0.5,
                  hratio=1) +
    ggplot2::scale_color_gradient2(low='yellow', mid='red', high='darkred',
                          midpoint=0.5, limits=c(0,1),
                          name='MigrationWeight') +
    ggplot2::labs(x='Drift parameter') +
    ggplot2::theme(axis.line.x = ggplot2::element_line(),
          axis.title.x = ggplot2::element_text(),
          axis.text.x = ggplot2::element_text(),
          axis.ticks.x = ggplot2::element_line())
  return(fig)
}
