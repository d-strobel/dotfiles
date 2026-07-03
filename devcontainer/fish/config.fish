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

    # Pi settings
    set -gx PI_SKIP_VERSION_CHECK 1
    set -gx PI_FFF_MODE override
    set -gx FFF_FRECENCY_DB ~/.cache/nvim/fff_nvim

    # Fzf settings
    set -gx FZF_DEFAULT_OPTS "--bind 'ctrl-l:accept'"

    # Fish keybinds
    bind \cj down-or-search
    bind \ck up-or-search
    bind \cl execute
end

# Global variables
set -gx EDITOR nvim
set -gx VISUAL nvim
