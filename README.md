# Dotfiles (Ken Brucker)

My OS X dotfiles.

## How to install

The installation step requires the [XCode Command Line
Tools](https://developer.apple.com/downloads) and may overwrite existing
dotfiles in your HOME and `.vim` directories.

```bash
$ bash -c "$(curl -fsSL raw.github.com/KnBrckr/dotfiles/master/bin/dotfiles)"
```

N.B. If you wish to fork this project and maintain your own dotfiles, you must
substitute my username for your own in the above command and the 2 variables
found at the top of the `bin/dotfiles` script.

## How to update

You should run the update when:

* You make a change to `~/.dotfiles/git/gitconfig` (the only file that is
  copied rather than symlinked).
* You want to pull changes from the remote repository.
* You want to update Homebrew formulae and Node packages.

Run the dotfiles command:

```bash
$ dotfiles
```

Options:

<table>
    <tr>
        <td><code>-h</code>, <code>--help</code></td>
        <td>Help</td>
    </tr>
    <tr>
        <td><code>-l</code>, <code>--list</code></td>
        <td>List of additional applications to install</td>
    </tr>
    <tr>
        <td><code>--no-packages</code></td>
        <td>Suppress package updates</td>
    </tr>
    <tr>
        <td><code>--no-sync</code></td>
        <td>Suppress pulling from the remote repository</td>
    </tr>
</table>


## Features ##

### Oh My Zsh! ###

Uses [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh/wiki) for zsh shell configuration

### Automatic software installation


Vim plugins:

* [ctrlp.vim](https://github.com/kien/ctrlp.vim)
* [html5.vim](https://github.com/othree/html5.vim)
* [mustache.vim](https://github.com/juvenn/mustache.vim)
* [syntastic](https://github.com/scrooloose/syntastic)
* [vim-colors-solarized](https://github.com/altercation/vim-colors-solarized)
* [vim-git](https://github.com/tpope/vim-git)
* [vim-haml](https://github.com/tpope/vim-haml)
* [vim-javascript](https://github.com/pangloss/vim-javascript)
* [vim-less](https://github.com/groenewege/vim-less)
* [vim-markdown](https://github.com/tpope/vim-markdown)
* [vim-pathogen](https://github.com/tpope/vim-pathogen)

### Custom OS X defaults

Custom OS X settings can be applied during the `dotfiles` process. They can
also be applied independently by running the following command:

```bash
$ osxdefaults
```

### Bootable backup-drive script

Last time this was tested it was not working.

These dotfiles include a script that uses `rync` to incrementally back up your
data to an external, bootable clone of your computer's internal drive. First,
make sure that the value of `DST` in the `bin/backup` script matches the name
of your backup-drive. Then run the following command:

```bash
$ backup
```

For more information on how to setup your backup-drive, please read the
preparatory steps in this post on creating a [Mac OS X bootable backup
drive](http://nicolasgallagher.com/mac-osx-bootable-backup-drive-with-rsync/).

### Local/private Bash and Vim configuration

Any special-case Vim directives local to a machine should be stored in a
`~/.vimrc.local` file on that machine. The directives will then be automatically
imported into your master `.vimrc`.

Any private and custom commands and configuration should be placed in a
`~/.shell_profile.local` file. This file will not be under version control or
committed to a public repository. If `~/.shell_profile.local` exists, it will be
sourced for inclusion in `bash_profile` or `zshprofile`.

Here is an example `~/.shell_profile.local`:

```bash
# PATH exports
PATH=$PATH:~/.gem/ruby/1.8/bin
export PATH

# Git credentials
# Not under version control to prevent people from
# accidentally committing with your details
VCS_AUTHOR_NAME="John Doe"
VCS_AUTHOR_EMAIL="jd@example.com"

# Done in dotfiles when putting config file in place
# Set the credentials (modifies ~/.gitconfig)
# git config --global user.name "$VCS_AUTHOR_NAME"
# git config --global user.email "$VCS_AUTHOR_EMAIL"

# Aliases
alias code="cd ~/Code"
```

N.B. Because the `git/gitconfig` file is copied to `~/.gitconfig`, any private
git configuration specified in `~/.bash_profile.local` will not be committed to
your dotfiles repository.


## Adding new git submodules

If you want to add more git submodules, e.g., Vim plugins to be managed by
pathogen, then follow these steps while in the root of the superproject.

```bash
# Add the new submodule
git submodule add https://example.com/remote/path/to/repo.git vim/bundle/one-submodule
# Initialize and clone the submodule
git submodule update --init
# Stage the changes
git add vim/bundle/one-submodule
# Commit the changes
git commit -m "Add a new submodule: one-submodule"
```


## Updating git submodules

Updating individual submodules within the superproject:

```bash
# Change to the submodule directory
cd vim/bundle/one-submodule
# Checkout the desired branch (of the submodule)
git checkout master
# Pull from the tip of master (of the submodule - could be any sha or pointer)
git pull origin master
# Go back to main dotfiles repo root
cd ../../..
# Stage the submodule changes
git add vim/bundle/one-submodule
# Commit the submodule changes
git commit -m "Update submodule 'one-submodule' to the latest version"
# Push to a remote repository
git push origin master
```

Now, if anyone updates their local repository from the remote repository, then
using `git submodule update` will update the submodules (that have been
initialized) in their local repository. N.B This will wipe away any local
changes made to those submodules.


## Acknowledgements

Inspiration and code was taken from many sources, including:

* [Moving to zsh](https://scriptingosx.com/2019/06/moving-to-zsh/)
* [@](https://github.com/necolas) (Nicolas Gallagher)
  [https://github.com/necolas/dotfiles]()
* [@mathiasbynens](https://github.com/mathiasbynens) (Mathias Bynens)
  [https://github.com/mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
* [@tejr](https://github.com/tejr) (Tom Ryder)
  [https://github.com/tejr/dotfiles](https://github.com/tejr/dotfiles)
* [@gf3](https://github.com/gf3) (Gianni Chiappetta)
  [https://github.com/gf3/dotfiles](https://github.com/gf3/dotfiles)
* [@cowboy](https://github.com/cowboy) (Ben Alman)
  [https://github.com/cowboy/dotfiles](https://github.com/cowboy/dotfiles)
* [@alrra](https://github.com/alrra) (Cãtãlin Mariş)
  [https://github.com/alrra/dotfiles](https://github.com/alrra/dotfiles)
