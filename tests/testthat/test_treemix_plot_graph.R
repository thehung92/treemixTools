test_that("plot_treemix_graph works", {
  infiles <- system.file('extdata', package='treemixTools') |> list.files(full.names=TRUE)
  inStem <- infiles[1] |> gsub(pattern=".cov.gz", replacement="")
  obj <- read_treemixResult(inStem)
  p <- plot_treemix_graph(obj)
  # 2 test based on above code
  expect_no_error(print(p), message = "function run with no error")
  expect_true(is.ggplot(p))
})
