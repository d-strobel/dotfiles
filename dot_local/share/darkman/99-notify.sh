#!/usr/bin/env sh

# Notification for mode switching.

case "$1" in
dark) ;;
light) ;;
default) exit 1 ;;
esac

notify-send --app-name="darkman" "darkman" "switching to $1 mode"
