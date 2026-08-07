#!/usr/bin/env bash

# Define timeouts
LT="${lock_timeout:-2400}"
ST="${screen_timeout:-600}"

# Helper functions for mangowm
mango_outputs_off() {
    mmsg get all-monitors | jq -r '.monitors[].name' | while read -r output; do
        mmsg dispatch sleep_monitor,"$output" 2&>/dev/null
    done
}

mango_outputs_on() {
    mmsg get all-monitors | jq -r '.monitors[].name' | while read -r output; do
        mmsg dispatch wakeup_monitor,"$output" 2&>/dev/null
    done
}

# Make the functions available to bash -c invocations from swayidle
export -f mango_outputs_off mango_outputs_on

# Execute swayidle
swayidle -w \
    timeout "$LT" 'swaylock -f' \
    timeout "$((LT + ST))" 'bash -c mango_outputs_off' \
              resume 'bash -c mango_outputs_on' \
    timeout "$ST" 'pgrep -xu "$USER" swaylock >/dev/null && bash -c mango_outputs_off' \
         resume 'pgrep -xu "$USER" swaylock >/dev/null && bash -c mango_outputs_on' \
    before-sleep 'swaylock -f' \
    lock 'swaylock -f' \
    unlock 'pkill -xu "$USER" -SIGUSR1 swaylock'
