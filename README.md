# xendev

A dockerized terminal-based vim-centric development environment.

[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](LICENSE)

## Tools

- [Neovim](https://github.com/neovim/neovim): Vim-fork focused on extensibility and usability
- [SpaceVim](https://github.com/SpaceVim/SpaceVim): A community-driven modular vim/neovim distribution - The ultimate vimrc
- [Node.js](https://github.com/nodejs/node): Node.js JavaScript runtime
- [Tomb](https://github.com/dyne/Tomb): the Crypto Undertaker
- [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt): An informative and fancy bash prompt for Git users
- [bfg-repo-cleaner](https://github.com/rtyley/bfg-repo-cleaner): Removes large or troublesome blobs like git-filter-branch does, but faster
- [coc.nvim](https://github.com/neoclide/coc.nvim): Conquer of Completion; Make your Vim/Neovim as smart as VSCode
- [codemod](https://github.com/facebookarchive/codemod): A tool/library to assist with large-scale codebase refactors
- [cpanminus](https://github.com/miyagawa/cpanminus): get, unpack, build and install modules from CPAN
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy): Good-lookin' diffs. Actually… nah… The best-lookin' diffs
- [entr](https://github.com/eradman/entr): Run arbitrary commands when files change
- [fish-shell](https://github.com/fish-shell/fish-shell): The user-friendly command line shell
- [forgit](https://github.com/wfxr/forgit): A utility tool powered by fzf for using git interactively
- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder
- [git](https://github.com/git/git), [git-lfs](https://github.com/git-lfs/git-lfs): Git extension for versioning large files
- [go](https://github.com/golang/go): The Go programming language
- [grip](https://github.com/joeyespo/grip): Preview GitHub README.md files locally before committing them
- [import-js](https://github.com/galooshi/import-js): A tool to simplify importing JS modules
- [jq](https://github.com/stedolan/jq): Command-line JSON processor
- [kpcli](http://kpcli.sourceforge.net/): A command line interface for KeePass
- [llvm-project](https://github.com/llvm/llvm-project): (clang) A collection of modular and reusable compiler and toolchain technologies
- [ninja-build](https://github.com/ninja-build/ninja): A small build system with a focus on speed
- [platformio-core](https://github.com/platformio/platformio-core): A professional collaborative platform for embedded development
- [prettier](https://github.com/prettier/prettier): Prettier is an opinionated code formatter
- [ripgrep](https://github.com/BurntSushi/ripgrep): recursively searches directories for a regex pattern while respecting your gitignore
- [silversearcher-ag](https://github.com/ggreer/the_silver_searcher): A code-searching tool similar to ack, but faster
- [solc-js](https://github.com/ethereum/solc-js): Javascript bindings for the Solidity compiler
- [solidity](https://github.com/ethereum/solidity): Solidity, the Smart Contract Programming Language
- [taskbook](https://github.com/klaussinani/taskbook): Tasks, boards & notes for the command-line habitat
- [ts-lehre](https://github.com/heavenshell/ts-lehre): Generate document block(JsDoc, EsDoc, TsDoc) from source code
- [xclip](https://github.com/astrand/xclip): Command line interface to the X11 clipboard
- [yarn](https://github.com/yarnpkg/yarn): Fast, reliable, and secure dependency management
- [tmux](https://github.com/tmux/tmux): A terminal multiplexer
  - [tpm](https://github.com/tmux-plugins/tpm): Tmux Plugin Manager
  - [tmux-gruvbox](https://github.com/egel/tmux-gruvbox): Gruvbox color scheme for Tmux
- and more...

## DX (vim)

- Language Server Protocol (LSP) servers for languages including:
  - bash
  - c/c++
  - css
  - dockerfile
  - eslint
  - html
  - javascript
  - json
  - typescript
- Code formatting support for languages including:
  - c/c++
  - css
  - html
  - javascript
  - json
  - markdown
  - solidity
  - typescript
  - xml
  - yaml

## Preferences

- vi-style key bindings
- dark [gruvbox](https://github.com/morhetz/gruvbox) color scheme
- [FROM ubuntu:21.04](https://hub.docker.com/_/ubuntu)
- `LOCALE=en_US.UTF-8`

## Howto

### Host "Requirements"

- use of a terminal with:
  - truecolor support (use scripts in [test/](test/) to test support inside `xendev`)
  - a patched font like one from [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) with [powerline](https://github.com/powerline/fonts) symbols
- docker-compose
- make (or manually run the commands in the [Makefile](Makefile))

### Build

- Optionally configure things in [.env](.env)
- `cd xendev/ && make build` (or `docker-compose build`)

### Run

- TODO...

## Configuration

- See [conf/](conf/) files

### vim CoC (autocompletion)

| Configuration Location                                                             | Purpose                             |
| ---------------------------------------------------------------------------------- | ----------------------------------- |
| [conf/SpaceVim.d/coc-settings.json](conf/SpaceVim.d/coc-settings.json)             | coc settings                        |
| [conf/SpaceVim.d/init.toml](conf/SpaceVim.d/init.toml)                             | enable coc as spacevim autocomplete |
| [conf/SpaceVim.d/autoload/myspacevim.vim](conf/SpaceVim.d/autoload/myspacevim.vim) | set coc home                        |
| [Dockerfile](Dockerfile)                                                           | install coc extensions with nvim    |
