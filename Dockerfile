ARG IMAGE_BASE=
FROM ${IMAGE_BASE}

# configuration
ARG _LOCALE=en_US.UTF-8
ARG _USER=xendev
ARG _USER_GROUPS=audio,dialout,video
ARG _USER_ID=1000

# persist _USER for use in inheriting images
ENV XENDEV_USER ${_USER}

# xendev source directory volume mount point when running container
# used for configuration files as symlinks
ENV XENDEV_DIR /home/${_USER}/src/xendev

# use the "noninteractive" debconf frontend
ENV DEBIAN_FRONTEND noninteractive

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
    openssh-client \
    pkg-config \
    psmisc \
    python3-pip \
    python3-pygments \
    rake \
    ranger \
    ripgrep \
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
    whiptail \
    xsel \
    zip \
    # https://github.com/mapbox/node-sqlite3/issues/1443
    python-is-python3 \
    # for kpcli:
    libreadline-dev \
    xclip \
  && rm -rf /var/lib/apt/lists/*

# set locale
RUN locale-gen ${_LOCALE} \
  && update-locale LANG=${_LOCALE} LC_ALL=${_LOCALE}

# install latest fish
RUN apt-add-repository ppa:fish-shell/release-3 \
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

# install latest git-crypt
RUN \
  # install deps
  apt update \
  && apt install --no-install-recommends -y -q \
    libssl-dev \
  && rm -rf /var/lib/apt/lists/* \
  # git clone the latest release
  && git clone \
    --depth 1 \
    --branch $( \
      curl -Ls https://api.github.com/repos/AGWA/git-crypt/releases/latest \
      | sed -n -e 's/"tag_name": "\(.*\)",/\1/p' \
    ) \
    https://github.com/AGWA/git-crypt.git \
    /usr/local/src/git-crypt \
  && cd /usr/local/src/git-crypt \
  # apply patch so it builds
  && curl -L https://patch-diff.githubusercontent.com/raw/AGWA/git-crypt/pull/249.patch \
    | git apply -v \
  # make, install, then cleanup
  && make  \
  && make \
    PREFIX=/usr/local \
    install \
  && rm -rf /usr/local/src/git-crypt

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

# install watchman
ARG VERSION_WATCHMAN
RUN cd /tmp \
  && if [ "${VERSION_WATCHMAN}" = "LATEST" ]; then \
    wget $( \
      curl -Ls https://api.github.com/repos/facebook/watchman/releases/latest \
      | grep -Eo "https://(.*)watchman_ubuntu$(lsb_release -rs)_(.*).deb" \
    ) \
  ; else \
    export F="${VERSION_WATCHMAN}/watchman_ubuntu$(lsb_release -rs)_${VERSION_WATCHMAN}.deb" \
    && wget "https://github.com/facebook/watchman/releases/download/${F}" \
  ; fi \
  && apt update \
  && (dpkg -i watchman_*.deb || true) \
  && apt install --no-install-recommends -y -q -f \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f watchman_*.deb \
  && watchman version

# add example local watchman config file
RUN echo -e \
'{\n\
  "ignore_dirs": ["node_modules"]\n\
}'\
> /usr/share/.watchmanconfig

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
RUN npm install --location=global \
    corepack

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
# https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim
# :help python-provider
RUN pip install --upgrade neovim pynvim

# install additional neovim tools
RUN pip install --upgrade \
  neovim-remote

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
RUN pip install --upgrade platformio

# install codemod
# https://github.com/facebook/codemod
# 20210201: consider replace/supplement with https://github.com/facebookincubator/fastmod
RUN pip install codemod

# install spacevim things
ARG INSTALL_SPACEVIM=0
RUN \
  if [ "${INSTALL_SPACEVIM}" = "1" ]; then \
    apt update \
    && apt install --no-install-recommends -y -q \
      fontconfig \
      libtool-bin \
      lua5.3 \
      ninja-build \
      wamerican \
      xfonts-utils \
      # for spacevim layer tags:
      exuberant-ctags \
      global \
    && rm -rf /var/lib/apt/lists/* \
  ; fi

RUN pip install pipenv # necessary?

# install starship cross-shell prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

# create user, grant sudo access
RUN useradd -m -s /bin/bash -u ${_USER_ID} -G ${_USER_GROUPS} ${_USER} \
  && echo "${_USER}:${_USER}" | chpasswd \
  && echo "${_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${_USER} \
  && chmod 0440 /etc/sudoers.d/${_USER}


########################################################################
# switch to user
########################################################################
ENV HOME=/home/${_USER} USER=${_USER} LC_ALL=${_LOCALE} LANG=${_LOCALE}
ENV PATH=/home/${_USER}/bin:/home/${_USER}/.yarn/bin:/home/${_USER}/.go/bin:/home/${_USER}/go:/home/${_USER}/perl5/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${_USER}/.fzf/bin
ENV SHELL=/bin/bash
ENV XDG_CONFIG_HOME=/home/${_USER}/.config
SHELL ["/bin/bash", "--login", "-c"]
USER ${_USER}
WORKDIR /home/${_USER}

# install node things
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
ENV NPM_CONFIG_PREFIX=/home/${_USER}/.npm-global
RUN npm install --location=global \
  diff-so-fancy \
  eslint-cli \
  import-js \
  neovim \
  npm-check \
  npm-check-updates \
  prettier \
  prettier-plugin-solidity \
  retypeapp \
  solc \
  taskbook \
  tern \
  typescript

# install node things for LSP
RUN npm install --location=global \
  # docker_compose_language_service:
  # @microsoft/compose-language-service \
  # prismals:
  @prisma/language-server \
  # tailwindcss:
  @tailwindcss/language-server \
  # bashls:
  bash-language-server \
  # dockerls:
  dockerfile-language-server-nodejs \
  # nxls:
  nxls \
  # tsserver:
  typescript-language-server \
  # cssls, eslint, html, jsonls:
  vscode-langservers-extracted

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
RUN cargo install \
  # 2023-01-31: install exa this way vs apt to avoid:
  # exa: Options --git and --git-ignore can't be used because `git` feature was disabled in this build of exa
  exa \
  git-absorb \
  spacer

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

# install cpanminus for installing perl modules
# running cpanm gives suggestion to install local::lib, so do that
RUN mkdir bin \
  && curl -L -o bin/cpanm https://cpanmin.us/ \
  && chmod +x bin/cpanm \
  && bin/cpanm --quiet --local-lib=perl5 local::lib \
  && perl -I perl5/lib/perl5/ -Mlocal::lib >> .bashrc

# install neovim perl provider dependencies (according to :checkhealth)
RUN eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib) \
  && bin/cpanm --quiet --notest \
    Neovim::Ext \
    App::cpanminus \
  && rm -rf .cpanm

# install latest kpcli and dependencies
ARG VERSION_KPCLI
RUN wget -O bin/kpcli https://downloads.sourceforge.net/project/kpcli/kpcli-${VERSION_KPCLI}.pl \
  && chmod +x bin/kpcli \
  && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib) \
  && bin/cpanm --quiet --notest \
    Authen::OATH \
    Capture::Tiny \
    Clipboard \
    Clone \
    Convert::Base32 \
    Crypt::Rijndael \
    Data::Password \
    Data::Password::passwdqc \
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

# install zoxide
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# install extra bash things
RUN mkdir ~/.bash

# install extra fish things
SHELL ["/bin/fish", "--login", "-c"]
RUN curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
    | source \
  && fisher install \
    gazorby/fish-exa \
    jomik/fish-gruvbox \
    xendarboh/fish-nx \
    jorgebucaran/fisher
SHELL ["/bin/bash", "--login", "-c"]

# copy configuration files so that links to them work during docker build
RUN mkdir -p ${XENDEV_DIR}
COPY --chown=${_USER}:${_USER} . ${XENDEV_DIR}

# link configuration files so that a mounted volume may override at container execution time
RUN \
  # replace kitty.conf file (from standalone-able Dockerfile.x11) with symlink
  rm -f /home/${_USER}/.config/kitty/kitty.conf \
  # create dirs so stow symlinks files and not dirs
  && mkdir \
    -p /home/${_USER}/.config/lazygit \
  # stow the conf files!
  && stow \
    --dir=${XENDEV_DIR} \
    --target=/home/${_USER}/ \
    --ignore=gitconfig \
    --verbose \
    conf

# enable local bash configuration
RUN /bin/echo -e "\ntest -f ~/.bash_local && . ~/.bash_local\n" >> .bashrc

# install tmux plugins (to avoid slight delay in tmux startup)
RUN mkdir -p ~/.tmux/plugins \
  && cd ~/.tmux/plugins \
  && git clone --depth 1 https://github.com/egel/tmux-gruvbox.git \
  && git clone --depth 1 https://github.com/ofirgall/tmux-window-name.git \
  && git clone --depth 1 https://github.com/tmux-plugins/tmux-resurrect.git \
  && git clone --depth 1 https://github.com/tmux-plugins/tpm.git

# tmux things that need something extra
RUN \
  # tmux-window-name deps
  pip install --user libtmux

# install smart-splits Kitty multiplexer support
# Kitty conf expects the kittens so don't wait for lunarvim lazy load
RUN cd /tmp \
  && git clone \
    --depth 1 \
    https://github.com/mrjones2014/smart-splits.nvim.git \
  && cd smart-splits.nvim \
  && ./kitty/install-kittens.bash \
  && rm -rf /tmp/smart-splits.nvim


####################################
# install spacevim
####################################
RUN \
  if [ "${INSTALL_SPACEVIM}" = "1" ]; then \
    curl -sLf https://spacevim.org/install.sh \
      # 2023-03-01 Hot Fix (temp hack!?) broken install script, see:
      # https://github.com/SpaceVim/SpaceVim/issues/4790
      # https://github.com/60ke/SpaceVim/commit/7607c86c03913d25046bb528560df83558c3e9d8
      | sed -e 's|config/nvim|nvim|' \
      | bash \
    \
    # use specific spacevim release
    # && cd ${XDG_CONFIG_HOME}/SpaceVim \
    # && git checkout ${VERSION_SPACEVIM} \
    \
    # 2020-12-15 fix System error while opening ShaDa file: no such file or directory
    && touch /tmp/main.shada \
    \
    # install plugins
    # https://github.com/SpaceVim/SpaceVim/issues/3477#issuecomment-619203729
    && nvim --headless +"call dein#install#_update([], 'update', 0)" +qall \
    \
    # this is ~redundant to the above but can increase visibility of vim plugin errors
    && nvim --headless +'call dein#install()' +qall \
    \
    # 2021-04-14: minor: prevent vim first run warning: startify: Can't read viminfo file.
    && nvim --headless +e /tmp/tmp +qall \
    \
    # 2021-04-14: does something... but does not fix first-run error from deoplete
    && nvim --headless +UpdateRemotePlugins +qall \
    \
    # spacevim things that need something extra
    # https://github.com/SpaceVim/SpaceVim/issues/544#issuecomment-687652874
    # https://github.com/Shougo/vimproc.vim#vundle
    && cd ${XDG_CONFIG_HOME}/SpaceVim/bundle/vimproc.vim/ && make \
    \
    # vim plugins that need something extra
    && cd ~/.cache/vimfiles/repos/github.com/RRethy/vim-hexokinase && make \
    \
    # install CoC extensions
    && nvim --headless \
      +'CocInstall -sync \
        @yaegassy/coc-tailwindcss3 \
        coc-clangd \
        coc-cmake \
        coc-css \
        coc-emoji \
        coc-html \
        coc-json \
        coc-markdownlint \
        coc-prisma \
        coc-sh \
        coc-solidity \
        coc-toml \
        coc-tsserver \
        coc-yaml \
      ' \
      +qall \
    \
    # install spacevim node things
    && npm install --location=global \
      # for spacevim layer lang#typescript:
      lehre \
  ; fi


####################################
# install lunarvim
####################################
ARG INSTALL_LUNARVIM=0
ARG VERSION_LUNARVIM
RUN \
  if [ "${INSTALL_LUNARVIM}" = "1" ]; then \
    # install npm deps
    npm install --location=global \
      neovim \
      tree-sitter-cli \
    \
    # install pip deps
    && pip install \
      pynvim \
    \
    # install rust deps
    && cargo install \
      fd-find \
      ripgrep \
    \
    # run lunarvim install script
    # https://github.com/LunarVim/LunarVim/blob/master/utils/installer/install.sh
    && mkdir /tmp/lv && cd /tmp/lv \
    && curl -LOs "https://raw.githubusercontent.com/LunarVim/LunarVim/${VERSION_LUNARVIM}/utils/installer/install.sh" \
    && chmod u+x install.sh \
    && \
      LV_BRANCH=${VERSION_LUNARVIM} \
      ./install.sh \
        --no-install-dependencies \
        --yes \
    && rm -rf /tmp/lv \
  ; fi


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

USER ${_USER}


########################################################################
CMD ["/bin/bash", "-c", "command -v start &>/dev/null && start || /bin/bash -l"]
