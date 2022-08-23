FROM ubuntu:rolling

# configuration
ARG _KPCLI_VERSION=3.8.1
ARG _LOCALE=en_US.UTF-8
ARG _NODE_VERSION=v16.16.0
ARG _RIPGREP_VERSION=13.0.0
ARG _TOMB_VERSION=v2.9
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
    fish \
    gpg-agent \
    htop \
    jq \
    less \
    libtool \
    locales \
    man-db \
    openssh-client \
    pkg-config \
    psmisc \
    python3-pip \
    python3-pygments \
    rake \
    rsync \
    silversearcher-ag \
    sqlite3 \
    sshfs \
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
    # for bfg-repo-cleaner:
    openjdk-11-jre \
    # for flow-bin:
    libelf1 \
    # for kpcli:
    libreadline-dev \
    xclip \
    # for neovim (build dep):
    cmake \
    # for tomb:
    cryptsetup \
    gettext \
    pinentry-curses \
    zsh \
  && rm -rf /var/lib/apt/lists/*

# set locale
RUN locale-gen ${_LOCALE} \
  && update-locale LANG=${_LOCALE} LC_ALL=${_LOCALE}

# install latest git
RUN apt-add-repository ppa:git-core/ppa \
  && apt-get update \
  && apt-get install --no-install-recommends -y -q \
    git \
    git-lfs \
  && rm -rf /var/lib/apt/lists/*

# install latest clang tools
# https://apt.llvm.org/
ARG XENDEV_LLVM_INSTALL=0
ARG XENDEV_LLVM_VERSION=14
RUN if [ "${XENDEV_LLVM_INSTALL}" = "1" ]; then \
    cd /tmp \
    && wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh ${XENDEV_LLVM_VERSION} all \
    && rm -f llvm.sh \
    && for x in $(ls /usr/bin/clang*${XENDEV_LLVM_VERSION}); do \
        ln -sv $x $(echo $x | sed -e "s/-${XENDEV_LLVM_VERSION}//"); \
      done \
  ; fi

# install solidity compiler
RUN apt-add-repository ppa:ethereum/ethereum \
  && apt-get update \
  && apt-get install --no-install-recommends -y -q \
    solc \
  && rm -rf /var/lib/apt/lists/*

# install bfg-repo-cleaner
RUN wget "https://search.maven.org/classic/remote_content?g=com.madgag&a=bfg&v=LATEST" \
    -O /usr/local/bin/bfg \
  && chmod 755 /usr/local/bin/bfg

# install tomb
RUN git clone --branch ${_TOMB_VERSION} --depth 1 https://github.com/dyne/Tomb.git /usr/local/src/tomb \
  && cd /usr/local/src/tomb \
  && make install \
  && rm -rf /usr/local/src/tomb

# install entr
RUN git clone --depth 1 https://github.com/eradman/entr.git /tmp/entr \
  && cd /tmp/entr \
  && ./configure \
  && make test \
  && make install \
  && rm -rf /tmp/entr

# install ripgrep (used by spacevim/vim-todo)
# @todo with ubuntu:cosmic do `apt install ripgrep`
RUN export F="ripgrep_${_RIPGREP_VERSION}_amd64.deb" \
  && curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/${_RIPGREP_VERSION}/${F}" \
  && dpkg -i "${F}"

# # install the platinum searcher
# ARG _PT_VERSION=v2.2.0
# RUN export F="pt_linux_amd64.tar.gz" \
#   && cd /tmp \
#   && wget "https://github.com/monochromegane/the_platinum_searcher/releases/download/${_PT_VERSION}/${F}" \
#   && tar \
#     --exclude='README.md' \
#     -C /usr/local/bin --strip-components 1 -xf ${F} \
#   && rm -f ${F}

# install node
RUN export F="node-${_NODE_VERSION}-linux-x64.tar.xz" \
  && cd /tmp \
  && wget http://nodejs.org/dist/${_NODE_VERSION}/${F} \
  && tar \
    --exclude='ChangeLog' \
    --exclude='LICENSE' \
    --exclude='README.md' \
    -C /usr/local --strip-components 1 -xf ${F} \
  && rm -f ${F}

# install yarn and pnpm
RUN npm install --location=global \
    corepack

# install node things
RUN npm install --location=global \
  bash-language-server \
  diff-so-fancy \
  dockerfile-language-server-nodejs \
  eslint-cli \
  import-js \
  javascript-typescript-langserver \
  neovim \
  npm-check \
  prettier \
  prettier-plugin-solidity \
  pretty-xl-formula \
  solc \
  taskbook \
  tern \
  typescript \
  typescript-language-server \
  vscode-langservers-extracted \
  # for spacevim layer lang#typescript:
  lehre

# install neovim tag'd release from source
# reference: https://github.com/neovim/neovim/wiki/Building-Neovim
# ARG _NEOVIM_VERSION=v0.1.6
# RUN git clone --branch ${_NEOVIM_VERSION} --depth 1 https://github.com/neovim/neovim.git /usr/local/src/neovim \
#   && cd /usr/local/src/neovim \
#   && make CMAKE_BUILD_TYPE=Release \
#   && make install \
#   && rm -rf /usr/local/src/neovim

# install neovim (stable) from ppa
# reference: https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu
# RUN add-apt-repository ppa:neovim-ppa/stable \
#   && apt-get update \
#   && apt-get install --no-install-recommends -y -q \
#     neovim \
#   && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install --no-install-recommends -y -q \
    neovim \
  && rm -rf /var/lib/apt/lists/*

# install python support for neovim
# https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim
# :help python-provider
RUN pip install --upgrade neovim pynvim

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
SHELL ["/bin/bash", "--login", "-c"]
USER ${_USER}
WORKDIR /home/${_USER}

# install latest go
# the installer writes to .bash_profile, remove to avoid conflict with custom bash config
# https://github.com/golang/tools/tree/master/cmd/getgo#usage
RUN curl -LO https://get.golang.org/$(uname)/go_installer \
  && chmod +x go_installer \
  && ./go_installer \
  && rm go_installer \
  && rm ~/.bash_profile

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# install latest circom
# https://docs.circom.io/getting-started/installation/#installing-dependencies
ARG XENDEV_CIRCOM_INSTALL=0
RUN if [ "${XENDEV_CIRCOM_INSTALL}" = "1" ]; then \
    cd /tmp \
    && git clone https://github.com/iden3/circom.git \
    && cd circom \
    && cargo build --release \
    && cargo install --path circom \
  ; fi

# install rust things
RUN cargo install \
  exa

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
RUN wget -O bin/kpcli http://downloads.sourceforge.net/project/kpcli/kpcli-${_KPCLI_VERSION}.pl \
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
    File::KeePass \
    Sort::Naturally \
    Term::ReadKey \
    Term::ReadLine::Gnu \
    Term::ShellUI \
  && rm -rf .cpanm

# install ultimate git bash prompt
RUN git clone \
  --depth 1 \
  --branch master \
  https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt

# install fzf
RUN git clone \
    --depth 1 \
    https://github.com/junegunn/fzf.git ~/.fzf \
  && ~/.fzf/install \
    --all \
    --no-zsh

# install extra bash things
RUN mkdir ~/.bash \
  && wget -O ~/.bash/forgit.plugin.sh \
    https://raw.githubusercontent.com/wfxr/forgit/master/forgit.plugin.zsh

# install extra fish things
SHELL ["/bin/fish", "--login", "-c"]
RUN curl -sL https://git.io/fisher | source \
  && fisher install \
    jorgebucaran/fisher \
    jomik/fish-gruvbox \
    wfxr/forgit
SHELL ["/bin/bash", "--login", "-c"]

# 2020-12-15: fix b0rking line endings on pxlf
# 2022-06-18: location changed; install with npm, not yarn
# RUN dos2unix ~/.config/yarn/global/node_modules/pretty-xl-formula/cli.js

# copy configuration files so that links to them work during docker build
RUN mkdir -p ${XENDEV_DIR}
COPY --chown=${_USER}:${_USER} . ${XENDEV_DIR}

# link configuration files so that a mounted volume may override at container execution time
RUN ln -sv \
    ${XENDEV_DIR}/conf/.SpaceVim.d \
    ${XENDEV_DIR}/conf/.bash_aliases \
    ${XENDEV_DIR}/conf/.bash_local \
    ${XENDEV_DIR}/conf/.bash_prompt \
    ${XENDEV_DIR}/conf/.tmux.conf \
    /home/${_USER}/ \
  && ln -sv \
    ${XENDEV_DIR}/conf/.config/starship.toml \
    /home/${_USER}/.config/ \
  && ln -svf \
    ${XENDEV_DIR}/conf/.config/fish/config.fish \
    /home/${_USER}/.config/fish/config.fish

# enable local bash configuration
RUN /bin/echo -e "\ntest -f ~/.bash_local && . ~/.bash_local\n" >> .bashrc

# install tmux plugins (to avoid slight delay in tmux startup)
RUN mkdir -p ~/.tmux/plugins \
  && cd ~/.tmux/plugins \
  && git clone --depth 1 https://github.com/tmux-plugins/tpm.git \
  && git clone --depth 1 https://github.com/egel/tmux-gruvbox.git


####################################
# install spacevim
####################################
RUN curl -sLf https://spacevim.org/install.sh | bash

# use specific spacevim release
# ARG _SPACEVIM_VERSION=v2.0.0
# RUN cd /home/${_USER}/.SpaceVim && git checkout ${_SPACEVIM_VERSION}

# 2020-12-15 fix System error while opening ShaDa file: no such file or directory
RUN touch /tmp/main.shada

# install plugins
# https://github.com/SpaceVim/SpaceVim/issues/3477#issuecomment-619203729
RUN nvim --headless +"call dein#install#_update([], 'update', 0)" +qall
# RUN nvim --headless +'call dein#install#_update([], "install", v:false)' +qall

# this is ~redundant to the above but can increase visibility of vim plugin errors
RUN nvim --headless +'call dein#install()' +qall

# 2021-04-14: minor: prevent vim first run warning: startify: Can't read viminfo file.
RUN nvim --headless +e /tmp/tmp +qall

# 2021-04-14: does something... but does not fix first-run error from deoplete
RUN nvim --headless +UpdateRemotePlugins +qall

# 2020-12-15: fix vimproc_linux64.so is not found
# https://github.com/SpaceVim/SpaceVim/issues/544#issuecomment-687652874
RUN cd ~/.SpaceVim/bundle/vimproc.vim/ && make

# vim plugins that need something extra
RUN cd ~/.cache/vimfiles/repos/github.com/RRethy/vim-hexokinase && make

# install CoC extensions
RUN nvim --headless \
  +'CocInstall -sync \
    coc-clangd \
    coc-cmake \
    coc-css \
    coc-emoji \
    coc-html \
    coc-json \
    coc-markdownlint \
    coc-sh \
    coc-solidity \
    coc-tsserver \
    coc-toml \
    coc-yaml \
  ' \
  +qall

# update yarn to the latest version
# 2022-06-18: do this last as other installations depend on yarn v1
RUN yarn set version stable

########################################################################
CMD ["/bin/bash", "-l"]
