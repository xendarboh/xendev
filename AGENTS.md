# AGENTS.md

Instructions for AI coding agents working in this repository.

## Project Overview

xendev is a dockerized terminal-based vim-centric development environment. It's "overpowered dotfiles" packaged as Docker images using x11docker for security-focused containerization.

## Build Commands (Human Operator Only)

AI agents must NOT run `make` — builds are slow and typically unavailable in agent environments.

```sh
make build       # Build full image with X11 support (xen/x11, xen/dev, xen/sys)
make rebuild     # Build from scratch without cache
make build-tty   # Build tty-only image (no X11, smaller)
make retag       # Tag current images as :prev before rebuilding
make help        # Show all make targets
```

## Testing

There are no automated tests. Manual verification scripts exist in `test/`:

```sh
# Verify GPG volume mapping works
./test/gpg.sh

# Test terminal capabilities
./test/truecolor.sh    # Truecolor support
./test/glyphs.sh       # Font glyph rendering
./test/italics.sh      # Italic text rendering
./test/test-fonts.sh   # General font tests
```

## Running the Environment

```sh
./xendev [name]      # Main launcher (x11docker, GPU, clipboard)
./xendev.gpu         # Direct GPU access variant
./xendev.sys         # Docker-in-docker via sysbox-runc
./xendev.tty         # TTY-only, no x11docker
```

## Configuration

- `.env`: Build options (INSTALL*\*, VERSION*\*, IMAGE_BASE)
- `conf/`: Built-in dotfiles, stowed during Docker build
- `conf.local/`: User-specific configs, stowed at runtime (gitignored)

## Code Style Guidelines

### General

- **Indentation**: 2 spaces (Bash, Lua, Dockerfile), 4 spaces (Fish)
- **Line endings**: Unix (LF)
- **Trailing whitespace**: Remove

### Shell Scripts (Bash)

```bash
#!/bin/bash                    # Use /bin/bash, not /usr/bin/env bash in this repo
name="${1:-default}"           # Quote variables, use defaults
[ -f "$file" ] && source "$file"  # Guard file sources

# Variables
local_var="value"              # lowercase for local variables
ENVIRONMENT_VAR="value"        # SCREAMING_SNAKE_CASE for exports/env vars

# Functions
my_function() {                # lowercase with underscores
  local result=""              # Use local for function variables
  echo "$result"
}

# Chained commands
command1 \
  && command2 \
  && command3

# Vim modeline at end of file (optional but common)
# vim:syntax=sh
```

### Fish Shell

```fish
# 4-space indent (see modeline in config.fish)
function my_function
    set local_var "value"
    echo $local_var
end

# Use abbr for interactive shortcuts, alias for scripts
abbr s 'git status'

# vim:sw=4:ts=4:et:
```

### Lua (Neovim/LazyVim)

Follows StyLua formatting (`conf/.config/nvim-lazyvim/stylua.toml`):

```lua
-- 2-space indent, 120 column width
return {
  {
    "plugin/name",
    opts = {
      setting = "value",
    },
  },
}
```

Plugin structure follows LazyVim conventions:

- `lua/config/`: Core settings (options.lua, keymaps.lua, autocmds.lua)
- `lua/plugins/`: One file per plugin or feature group

### Dockerfile

```dockerfile
ARG VERSION_TOOL                # ARGs at top for versioning

# Chain RUN commands with && and cleanup in same layer
RUN apt update \
  && apt install --no-install-recommends -y -q \
    package1 \
    package2 \
  && rm -rf /var/lib/apt/lists/*

# Conditional installations via ARG
ARG INSTALL_FEATURE=0
RUN \
  if [ "${INSTALL_FEATURE}" = "1" ]; then \
    # installation commands \
  ; fi
```

### Makefile

```makefile
SHELL := /bin/bash

.PHONY: target
target: ## Description for help output
  command
```

## Naming Conventions

| Context               | Convention           | Example                        |
| --------------------- | -------------------- | ------------------------------ |
| Environment variables | SCREAMING_SNAKE_CASE | `XENDEV_DIR`, `IMAGE_BASE`     |
| Local shell variables | snake_case           | `name`, `arg_set`              |
| Shell functions       | snake_case           | `dirmap()`, `my_function()`    |
| Makefile targets      | kebab-case           | `build-tty`, `rebuild`         |
| Docker ARGs           | SCREAMING_SNAKE_CASE | `INSTALL_LLVM`, `VERSION_NODE` |
| Lua variables         | snake_case           | `local_var`                    |

## Key Directories

```
conf/                      # Built-in dotfiles (stowed during build)
  .bash_xendev             # Main bash config
  .bash_aliases            # Shell aliases
  .config/nvim-lazyvim/    # Neovim LazyVim distribution
  .config/fish/            # Fish shell config
  .config/kitty/           # Kitty terminal config
  .tmux.conf               # Tmux configuration

conf.local/                # User-specific overrides (gitignored)
  xendev/bash.sh           # Custom env vars (GH_TOKEN, etc.)
  xendev/directory_map.txt # PWD symlink mappings

setup.d/                   # Optional setup scripts
test/                      # Manual verification scripts
```

## Important Notes

1. **GNU Stow**: Config management uses stow for symlinks. Files in `conf/` become `~/.file`.

2. **Shell behavior**: Bash auto-drops into Fish shell (see `.bash_xendev` lines 96-99).

3. **x11docker**: Launcher scripts use `--user=RETAIN` to preserve host UID.

4. **No package.json**: This is not a Node.js project. Build system is Make + Docker Compose.

5. **Git config**: Use `[includeIf]` directive to include xendev gitconfig only within `/home/xendev/`.

6. **No `make` for agents**: AI agents must not run build commands (see Build Commands section)

## Common Tasks

**Add a new tool to the Docker image:**

1. Edit `Dockerfile` following existing patterns
2. For optional tools, add `INSTALL_*` ARG and conditional block
3. Update `.env-example` with the new `INSTALL_*` or `VERSION_*` variable
4. Update `docker-compose.yml` to pass the new ARG to the build
5. Update `README.md` — add the tool with its GitHub link and description, following existing format

**Update latest versions:**

1. For each `VERSION_*` in `.env-example`:
   1. Retrieve the latest version from its GitHub page (linked in `README.md`); release, tag, or branch name
   2. Update its value in `.env-example`

**Modify shell config:**

1. Edit files in `conf/` (.bash_xendev, .bash_aliases, config.fish)
2. Changes take effect on next container start (configs are stowed at runtime)
