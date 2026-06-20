#!/usr/bin/env bash

tmp_file=$(mktemp)
tmux capture-pane -pS -3000 > "$tmp_file"
tmux display-popup -d '#{pane_current_path}' -E -w 90% -h 90% "$EDITOR -c '$' $tmp_file && rm $tmp_file"
