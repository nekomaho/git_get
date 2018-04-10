# Git Get
get_get is Github pull request search from commit hash.

### Usage
to start this tool, you need registration Personal access tokens at Github. it need *repo* scopes.
And set access token to your computers environment variable such as a following.
```
$ export GIT_HUB_AUTH_TOKEN=access token
```
then run bundle install and execute script below, display pull requests include commit.
```
$ bundle exec ruby lib/git_get.rb -u user -r repogitory sha
```

