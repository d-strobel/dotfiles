#!/usr/bin/env bash

last_session=$(tmux display-message -p '#{client_last_session}')
sessions=$(tmux list-sessions -F '#{session_name}' | grep -v "^$last_session$")

if [[ -z $last_session ]]; then
    selected=$(echo "$sessions" | fzf --tmux bottom --border-label=" Tmux Sessions ")
else
    selected=$(echo -e "$last_session\n$sessions" | fzf --tmux bottom --border-label=" Sessions ")
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(echo "$selected" | sed 's/:.*//')

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
