#!/bin/sh

# Change mango theme.

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
  THEME_ROOT_COLOR=0x0e1415ff
  THEME_BORDER_COLOR=0x444444ff
  THEME_FOCUS_COLOR=0xc9b890ff
  THEME_MAXIMIZESCREEN_COLOR=0x89aa61ff
  THEME_URGENT_COLOR=0xad401fff
  THEME_SCRATCHPAD_COLOR=0x516c93ff
  THEME_GLOBAL_COLOR=0xb153a7ff
  THEME_OVERLAY_COLOR=0x14a57cff
  ;;
light)
  PIC=$(random_file "$HOME/.local/wallpaper/light")
  THEME_ROOT_COLOR=0x0e1415ff
  THEME_BORDER_COLOR=0xcdcdcdff
  THEME_FOCUS_COLOR=0xcd8d06ff
  THEME_MAXIMIZESCREEN_COLOR=0x89aa61ff
  THEME_URGENT_COLOR=0xad401fff
  THEME_SCRATCHPAD_COLOR=0x516c93ff
  THEME_GLOBAL_COLOR=0xb153a7ff
  THEME_OVERLAY_COLOR=0x14a57cff
  ;;
default) exit 1 ;;
esac

# Helper variables
OUT_DIR="$HOME/.local/state/mango"
OUT_FILE="$OUT_DIR/theme.conf"

# First create the directory
mkdir -p "$OUT_DIR"

# Write settings to theme file
echo "exec=pkill .swaybg-wrapped 2>/dev/null; swaybg --output \"*\" --image \"$PIC\" --mode \"fill\"" > "$OUT_FILE"

# Write colors to theme file
echo "rootcolor=$THEME_ROOT_COLOR" >> "$OUT_FILE"
echo "bordercolor=$THEME_BORDER_COLOR" >> "$OUT_FILE"
echo "focuscolor=$THEME_FOCUS_COLOR" >> "$OUT_FILE"
echo "maximizescreencolor=$THEME_MAXIMIZESCREEN_COLOR" >> "$OUT_FILE"
echo "urgentcolor=$THEME_URGENT_COLOR" >> "$OUT_FILE"
echo "scratchpadcolor=$THEME_SCRATCHPAD_COLOR" >> "$OUT_FILE"
echo "globalcolor=$THEME_GLOBAL_COLOR" >> "$OUT_FILE"
echo "overlaycolor=$THEME_OVERLAY_COLOR" >> "$OUT_FILE"

# Reload mango with the correct socket
for socket in /run/user/$UID/mango-*.sock; do
  [ -S "$socket" ] || continue
  export MANGO_INSTANCE_SIGNATURE="$socket"
  mmsg dispatch reload_config &2>/dev/null
done
