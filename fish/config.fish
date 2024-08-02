if status is-interactive
    fish_add_path /usr/local/go/bin $HOME/go/bin $HOME/.local/bin $HOME/bin $HOME/.cargo/bin
    set -x EDITOR nvim
    alias vim="nvim"
    alias vi="nvim"
    alias n="nvim"
end
direnv hook fish | source
kubectl completion fish | source
starship init fish | source
