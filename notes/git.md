# Git

Show file contents from a commit
  $ git show REVISION:/path/to/file

Fastforward accurev to match newer wsldev/cp branch
  $ git fetch . wsldev/cp:accurev

Rebase changes on forked branch leaving other topic branches as-is
  $ git rebase --onto target-branch topic-branch forked-branch

