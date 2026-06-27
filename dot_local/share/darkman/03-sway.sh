#!/bin/sh

# Change sway settings.

# Helper function to select a random picture
random_file() {
    dir=$1
    set -- "$dir"/*
    [ -e "$1" ] || return 1

    printf '%s\n' "$@" | awk '
        BEGIN { srand() }
        { files[++n] = $0 }
        END { print files[int(rand()*n)+1] }
    '
}

case "$1" in
dark)
  PIC=$(random_file "$HOME/.local/wallpaper/dark")
  ;;
light)
  PIC=$(random_file "$HOME/.local/wallpaper/light")
  ;;
default) exit 1 ;;
esac

# Helper variables
OUT_DIR="$HOME/.local/state/sway"
OUT_FILE="$OUT_DIR/config"

# First create the directory
mkdir -p "$OUT_DIR"

# Write sway settings here to config file
echo "output * bg $PIC fill" > "$OUT_FILE"

# Reload sway with the correct socket
for socket in /run/user/$UID/sway-ipc.*.sock; do
  [ -S "$socket" ] || continue
  exec swaymsg -s "$socket" --quiet reload
done
