ARG IMAGE_BASE=
FROM ${IMAGE_BASE}

# configuration
ARG _LOCALE=en_US.UTF-8
ARG _USER=xendev
ARG _USER_GROUPS=audio,dialout,video
ARG _USER_ID=1000

# persist _USER for use in inheriting images
ENV XENDEV_USER=${_USER}

# xendev source directory volume mount point when running container
# used for configuration files as symlinks
ENV XENDEV_DIR=/home/${_USER}/src/xendev

# use the "noninteractive" debconf frontend
ENV DEBIAN_FRONTEND=noninteractive

# use bash for RUN commands
SHELL ["/bin/bash", "--login", "-c"]

# install things
RUN apt update \
  # install some apt related things first
  && apt install --no-install-recommends -y -q \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
  && apt install --no-install-recommends -y -q \
    ack-grep \
    automake \
    bash-completion \
    build-essential \
    curl \
    dos2unix \
    gpg-agent \
    htop \
    jq \
    less \
    libtool \
    locales \
    man-db \
    ncdu \
    ninja-build \
    openssh-client \
    pinentry-curses \
    pkg-config \
    psmisc \
    python3-pip \
    python3-pygments \
    rake \
    ranger \
    rsync \
    silversearcher-ag \
    sqlite3 \
    sshfs \
    stow \
    sudo \
    tmux \
    tree \
    tzdata \
    units \
    unzip \
    wget \
    xsel \
    zip \
    # https://github.com/mapbox/node-sqlite3/issues/1443
    python-is-python3 \
    # for kpcli:
    libreadline-dev \
    xclip \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# set locale
RUN locale-gen ${_LOCALE} \
  && update-locale LANG=${_LOCALE} LC_ALL=${_LOCALE}

