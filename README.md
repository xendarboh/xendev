# xen/dev:latest

[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](LICENSE)

Overpowered dotfiles in a box. A sandboxed, GPU-accelerated, terminal-first development environment.

Run it as a:

- **TTY-only terminal** for headless servers
- **GPU-accelerated terminal** with clipboard integration ← recommended
- **Full desktop environment** in a window (x11docker)
- **Docker-in-Docker environment** for nested containers (sysbox)

> Developed on and for Linux. Other platforms untested.

## Quickstart

```sh
git clone https://github.com/xendarboh/xendev.git ~/src/xendev
cd ~/src/xendev
cp .env-example .env                 # edit to enable optional tools
cp -a conf.local-example conf.local  # local overrides (see Customization)
make build
./xendev
```

## Philosophy

- Open Source!
- Latest greatest terminal tools, LTS versions, vi-bindings
- Unified theming via [tinty](https://github.com/tinted-theming/tinty) with native Neovim colorscheme sync
- Reproducible environment from [Ubuntu](https://hub.docker.com/_/ubuntu) base
- Security via sandboxing with analog control over isolation vs. functionality

## Host Dependencies

| Dependency                                                                                  | Required For              | Notes                                                      |
| :------------------------------------------------------------------------------------------ | :------------------------ | :--------------------------------------------------------- |
| docker or podman                                                                            | Core                      | Container runtime                                          |
| docker compose                                                                              | Building                  | Build orchestration                                        |
| make                                                                                        | Building                  | Recommended; or run [Makefile](Makefile) commands manually |
| [x11docker](https://github.com/mviereck/x11docker#installation)                             | `max`, `min`, `sys` modes | Not needed for `tty` mode                                  |
| [sysbox](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md) | `sys` mode                | Recommended for Docker-in-Docker                           |
| rofi / dmenu / fzf                                                                          | Launcher                  | Any one; detected in order                                 |
| [Nerd Font](https://github.com/ryanoasis/nerd-fonts#font-installation)                      | `tty` mode                | Container provides fonts for GUI modes                     |

## Run

### Launcher

The `./xendev` launcher provides an interactive menu (via `rofi`, `dmenu`, or `fzf`) for selecting modes, naming containers, and toggling volume mounts.

| Mode  | Description                                                       | X11 |   GPU    | Use Case                           |
| ----- | ----------------------------------------------------------------- | :-: | :------: | ---------------------------------- |
| `max` | Most host integration, direct GPU                                 | Yes |  Direct  | Daily development                  |
| `min` | Minimal host integration, fallback GPU                            | Yes | Fallback | Sandboxed agents, untrusted code   |
| `sys` | Docker-in-Docker via [sysbox](https://github.com/nestybox/sysbox) | Yes | Fallback | Stronger isolation, run containers |
| `tty` | TTY-only, no X11                                                  | No  |    No    | Headless servers, SSH sessions     |

All modes are containerized and sandboxed; the difference is capability and host integration.

**Selector**: The launcher probes for an available selector. Override with `XENDEV_SELECTOR` or `./xendev -s fzf`.

### No Launcher

Run directly without the interactive menu, for example:

```sh
# GPU-accelerated terminal with clipboard
x11docker --gpu --clipboard --network --user=RETAIN -- --tmpfs=/tmp:exec -- xen/dev

# Full desktop in a window
x11docker --desktop --gpu --clipboard --network -- xen/dev

# TTY-only (no x11docker needed)
docker run -it --rm --network=host xen/dev
```

### Docker-in-Docker (Sysbox)

The `sys` mode uses [sysbox](https://github.com/nestybox/sysbox) for secure, rootless Docker-in-Docker without `--privileged`.

**Tradeoffs**: No direct GPU (uses `--gpu` fallback), bridged networking (no `--network=host`).

**Persistence**: Inner Docker data stored at `~/.local/share/xendev/sysbox/var-lib-docker`.

## Tools

### Powered By

- [x11docker](https://github.com/mviereck/x11docker): Secure GUI containers
- [Sysbox](https://github.com/nestybox/sysbox): Rootless system containers, enabling Docker-in-Docker
- [Xen](https://github.com/xendarboh): Elven Tech Wizard

### Editor & Plugins

- [Neovim](https://github.com/neovim/neovim): Vim-fork focused on extensibility and usability
  - [LazyVim](https://github.com/LazyVim/LazyVim): Neovim config for the lazy _(INSTALL_NVIM_LAZYVIM)_
    - [avante.nvim](https://github.com/yetone/avante.nvim): Use your Neovim like using Cursor AI IDE!
    - [better-escape.nvim](https://github.com/max397574/better-escape.nvim): Escape from insert mode without delay
    - [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim): Gruvbox colorscheme
    - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim): Markdown preview plugin
    - [noir.nvim](https://github.com/noir-lang/noir-nvim): Syntax highlighting and LSP for Noir
    - [nx.nvim](https://github.com/Equilibris/nx.nvim): NX console features for Neovim
    - [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim): Seamless navigation and resizing
    - [tinted-nvim](https://github.com/tinted-theming/tinted-nvim): Tinty colorscheme sync with native fallback
    - [tokyonight.nvim](https://github.com/folke/tokyonight.nvim): Tokyo Night colorscheme
    - [wakatime.nvim](https://github.com/wakatime/vim-wakatime): Automatic time tracking

### AI/Agentic Coding

- [aicommits](https://github.com/Nutlope/aicommits): AI-written git commit messages
- [claude-code](https://github.com/anthropics/claude-code): Agentic coding tool in your terminal
- [OpenCode](https://github.com/anomalyco/opencode): Open source coding agent _(INSTALL_OPENCODE)_
  - [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode): Batteries-included agent harness
  - [opencode-wakatime](https://github.com/angristan/opencode-wakatime): OpenCode usage time tracking
- [repomix](https://github.com/yamadashy/repomix): Pack repository into AI-friendly file

### Shell & Terminal

- [bat](https://github.com/sharkdp/bat): A cat(1) clone with syntax highlighting
- [exa](https://github.com/ogham/exa): Modern replacement for 'ls'
- [fd](https://github.com/sharkdp/fd): Simple, fast alternative to 'find'
- [fish-shell](https://github.com/fish-shell/fish-shell): User-friendly command line shell
  - [fish-exa](https://github.com/gazorby/fish-exa): exa aliases for fish
  - [fish-nx](https://github.com/jukben/fish-nx): Fish completions for Nx
  - [fisher](https://github.com/jorgebucaran/fisher): Plugin manager for Fish
  - [nix-env.fish](https://github.com/lilyball/nix-env.fish): Nix environment for fish _(INSTALL_NIX)_
- [fzf](https://github.com/junegunn/fzf): Command-line fuzzy finder
- [jq](https://github.com/stedolan/jq): Command-line JSON processor
- [ripgrep](https://github.com/BurntSushi/ripgrep): Fast regex search respecting gitignore
- [silversearcher-ag](https://github.com/ggreer/the_silver_searcher): Code search faster than ack
- [spacer](https://github.com/samwho/spacer): Insert spacers in command output
- [starship](https://github.com/starship/starship): Minimal, fast, customizable prompt
- [stow](https://github.com/aspiers/stow): Symlink farm manager
- [tinty](https://github.com/tinted-theming/tinty): Unified colorscheme manager for 70+ apps
- [tmux](https://github.com/tmux/tmux): Terminal multiplexer
  - [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect): Persist environment across restarts
  - [tmux-window-name](https://github.com/ofirgall/tmux-window-name): Smart window naming
  - [tpm](https://github.com/tmux-plugins/tpm): Tmux Plugin Manager
- [zoxide](https://github.com/ajeetdsouza/zoxide): Smarter cd command

### Git & Version Control

- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy): Best-lookin' diffs
- [git](https://github.com/git/git): Latest stable version
  - [gh](https://github.com/cli/cli): GitHub's official CLI
  - [git-absorb](https://github.com/tummychow/git-absorb): Automatic fixup commits
  - [git-crypt](https://github.com/xendarboh/git-crypt): Transparent file encryption \[fork\]
  - [git-filter-repo](https://github.com/newren/git-filter-repo): Rewrite git history fast
    - gfr-bfg-ish: BFG Repo Cleaner reimplementation
    - gfr-clean-ignore: Remove gitignored files from history
    - gfr-insert-beginning: Insert a file at history start
    - gfr-lint-history: Lint all non-binary files across history
    - gfr-signed-off-by: Add Signed-off-by tags to commit range
  - [git-lfs](https://github.com/git-lfs/git-lfs): Large file versioning
  - [lazygit](https://github.com/jesseduffield/lazygit): Terminal UI for git

### Languages & Runtimes

- [Bun](https://github.com/oven-sh/bun): Fast JS runtime, bundler, test runner, package manager
- [Deno](https://github.com/denoland/deno): Modern JavaScript/TypeScript runtime
- [Go](https://github.com/golang/go): The Go programming language
- [LLVM](https://github.com/llvm/llvm-project): Clang toolchain _(INSTALL_LLVM)_
- [Nix](https://github.com/NixOS/nix): Purely functional package manager _(INSTALL_NIX)_
- [Node.js](https://github.com/nodejs/node): JavaScript runtime
  - [fnm](https://github.com/Schniz/fnm): Fast Node.js version manager
  - [npm-check-updates](https://github.com/raineorshine/npm-check-updates): Find newer package versions
  - [npm-check](https://github.com/dylang/npm-check): Check for outdated dependencies
  - [pnpm](https://github.com/pnpm/pnpm): Fast, disk space efficient package manager
  - [yarn](https://github.com/yarnpkg/yarn): Dependency management
- [Rust](https://github.com/rust-lang/rust): Reliable and efficient software
  - [cargo-edit](https://github.com/killercup/cargo-edit): Manage cargo dependencies from CLI
  - [rust-analyzer](https://github.com/rust-lang/rust-analyzer): Rust compiler front-end for IDEs
  - [rustup](https://github.com/rust-lang/rustup): Rust toolchain installer

### ZK & Blockchain

- [circom](https://github.com/iden3/circom): zkSnark circuit compiler _(INSTALL_CIRCOM)_
- [Noir](https://github.com/noir-lang/noir): DSL for zero knowledge proofs _(INSTALL_NOIR)_
  - [barretenberg](https://github.com/AztecProtocol/aztec-packages): ZK prover backend
- [Solidity](https://github.com/ethereum/solidity): Smart contract language

### DevOps _(INSTALL_DEVOPS)_

- [Ansible](https://github.com/ansible/ansible): IT automation
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html): AWS interaction
- [OpenTofu](https://github.com/opentofu/opentofu): Open source Terraform alternative
- [Packer](https://github.com/hashicorp/packer): Machine image builder
- [terraform-local](https://github.com/localstack/terraform-local): Deploy to LocalStack
- [Terraform](https://github.com/hashicorp/terraform): Infrastructure as code

### Utilities

- [cpanminus](https://github.com/miyagawa/cpanminus): CPAN module installer
- [cypress](https://github.com/cypress-io/cypress): Browser testing deps _(INSTALL_CYPRESS_DEPS)_
- [fastmod](https://github.com/facebookincubator/fastmod): Large-scale codebase refactors
- [fleek-cli](https://github.com/fleekhq/fleek-cli): Deploy to Fleek
- [ImageMagick](https://github.com/ImageMagick/ImageMagick): Image manipulation
- [kpcli](http://kpcli.sourceforge.net/): KeePass CLI
- [ncdu](https://code.blicky.net/yorhel/ncdu): NCurses Disk Usage
- [ninja-build](https://github.com/ninja-build/ninja): Fast build system
- [platformio-core](https://github.com/platformio/platformio-core): Embedded development _(INSTALL_PLATFORMIO)_
- [prettier](https://github.com/prettier/prettier): Opinionated code formatter
- [protobuf](https://github.com/protocolbuffers/protobuf): Protocol Buffers _(INSTALL_PB)_
  - [buf](https://github.com/bufbuild/buf): Modern protobuf workflow
- [ranger](https://github.com/ranger/ranger): VIM-inspired file manager
- [sqlite](https://github.com/sqlite/sqlite): SQL database engine
- [tauri-cli](https://github.com/tauri-apps/tauri): Build desktop apps _(INSTALL_TAURI)_
- [Tomb](https://github.com/dyne/Tomb): Crypto Undertaker _(INSTALL_TOMB)_
- [watchexec](https://github.com/watchexec/watchexec): Execute on file changes
- [websocat](https://github.com/vi/websocat): WebSocket CLI client

### X11 Desktop

- [Brave browser](https://github.com/brave/brave-browser) _(INSTALL_BROWSER_BRAVE)_
- [Chromium](https://github.com/chromium/chromium) _(INSTALL_BROWSER_CHROMIUM)_
- [kitty](https://github.com/kovidgoyal/kitty): GPU-accelerated terminal
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts): Developer fonts with icons
  - [Hack](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack): Typeface for code
- [xclip](https://github.com/astrand/xclip): X11 clipboard CLI
- [Xfce](https://gitlab.xfce.org/xfce): Lightweight desktop environment

### Sysbox Runtime

- [docker](https://github.com/docker/cli): The Docker CLI
  - [docker-compose](https://github.com/docker/compose): Orchestrate multi-container Docker apps

### Runtime Scripts

Optional tools installed on-demand via [setup.d/](setup.d/):

- [Aztec](https://github.com/AztecProtocol/aztec-packages): Privacy-first L2 (requires `sys` mode)
- [WhisperX](https://github.com/m-bain/whisperX): Speech recognition with timestamps

## Build

### Configure

Edit `.env` to set versions and enable optional tools (copy from `.env-example`).

### Build Images

```sh
make build      # Full image with X11 support
make build-tty  # TTY-only image (smaller, no X11)
make help       # All available targets
```

## Customization

### Dotfiles

- `conf/` — Built-in configs, shipped with xendev source, baked into image
- `conf.local/` — Your customizations go here; gitignored, volume-mapped at runtime

Both directories are [stow](https://github.com/aspiers/stow)'d to the user's home directory at container start (ex: `conf.local/.aws/` → `~/.aws/`).

```sh
cp -a conf.local-example conf.local
```

Notable files in `conf.local/`, for example:

| File                       | Purpose                                             |
| :------------------------- | :-------------------------------------------------- |
| `xendev/bash.sh`           | Custom env vars (`GH_TOKEN`, `FLEEK_API_KEY`, etc.) |
| `xendev/directory_map.txt` | Path mappings for tmux/kitty CWD preservation       |
| `.aicommits`               | aicommits configuration                             |
| `.wakatime.cfg`            | Wakatime/Wakapi config                              |
| `.aws/`                    | AWS credentials                                     |

### Git Config

Include xendev's git config conditionally:

```gitconfig
# ~/.config/git/config
[includeIf "gitdir:/home/xendev"]
  path = ~/src/xendev/conf/gitconfig
```

### Themes

Colorschemes are managed by [tinty](https://github.com/tinted-theming/tinty), providing unified theming across apps.

Set `OPTIONS_THEME` in `.env` for the image build-time default.

Neovim listens for theme changes and applies the corresponding native plugin (tokyonight, gruvbox) when available.

**Change theme at runtime:**

```sh
tinty cycle                          # cycle through preferred schemes
tinty apply base24-tokyo-night-dark  # or any scheme from `tinty list`
```

### Tests

Verify terminal capabilities with scripts in [test/](test/):

```sh
./test/truecolor.sh  # Terminal color support
./test/glyphs.sh     # Nerd font rendering
./test/italics.sh    # Italic text
./test/gpg.sh        # GPG volume mapping
```
