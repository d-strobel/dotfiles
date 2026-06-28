#!/usr/bin/env bash

# Dotfiles install script for debian based devcontainers.

set -e

DOTFILES_SOURCE_PATH="$HOME/dotfiles"

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

echo "Start devcontainer setup"

if ! command -v fish >/dev/null 2>&1; then
  echo "Set user shell to fish"
  sudo chsh vscode --shell "$(which fish)"
else
  echo "WARNING - fish is not installed!"
fi

# Symlink dotfiles
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/mise" "$HOME/.config/mise"
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/fish" "$HOME/.config/fish"
ensure_symlink "$DOTFILES_SOURCE_PATH/dot_config/nvim" "$HOME/.config/nvim"
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/pi/extensions" "$HOME/.pi/agent/extensions"
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/pi/keybindings.json" "$HOME/.pi/agent/keybindings.json"
ensure_symlink "$DOTFILES_SOURCE_PATH/devcontainer/pi/settings.json" "$HOME/.pi/agent/settings.json"

echo "Deploy mise"
curl https://mise.run | sh
"$HOME/.local/bin/mise" install


echo "Finished devcontainer setup"
