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

When hierarchy is different and/or some files not present use `git apply`
    git apply --reject -pN --directory=<new path>

## Fixup author references in commits

    % git rebase -i # Change pick to edit to update the commit

    For each commit:

    % git commit --amend --author="Author Name <email@address.com>" --no-edit
    % git rebase --continue

## Education Resources

* [Git Introduction Video](https://www.youtube.com/watch?v=1ffBJ4sVUb4) from 2013 Linux Conference
* [Introduction to Git with Scott Chacon](https://www.youtube.com/watch?v=ZDR433b0HJY) -- Also long (1:20). Includes merge conflict discussion, and other good hints on using Git day-to-day. (Note that some of the referenced links are stale as the presentation is from 2011.)
* [On writing a good commit message](https://cbea.ms/git-commit/)
* [Using a template to write better commit messages](https://gist.github.com/lisawolderiksen/a7b99d94c92c6671181611be1641c733)
* [Write better commit messages](https://www.freecodecamp.org/news/how-to-write-better-git-commit-messages/)
* [My Favorite Git Commit](https://dhwthompson.com/2019/my-favourite-git-commit)
* [Telling Stories through your commits](https://blog.mocoso.co.uk/talks/2015/01/12/telling-stories-through-your-commits/)
* [A Branch in Time (a story about revision histories)](https://tekin.co.uk/2019/02/a-talk-about-revision-histories)
