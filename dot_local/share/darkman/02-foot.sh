#!/bin/sh

# Switch the foot terminal initial mode and sen SIGUSR to reload.

# Ignore SIGUSR1 and SIGUSR2 to prevent the script from terminating
trap '' USR1 USR2

case "$1" in
dark)
  pkill -USR1 foot
  ;;
light)
  pkill -USR2 foot
  ;;
default) exit 1 ;;
esac

# Helper variables
OUT_DIR="$HOME/.local/state/foot"

# Create the directory first
mkdir -p "$OUT_DIR"

# Write settings to config file
echo "initial-color-theme=$1" > "$OUT_DIR/colorscheme.ini"
