#!/bin/bash

# -- Function definitions --

install_package() {
  if ! command -v "$1" &> /dev/null; then
    sudo apt update
    sudo apt install -y "$1"
    echo "Installed $1"
  else
    echo "$1 is already installed."
  fi
}

install_plugin() {
  if [[ ! -d ~/.oh-my-zsh/plugins/$1 ]]; then
    git clone https://github.com/zsh-users/$1 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$1
    echo "Installed $1 plugin"
  else
    echo "$1 plugin is already installed."
  fi
}

# --- Function calls ---

# Backup .zshrc file
if [ -f ~/.zshrc ]; then
  cp ~/.zshrc ~/.zshrc.bak
  echo "Backed up .zshrc file to ~/.zshrc.bak"
fi

# Install zsh
install_package zsh

# Set zsh as default shell
if [[ "$SHELL" != "/bin/zsh" ]]; then
  chsh -s $(which zsh)
  echo "Set zsh as default shell"
fi

install_package git
install_package curl

# Install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Installed oh-my-zsh"
fi

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
  # If fzf is not installed, install it using git clone
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  echo "fzf installation complete."
else
  echo "fzf is already installed."
fi

# Install autojump
install_package autojump

# Install rip-grep
install_package ripgrep

# Install fd
install_package fd-find
if [[ ! -f /usr/bin/fd ]]; then
  sudo ln -s $(which fdfind) /usr/bin/fd
  echo "Made a symbolic link 'fd' to the file: /usr/bin/fdfind"
fi

# Install jq
install_package jq

# Install zsh-completions
install_plugin zsh-completions

# Install zsh-autosuggestions
install_plugin zsh-autosuggestions

# Install zsh-syntax-highlighting
install_plugin zsh-syntax-highlighting

# ZSH_THEME theme
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="duellj"/g' ~/.zshrc

# oh-my-zsh plugins
sed -i 's/plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions autojump fzf zsh-completions command-not-found)/g' ~/.zshrc

# Reload zsh settings
source ~/.zshrc
echo "Reloaded zsh settings"

echo "All settings completed!"

