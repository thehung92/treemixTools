#' Plot a treemix residual heatmap
#'
#' Plot a treemix residual heatmap with ggplot from the treemixResult obj
#'
#' @param obj an object of class treemixResult
#'
#' @return a ggplot object
#'
#' @examples
#' infiles <- system.file('extdata', package='treemixTools') |> list.files(full.names=TRUE)
#' inStem <- infiles[1] |> gsub(pattern=".cov.gz", replacement="")
#' obj <- read_treemixResult(inStem)
#' plot_treemix_residual(obj)
#'
#' @export
plot_treemix_residual <- function(obj) {
  # sort by pop name to make it consistent
  df.resid <- obj$resid
  df.resid <- df.resid[, order(colnames(df.resid))]
  df.resid <- df.resid[order(rownames(df.resid)), ]
  #
  df <- custom_convert(df.resid)
  df <- df %>%
    mutate(value = value / obj$mse)
  #
  fig.resid <- ggplot(df, aes(pop1, pop2, fill=value)) +
    geom_tile(color='white', na.rm=TRUE) +
    scale_fill_gradient2(low='blue', high='red', mid='white', na.value='white',
                         name='res') +
    scale_y_discrete(limits=rev(levels(df$pop2))) +
    labs(title='Residuals') +
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
    guides(fill=guide_colorbar(title='res (SE)', title.position = 'top', title.hjust = 0.5))
  return(fig.resid)
}
