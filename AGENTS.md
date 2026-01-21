# AGENTS.md

Instructions for AI coding agents working in this repository.

## Project Overview

xendev is a dockerized terminal-based vim-centric development environment. It's "overpowered dotfiles" packaged as Docker images using x11docker for security-focused containerization.

## Build Commands (Human Operator Only)

**AI agents must NOT run `make`** — builds are slow and typically unavailable in agent environments.

```sh
make build       # Build full image (xen/x11, xen/dev, xen/sys)
make build-tty   # Build tty-only image (no X11, smaller)
make rebuild     # Build from scratch without cache
make help        # Show all make targets
```

## Testing

No automated tests exist. Manual verification scripts in `test/`:

```sh
./test/gpg.sh         # Verify GPG volume mapping
./test/truecolor.sh   # Terminal truecolor support
./test/glyphs.sh      # Font glyph rendering
./test/italics.sh     # Italic text rendering
```

## Code Style

### General Rules

- **Indentation**: 2 spaces (Bash, Lua, Dockerfile), 4 spaces (Fish)
- **Line endings**: Unix (LF)
- **Trailing whitespace**: Remove
- **Vim modelines**: Use at file end when helpful (e.g., `# vim:syntax=sh`)

### Shell Scripts (Bash)

```bash
#!/bin/bash                       # Use /bin/bash, not /usr/bin/env bash
name="${1:-default}"              # Quote variables, provide defaults
[ -f "$file" ] && source "$file"  # Guard file sources

local_var="value"                 # snake_case for local variables
ENVIRONMENT_VAR="value"           # SCREAMING_SNAKE_CASE for exports

my_function() {                   # snake_case function names
  local result=""                 # Use 'local' for function variables
  echo "$result"
}

# Chain commands with backslash continuation
command1 \
  && command2 \
  && command3
```

### Fish Shell

```fish
# 4-space indent
function my_function
    set local_var "value"
    echo $local_var
end

abbr s 'git status'   # Use abbr for interactive shortcuts

# vim:sw=4:ts=4:et:
```

### Lua (Neovim/LazyVim)

Follows StyLua: 2-space indent, 120 column width (`conf/.config/nvim-lazyvim/stylua.toml`)

```lua
return {
  {
    "plugin/name",
    opts = {
      setting = "value",
    },
  },
}
```

Plugin structure: `lua/config/` for core settings, `lua/plugins/` for one file per plugin.

### Dockerfile

```dockerfile
ARG VERSION_TOOL                  # ARGs at top for versioning

# Chain RUN + cleanup in same layer
RUN apt update \
  && apt install --no-install-recommends -y -q \
    package1 \
    package2 \
  && rm -rf /var/lib/apt/lists/*

# Conditional install pattern
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
  .config/tinted-theming/  # Tinty colorscheme config
  .tmux.conf               # Tmux configuration

conf.local/                # User dotfiles (gitignored, stowed during runtime)
  xendev/bash.sh           # Custom env vars (GH_TOKEN, etc.)

setup.d/                   # Optional runtime setup scripts
test/                      # Manual verification scripts
```

## Important Notes

1. **GNU Stow**: Configs use stow for symlinks. Files in `conf/` become `~/.file`.
2. **Shell behavior**: Bash auto-drops into Fish (see `.bash_xendev` lines 101-104).
3. **x11docker**: The `./xendev` launcher uses `--user=RETAIN` to preserve host UID.
4. **No package.json**: Build system is Make + Docker Compose.
5. **No `make` for agents**: AI agents must not run build commands.

## Common Tasks

### Add a new tool to the Docker image

1. Edit `Dockerfile` following existing conditional install patterns
2. For optional tools:
   1. add `INSTALL_*` ARG and conditional block
   2. Update `.env-example` with the new `INSTALL_*` or `VERSION_*` variable
   3. Update `docker-compose.yml` to pass the new ARG to the build
3. Update `README.md` — add tool to the appropriate section in "Tools"

#### README.md Tool List Format

The Tools section is an **Awesome-List** style curated collection with strict conventions:

**Organization**: Tools are grouped into sections (Editor & Plugins, AI/Agentic Coding, Shell & Terminal, etc.)

**Ordering**: **Case-insensitive alphabetical order** within each section (e.g., `Bun`, `Deno`, `Go`)

**Entry format**:
```markdown
- [ToolName](https://github.com/org/repo): Brief description
```

**Optional tools** (controlled by build ARGs): Append `_(INSTALL_*)_` suffix:
```markdown
- [Nix](https://github.com/NixOS/nix): Purely functional package manager _(INSTALL_NIX)_
```

**Sub-tools** (plugins, extensions): Indent under parent:
```markdown
- [fish-shell](https://github.com/fish-shell/fish-shell): User-friendly command line shell
  - [fisher](https://github.com/jorgebucaran/fisher): Plugin manager for Fish
  - [fish-exa](https://github.com/gazorby/fish-exa): exa aliases for fish
```

**Example placement**: To add `htop`, find the Utilities section, then insert alphabetically between existing entries:
```markdown
- [ImageMagick](...)
- [htop](https://github.com/htop-dev/htop): Interactive process viewer  ← insert here
- [kpcli](...)
```

### Update tool versions

1. For each `VERSION_*` in `.env-example`:
   - Check latest version from its GitHub page (linked in `README.md`)
   - Update value in `.env-example`

### Modify shell config

1. Edit files in `conf/` (`.bash_xendev`, `.bash_aliases`, `config.fish`)
2. Changes take effect on next container start (stowed at runtime)

### Add a Neovim plugin

1. Create `conf/.config/nvim-lazyvim/lua/plugins/<plugin-name>.lua`
2. Follow existing plugin patterns (return table with plugin spec)
3. Update `README.md` if it's a notable addition

### Theming

Colorschemes are managed by [tinty](https://github.com/tinted-theming/tinty), providing unified theming across kitty, tmux, and Neovim.

**Key files:**
- `conf/.config/tinted-theming/tinty/config.toml` — tinty item configs (shell, tmux, kitty)
- `conf/.config/nvim-lazyvim/lua/plugins/colorscheme.lua` — Neovim theme sync with native plugin fallback
- `.env-example` `OPTIONS_THEME` — build-time default theme

**How it works:**
1. `tinty apply <scheme>` propagates colors to all configured apps via hooks
2. Neovim listens for `TintedColorsPost` event (via tinted-nvim plugin) and applies native plugins (gruvbox.nvim, tokyonight.nvim) when available
3. Neovim falls back to tinty-provided generic theme when no native plugin matches

**Preferred schemes** (have native Neovim plugins): `base24-gruvbox-dark-hard`, `base24-tokyo-night-dark`
