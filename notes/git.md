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
