#!/usr/bin/env bash

# Dotfiles install script for debian based devcontainers.

set -e

DOTFILES_SOURCE_PATH="$HOME/dotfiles"
MISE_SCRIPT_BIN="$HOME/.local/bin/mise"

ensure_symlink() {
    local source="$1"
    local link="$2"

    # Ensure target directory exists
    mkdir -p "$(dirname "$link")"

    if [[ "$(readlink "$link" 2>/dev/null)" != "$source" ]]; then
        # Create or overwrite link
        echo "Symlink $source -> $link"
        ln -sfn "$source" "$link"
    fi
}

ensure_git_config() {
    local key="$1"
    local desired_value="$2"

    # Get current value; git exits with 1 if the key is unset, so handle that.
    local current_value
    current_value=$(git config --global "$key" 2>/dev/null || true)

    if [[ "$current_value" != "$desired_value" ]]; then
        echo "Set git $key to $desired_value"
        git config --global "$key" "$desired_value"
    fi
}

echo "Start devcontainer setup"

if command -v fish >/dev/null 2>&1; then
    echo "Set user shell to fish"
    sudo chsh "$USER" --shell "$(which fish)"
else
    echo "WARNING - fish is not installed!"
fi

# Symlink dotfiles
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/mise" "$HOME/.config/mise"
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/fish" "$HOME/.config/fish"
ensure_symlink "$DOTFILES_SOURCE_PATH/dot_config/nvim" "$HOME/.config/nvim"
ensure_symlink "$DOTFILES_SOURCE_PATH/dot_config/git/ignore" "$HOME/.config/git/ignore"
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/pi/extensions" "$HOME/.pi/agent/extensions"
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/pi/keybindings.json" "$HOME/.pi/agent/keybindings.json"
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/pi/settings.json" "$HOME/.pi/agent/settings.json"

# Global git config
if [[ -n "${GIT_USER_NAME:-}" ]]; then
    ensure_git_config "user.name" "$GIT_USER_NAME"
fi

if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
    ensure_git_config "user.email" "$GIT_USER_EMAIL"
fi

ensure_git_config "core.excludesFile" "$HOME/.config/git/ignore"

# Check if mise is installed
if [ ! -x "$MISE_SCRIPT_BIN" ]; then
    echo "Deploy mise"
    export MISE_QUIET=1
    curl https://mise.run | sh
    "$MISE_SCRIPT_BIN" install
    eval "$($MISE_SCRIPT_BIN activate bash)"
fi

# Check if the last plugin in the vim.pack.add list is installed
if [ ! -d "$HOME/.local/share/nvim/site/pack/core/opt/fff.nvim" ]; then
    echo "Install Neovim plugins"
    nvim --headless "+qa"
fi

echo "Finished devcontainer setup"
