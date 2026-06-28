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

echo "Start devcontainer setup"

if command -v fish >/dev/null 2>&1; then
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
export MISE_QUIET=1
curl https://mise.run | sh
"$MISE_SCRIPT_BIN" install
eval "$($MISE_SCRIPT_BIN activate bash)"

# Check if the last plugin in the vim.pack.add list is installed
if [ ! -d "$HOME/.local/share/nvim/site/pack/core/opt/fff.nvim" ]; then
  echo "Install Neovim plugins"
  nvim --headless "+qa"
fi

echo "Finished devcontainer setup"
