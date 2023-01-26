# xen/dev:latest

[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](LICENSE)

A modern portable sandboxed containerized terminal-based vim-centric development environment.

Overpowered "dotfiles" intended to run in a number of ways; either within a:

- terminal of your choice
- customized gpu-accelerated terminal
- x11docker-powered full, but minimal, desktop

## Quickstart

```sh
git clone https://github.com/xendarboh/xendev.git
cd xendev
make build
./xendev
```

## Tools

- [Neovim](https://github.com/neovim/neovim): Vim-fork focused on extensibility and usability
  - [SpaceVim](https://github.com/SpaceVim/SpaceVim): A community-driven modular vim/neovim distribution - The ultimate vimrc
  - [coc.nvim](https://github.com/neoclide/coc.nvim): Conquer of Completion; Make your Vim/Neovim as smart as VSCode
  - [neovim-remote](https://github.com/mhinz/neovim-remote): Support for --remote and friends
- [Node.js](https://github.com/nodejs/node): Node.js JavaScript runtime
  - [pnpm](https://github.com/pnpm/pnpm): Fast, disk space efficient package manager
  - [yarn](https://github.com/yarnpkg/yarn): Fast, reliable, and secure dependency management
  - [npm-check](https://github.com/dylang/npm-check): Check for outdated, incorrect, and unused dependencies
  - [npm-check-updates](https://github.com/raineorshine/npm-check-updates): Find newer versions of package dependencies than what your package.json allows
- [Tomb](https://github.com/dyne/Tomb): the Crypto Undertaker
- [circom](https://github.com/iden3/circom): zkSnark circuit compiler
- [codemod](https://github.com/facebookarchive/codemod): A tool/library to assist with large-scale codebase refactors
- [cpanminus](https://github.com/miyagawa/cpanminus): get, unpack, build and install modules from CPAN
- [cypress](https://github.com/cypress-io/cypress): (deps) Fast, easy and reliable testing for anything that runs in a browser
- [deno](https://github.com/denoland/deno): A modern runtime for JavaScript and TypeScript
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy): Good-lookin' diffs. Actually… nah… The best-lookin' diffs
- [entr](https://github.com/eradman/entr): Run arbitrary commands when files change
- [exa](https://github.com/ogham/exa): A modern replacement for ‘ls’
- [fish-shell](https://github.com/fish-shell/fish-shell): The user-friendly command line shell
  - [fisher](https://github.com/jorgebucaran/fisher): A plugin manager for Fish
  - [fish-gruvbox](https://github.com/Jomik/fish-gruvbox): gruvbox theme for fish
- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder
- [git](https://github.com/git/git) (latest stable version)
  - [bfg-repo-cleaner](https://github.com/rtyley/bfg-repo-cleaner): Removes large or troublesome blobs like git-filter-branch does, but faster
  - [git-lfs](https://github.com/git-lfs/git-lfs): Git extension for versioning large files
  - [lazygit](https://github.com/jesseduffield/lazygit): Simple terminal UI for git commands
- [go](https://github.com/golang/go): The Go programming language
- [grip](https://github.com/joeyespo/grip): Preview GitHub README.md files locally before committing them
- [import-js](https://github.com/galooshi/import-js): A tool to simplify importing JS modules
- [jq](https://github.com/stedolan/jq): Command-line JSON processor
- [kpcli](http://kpcli.sourceforge.net/): A command line interface for KeePass
- [llvm-project](https://github.com/llvm/llvm-project): (clang) A collection of modular and reusable compiler and toolchain technologies
- [ncdu](https://code.blicky.net/yorhel/ncdu): NCurses Disk Usage
- [ninja-build](https://github.com/ninja-build/ninja): A small build system with a focus on speed
- [platformio-core](https://github.com/platformio/platformio-core): A professional collaborative platform for embedded development
- [prettier](https://github.com/prettier/prettier): Prettier is an opinionated code formatter
- [ranger](https://github.com/ranger/ranger): A VIM-inspired filemanager for the console
- [retype](https://github.com/retypeapp/retype): An ultra-high-performance static site generator that builds a website based on simple text files
- [ripgrep](https://github.com/BurntSushi/ripgrep): recursively searches directories for a regex pattern while respecting your gitignore
- [rustup](https://github.com/rust-lang/rustup): The Rust toolchain installer
- [silversearcher-ag](https://github.com/ggreer/the_silver_searcher): A code-searching tool similar to ack, but faster
- [solidity](https://github.com/ethereum/solidity): Solidity, the Smart Contract Programming Language
  - [solc-js](https://github.com/ethereum/solc-js): Javascript bindings for the Solidity compiler
- [sqlite](https://github.com/sqlite/sqlite): a small, fast, self-contained, high-reliability, full-featured, SQL database engine
- [starship](https://github.com/starship/starship): The minimal, blazing-fast, and infinitely customizable prompt for any shell!
- [taskbook](https://github.com/klaussinani/taskbook): Tasks, boards & notes for the command-line habitat
- [tmux](https://github.com/tmux/tmux): A terminal multiplexer
  - [tpm](https://github.com/tmux-plugins/tpm): Tmux Plugin Manager
  - [tmux-gruvbox](https://github.com/egel/tmux-gruvbox): Gruvbox color scheme for Tmux
  - [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect): Persists tmux environment across system restarts
  - [tmux-window-name](https://github.com/ofirgall/tmux-window-name): A plugin to name your tmux windows smartly
- [ts-lehre](https://github.com/heavenshell/ts-lehre): Generate document block(JsDoc, EsDoc, TsDoc) from source code
- [xclip](https://github.com/astrand/xclip): Command line interface to the X11 clipboard
- [zoxide](https://github.com/ajeetdsouza/zoxide): A smarter cd command
- and more...

Additionally (and optionally), the following are provided by the X11 base image.

- [Xfce](https://gitlab.xfce.org/xfce): A lightweight desktop environment for UNIX-like operating systems. It aims to be fast and low on system resources, while still being visually appealing and user friendly.
- [kitty](https://github.com/kovidgoyal/kitty): Cross-platform, fast, feature-rich, GPU based terminal
  - [kitty-gruvbox-theme](https://github.com/wdomitrz/kitty-gruvbox-theme): Gruvbox theme for kitty terminal
- [ImageMagick](https://github.com/ImageMagick/ImageMagick): Software suite for displaying, converting, and editing raster image and vector image files
- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts): Developer targeted fonts with a high number of glyphs (icons)
  - [Hack](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack): A typeface designed for source code

Powered-by

- [x11docker](https://github.com/mviereck/x11docker): Run GUI applications and desktops in docker and podman containers. Focus on security.
- [Xendarboh](https://github.com/xendarboh): An Elven Tech Wizard

## Build

### Host Requirements

- docker or podman
- docker compose
- x11docker (not required for tty-only)
  - x11docker gpu support
- make (or manually run the commands in [Makefile](Makefile))

### Configure

Optionally edit [.env](.env).

### Build Image(s)

#### Build the full image with X11 support

```sh
make build
```

#### Build the tty-only image

```sh
make build-tty
```

#### See all make commands

```sh
❯ make                                                                                                                                                                                                        2023-01-21 14:02:33
help                 print this help message with some nifty mojo
build                build docker image with X11 support
rebuild              rebuild docker image with X11 support
build-tty            build tty-only docker image
rebuild-tty          (re)build tty-only docker image with --no-cache --pull
```

## Run Examples

### Within a terminal of your choice

#### Without X11

This is the mode of minimal host requirements, only `docker|podman`

```sh
make build-tty
docker run -ti --rm xen/dev /bin/bash
```

This also works with `make build`, just larger docker image.

#### with X11

In this mode, host clipboard will work with enhanced security provided by `x11docker`.

```sh
x11docker --tty --interactive -- xen/dev
```

- Host terminal expectations, ideally:
  - truecolor support (use scripts in [test/](test/) to test support inside `xendev`)
  - patched font like one from [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) with [powerline](https://github.com/powerline/fonts) symbols

### Within a gpu-accelerated terminal

```sh
x11docker --gpu --clipboard --network -- xen/dev kitty
```

### Within an x11docker-powered desktop

```sh
x11docker --desktop --gpu --clipboard --network -- xen/dev
```

### With directories shared from the host

See the [xendev](xendev) launcher script for a functional example that shares
the host user's ssh, gpg, and git config with the container and provides
writeable access to `~/src`.

Note: Some applications need more privileges or capabilities than x11docker
provides by default; refer to the x11docker docs on [privilege
checks](https://github.com/mviereck/x11docker#privilege-checks).

## Preferences & Philosophy

- vi-style key bindings
- dark [gruvbox](https://github.com/morhetz/gruvbox) color scheme
- [FROM ubuntu:rolling](https://hub.docker.com/_/ubuntu)
- `LOCALE=en_US.UTF-8` (overridden by x11docker)
- modern latest greatest versions; from apt, PPA, install scripts, or built from source
- analog choice of sandboxed security vs function

## Customization

- See [conf/](conf/) files

### Local (machine-specific) Configuration

```sh
cp conf.local.example conf.local
```

- `conf.local/directory_map.txt` list of "from:to" directory mappings for
  preserving current working directory in new tmux windows (since tmux does
  not handle symlinked directories well).

### vim CoC (autocompletion)

| Configuration Location                                                             | Purpose                             |
| ---------------------------------------------------------------------------------- | ----------------------------------- |
| [conf/SpaceVim.d/coc-settings.json](conf/SpaceVim.d/coc-settings.json)             | coc settings                        |
| [conf/SpaceVim.d/init.toml](conf/SpaceVim.d/init.toml)                             | enable coc as spacevim autocomplete |
| [conf/SpaceVim.d/autoload/myspacevim.vim](conf/SpaceVim.d/autoload/myspacevim.vim) | set coc home                        |
| [Dockerfile](Dockerfile)                                                           | install coc extensions with nvim    |
