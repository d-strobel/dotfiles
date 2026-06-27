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

    # Don't check pi version
    set -gx PI_SKIP_VERSION_CHECK 1

    # Set fzf options
    set -gx FZF_DEFAULT_OPTS "--bind 'ctrl-l:accept'"
end

# Global variables
set -gx EDITOR nvim
set -gx VISUAL nvim
