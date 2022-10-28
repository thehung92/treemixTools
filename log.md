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


```
