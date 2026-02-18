if status is-interactive
    # Path
    fish_add_path $HOME/.local/bin

    # Aliases
    alias lla 'ls -la'
    alias la 'ls -la'
    alias t tmux-open.sh
    alias vimdiff 'nvim -d'
    alias vim="nvim"
    alias vi="nvim"

    # Interactive shell initialisation
    fzf --fish | source
    zoxide init fish --cmd cd | source
end

# Global variables
set -gx EDITOR nvim
set -gx VISUAL nvim
