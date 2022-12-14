% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_treemix_drift.R
\name{plot_treemix_drift}
\alias{plot_treemix_drift}
\title{Plot a treemix drift heatmap}
\usage{
plot_treemix_drift(obj)
}
\arguments{
\item{obj}{an object of class treemixResult}
}
\value{
a ggplot object
}
\description{
Plot a treemix genetic drift heatmap with ggplot from the treemixResult obj
}
\examples{
infiles <- system.file('extdata', package='treemixTools') |> list.files(full.names=TRUE)
inStem <- infiles[1] |> gsub(pattern=".cov.gz", replacement="")
obj <- read_treemixResult(inStem)
plot_treemix_drift(obj)


}
