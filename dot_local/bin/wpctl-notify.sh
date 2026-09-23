#!/usr/bin/env bash

set -euo pipefail

ACTION="${1:-}"
STEP="${2:-5}"

usage() {
    echo "Usage: $0 [up|down|mute|toggle] [step%]" >&2
    exit 1
}

[[ -z "$ACTION" ]] && usage

case "$ACTION" in
    up|+)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%+"
        ;;
    down|-)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%-"
        ;;
    mute|toggle)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    *)
        usage
        ;;
esac

# Get volume and mute state
VOL_INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOL=$(echo "$VOL_INFO" | grep -oP '[0-9]\.[0-9]{2}' | awk '{printf "%.0f", $1 * 100}')
MUTE=$(echo "$VOL_INFO" | grep -o 'MUTED' || true)

if [[ -n "$VOL" ]]; then
    if [[ -n "$MUTE" ]]; then
        notify-send -e \
            -h string:x-canonical-private-synchronous:volume \
            -h "int:value:${VOL}" \
            -t 800 \
            "Volume: Muted"
    else
        notify-send -e \
            -h string:x-canonical-private-synchronous:volume \
            -h "int:value:${VOL}" \
            -t 800 \
            "Volume: ${VOL}%"
    fi
fi
