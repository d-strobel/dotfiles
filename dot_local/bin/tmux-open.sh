#!/usr/bin/env bash

if [[ $PWD == "$HOME" ]]; then
	selected_name="scratch"
else
	selected_name=$(basename "$PWD" | tr . _)
fi

tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	tmux new-session -s "$selected_name" -c "$PWD"
	exit 0
fi

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
	tmux new-session -ds "$selected_name" -c "$PWD"
fi

tmux attach-session -t "$selected_name"
