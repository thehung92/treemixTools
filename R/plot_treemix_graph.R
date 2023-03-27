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
#' @importFrom dplyr filter rename mutate mutate_at
#' @importFrom plyr mapvalues
#' @importFrom ggtree ggtree geom_tiplab geom_nodepoint geom_taxalink
#' @importFrom ggplot2 scale_x_continuous expansion scale_color_gradient
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
    filter(V5=="MIG") %>%
    rename(from=1, to=2, weight=4, type=5) %>%
    mutate_at(c('from', 'to'), as.character)
  # replace label based on vertices value in phylo and df.link before plotting
  df.lab <- obj$vertices %>%
    filter(V5=="TIP")
  phylo$tip.label <- df.lab$V2[match(phylo$tip.label, df.lab$V1)]
  df.link <- df.link %>%
    mutate(from = mapvalues(from, from=df.lab$V1, to=df.lab$V2, warn_missing = FALSE),
           to = mapvalues(to, from=df.lab$V1, to=df.lab$V2, warn_missing = FALSE))
  # plot tree with ggtree
  fig <- ggtree(phylo) +
    geom_tiplab() + geom_nodepoint() +
    scale_x_continuous(expand = expansion(mult=c(0.02,0.1))) +
    geom_taxalink(df.link, ggplot2::aes(taxa1=from, taxa2=to, color=weight),
                  arrow=grid::arrow(length=grid::unit(0.05, "npc")), size=1, alpha=0.5,
                  hratio=1) +
    scale_color_gradient(low='yellow', high='red',
                         limits=c(0,0.5),
                         name='MigrationWeight') +
    ggplot2::labs(x='Drift parameter') +
    ggplot2::theme(axis.line.x = ggplot2::element_line(),
          axis.title.x = ggplot2::element_text(),
          axis.text.x = ggplot2::element_text(),
          axis.ticks.x = ggplot2::element_line())
  return(fig)
}
