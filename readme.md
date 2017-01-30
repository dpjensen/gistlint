# gistlint.sh
This is a fairly simple shell script that runs pylint across files called out in `git status`

It can be used as git hook, as it will return non-zero if the pylint score for a file has gone down.

# Usage
```
#run across all files in pwd
$gistlint.sh all
#run across files called out by git status. Will ignore Deleated and untracked files.
$gistlist git 
```
