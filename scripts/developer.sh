# Rosetta for Intel/M1 chip compatibility
# https://blog.logrocket.com/set-up-macbook-for-web-development-in-20-minutes/
# /usr/sbin/softwareupdate --install-rosetta --agree-to-license

# XCode support
xcode-select --install

# Dev tools
brew install git
# brew install vim
brew install nvim
brew install tmux
brew install z
brew install the_silver_searcher

# Node
brew install nvm

# TODO: Echo the following into `.zshrc`
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Node
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v1.38.0/install.sh | bash
nvm install node

# Enable `yarn` via node corepack
corepack enable
# npm install yarn

# Ruby stuff
# https://github.com/rbenv/rbenv
# brew install rbenv
# brew install ruby-build
# rbenv init

# TODO: Add this to .zshrc
# eval "$(rbenv init - zsh)"

# rbenv install 3.1.2
# rbenv global 3.1.2
#
# => The terminal might need to be reloaded first
#
# gem install bundler
# gem install jekyll

# Alternative option:
# brew install chruby
# brew install ruby-install
# brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
