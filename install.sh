# Install home brew (see brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Rosetta for Intel/M1 chip compatibility
# https://blog.logrocket.com/set-up-macbook-for-web-development-in-20-minutes/
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

# XCode support
xcode-select --install

# Dev tools
brew install git
brew install tmux
brew install z
brew install the_silver_searcher

# Create symlinks for dotfiles
ln -s ~/Code/dotfiles/zshrc ~/.zshrc
ln -s ~/Code/dotfiles/vimrc ~/.vimrc
ln -s ~/Code/dotfiles/agignore ~/.agignore
ln -s ~/Code/dotfiles/gitconfig ~/.gitconfig
ln -s ~/Code/dotfiles/gitignore_global ~/.gitignore_global
ln -s ~/Code/dotfiles/tmux.conf ~/.tmux.conf

# Node stuff
# TODO: Consider using Volta (https://volta.sh)

# NVM for node version management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v1.38.0/install.sh | bash
# Latest node (with NPM)
nvm install node
# Yarn for package management
npm install yarn

# Dev applications
brew install --cask 1password
brew install --cask iterm2
brew install --cask alfred
brew install --cask macdown
brew install --cask brave
brew install --cask visual-studio-code
brew install --cask tower
brew install --cask kaleidoscope
brew install --cask karabiner-elements

# Other applications
# brew install --cask spotify
# brew install --cask notion
# brew install --cask vlc
# brew install --cask zoom
# brew install --cask slack
# brew install --cask dropbox

# Ruby stuff
# TODO: Update and use rbenv instead
# brew install chruby
# brew install ruby-install
# brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
