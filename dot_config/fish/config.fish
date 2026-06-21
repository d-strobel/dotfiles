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

    # Theme
    fish_config theme choose alabaster_dark

    # Interactive shell initialisation
    fzf --fish | source
    zoxide init fish --cmd cd | source

    # Keychain integration
    SHELL=fish eval (keychain --eval --timeout 720 --quiet id_ed25519 id_ed25519_vault-prod)

    # Direnv integration
    direnv hook fish | source
end

# Global variables
set -gx EDITOR nvim
set -gx VISUAL nvim
