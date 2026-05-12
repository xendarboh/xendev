#!/usr/bin/env sh
set -eu

# remove stray "}" in window name
fix_tmux_option() {
  opt="$1"
  value="$(tmux show-option -gqv "$opt" | sed 's/#{?window_zoomed_flag,\*Z,}}/#{?window_zoomed_flag,*Z,}/g')"
  tmux set-window-option -g "$opt" "$value"
}

fix_tmux_option window-status-current-format
fix_tmux_option window-status-format
