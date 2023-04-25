ARG IMAGE_BASE=
FROM ${IMAGE_BASE}

# configuration
ARG _LOCALE=en_US.UTF-8
ARG _USER=xendev
ARG _USER_GROUPS=audio,dialout,video
ARG _USER_ID=1000

# versions
ARG VERSION_KPCLI=3.8.1
ARG VERSION_LLVM=14
ARG VERSION_NODE=v18.16.0
ARG VERSION_TOMB=v2.9

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
    # for spacevim layer tags:
    exuberant-ctags \
    global \
    # for flow-bin:
    libelf1 \
    # for kpcli:
    libreadline-dev \
    xclip \
    # for tomb:
    cryptsetup \
    gettext \
    pinentry-curses \
    zsh \
  && rm -rf /var/lib/apt/lists/*

# set locale
RUN locale-gen ${_LOCALE} \
  && update-locale LANG=${_LOCALE} LC_ALL=${_LOCALE}

# install latest fish
RUN apt-add-repository ppa:fish-shell/release-3 \
  && apt-get update \
  && apt-get install --no-install-recommends -y -q \
    fish \
  && rm -rf /var/lib/apt/lists/*

# install latest git
RUN apt-add-repository ppa:git-core/ppa \
  && apt-get update \
  && apt-get install --no-install-recommends -y -q \
    git \
    git-lfs \
  && rm -rf /var/lib/apt/lists/*

# install latest clang tools
# https://apt.llvm.org/
ARG INSTALL_LLVM=0
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
  && apt-get update \
  && apt-get install --no-install-recommends -y -q \
    solc \
  && rm -rf /var/lib/apt/lists/*

# install bfg-repo-cleaner
ARG INSTALL_BFG=0
RUN \
  if [ "${INSTALL_BFG}" = "1" ]; then \
    apt-get update \
    && apt-get install --no-install-recommends -y -q \
      openjdk-11-jre \
    && rm -rf /var/lib/apt/lists/* \
    && wget "https://search.maven.org/classic/remote_content?g=com.madgag&a=bfg&v=LATEST" \
      -O /opt/bfg.jar \
    && echo -e '#!/bin/bash\njava -jar /opt/bfg.jar ${@}' \
      > /usr/local/bin/bfg \
    && chmod 755 /usr/local/bin/bfg \
  ; fi

# install cypress system deps
# https://docs.cypress.io/guides/getting-started/installing-cypress#UbuntuDebian
ARG INSTALL_CYPRESS_DEPS=0
RUN \
  if [ "${INSTALL_CYPRESS_DEPS}" = "1" ]; then \
    apt-get update \
    && apt-get install --no-install-recommends -y -q \
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
RUN git clone \
    --branch ${VERSION_TOMB} \
    --depth 1 \
    https://github.com/dyne/Tomb.git \
    /usr/local/src/tomb \
  && cd /usr/local/src/tomb \
  && make install \
  && rm -rf /usr/local/src/tomb

# # install the platinum searcher
# ARG _PT_VERSION=v2.2.0
# RUN export F="pt_linux_amd64.tar.gz" \
#   && cd /tmp \
#   && wget "https://github.com/monochromegane/the_platinum_searcher/releases/download/${_PT_VERSION}/${F}" \
#   && tar \
#     --exclude='README.md' \
#     -C /usr/local/bin --strip-components 1 -xf ${F} \
#   && rm -f ${F}

# install watchman, for coc-tsserver
RUN apt update \
  && apt install --no-install-recommends -y -q \
    watchman \
  && rm -rf /var/lib/apt/lists/*

# add example local watchman config file
RUN echo -e \
'{\n\
  "ignore_dirs": ["node_modules"]\n\
}'\
> /usr/share/.watchmanconfig

# install node
RUN export F="node-${VERSION_NODE}-linux-x64.tar.xz" \
  && cd /tmp \
  && wget http://nodejs.org/dist/${VERSION_NODE}/${F} \
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
ARG VERSION_NEOVIM=stable
RUN \
  if [ "${INSTALL_NEOVIM_FROM_SRC}" = "1" ]; then \
    # install neovim tag'd release from source
    # reference: https://github.com/neovim/neovim/wiki/Building-Neovim
    apt-get update \
      && apt-get install --no-install-recommends -y -q \
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
        --branch ${VERSION_NEOVIM} \
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
      && apt-get update \
      && apt-get install --no-install-recommends -y -q \
        neovim \
      && rm -rf /var/lib/apt/lists/* \
  ; elif [ "${INSTALL_NEOVIM_FROM_PPA_UNSTABLE}" = "1" ]; then \
    # install neovim (unstable) from ppa
    add-apt-repository ppa:neovim-ppa/unstable \
      && apt-get update \
      && apt-get install --no-install-recommends -y -q \
        neovim \
      && rm -rf /var/lib/apt/lists/* \
  ; else \
    # install neovim from apt
    apt-get update \
      && apt-get install --no-install-recommends -y -q \
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

# install grip markdown previewer
RUN pip install grip

# install codemod
# https://github.com/facebook/codemod
# 20210201: consider replace/supplement with https://github.com/facebookincubator/fastmod
RUN pip install codemod

# install spacevim things
RUN apt update \
  && apt install --no-install-recommends -y -q \
    fontconfig \
    libtool-bin \
    lua5.3 \
    ninja-build \
    wamerican \
    xfonts-utils \
  && rm -rf /var/lib/apt/lists/*
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
  typescript \
  # for spacevim layer lang#typescript:
  lehre

# install node things for spacevim layer lsp
RUN npm install --location=global \
  # docker_compose_language_service
  # @microsoft/compose-language-service \
  # prismals
  @prisma/language-server \
  # tailwindcss
  @tailwindcss/language-server \
  # bashls
  bash-language-server \
  # dockerls
  dockerfile-language-server-nodejs \
  # nxls
  nxls \
  # tsserver
  typescript-language-server \
  # cssls, eslint, html, jsonls
  vscode-langservers-extracted

# install latest go
# https://github.com/golang/tools/tree/master/cmd/getgo#usage
RUN curl -LO https://get.golang.org/$(uname)/go_installer \
  && chmod +x go_installer \
  && ./go_installer \
  && rm go_installer \
  # the installer writes to .bash_profile, remove to avoid conflict with custom bash config
  && rm ~/.bash_profile \
  && go clean --cache

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
  exa

# install latest circom
# https://docs.circom.io/getting-started/installation/#installing-dependencies
ARG INSTALL_CIRCOM=0
RUN \
  if [ "${INSTALL_CIRCOM}" = "1" ]; then \
    cd /tmp \
    && git clone https://github.com/iden3/circom.git \
    && cd circom \
    && cargo build --release \
    && cargo install --path circom \
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
RUN wget -O bin/kpcli http://downloads.sourceforge.net/project/kpcli/kpcli-${VERSION_KPCLI}.pl \
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

# install fzf
RUN git clone \
    --depth 1 \
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


####################################
# install spacevim
####################################
RUN curl -sLf https://spacevim.org/install.sh \
  # 2023-03-01 Hot Fix (temp hack!?) broken install script, see:
  # https://github.com/SpaceVim/SpaceVim/issues/4790
  # https://github.com/60ke/SpaceVim/commit/7607c86c03913d25046bb528560df83558c3e9d8
  | sed -e 's|config/nvim|nvim|' \
  | bash

# use specific spacevim release
# ARG VERSION_SPACEVIM=v2.0.0
# RUN cd ${XDG_CONFIG_HOME}/SpaceVim && git checkout ${VERSION_SPACEVIM}

# 2020-12-15 fix System error while opening ShaDa file: no such file or directory
RUN touch /tmp/main.shada

# install plugins
# https://github.com/SpaceVim/SpaceVim/issues/3477#issuecomment-619203729
RUN nvim --headless +"call dein#install#_update([], 'update', 0)" +qall

# this is ~redundant to the above but can increase visibility of vim plugin errors
RUN nvim --headless +'call dein#install()' +qall

# 2021-04-14: minor: prevent vim first run warning: startify: Can't read viminfo file.
RUN nvim --headless +e /tmp/tmp +qall

# 2021-04-14: does something... but does not fix first-run error from deoplete
RUN nvim --headless +UpdateRemotePlugins +qall

# spacevim things that need something extra
RUN \
  # https://github.com/SpaceVim/SpaceVim/issues/544#issuecomment-687652874
  # https://github.com/Shougo/vimproc.vim#vundle
  cd ${XDG_CONFIG_HOME}/SpaceVim/bundle/vimproc.vim/ && make

# vim plugins that need something extra
RUN cd ~/.cache/vimfiles/repos/github.com/RRethy/vim-hexokinase && make

# install CoC extensions
RUN nvim --headless \
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
  +qall


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

USER ${_USER}


########################################################################
CMD ["/bin/bash", "-c", "command -v start &>/dev/null && start || /bin/bash -l"]
