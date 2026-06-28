#!/usr/bin/env bash

# Dotfiles install script for debian based devcontainers.

set -e
echo "Start devcontainer setup"

# Abort install if fish is not installed
if ! command -v fish >/dev/null 2>&1; then
  echo "fish is not installed - abort setup"
  exit 1
fi

echo "Set user shell to fish"
sudo chsh vscode --shell "$(which fish)"

echo "Install mise"
curl https://mise.run | sh

echo "Symlink mise config"
ln -s "$HOME/dotfiles/devcontainer/mise" "$HOME/.config/mise"

echo "Mise bootstrap"
"$HOME/.local/bin/mise" bootstrap

echo "Finished devcontainer setup"
