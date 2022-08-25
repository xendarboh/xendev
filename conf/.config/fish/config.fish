if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

theme_gruvbox dark medium

# forgit requires SHELL=/bin/fish
set SHELL /bin/fish

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
  set F "$XENDEV_DIR/conf.local/directory_map.txt"
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

alias exa="exa \
--git \
--group-directories-first \
--header \
--icons \
--long \
--time-style=long-iso \
"

abbr ll 'exa'
abbr la 'exa --all'
abbr lt 'exa --tree'

abbr s 'git status'

# 2022-08 FIX: (neo)vim format buffer (prettier) inserts chars with SHELL=/bin/fish
abbr vim 'set SHELL /bin/bash; vim'
