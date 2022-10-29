# log

## log of git command

```shell
# push existing dir to github repo
# -u flag mean to: set the default stream for next push
# -f flag mean to: overwrite existing file on the repos
git push -u -f origin master

# download the remote branch
# it will create a branch name remotes/origin/main in your local `branch -a`
# it will also create another FETCH_HEAD to mark the state of that branch
git fetch origin main
# merge that branch
git checkout main
git  merge origin/main

#


```

## log r command

url: 

```R
# the following r code will create a blank file in the R dir
library(devtools)
use_r("treemix_plot_graph")
use_r('read_treemixResult')

# write simple function in that blank file
# test the function like you have build and load the package # this will only put the function into your global env
load_all() # or Cmd + shift + L
# build the documentation with
document() # or Cmd + shift + D
# run standard r check if everything work # it create error when there is no example to check
check()

# create MIT license with you as the author # will create a LICENSE file and an .md file
use_mit_license("Hung TT Nguyen")

# a minimall working R package
install()

# Test
# it's good practice to write a meaningful test for your function
# use_testhat function will add the `testthat` to the package dependencies
use_testthat()
# create a test for a function
use_test('treemix_plot_graph')

# after editing the test script
# run the test with the following function
test()


# It's always good to import function from another packages
# for example let's use a stringr function
# the following function will add stringr to dependencies and description so that you don't have to edit manually
use_package('stringr')
use_package('ape')
use_package('aphylo', type='Depends')
use_package('magrittr')
use_package('ggtree')
use_package('ggplot2')
use_package('ggthemes')
use_package('grid')


# refer to the function with `stringr::str_c`
# document your function and load it
document()
load_all()

# try create a README.md with the code
# it's more automatic, it's better
use_readme_rmd()
# after you are satisfied with your markdown code, build the md file
build_readme()

# prep external raw data for test
#

# create package level import with the following function # it will create R/treemixTools-package.R
usethis::use_package_doc()
#  function to import package directive
usethis::use_import_from('dplyr', 'filter')
usethis::use_import_from('ape', 'as.phylo')


```

