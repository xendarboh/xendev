# git
alias gl='git log --date=relative --graph --name-status'
alias s='git status'

# http://stackoverflow.com/questions/3432536/create-session-if-none-exists
alias tm='tmux attach-session -t default || tmux new-session -s default'

# usually provided by ~/.bashrc, defined here to make sure they are active:
alias ll='ls -l --time-style="+%Y-%m-%d"'
alias la='ls -A'
alias l='ls -CF'

# neovim aliases
alias vimdiff='nvim -d'
alias view='nvim -R'

# edit files of specified git status, for example "vimgit M" to open all modified files
vimgit () { nvim ${@:2} $(git status --porcelain | grep "$1 " | awk '{print $2}'); }

# taskbook: set custom home dir, enforce color (for pipe to less)
alias tb='clear; HOME=~/src/ tb --color=always'

# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
alias less='less -F -i -J -M -R -W -x4 -X -z-4'

alias x="cd ${XENDEV_DIR} && vim"

# INSTALL_BRAVE
alias brave-browser='brave-browser --no-sandbox'

# platformio shortcuts
pioe() { cat ./platformio.ini | sed -nre 's/^\[env:(.*)\]/\1/p'; }
piol() { pio device list; }
piom() { pio device monitor -b 115200 -p /dev/ttyUSB${1:-0} ${@:2}; }
piou() { pio run -t upload --upload-port /dev/ttyUSB${1:-0} ${@:2}; }
piot() {
  pio test \
    --upload-port /dev/ttyUSB${1:-0} \
    --test-port /dev/ttyUSB${1:-0} \
    ${@:2};
}
