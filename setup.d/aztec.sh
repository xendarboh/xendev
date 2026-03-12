#!/bin/bash
test $(whoami) = "root" && echo "[xendev] ERROR: must not be root" && exit 1

source $(readlink -f $(dirname $0))/../.env 2>/dev/null
export VERSION=${VERSION_AZTEC:-$VERSION}

# 2026-03-12: foundry installer uses XDG_CONFIG_HOME in a strange way
# https://github.com/foundry-rs/foundry/blob/master/foundryup/install#L6
# ensure foundry is installed to the location expected by aztec installer
export FOUNDRY_DIR="${HOME}/.foundry"

curl -sL https://install.aztec.network/${VERSION} |
  NON_INTERACTIVE=1 SHELL= bash

echo ""
echo "[xendev] Aztec toolchain installed!"
