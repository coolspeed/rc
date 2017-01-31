function git-pull {
  # Clone a Git repository.  If the repository already exists,
  # just pull from the remote.
  SRC="$1"
  DEST="$2"
  if [[ ! -d "$DEST" ]]
  then
    mkdir -p "$DEST"
    git clone "$SRC" "$DEST"
  else
    git -C "$DEST" pull
  fi
}


# Authorize the local SSH key for connecting to
# localhost without password.
if ! ssh -qo BatchMode=yes localhost true
then
  if [[ ! -f ~/.ssh/id_rsa ]]
  then
    info "Generating new SSH key..."
    ssh-keygen -f ~/.ssh/id_rsa -N ''
  fi
  ssh-keyscan -H localhost 2>/dev/null 1>> ~/.ssh/known_hosts
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  info "Authorized the SSH key to connect to localhost."
fi

# Install ZSH and Oh My ZSH!
if ! executable zsh
then
  info "Installing Zsh..."
  sudo apt-get install -y zsh
fi
info "Setting up the Zsh environment..."
sudo chsh -s "$(which zsh)" "$USER"
git-pull https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
git-pull https://github.com/zsh-users/zsh-syntax-highlighting \
         ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git-pull https://github.com/zsh-users/zsh-autosuggestions \
         ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git-pull https://github.com/bobthecow/git-flow-completion \
         ~/.oh-my-zsh/custom/plugins/git-flow-completion

# Install ripgrep.
RG_RELEASE="$(curl -s \
              https://api.github.com/repos/BurntSushi/ripgrep/releases/latest)"
RG_VERSION="$(echo "$RG_RELEASE" | grep tag_name | cut -d '"' -f4)"
info "Installing ripgrep-${RG_VERSION}..."
if executable rg && [[ "$(rg --version)" == "$RG_VERSION" ]]
then
  echo "Already up-to-date."
else
  RG_URL="$(echo "$RG_RELEASE" | \
            grep -e 'browser_download_url.\+x86_64.\+linux' | \
            cut -d'"' -f4)"
  RG_ARCHIVE="$(basename "$RG_URL")"
  pushd /usr/local
  if [[ ! -f "/usr/local/src/$RG_ARCHIVE" ]]
  then
    curl -L "$RG_URL" | sudo tee "src/~$RG_ARCHIVE" > /dev/null
    sudo mv "src/~$RG_ARCHIVE" "src/$RG_ARCHIVE"
  fi
  sudo tar xvzf "src/$RG_ARCHIVE" -C src
  sudo cp "src/${RG_ARCHIVE%.*.*}/rg" bin/rg
  popd
  echo "Installed at $(which rg)."
fi

# Install plugin managers for Vim and tmux.
info "Setting up the Vim and tmux environment..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
git-pull https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Vim and tmux plugins.
info "Installing plugins for Vim and tmux..."
vim --noplugin -c PlugInstall -c qa
stty -F /dev/stdout sane
TMUX_PLUGIN_MANAGER_PATH=~/.tmux/plugins/ \
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh

