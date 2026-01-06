#!/bin/bash

# NOTE: requires docker (xen/sys)

source $(readlink -f $(dirname $0))/../.env
export VERSION=${VERSION_AZTEC:-$VERSION}

test $(whoami) = "root" && echo "[xendev] ERROR: must not be root" && exit 1

# install aztec tools and docker images, use env VERSION for pin which version
curl -Ls https://install.aztec.network |
  NON_INTERACTIVE=1 SHELL= bash

echo ""
echo "[xendev] Aztec installed!"
