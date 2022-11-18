#!/usr/bin/env Rscript
#
# library(treemixTools)
devtools::load_all('/Users/hung/Data/side-project/treemixTools')
library(tidyverse)
library(patchwork)
#
infiles <- system.file('extdata', package='treemixTools') |> list.files(full.names=TRUE)
inStem <- infiles[1] |> gsub(pattern=".cov.gz", replacement="")
obj <- read_treemixResult(inStem)
fig.tree <- plot_treemix_graph(obj)
  # theme(legend.position = 'none')
fig.drift <- plot_treemix_drift(obj)
fig.resid <- plot_treemix_residual(obj)

fig.merge <- fig.tree + fig.drift + fig.resid +
  plot_layout(ncol=1, nrow=3,
              #guides='collect'
  ) +
  plot_annotation(tag_levels = 'A') & theme(legend.justification = "left")
# save to website local dir
outDir="/Users/hung/Data/side-project/thehung92.github.io/assets/img/"
ggplot2::ggsave(filename=paste0(outDir, 'treemixTools_thumbnail.jpg'), plot=fig.tree,
       width=6, height=3, units='in', dpi=300)
ggplot2::ggsave(filename=paste0(outDir, 'treemixTools_showcase.jpg'), plot=fig.merge,
       width=7, height=9, units='in', dpi=300)
### debug connection ####
