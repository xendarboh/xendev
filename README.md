# xen/dev:latest

[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](LICENSE)

A modern portable sandboxed (dockerized) terminal-based vim-centric development environment.

Overpowered "dotfiles" intended to run in a number of ways; either within a:

- customized sandboxed gpu-accelerated terminal (recommended)
- x11docker-powered full, but minimal, desktop (interesting)
- terminal of your choice (minimal requirements)

Note: Developed on and for Linux; other host compatibility is unknown.

## Quickstart

```sh
mkdir ~/src && cd ~/src
git clone https://github.com/xendarboh/xendev.git
cd xendev
cp .env-example .env
# edit .env to enable optionals or set specific versions
make build
./xendev
```

## Tools

- [Neovim](https://github.com/neovim/neovim): Vim-fork focused on extensibility and usability
  - [LunarVim](https://github.com/LunarVim/LunarVim): An IDE layer for Neovim. Completely free and community driven (_INSTALL_LUNARVIM_)
    - [better-escape.nvim](https://github.com/max397574/better-escape.nvim): Escape from insert mode without delay when typing
    - [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp): Lua plugin to turn github copilot into a cmp source
    - [copilot.lua](https://github.com/zbirenbaum/copilot.lua): Fully featured & enhanced replacement for copilot.vim complete with API for interacting with Github Copilot
    - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim): Markdown preview plugin for (neo)vim
    - [marksman](https://github.com/artempyanykh/marksman): Write Markdown with code assist and intelligence in the comfort of your favourite editor
    - [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim): Smooth scrolling neovim plugin written in lua
    - [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim): Smart, seamless, directional navigation and resizing of Neovim + terminal multiplexer splits
  - [SpaceVim](https://github.com/SpaceVim/SpaceVim): A community-driven modular vim/neovim distribution - The ultimate vimrc (_INSTALL_SPACEVIM_)
    - [coc.nvim](https://github.com/neoclide/coc.nvim): Conquer of Completion; Make your Vim/Neovim as smart as VSCode
  - [neovim-remote](https://github.com/mhinz/neovim-remote): Support for --remote and friends
- [Nix](https://github.com/NixOS/nix): Nix, the purely functional package manager (_INSTALL_NIX_)
- [Node.js](https://github.com/nodejs/node): Node.js JavaScript runtime
  - [pnpm](https://github.com/pnpm/pnpm): Fast, disk space efficient package manager
  - [yarn](https://github.com/yarnpkg/yarn): Fast, reliable, and secure dependency management
  - [fnm](https://github.com/Schniz/fnm): Fast and simple Node.js version manager, built in Rust
  - [npm-check-updates](https://github.com/raineorshine/npm-check-updates): Find newer versions of package dependencies than what your package.json allows
  - [npm-check](https://github.com/dylang/npm-check): Check for outdated, incorrect, and unused dependencies
- [Tomb](https://github.com/dyne/Tomb): the Crypto Undertaker (_INSTALL_TOMB_)
- [aicommits](https://github.com/Nutlope/aicommits): A CLI that writes your git commit messages for you with AI
- [circom](https://github.com/iden3/circom): zkSnark circuit compiler (_INSTALL_CIRCOM_)
- [cpanminus](https://github.com/miyagawa/cpanminus): get, unpack, build and install modules from CPAN
- [cypress](https://github.com/cypress-io/cypress): (deps) Fast, easy and reliable testing for anything that runs in a browser (_INSTALL_CYPRESS_DEPS_)
- [deno](https://github.com/denoland/deno): A modern runtime for JavaScript and TypeScript
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy): Good-lookin' diffs. Actually… nah… The best-lookin' diffs
- [exa](https://github.com/ogham/exa): A modern replacement for ‘ls’
- [fastmod](https://github.com/facebookincubator/fastmod): A tool to assist with large-scale codebase refactors
- [fish-shell](https://github.com/fish-shell/fish-shell): The user-friendly command line shell
  - [fisher](https://github.com/jorgebucaran/fisher): A plugin manager for Fish
  - [fish-exa](https://github.com/gazorby/fish-exa): exa aliases for fish
  - [fish-gruvbox](https://github.com/Jomik/fish-gruvbox): gruvbox theme for fish
  - [fish-nx](https://github.com/xendarboh/fish-nx): Fish completions for Nx
  - [nix-env.fish](https://github.com/lilyball/nix-env.fish): Nix environment setup for the fish shell (_INSTALL_NIX_)
- [fleek-cli](https://github.com/fleekhq/fleek-cli): Use Fleek to deploy websites and apps on the open web: permissionless, trustless, censorship resistant, and free of centralized gatekeepers
- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder
- [git](https://github.com/git/git) (latest stable version)
  - [gh](https://github.com/cli/cli): GitHub’s official command line tool
  - [git-absorb](https://github.com/tummychow/git-absorb): git commit --fixup, but automatic
  - [git-crypt](https://github.com/xendarboh/git-crypt): \[fork\] Transparent file encryption in git
  - [git-filter-repo](https://github.com/newren/git-filter-repo): Quickly rewrite git repository history (filter-branch replacement)
    - gfr-bfg-ish: A re-implementation of most of BFG Repo Cleaner, with new features and bug fixes
    - gfr-clean-ignore: Delete files from history which match current gitignore rules
    - gfr-insert-beginning: Add a new file (e.g. LICENSE/COPYING) to the beginning of history
    - gfr-lint-history: Run some lint command on all non-binary files in history
    - gfr-signed-off-by: Add a Signed-off-by tag to a range of commits
  - [git-lfs](https://github.com/git-lfs/git-lfs): Git extension for versioning large files
  - [lazygit](https://github.com/jesseduffield/lazygit): Simple terminal UI for git commands
- [go](https://github.com/golang/go): The Go programming language
- [import-js](https://github.com/galooshi/import-js): A tool to simplify importing JS modules
- [jq](https://github.com/stedolan/jq): Command-line JSON processor
- [kpcli](http://kpcli.sourceforge.net/): A command line interface for KeePass
- [llvm-project](https://github.com/llvm/llvm-project): (clang) A collection of modular and reusable compiler and toolchain technologies (_INSTALL_LLVM_)
- [ncdu](https://code.blicky.net/yorhel/ncdu): NCurses Disk Usage
- [ninja-build](https://github.com/ninja-build/ninja): A small build system with a focus on speed
- [platformio-core](https://github.com/platformio/platformio-core): A professional collaborative platform for embedded development
- [prettier](https://github.com/prettier/prettier): Prettier is an opinionated code formatter
- [protobuf](https://github.com/protocolbuffers/protobuf): Protocol Buffers - Google's data interchange format (_INSTALL_PB_)
  - [buf](https://github.com/bufbuild/buf): A new way of working with Protocol Buffers
- [ranger](https://github.com/ranger/ranger): A VIM-inspired filemanager for the console
- [ripgrep](https://github.com/BurntSushi/ripgrep): recursively searches directories for a regex pattern while respecting your gitignore
- [rustup](https://github.com/rust-lang/rustup): The Rust toolchain installer
- [silversearcher-ag](https://github.com/ggreer/the_silver_searcher): A code-searching tool similar to ack, but faster
- [solidity](https://github.com/ethereum/solidity): Solidity, the Smart Contract Programming Language
  - [solc-js](https://github.com/ethereum/solc-js): Javascript bindings for the Solidity compiler
- [spacer](https://github.com/samwho/spacer): CLI tool to insert spacers when command output stops
- [sqlite](https://github.com/sqlite/sqlite): a small, fast, self-contained, high-reliability, full-featured, SQL database engine
- [starship](https://github.com/starship/starship): The minimal, blazing-fast, and infinitely customizable prompt for any shell!
- [stow](https://github.com/aspiers/stow): a symlink farm manager
- [taskbook](https://github.com/klaussinani/taskbook): Tasks, boards & notes for the command-line habitat
- [tmux](https://github.com/tmux/tmux): A terminal multiplexer
  - [tpm](https://github.com/tmux-plugins/tpm): Tmux Plugin Manager
  - [tmux-gruvbox](https://github.com/egel/tmux-gruvbox): Gruvbox color scheme for Tmux
  - [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect): Persists tmux environment across system restarts
  - [tmux-window-name](https://github.com/ofirgall/tmux-window-name): A plugin to name your tmux windows smartly
- [ts-lehre](https://github.com/heavenshell/ts-lehre): Generate document block(JsDoc, EsDoc, TsDoc) from source code
- [watchman](https://github.com/facebook/watchman): Watches files and records, or triggers actions, when they change
  - [watchman-make](https://facebook.github.io/watchman/docs/watchman-make): A convenience tool to automatically invoke a command in response to files changing
  - [watchman-replicate-subscription](https://facebook.github.io/watchman/docs/watchman-replicate-subscription): Replicates an existing watchman subscription
  - [watchman-wait](https://facebook.github.io/watchman/docs/watchman-wait): Waits for changes to files, suitable for waiting from shell scripts
- [xclip](https://github.com/astrand/xclip): Command line interface to the X11 clipboard
- [zoxide](https://github.com/ajeetdsouza/zoxide): A smarter cd command
- _INSTALL_DEVOPS_
  - [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html): enables interaction with AWS services
  - [Ansible](https://github.com/ansible/ansible): a radically simple IT automation system
  - [OpenTofu](https://github.com/opentofu/opentofu): declaratively manage your cloud infrastructure
  - [Packer](https://github.com/hashicorp/packer): a tool for creating identical machine images for multiple platforms from a single source configuration
  - [Terraform](https://github.com/hashicorp/terraform): enables you to safely and predictably create, change, and improve infrastructure.
  - [terraform-local](https://github.com/localstack/terraform-local): Terraform CLI wrapper to deploy your Terraform applications directly to LocalStack

Additionally (and optionally), the following are within the X11 base image:

- [Xfce](https://gitlab.xfce.org/xfce): A lightweight desktop environment for UNIX-like operating systems. It aims to be fast and low on system resources, while still being visually appealing and user friendly.
- [kitty](https://github.com/kovidgoyal/kitty): Cross-platform, fast, feature-rich, GPU based terminal
  - [kitty-gruvbox-theme](https://github.com/wdomitrz/kitty-gruvbox-theme): Gruvbox theme for kitty terminal
- [ImageMagick](https://github.com/ImageMagick/ImageMagick): Software suite for displaying, converting, and editing raster image and vector image files
- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts): Developer targeted fonts with a high number of glyphs (icons)
  - [Hack](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack): A typeface designed for source code

Powered-by:

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

Edit `.env` to set specific versions and optional installations.

### Build Image(s)

#### Build the full image with X11 support

```sh
make build
```

#### Or build the tty-only image

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

### Within a gpu-accelerated terminal

This is the recommended mode of operation with balance of sandboxed environment
and host integration for optimal DX.

```sh
x11docker --gpu --clipboard --network -- xen/dev kitty
```

### Within an x11docker-powered desktop

This mode illustrates interesting capabilities provided by x11docker with a
fullly operational sandboxed desktop running within a window on the host.

```sh
x11docker --desktop --gpu --clipboard --network -- xen/dev
```

### Within a terminal of your choice

#### Without X11

This is the mode of minimal host requirements, only `docker|podman`. It will
work on a headless server, for example. Refer to [xendev.tty](./xendev.tty) as
an example for mapping volumes from the host.

```sh
make build-tty
./xendev.tty
```

This also works with `make build`, just larger docker image.

#### with X11

In this mode, host clipboard will work with enhanced security provided by `x11docker`.

```sh
x11docker --tty --interactive --clipboard --network -- xen/dev
```

- Host terminal expectations, ideally:
  - truecolor support (use scripts in [test/](test/) to test support inside `xendev`)
  - patched font like one from [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) with [powerline](https://github.com/powerline/fonts) symbols

### With directories shared from the host

See the [xendev](xendev) launcher script for a functional example that shares
the host user's ssh, gpg, and git config with the container and provides
writeable access to `~/src`.

Note: Some applications need more privileges or capabilities than x11docker
provides by default; refer to the x11docker docs on [privilege
checks](https://github.com/mviereck/x11docker#privilege-checks).

## Preferences & Philosophy

- modern latest greatest terminal utilities and versions
- reproducible personal development environment
- default to current LTS versions
- [FROM ubuntu](https://hub.docker.com/_/ubuntu)
- vi-style key bindings
- dark [gruvbox](https://github.com/morhetz/gruvbox) color scheme
- `LOCALE=en_US.UTF-8` (overridden by x11docker)
- analog choice of sandboxed security vs function

## Tests

See the shell scripts within the [test](test/) directory for tests to confirm
host-mapped gpg support, terminal font rendering (truecolor, glyphs, italics)
capabilities, etc.

## Customization & Notes

See [conf/](conf/) files.

### git

To include xendev git config without replacing the local, add the following to `~/.config/git/config`:

```
[includeIf "gitdir:/home/xendev"]
  path = ~/src/xendev/conf/gitconfig
```

- facilitates same git config on host and within [xendev](./xendev) container
- only applied to git commands run within `/home/xendev/`
- recommendation is to share source between host/container with volume-mapped `~/src/`

### Watchman

By default, watchman will watch all files and this can cause issue (such as vim
lsp/coc types failing), for example if watching `node_modules`, so configure it
per project as needed. See `/usr/share/.watchmanconfig` for an example.

### Lunarvim

- markdown-preview
  - `:MarkdownPreview` start the preview, see URL
  - `:MarkdownPreviewStop` stop the preview

### Local (machine-specific) Configuration

This configuration remains outside the image and is volume-mapped into the
container at runtime.

```sh
cp -a conf.local-example conf.local
```

With the exception of `conf.local/xendev/`, the "dotfiles" of `conf.local` are [stow](https://github.com/aspiers/stowstow)'d in the user's homedir. For example, `conf.local/.xyz` gets symlinked from `~/.xyz`.

Notable local conf files may include:

- `conf.local/xendev/bash.sh`: use to set custom config like `GH_TOKEN` or `FLEEK_API_KEY`
- `conf.local/xendev/directory_map.txt`
  - a list of `from:to` directory mappings to preserve current working directory
    in new windows (since tmux/kitty does not handle preserved symlinked directories)
  - you likely want a directory mapping for `/home/xendev:/home/<USER>`
- `conf.local/xendev/lvim.lua`: sourced by lunarvim's `config.lua`
- `conf.local/.aicommits`: aicommits configuration
- `conf.local/.wakatime.cfg`
  - wakatime or [wakapi](https://github.com/muety/wakapi) configuration
  - see [conf.local-example/xendev/lvim.lua](conf.local-example/xendev/lvim.lua) for how to enable wakatime plugin in lunarvim
- `conf.local/.aws`: preserve local aws credentials... or anything else in this mannar

### SpaceVim + CoC (autocompletion)

| Configuration Location                                                                             | Purpose                             |
| -------------------------------------------------------------------------------------------------- | ----------------------------------- |
| [conf/.config/SpaceVim.d/coc-settings.json](conf/.config/SpaceVim.d/coc-settings.json)             | coc settings                        |
| [conf/.config/SpaceVim.d/init.toml](conf/.config/SpaceVim.d/init.toml)                             | enable coc as spacevim autocomplete |
| [conf/.config/SpaceVim.d/autoload/myspacevim.vim](conf/.config/SpaceVim.d/autoload/myspacevim.vim) | set coc home                        |
| [Dockerfile](Dockerfile)                                                                           | install coc extensions with nvim    |
