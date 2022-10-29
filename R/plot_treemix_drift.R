#' Plot a treemix drift heatmap
#'
#' Plot a treemix genetic drift heatmap with ggplot from the treemixResult obj
#'
#' @param obj an object of class treemixResult
#'
#' @return a ggplot object
#'
#' @examples
#' infiles <- system.file('extdata', package='treemixTools') |> list.files(full.names=TRUE)
#' inStem <- infiles[1] |> gsub(pattern=".cov.gz", replacement="")
#' obj <- read_treemixResult(inStem)
#' plot_treemix_drift(obj)
#'
#'
#' @export
plot_treemix_drift <- function(obj) {
  # phylo object
  df.drift <- ape::cophenetic.phylo(obj$tree)
  # change label
  df.lab <- obj$vertices %>%
    filter(V5=="TIP")
  # colnames(df.drift) <- df.lab$V2[match(colnames(df.drift), df.lab$V1)]
  # rownames(df.drift) <- df.lab$V2[match(rownames(df.drift), df.lab$V1)]
  df <- custom_convert(as.matrix(df.drift))
  #
  fun.color <- colorRampPalette(c('lightgrey', 'yellow', 'green', 'blue'))
  fig <- ggplot(df, aes(pop1, pop2, fill=value)) +
    geom_tile(color='white', na.rm=TRUE) +
    scale_fill_gradientn(colors=fun.color(10), na.value=NA) +
    scale_y_discrete(limits=rev(levels(df$pop2))) +
    labs(title='Genetic drift') +
    theme(
      axis.text.x=element_text(),
      axis.title.x=element_blank(),
      axis.title.y=element_blank(),
      panel.grid.major=element_blank(),
      panel.border=element_blank(),
      panel.background=element_blank(),
      axis.ticks = element_blank(),
      #legend.justification = c(1,1),
      #legend.position = c(0.95,0.95)
      plot.title=element_text(hjust=0.5)
    ) +
    guides(fill=guide_colorbar(title.position = 'top', title.hjust = 0.5))
  return(fig)
}

#' internal function
#'
#' convert the pairwise matrix into long table that can be plot by geom_tile
#' @keywords internal
#' @param mat the pairwise matrix in matrix class
#' @return a long tibble
custom_convert <- function(mat) {
  mat[lower.tri(mat)] <- NA
  df <- as_tibble(mat) %>%
    mutate(pop1=rownames(mat)) %>%
    tidyr::pivot_longer(cols=1:ncol(mat), names_to = 'pop2', values_to = 'value') %>%
    mutate(pop1=factor(pop1, levels=rownames(mat)), pop2=factor(pop2, levels=colnames(mat)))
  return(df)
}
