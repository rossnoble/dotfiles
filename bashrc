####################################
## DEPRECATED. USE ZSHRC INSTEAD. ##
####################################

if [ -f ~/.bash_private ]; then
  source ~/.bash_private
fi

# Hide warning about zsh being the new default
export BASH_SILENCE_DEPRECATION_WARNING=1

# Enables color highlighting
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagacad

# MySQL socket location
export MYSQL_SOCKET='/tmp/mysql.sock'

# Postgres
export PGHOST=localhost
export PATH="/usr/local/opt/postgresql@10/bin:$PATH"

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Yarn binaries
# export PATH="/usr/local/Cellar/node@6/6.10.3/bin:$PATH"

# Link to PHP via Homebrew
export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"

# PHP Composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Add Go to PATH and set GOPATH
export GOPATH=$HOME/Code/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Local binaries
export PATH="$HOME/bin:$PATH"

# Homebrew sbins
export PATH="/usr/local/sbin:$PATH"

# OpenSSL support
export PATH="/usr/local/opt/openssl@1.0/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.0/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.0/include"

# Enables color for iTerm
# export TERM=xterm-color

# Set the default editor to vim
export EDITOR=vim

# Chruby scripts and config
# http://zaiste.net/2013/04/towards_simplicity_from_rbenv_to_chruby/
# NOTE: chruby is also sourced in /etc/bashrc
if [ -f /usr/local/share/chruby/chruby.sh ]; then
  source /usr/local/share/chruby/chruby.sh
fi

# Enable auto-switching of Rubies specified by .ruby-version files
if [ -f /usr/local/opt/chruby/share/chruby/auto.sh ]; then
  source /usr/local/opt/chruby/share/chruby/auto.sh
fi

# gem_home for gemset management
# https://github.com/postmodern/gem_home
if [ -f /usr/local/share/gem_home/gem_home.sh ]; then
  source /usr/local/share/gem_home/gem_home.sh
fi

# if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
#   source /usr/local/etc/bash_completion.d/git-completion.bash
# fi

# Custom modifications to git completion to ignore tags
if [ -f ~/.dotfiles/git-completion.bash ]; then
  source ~/.dotfiles/git-completion.bash
fi

# Sets up the prompt color (currently a green similar to linux terminal)
if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
  source /usr/local/etc/bash_completion.d/git-prompt.sh

  # Show user@server path (git branch)
  export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\W\[\033[00m\]$(__git_ps1 " (%s)")$ '
fi

# pass password manager
# https://www.passwordstore.org/
if [ -f /usr/local/etc/bash_completion.d/pass ]; then
  source /usr/local/etc/bash_completion.d/pass
fi

# Default ruby version
# chruby 'ruby-2.3.1'

# z
if [ -f /usr/local/etc/profile.d/z.sh ]; then
  source /usr/local/etc/profile.d/z.sh
fi

## Aliases
alias ag='ag --path-to-ignore ~/.agignore'

alias pgstart="brew services start postgresql"
alias pgstop="brew services stop postgresql"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ls='ls -lAh'
alias find='gfind'
alias dotfiles='cd ~/.dotfiles'
alias bashrc='vim ~/.bashrc'
alias sobashrc='source ~/.bashrc'
alias bash_private='vim ~/.bash_private'
alias vimrc='vim ~/.vimrc'
alias pryrc='vim ~/.pryrc'
alias agignore='vim ~/.agignore'
alias gitconfig='vim ~/.gitconfig'
alias tconfig='vim ~/.tmux.conf'
alias hosts='sudo vim /etc/hosts'
alias gohome='cd ~/Code/Go/src/github.com/rossnoble'

# Tmux
alias tmux="tmux -2"
alias tat='tmux new-session -As "$(basename "$PWD" | tr . -)"'
alias tlist="tmux list-sessions"

# Toggle hidden files
alias show_hidden='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide_hidden='defaults write com.apple.finder AppleShowAllFiles NO'

alias routes='rake routes > routes.txt && mate routes.txt'
alias be='bundle exec'

alias mampsql='/Applications/MAMP/Library/bin/mysql -uroot -proot'
alias genpass='openssl rand -base64 15'

# Functions

# tkill destroys a tmux session by name
function tkill() {
  tmux kill-session -t ${1}
  echo "Killed session ${1}"
}

# server starts a static file server on the given port
function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "${port}"
}

# fbr performs a fuzzy match on git branches
fbr() {
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +s +m -e) &&
  git checkout $(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
}

function run_bundler_cmd() {
  if [ -e ./Gemfile ]; then
    echo "bundle exec $@"
    bundle exec $@
  else
    echo "$@"
    $@
  fi
}

bundle_commands=( rake rspec spec cucumber cap watchr rails rackup jekyll )
for cmd in $bundle_commands
do
  alias $cmd="run_bundler_cmd $cmd"
done

function rtest () {
  ruby -I"lib:test" $@
}

function restart_ssh_agent() {
  eval "$(ssh-agent -s)"
  ssh-add -K ~/.ssh/id_rsa
}

# gpg-agent
GPG_TTY=$(tty)
export GPG_TTY

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/ross/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/ross/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/ross/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/ross/google-cloud-sdk/completion.bash.inc'
fi

# Volta for node
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

export YVM_DIR=/Users/ross/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
