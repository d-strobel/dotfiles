if status is-interactive
    # Mise activation
    ~/.local/bin/mise activate fish | source

    # Aliases
    alias lla 'ls -la'
    alias la 'ls -la'
    alias vimdiff 'nvim -d'
    alias vim="nvim"
    alias vi="nvim"

    # Interactive shell initialisation
    fzf --fish | source
    zoxide init fish --cmd cd | source

    # Direnv integration
    direnv hook fish | source
end

# Global variables
set -gx EDITOR nvim
set -gx VISUAL nvim
