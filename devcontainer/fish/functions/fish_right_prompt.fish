#!/usr/bin/env fish

function fish_right_prompt
    set_color 424a4b
    date '+%H:%M:%S'
    set_color normal
end
