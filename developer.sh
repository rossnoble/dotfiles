# Rosetta for Intel/M1 chip compatibility
# https://blog.logrocket.com/set-up-macbook-for-web-development-in-20-minutes/
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

# XCode support
xcode-select --install

# Dev tools
brew install git
brew install vim
brew install tmux
brew install z
brew install the_silver_searcher

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v1.38.0/install.sh | bash
nvm install node
npm install yarn

# Ruby stuff
brew install rbenv
rbenv init

# Alternative option:
# brew install chruby
# brew install ruby-install
# brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
