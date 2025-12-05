# Rosetta for Intel/M1 chip compatibility
# https://blog.logrocket.com/set-up-macbook-for-web-development-in-20-minutes/
# /usr/sbin/softwareupdate --install-rosetta --agree-to-license

# XCode support
# xcode-select --install

# Dev tools
# brew install git
# brew install nvim
# brew install tmux
# brew install z
# brew install rg
# brew install deno

# See ./node.sh for Node environment config
# See ./ruby.sh for Ruby environment config
#
# Install vim-plug for Neovim plugins
# https://github.com/junegunn/vim-plug
#
# Installs to .local/share/nvim/site/autoload/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
