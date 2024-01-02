# Git

Show upstream commits
  $ git log ..@{u}

Show local unpushed changes and upstream
  $ git log ...@{u}

Show local unpushed changes
  $ git log @{u}..

Show file contents from a commit
  $ git show REVISION:/path/to/file

Fastforward accurev to match newer wsldev/cp branch
  $ git fetch . wsldev/cp:accurev

Fastforward main to origin/main
  $ git fetch origin main:main

Rebase changes on forked branch leaving other topic branches as-is
  $ git rebase --onto target-branch topic-branch forked-branch

Search files in index
  $ git grep --cached "searchterm" $(git diff --cached --name-only)

Restore file from another branch
  $ git restore --source <branch> <file>

Shorthands:
  @{u} HEAD@{upstream}
  A..B same as ^A B or B --not A; means show changes in B excluding those in A

git bisect
	$ git bisect start
  $ git bisect bad                # Current version bad
  $ git bisect good good-branch   # Mark known good
	...
  $ git bisect run command args   # Auto-bisect
  $ git bisect reset              # cleanup

## Patching

Apply a patch from different repo to the active branch
    git --git-dir=/path/to/1/.git format-patch --stdout sha1^..sha1 | git am -3

## Education Resources

* [Git Introduction Video](https://www.youtube.com/watch?v=1ffBJ4sVUb4) from 2013 Linux Conference
