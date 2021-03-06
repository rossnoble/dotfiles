# Install home brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# XCode tools
xcode-select --install

# Dev tools
brew install git
brew install tmux
brew install z
brew install the_silver_searcher

# # Ruby stuff
brew install chruby
brew install ruby-install
brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb

# Create symlinks for dotfiles
ln -s ~/.dotfiles/bashrc ~/.bashrc
ln -s ~/.dotfiles/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/agignore ~/.agignore
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/gitignore_global ~/.gitignore_global
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

# Install vim bundles via Pathogen
git clone --depth=1 https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
git clone --depth=1 https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
git clone --depth=1 https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/syntastic
git clone --depth=1 https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
git clone --depth=1 https://github.com/tpope/vim-surround.git ~/.vim/bundle/vim-surround
git clone --depth=1 https://github.com/tpope/vim-rails.git ~/.vim/bundle/vim-rails
git clone --depth=1 https://github.com/junegunn/goyo.vim ~/.vim/bundle/goyo.vim
git clone --depth=1 https://github.com/mileszs/ack.vim ~/.vim/bundle/ack.vim

# Other stuff
brew cask install macdown
brew install npm
