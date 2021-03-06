#!/bin/sh
# Deal with MacOS nonsense
sudo xcode-select --install

# Rename remote repo to use ssh
git remote set-url origin git@github.com:vctrshn/dotfiles.git

# Set up directories
mkdir "$HOME/.config"
mkdir "$HOME/.config/fonts"
mkdir "$HOME/.config/nvim"

# Link in config files
ln -s "$PWD/.bash_profile" "$HOME/.bash_profile"
ln -s "$PWD/.bashrc" "$HOME/.bashrc"
ln -s "$PWD/.gitignore_global" "$HOME/.gitignore_global"
ln -s "$PWD/.vimrc" "$HOME/.vimrc"
ln -s "$PWD/nvim/init.vim" "$HOME/.config/nvim/init.vim"
ln -s "$PWD/.zshrc" "$HOME/.zshrc"
ln -s "$PWD/.zlogin" "$HOME/.zlogin"
ln -s "$PWD/.zlogout" "$HOME/.zlogout"
ln -s "$PWD/.zpreztorc" "$HOME/.zpreztorc"
ln -s "$PWD/.zprofile" "$HOME/.zprofile"
ln -s "$PWD/.zshenv" "$HOME/.zshenv"
ln -s "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -s "$PWD/.agignore" "$HOME/.agignore"

# Switch to zsh and use prezto
# https://github.com/sorin-ionescu/prezto
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
chsh -s /bin/zsh
ln -s "$PWD/themes/prompt_superlinh_setup" "${ZDOTDIR:-$HOME}/.zprezto/modules/prompt/functions/prompt_superlinh_setup"

# Make sure node is correct, and install nvm
# https://github.com/creationix/nvm#install-script
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
) && . "$NVM_DIR/nvm.sh"

source $HOME/.zshrc
nvm install stable
nvm use stable

#---------------------------------HOMEBREW------------------------------------
# Install Homebrew, and homebrew things
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
sudo chown -R $(whoami) /usr/local/Cellar

brew install git
git config --global core.excludesfile "$HOME/.gitignore_global"

brew install tmux ctags python3 tree tig ranger icdiff diff-so-fancy watchman highlight reattach-to-user-namespace bat fd

brew install fzf
/usr/local/opt/fzf/install

# 6) rg
# https://github.com/BurntSushi/ripgrep
brew tap burntsushi/ripgrep https://github.com/BurntSushi/ripgrep.git
brew install burntsushi/ripgrep/ripgrep-bin

# 8) neovim
# https://github.com/neovim/homebrew-neovim/blob/master/README.md
# https://github.com/neovim/homebrew-neovim/issues/149
brew install neovim --env=std
sudo pip3 install --upgrade neovim

# 9) vim
brew install vim --with-python3

#---------------------------------BREW CASK------------------------------------
brew cask install google-chrome firefox atom iterm2 alfred sublime-text slack amethyst karabiner clipy

#-----------------------------------NPM---------------------------------------
npm install -g eslint prettier flow-bin flow-vim-quickfix tldr

#-----------------------------------TMUX---------------------------------------
# 1) Get tpm
# https://github.com/tmux-plugins/tpm
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

#----------------------------------Atom---------------------------------------
# 1) Link in config files
ln -s "$PWD/atom/config.cson" "$HOME/.atom/config.cson"
ln -s "$PWD/atom/keymap.cson" "$HOME/.atom/keymap.cson"

# 2) Install all Atom packages
apm install --packages-file ./atom/package-list.txt

#-------------------------------VIM/NEOVIM------------------------------------
# 9) Get vim-plug
# https://github.com/junegunn/vim-plug
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugUpgrade +PlugInstall +PlugUpdate

#-------------------------------Fix fonts--------------------------------------
git clone https://github.com/powerline/fonts "$HOME/.config/fonts"
"$HOME/.config/fonts/install.sh"