# install latest fish
ARG VERSION_FISH
RUN apt-add-repository ppa:fish-shell/${VERSION_FISH} \
  && apt update \
  && apt install --no-install-recommends -y -q \
    fish \
  && rm -rf /var/lib/apt/lists/*

# install latest git
RUN apt-add-repository ppa:git-core/ppa \
  && apt update \
  && apt install --no-install-recommends -y -q \
    git \
    git-lfs \
  && rm -rf /var/lib/apt/lists/*

# create user, grant sudo access
# NOTE: _USER_GROUPS are voided by x11docker without --user=RETAIN option
RUN \
  # remove ubuntu (1000:1000) user/group if it exists to replace it
  (userdel -r ubuntu) || true && (groupdel ubuntu) || true \
  && groupadd -g ${_USER_ID} ${_USER} \
  && useradd -m \
    -s /bin/bash \
    -u ${_USER_ID} \
    -g ${_USER_ID} \
    -G ${_USER_GROUPS} \
    ${_USER} \
  && echo "${_USER}:${_USER}" | chpasswd \
  && echo "${_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${_USER} \
  && chmod 0440 /etc/sudoers.d/${_USER}

# fix: "cannot find name for group ID 110"
RUN groupadd -g 110 render

# install git-crypt
RUN \
  # install deps
  apt update \
  && apt install --no-install-recommends -y -q \
    libssl-dev \
  && rm -rf /var/lib/apt/lists/* \
  # clone our patched fork
  && git clone \
    --depth 1 \
    https://github.com/xendarboh/git-crypt.git \
    /tmp/git-crypt \
  && cd /tmp/git-crypt \
  # make, install, then cleanup
  && make  \
  && make \
    PREFIX=/usr/local \
    install \
  && rm -rf /tmp/git-crypt

# install latest git-filter-repo
RUN cd /tmp \
  # download the latest source package
  # Note: 2023-06-12 make from git clone failed
  && export V=$( \
    curl -L -s https://api.github.com/repos/newren/git-filter-repo/releases/latest \
    | sed -n -e 's/"tag_name": "\(.*\)",/\1/p' \
    | sed -e 's/^.*v//' \
  ) \
  && export F="git-filter-repo-${V}" \
  && wget "https://github.com/newren/git-filter-repo/releases/download/v${V}/${F}.tar.xz" \
  && tar -xf "${F}.tar.xz" \
  && cd ${F} \
  # make install
  && make \
    bindir=/usr/local/bin \
    prefix=/usr \
    pythondir=$(python -c "import site; print(site.getsitepackages()[-1])") \
    install \
  && gzip $(git --man-path)/man1/git-filter-repo.1 \
  # install contrib tools
  && cd contrib/filter-repo-demos \
  && for x in \
      bfg-ish \
      clean-ignore \
      insert-beginning \
      lint-history \
      signed-off-by \
    ; do \
      install -Dm0755 $x /usr/local/bin/gfr-$x; \
    done \
  && rm -rf /tmp/git-filter-repo-*

# install latest github cli
RUN cd /tmp \
  && export V=$( \
    curl -L -s https://api.github.com/repos/cli/cli/releases/latest \
    | sed -n -e 's/"tag_name": "\(.*\)",/\1/p' \
    | sed -e 's/^.*v//' \
  ) \
  && export F="gh_${V}_linux_amd64.deb" \
  && wget "https://github.com/cli/cli/releases/download/v${V}/${F}" \
  && apt update \
  && (dpkg -i ${F} || true) \
  && apt install --no-install-recommends -y -q -f \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f ${F}

# install latest clang tools
# https://apt.llvm.org/
ARG INSTALL_LLVM=0
ARG VERSION_LLVM
RUN \
  if [ "${INSTALL_LLVM}" = "1" ]; then \
    cd /tmp \
    && wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh ${VERSION_LLVM} all \
    && rm -f llvm.sh \
    && for x in $(ls /usr/bin/clang*${VERSION_LLVM}); do \
        ln -sv $x $(echo $x | sed -e "s/-${VERSION_LLVM}//"); \
      done \
  ; fi

# install solidity compiler
RUN apt-add-repository ppa:ethereum/ethereum \
  && apt update \
  && apt install --no-install-recommends -y -q \
    solc \
  && rm -rf /var/lib/apt/lists/*

# install cypress system deps
# https://docs.cypress.io/guides/getting-started/installing-cypress#UbuntuDebian
ARG INSTALL_CYPRESS_DEPS=0
RUN \
  if [ "${INSTALL_CYPRESS_DEPS}" = "1" ]; then \
    apt update \
    && apt install --no-install-recommends -y -q \
      libasound2 \
      libgbm-dev \
      libgconf-2-4 \
      libgtk-3-0 \
      libgtk2.0-0 \
      libnotify-dev \
      libnss3 \
      libxss1 \
      libxtst6 \
      xauth \
      xvfb \
    && rm -rf /var/lib/apt/lists/* \
  ; fi

# install tomb
ARG INSTALL_TOMB=0
ARG VERSION_TOMB
RUN \
  if [ "${INSTALL_TOMB}" = "1" ]; then \
    apt update \
      && apt install --no-install-recommends -y -q \
        cryptsetup \
        gettext \
        pinentry-curses \
        zsh \
      && rm -rf /var/lib/apt/lists/* \
    && git clone \
      --branch ${VERSION_TOMB} \
      --depth 1 \
      https://github.com/dyne/Tomb.git \
      /usr/local/src/tomb \
    && cd /usr/local/src/tomb \
    && make install \
    && rm -rf /usr/local/src/tomb \
  ; fi

# install node
ARG VERSION_NODE
RUN \
  if [ "${VERSION_NODE}" = "LATEST" ]; then \
    export V=$( \
      wget -O - -q https://nodejs.org/dist/index.json \
        | grep '"lts":false' \
        | head -n1 \
        | cut -d',' -f1 \
        | cut -d'"' -f4 \
    ) \
  ; elif [ "${VERSION_NODE}" = "LTS" ]; then \
    export V=$( \
      wget -O - -q https://nodejs.org/dist/index.json \
        | grep -v '"lts":false' \
        | grep lts \
        | head -n1 \
        | cut -d',' -f1 \
        | cut -d'"' -f4 \
    ) \
  ; else \
    export V=${VERSION_NODE} \
  ; fi \
  && export F="node-${V}-linux-x64.tar.xz" \
  && cd /tmp \
  && wget https://nodejs.org/dist/${V}/${F} \
  && tar \
    --directory /usr/local \
    --exclude='CHANGELOG.md' \
    --exclude='LICENSE' \
    --exclude='README.md' \
    --extract \
    --file ${F} \
    --strip-components 1 \
  && chown -R 0:0 /usr/local \
  && rm -f ${F}

# install yarn and pnpm
RUN npm install --global corepack

# stop corepack from prompting
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# install node things
RUN npm install --global \
    @anthropic-ai/claude-code \
    @fleek-platform/cli \
    aicommits \
    diff-so-fancy \
    neovim \
    npm-check \
    npm-check-updates \
    prettier \
    prettier-plugin-solidity \
    typescript

# install latest deno
RUN curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh

ARG INSTALL_NEOVIM_FROM_SRC=0
ARG INSTALL_NEOVIM_FROM_PPA_STABLE=0
ARG INSTALL_NEOVIM_FROM_PPA_UNSTABLE=0
ARG VERSION_NEOVIM_FROM_SRC=stable
RUN \
  if [ "${INSTALL_NEOVIM_FROM_SRC}" = "1" ]; then \
    # install neovim tag'd release from source
    # reference: https://github.com/neovim/neovim/wiki/Building-Neovim
    apt update \
      && apt install --no-install-recommends -y -q \
        cmake \
        curl \
        g++ \
        gettext \
        libtool-bin \
        ninja-build \
        pkg-config \
        unzip \
      && rm -rf /var/lib/apt/lists/* \
      && git clone \
        --branch ${VERSION_NEOVIM_FROM_SRC} \
        --depth 1 \
        https://github.com/neovim/neovim.git \
        /usr/local/src/neovim \
      && cd /usr/local/src/neovim \
      && make \
        CMAKE_BUILD_TYPE=Release \
        CMAKE_INSTALL_PREFIX=/usr \
      && make install \
      && rm -rf /usr/local/src/neovim \
  ; elif [ "${INSTALL_NEOVIM_FROM_PPA_STABLE}" = "1" ]; then \
    # install neovim (stable) from ppa
    # reference: https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu
    add-apt-repository ppa:neovim-ppa/stable \
      && apt update \
      && apt install --no-install-recommends -y -q \
        neovim \
      && rm -rf /var/lib/apt/lists/* \
  ; elif [ "${INSTALL_NEOVIM_FROM_PPA_UNSTABLE}" = "1" ]; then \
    # install neovim (unstable) from ppa
    add-apt-repository ppa:neovim-ppa/unstable \
      && apt update \
      && apt install --no-install-recommends -y -q \
        neovim \
      && rm -rf /var/lib/apt/lists/* \
  ; else \
    # install neovim from apt
    apt update \
      && apt install --no-install-recommends -y -q \
        neovim \
      && rm -rf /var/lib/apt/lists/* \
  ; fi

# install python support for neovim
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV PIP_NO_CACHE_DIR=1
RUN pip install --upgrade pynvim

# use neovim for editor alternatives
# reference: https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source
RUN update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 \
  && update-alternatives --config vi \
  && update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60 \
  && update-alternatives --config vim \
  && update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60 \
  && update-alternatives --config editor

# install PlatformIO (stable version)
# http://docs.platformio.org/en/latest/installation.html#python-package-manager
ARG INSTALL_PLATFORMIO=0
RUN \
  if [ "${INSTALL_PLATFORMIO}" = "1" ]; then \
    pip install --upgrade platformio \
  ; fi

########################################################################
# switch to user
########################################################################
ENV HOME=/home/${_USER} USER=${_USER} LC_ALL=${_LOCALE} LANG=${_LOCALE}
ENV PATH=/home/${_USER}/bin:/home/${_USER}/.go/bin:/home/${_USER}/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV SHELL=/bin/bash
ENV XDG_CONFIG_HOME=/home/${_USER}/.config
SHELL ["/bin/bash", "--login", "-c"]
USER ${_USER}
WORKDIR /home/${_USER}

# install latest go
# Note: 2023-08: go_installer fails with:
#   Downloading Go from 400 Bad Request failed with HTTP status %!s(MISSING)
#   https://github.com/golang/tools/tree/master/cmd/getgo#usage
RUN mkdir -p /tmp/go && cd /tmp/go \
  # https://github.com/golang/tools/blob/master/cmd/getgo/download.go
  && curl -Ls 'https://go.dev/dl/?mode=json' \
    | jq -r '.[0].files[] | select(.os == "linux" and .arch == "amd64")' \
    > go.json \
  && export F=$(cat go.json | jq -r '.filename') \
  && export C=$(cat go.json | jq -r '.sha256') \
  && curl -LO "https://go.dev/dl/${F}" \
  && echo "${C} ${F}" > checksum.txt \
  && sha256sum --check checksum.txt \
  && tar -xzf ${F} \
  && mv go /home/${_USER}/.go \
  && rm -rf /tmp/go

# install go things
RUN go install \
    github.com/jesseduffield/lazygit@latest \
  && go clean --cache

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# install rust things
ENV CARGO_HOME=/home/${_USER}/.cargo
ENV CARGO_TARGET_DIR=${CARGO_HOME}/target
RUN \
  --mount=type=cache,id=cargo-registry,target=${CARGO_HOME}/registry,uid=${_USER_ID} \
  --mount=type=cache,id=cargo-target,target=$CARGO_TARGET_DIR,uid=${_USER_ID} \
  curl -L --proto '=https' --tlsv1.2 -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash \
  && cargo binstall \
    --continue-on-failure \
    --disable-telemetry \
    --locked \
    bat \
    cargo-edit \
    exa \
    fastmod \
    fd-find \
    fnm \
    git-absorb \
    ripgrep \
    spacer \
    starship \
    tree-sitter-cli \
    watchexec-cli \
    websocat \
    zoxide \
  && rustup component add \
    rust-analyzer

# install latest bun and make it available in PATH
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/home/${_USER}/.bun/bin:${PATH}"

# install bun things
RUN bun add -g \
    repomix

# install latest circom release
# https://docs.circom.io/getting-started/installation/#installing-dependencies
ARG INSTALL_CIRCOM=0
RUN \
  if [ "${INSTALL_CIRCOM}" = "1" ]; then \
    git clone \
      --branch $( \
        curl -Ls https://api.github.com/repos/iden3/circom/releases/latest \
        | sed -n -e 's/"tag_name": "\(.*\)",/\1/p' \
      ) \
      --depth 1 \
      https://github.com/iden3/circom.git \
      /usr/local/src/circom \
    && cd /usr/local/src/circom \
    && cargo build --release \
    && cargo install --path circom \
    && rm -rf /usr/local/src/circom \
  ; fi

# install noir
# https://noir-lang.org/docs/getting_started/quick_start
ARG INSTALL_NOIR=0
ENV NARGO_HOME=/home/${_USER}/.nargo
RUN \
  if [ "${INSTALL_NOIR}" = "1" ]; then \
    curl -L https://raw.githubusercontent.com/noir-lang/noirup/refs/heads/main/install | bash \
    && ${NARGO_HOME}/bin/noirup \
    # NOTE: bb installed this way works on ubuntu 24, but not 22 (cuz glibc)
    && curl -L https://raw.githubusercontent.com/AztecProtocol/aztec-packages/refs/heads/next/barretenberg/bbup/install | bash \
    && PATH="${NARGO_HOME}/bin:$PATH" SHELL=/bin/bash ~/.bb/bbup \
  ; fi

# install Protocol Buffers
ARG INSTALL_PB=0
RUN \
  if [ "${INSTALL_PB}" = "1" ]; then \
    # install latest protoc release
    export V=$( \
      curl -L -s https://api.github.com/repos/protocolbuffers/protobuf/releases/latest \
      | sed -n -e 's/"tag_name": "\(.*\)",/\1/p' \
      | sed -e 's/^.*v//' \
    ) \
    && export F="protoc-${V}-linux-x86_64.zip" \
    && wget "https://github.com/protocolbuffers/protobuf/releases/download/v${V}/${F}" \
    && unzip ${F} \
      -x readme.txt \
      -d ~/.local \
    && rm -f ${F} \
    # install buf; also provides formatter and linter
    && go install github.com/bufbuild/buf/cmd/buf@latest \
    # clean up
    && go clean --cache \
  ; fi

# install cpanminus for installing perl modules
# running cpanm gives suggestion to install local::lib, so do that
RUN mkdir bin \
  && curl -L -o bin/cpanm https://cpanmin.us/ \
  && chmod +x bin/cpanm \
  && bin/cpanm --quiet --local-lib=perl5 local::lib \
  && perl -I perl5/lib/perl5/ -Mlocal::lib >> .bashrc

# install neovim perl provider dependencies (according to :checkhealth)
RUN cpanm --quiet --notest \
    Neovim::Ext \
    App::cpanminus \
  && rm -rf .cpanm

# install latest kpcli and dependencies
ARG VERSION_KPCLI
RUN wget -O bin/kpcli https://downloads.sourceforge.net/project/kpcli/kpcli-${VERSION_KPCLI}.pl \
  && chmod +x bin/kpcli \
  && cpanm --quiet --notest \
    Authen::OATH \
    Capture::Tiny \
    Clipboard \
    Clone \
    Convert::Base32 \
    Crypt::Argon2 \
    Crypt::Rijndael \
    Data::Password \
    Data::Password::zxcvbn \
    File::KDBX \
    File::KeePass \
    Math::Random::ISAAC \
    Sort::Naturally \
    Sub::Install \
    Term::ReadKey \
    Term::ReadLine::Gnu \
    Term::ShellUI \
  && rm -rf .cpanm

# install latest fzf release
RUN git clone \
    --depth 1 \
    --branch $( \
      curl -Ls https://api.github.com/repos/junegunn/fzf/releases/latest \
      | sed -n -e 's/"tag_name": "\(.*\)",/\1/p' \
    ) \
    https://github.com/junegunn/fzf.git \
    ~/.fzf \
  && ~/.fzf/install \
    --all \
    --no-zsh

# install opencode
ARG INSTALL_OPENCODE=0
ARG OPTIONS_OHMYOPENCODE
RUN \
  if [ "${INSTALL_OPENCODE}" = "1" ]; then \
    curl -fsSL https://opencode.ai/install | bash \
    && export PATH=/home/${_USER}/.opencode/bin:${PATH} \
    && bunx oh-my-opencode install --no-tui ${OPTIONS_OHMYOPENCODE} \
    && sudo npm i -g opencode-wakatime && opencode-wakatime --install \
  ; fi

# install extra bash things
RUN mkdir ~/.bash

# install extra fish things
SHELL ["/bin/fish", "--login", "-c"]
RUN curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
    | source \
  && fisher install \
    gazorby/fish-exa \
    jukben/fish-nx \
    jorgebucaran/fisher
SHELL ["/bin/bash", "--login", "-c"]

# install nix; single-user mode
# https://nixos.wiki/wiki/Nix_Installation_Guide
ARG INSTALL_NIX=0
RUN \
  if [ "${INSTALL_NIX}" = "1" ]; then \
    sudo install -d -m755 -o $(id -u) -g $(id -g) /nix \
    && curl -L https://nixos.org/nix/install | sh \
    && /bin/fish --login -c 'fisher install lilyball/nix-env.fish' \
  ; fi

ARG INSTALL_DEVOPS=0
RUN \
  if [ "${INSTALL_DEVOPS}" = "1" ]; then \
    # install ansible
    pip install --upgrade ansible \
    # install awscli
    && cd /tmp \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install \
    && rm -rf ./aws* \
    # install opentofu
    # https://opentofu.org/docs/intro/install/deb/#installing-using-the-installer
    && curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh \
    && chmod +x install-opentofu.sh \
    && ./install-opentofu.sh --install-method deb \
    && rm install-opentofu.sh \
    # install hashicorp things
    && wget -O - https://apt.releases.hashicorp.com/gpg \
      | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
      | sudo tee /etc/apt/sources.list.d/hashicorp.list \
    && sudo apt update \
    && sudo apt install --no-install-recommends -y -q \
      packer \
      terraform \
    ## install tflocal (for localstack)
    && pip install --upgrade terraform-local \
    ## clean up
    && sudo rm -rf /var/lib/apt/lists/* \
  ; fi

# https://v2.tauri.app/start/prerequisites/#linux
ARG INSTALL_TAURI=0
RUN \
  if [ "${INSTALL_TAURI}" = "1" ]; then \
    sudo apt update \
    && sudo apt install --no-install-recommends -y -q \
      build-essential \
      curl \
      file \
      libayatana-appindicator3-dev \
      librsvg2-dev \
      libssl-dev \
      libwebkit2gtk-4.1-dev \
      libxdo-dev \
      wget \
    && sudo rm -rf /var/lib/apt/lists/* \
    && cargo binstall \
      --continue-on-failure \
      --disable-telemetry \
      --locked \
      tauri-cli \
  ; fi

# copy configuration files so that links to them work during docker build
RUN mkdir -p ${XENDEV_DIR}
COPY --chown=${_USER}:${_USER} . ${XENDEV_DIR}

# link configuration files so that a mounted volume may override at container execution time
RUN \
  # replace files with symlinks to our custom config files
  rm -f \
    /home/${_USER}/.config/kitty/kitty.conf \
    /home/${_USER}/.config/opencode/oh-my-opencode.json \
    /home/${_USER}/.config/opencode/opencode.json \
  # create dirs so stow symlinks files and not dirs
  && mkdir -p \
    /home/${_USER}/.config/lazygit \
    /home/${_USER}/.config/opencode \
  # stow the conf files!
  && stow \
    --dir=${XENDEV_DIR} \
    --target=/home/${_USER}/ \
    --ignore=gitconfig \
    --verbose \
    conf

# source bash configuration
RUN /bin/echo -e "\ntest -f ~/.bash_xendev && . ~/.bash_xendev\n" >> .bashrc

# tmux things that need something extra
RUN \
  # tmux-window-name deps
  pip install --user libtmux

# install smart-splits Kitty multiplexer support
# Kitty conf expects the kittens so don't wait for nvim lazy load
RUN cd /tmp \
  && git clone \
    --depth 1 \
    https://github.com/mrjones2014/smart-splits.nvim.git \
  && cd smart-splits.nvim \
  && ./kitty/install-kittens.bash \
  && rm -rf /tmp/smart-splits.nvim

# install tinty, sync schemes/templates, and apply a theme
# tinty expects a ~/.config/ file, so run this after stow
ARG OPTIONS_THEME
RUN \
  cargo binstall \
    --continue-on-failure \
    --disable-telemetry \
    --locked \
    tinty \
  && tinty sync \
  # symlink our custom schemes, as they only work in tinty data-dir
  && export D="tinted-theming/tinty/custom-schemes" && ln -sfn /home/${_USER}/.config/${D} ~/.local/share/${D} \
  # apply configured theme system wide
  && tinty apply ${OPTIONS_THEME} \
  # relocate tinty data-dir as ~/.local/share/ is commonly volume-mapped for persistence
  && mv ~/.local/share/tinted-theming/tinty ~/.tinty

# set nvim distribution
ARG OPTIONS_NVIM_APPNAME
ENV NVIM_APPNAME=${OPTIONS_NVIM_APPNAME}

########################################################################
# temporarily switch back to root user
########################################################################
USER root

# /home/${_USER} --> /etc/skel
# symlink xendev user's home to /etc/skel to support x11docker user home
RUN mv /etc/skel /etc/skel.bak \
  && mkdir /etc/skel \
  && (ln -sv /home/${_USER}/{.,}* /etc/skel/ || true)

# record xendev release
RUN echo \
    "VERSION=$(date +'%Y%m%d%H%M%S')" \
    > /etc/xendev-release

# unminimize to install docs
ARG INSTALL_DOCS=0
RUN \
  if [ "${INSTALL_DOCS}" = "1" ]; then \
    yes | unminimize \
    && rm -rf /var/lib/apt/lists/* \
  ; fi

########################################################################
# switch to user
########################################################################
USER ${_USER}

CMD ["/bin/bash", "-c", "command -v start &>/dev/null && start || /bin/bash -l"]
