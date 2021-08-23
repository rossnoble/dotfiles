# Install home brew (see brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# XCode tools (TODO: check if needed)
# xcode-select --install

# Dev tools
brew install git
brew install tmux
brew install z
brew install the_silver_searcher

# Other stuff
brew install --cask macdown

# Create symlinks for dotfiles
ln -s ~/Code/dotfiles/zshrc ~/.zshrc
ln -s ~/Code/dotfiles/vimrc ~/.vimrc
ln -s ~/Code/dotfiles/agignore ~/.agignore
ln -s ~/Code/dotfiles/gitconfig ~/.gitconfig
ln -s ~/Code/dotfiles/gitignore_global ~/.gitignore_global
ln -s ~/Code/dotfiles/tmux.conf ~/.tmux.conf

# # Ruby stuff
# brew install chruby
# brew install ruby-install
# brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb

# Node stuff
# TODO: Consider using Volta (https://volta.sh)

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# Install latest node
nvm install node
# Install NPM for package management
brew install npm
# Install yarn for package management
npm install -g yarn
