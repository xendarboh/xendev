if status is-interactive
    # Commands to run in interactive sessions can go here
end

command -q bat && bat --completion fish | source
command -q buf && buf completion fish | source
command -q nargo && nargo generate-completion-script fish | source
command -q tinty && tinty generate-completion fish | source
fnm completions --shell fish | source
fnm env | source
git-absorb --gen-completions fish | source
starship init fish | source
zoxide init fish | source

# gpg needs this
export GPG_TTY=(tty)

# forgit requires SHELL=/bin/fish
set SHELL /bin/fish

# kitty manual shell integration
# https://sw.kovidgoyal.net/kitty/shell-integration/#manual-shell-integration
if set -q KITTY_INSTALLATION_DIR
    set --global KITTY_SHELL_INTEGRATION enabled
    source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
    set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
end

# add all emacs-mode bindings to vi-mode
# https://fishshell.com/docs/current/interactive.html#vi-mode-commands
function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end

function fish_greeting
    # silence the greeting
end

function dirmap
    set F "$XENDEV_DIR/conf.local/xendev/directory_map.txt"
    test -f "$F" || return
    for line in (cat "$F")
        set from (echo "$line" | cut -d':' -f1)
        set to (echo "$line" | cut -d':' -f2)

        set match (string match --regex ^$from $PWD)
        if test ! -z "$match"
            set XENDEV_DIRMAP_MSG "[xendev] directory map: $from --> $to"
            set XENDEV_DIRMAP_PWD (echo "$PWD" | sed -e "s|^$from|$to|")
            echo $XENDEV_DIRMAP_MSG && cd $XENDEV_DIRMAP_PWD
        end
    end
end
dirmap

# 20250724: fix pesky issue where all nx commands b0rk the terminal prompt
function nx
    command nx $argv
    commandline -f repaint
    commandline -f execute
end

function on_variable_pwd --on-variable PWD
    # update tmux-window-name upon directory change (iff running tmux)
    test ! -z "$TMUX_PLUGIN_MANAGER_PATH" \
        && $TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py &>/dev/null
end

# https://github.com/gazorby/fish-exa#-configuration
set -Ux EXA_STANDARD_OPTIONS \
    --group \
    --group-directories-first \
    --header \
    --icons \
    --long \
    --time-style=long-iso
set -Ux EXA_LL_OPTIONS --sort changed
set -Ux EXA_LT_OPTIONS --ignore-glob '.git|node_modules' --tree --level

abbr b 'git branch -av'
abbr s 'git status'
abbr gl 'git log --show-signature'
abbr lz lazygit
abbr tc 'tinty cycle'

# INSTALL_BROWSER_BRAVE
command -v brave-browser >/dev/null && abbr brave-browser 'brave-browser --no-sandbox'

# INSTALL_BROWSER_CHROMIUM
command -v chromium-browser >/dev/null && abbr chromium-browser 'chromium-browser --no-sandbox'

abbr kt-clip 'kitty +kitten clipboard'
abbr kt-diff 'kitty +kitten diff'
abbr kt-icat 'kitty +kitten icat'

# vim:sw=4:ts=4:et:
