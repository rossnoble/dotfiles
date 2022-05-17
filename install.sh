# Install home brew (see brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Rosetta for Intel/M1 chip compatibility
# https://blog.logrocket.com/set-up-macbook-for-web-development-in-20-minutes/
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

# XCode support
xcode-select --install

# Create symlinks for dotfiles
ln -s ~/Code/dotfiles/zshrc ~/.zshrc
ln -s ~/Code/dotfiles/vimrc ~/.vimrc
ln -s ~/Code/dotfiles/agignore ~/.agignore
ln -s ~/Code/dotfiles/gitconfig ~/.gitconfig
ln -s ~/Code/dotfiles/gitignore_global ~/.gitignore_global
ln -s ~/Code/dotfiles/tmux.conf ~/.tmux.conf

# Dev tools
brew install git
brew install vim
brew install tmux
brew install z
brew install the_silver_searcher

# RUBY stuff
brew install rbenv
rbenv init

# NODE stuff
# Install nvm, the latest node (with npm) and yarn
# TODO: Consider using Volta (https://volta.sh)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v1.38.0/install.sh | bash
nvm install node
npm install yarn

# APPLICATIONS
# Uncomment to install

# brew install --cask 1password
# brew install --cask iterm2
# brew install --cask alfred
# brew install --cask macdown
# brew install --cask brave
# brew install --cask kaleidoscope
# brew install --cask imageoptim
# brew install --cask flux
# brew install --cask karabiner-elements
# brew install --cask nordvpn
# brew install --cask krisp
# brew install --cask expressvpn
# brew install --cask spotify
# brew install --cask figma
# brew install --cask slack
# brew install --cask react-native-debugger
# brew install --cask the-clock
# brew install --cask notion
# brew install --cask vlc
# brew install --cask zoom
# brew install --cask sync
# brew install --cask dropbox
# brew install --cask soulver
# brew install --cask visual-studio-code
# brew install --cask textmate
# brew install --cask certbot

# Ruby stuff
# TODO: Update and use rbenv instead

# brew install chruby
# brew install ruby-install
# brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
