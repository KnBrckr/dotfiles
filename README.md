# Dotfiles (Ken Brucker)

My OS X dotfiles.

## How to install

The installation step requires the
[XCode Command Line Tools](https://developer.apple.com/downloads)
if used in OSX and may overwrite existing dotfiles in your $HOME, `~/.vim` and
other directories.

```bash
bash -c "$(curl -fsSL raw.github.com/KnBrckr/dotfiles/master/bin/dotfiles)"
```

WARNING: This project is has several configurations specific to me personally.
If you wish to fork this project, the project path in bin/dotfiles must be
changed as well as user identifying information included in git configurations.

Review contents of:

- `bin/dotfiles`
- `config/git/config`
- `config/git/*.inc`

## How to update

You should run the update when:

* You want to pull changes from the remote repository.
* You want to update Homebrew formulae, Node and other packages.

Run the dotfiles command:

```bash
% dotfiles
```

Options:

| Option | Description |
|----|----|
|`-h`, `--help`|Help|
|`-l`, `--list`|List of additional applications to install|
|`--no-packages`|Suppress package updates|
|`--no-sync`|Suppress pulling dotfiles from report repository|

## Features

### Oh My Zsh

Uses [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh/wiki) for zsh shell configuration

### Automatic software installation

Vim plugins:

* [editorconfig-vim](https://github.com/editorconfig/editorconfig-vim)
* [fzf](https://github.com/junegunn/fzf)
* [fzf.vim](https://github.com/junegunn/fzf.vim)
* [gutentags_plus](https://github.com/skywind3000/gutentags_plus)
* [lightline](https://github.com/itchyny/lightline.vim)
* [nerdtree](https://github.com/preservim/nerdtree)
* [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)
* [papercolor-theme](https://github.com/NLKNguyen/papercolor-theme)
* [splitjoin](https://github.com/AndrewRadev/splitjoin.vim)
* [tcomment](https://github.com/tomtom/tcomment_vim)
* [vim-abolish](https://github.com/tpope/vim-abolish)
* [vim-colors-solarized](https://github.com/altercation/vim-colors-solarized)
* [vim-devicons](https://github.com/ryanoasis/vim-devicons)
* [vim-dispatch](https://github.com/tpope/vim-dispatch)
  * Used by cmake4vim to launch async shells
* [vim-fugitive](https://github.com/tpope/vim-fugitive) Git management
* [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
  * Requires ctags support such as exuberant-ctags.
  * [gtags-cscope job failed](https://github.com/ludovicchabant/vim-gutentags/issues/322) -
    chmod +x vim-gutentags/plat/unix/*
* [vim-kitty](https://github.com/fladson/vim-kitty) Kitty terminal emulator
  configuration highlighting
* [vim-kitty-navigator](https://github.com/knubie/vim-kitty-navigator) VIM +
  Kitty navigation
  * Requires copying of pass_keys.py and neighboring_window.py scripts to
    ~/.config/kitty/
* [vim-snippets](https://github.com/honza/vim-snippets)
* [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

### Neovim

Thesaurus is retrieved from zip file found at
https://github.com/vim/vim/issues/629#issuecomment-443293282

#### FZF Notes

After install, use :call fzf#install() to update fzf binary to latest if necessary

### Custom OS X defaults

Custom OS X settings can be applied during the `dotfiles` process. They can
also be applied independently by running the following command:

```bash
% osxdefaults
```

### Local/private Bash and Vim configuration

Any special-case Vim directives local to a machine should be stored in a
`~/.vimrc.local` file on that machine. The directives will then be automatically
imported into your master `.vimrc`.

Any private and custom commands and configuration should be placed in a
`~/.shell_profile.local` file. This file will not be under version control or
committed to a public repository. If `~/.shell_profile.local` exists, it will be
sourced for inclusion in `bash_profile` or `zshprofile`.

### Fastfetch

Part of brew install on MacOS

#### Install on RaspPi

Depending on architecture (uname -m):

    wget -qO fastfetch.tar.gz https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-$(uname -m).tar.gz
    sudo tar xf fastfetch.tar.gz --strip-components=3 -C /usr/local/bin fastfetch-linux-$(uname -m)/usr/bin/fastfetch

## Adding new git submodules

If you want to add more git submodules, e.g., Vim plugins to be managed by
pathogen, then follow these steps while in the root of the superproject.

```bash
# Add the new submodule
git submodule add --depth 1 --name submodule-name https://example.com/remote/path/to/repo.git vim/pack/vendor/opt/submodule-name
# Initialize and clone the submodule
git submodule update --depth 1 --init
# Stage the changes
git add vim/bundle/one-submodule
# Include module in load at startup if desired
vim ~/.vimrc
# Commit the changes
git commit -m "Add a new submodule: submodule-name"
```

## Updating git submodules

Updating packages:

```bash
git submodule update --depth 1 --remote --merge
git commit
```

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

## Removing git submodules

Removing individual submodules within the superproject:

```bash
cd .dotfiles
git submodule deinit vim/pack/vendor/start/<package>
git rm vim/pack/vendor/start/<package>
rm -Rf .git/modules/vim/pack/vendor/start/<package>
git commit
```

Now, if anyone updates their local repository from the remote repository, then
using `git submodule update` will update the submodules (that have been
initialized) in their local repository. N.B This will wipe away any local
changes made to those submodules.

## Acknowledgements

Inspiration and code was taken from many sources, including:

* [Moving to zsh](https://scriptingosx.com/2019/06/moving-to-zsh/)
* [@nicholas](https://github.com/necolas) (Nicolas Gallagher)
  [https://github.com/necolas/dotfiles](https://github.com/necolas/dotfiles)
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
