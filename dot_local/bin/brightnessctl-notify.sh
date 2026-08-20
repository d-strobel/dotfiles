#!/usr/bin/env bash

set -euo pipefail

ACTION="${1:-}"
STEP="${2:-10}"

case "$ACTION" in
    up|+)
        brightnessctl --class=backlight set "+${STEP}%"
        ;;
    down|-)
        brightnessctl --class=backlight set "${STEP}%-"
        ;;
    *)
        usage
        ;;
esac

VALUE=$(brightnessctl info | grep -oP '\(\K[0-9]+(?=%)')

notify-send -e \
    -h string:x-canonical-private-synchronous:brightness \
    -h "int:value:${VALUE}" \
    -t 800 \
    "Brightness: ${VALUE}%"
