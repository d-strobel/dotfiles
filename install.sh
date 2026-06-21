#!/usr/bin/env bash

# Dotfiles install script for debian based devcontainers.

set -e

DOTFILES_SOURCE_PATH="$HOME/dotfiles"
DOTFILES_TARGET_PATH="$HOME/.config"

echo "Start devcontainer setup"

# Check if fish is installed
if ! command -v fish >/dev/null 2>&1; then
  echo "fish is not installed - abort setup"
  exit 1
fi

echo "Install mise"
curl https://mise.run | sh

echo "Remove old dotfiles"
rm -rf "$DOTFILES_TARGET_PATH/fish"
rm -rf "$DOTFILES_TARGET_PATH/nvim"
rm -rf "$DOTFILES_TARGET_PATH/mise"

echo "Copy devcontainer dotfiles"
ln -s "$DOTFILES_SOURCE_PATH/devcontainer/fish" "$DOTFILES_TARGET_PATH/fish"
ln -s "$DOTFILES_SOURCE_PATH/devcontainer/mise" "$DOTFILES_TARGET_PATH/mise"
ln -s "$DOTFILES_SOURCE_PATH/dot_config/nvim" "$DOTFILES_TARGET_PATH/nvim"

echo "Copy pi settings if not present"
mkdir -p "$HOME/.pi/agent"
cp --update=none "$DOTFILES_SOURCE_PATH/devcontainer/pi/*.json" "$HOME/.pi/agent/"

echo "Set user shell to fish"
sudo chsh vscode --shell "$(which fish)"

echo "Install applications via mise"
"$HOME/.local/bin/mise" install

echo "Finished devcontainer setup"
