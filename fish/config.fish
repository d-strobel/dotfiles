if status is-interactive
    fish_add_path /usr/local/go/bin $HOME/go/bin $HOME/.local/bin $HOME/bin $HOME/.cargo/bin
    set -x EDITOR nvim
    alias vim="nvim"
    alias vi="nvim"
    alias n="nvim"
    alias ll="eza -la"
    alias ls="eza"
end
direnv hook fish | source
kubectl completion fish | source
starship init fish | source
zoxide init --cmd cd fish | source
fzf --fish | source
