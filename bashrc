if [ -f ~/.remote_locations ]; then
  source ~/.remote_locations
fi

if [ -f ~/.coomo_commands ]; then
  source ~/.coomo_commands
  alias ecoomo="vim ~/.coomo_commands"
fi

# Enables color highlighting
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagacad

# MySQL socket location
export MYSQL_SOCKET='/tmp/mysql.sock'

# Postgres
export PGHOST=localhost

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Add Go to PATH and set GOPATH
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Code/Go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Enables color for iTerm
export TERM=xterm-color

# Set the default editor to vim
export EDITOR=vim

# Show user@server path (git branch)
#export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]$(__git_ps1 " (%s)")$ '
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\W\[\033[00m\]$(__git_ps1 " (%s)")$ '

# Chruby scripts and config
# http://zaiste.net/2013/04/towards_simplicity_from_rbenv_to_chruby/
source '/usr/local/share/chruby/chruby.sh'
source '/usr/local/share/chruby/auto.sh'
source '/usr/local/share/gem_home/gem_home.sh'

# Sets up the prompt color (currently a green similar to linux terminal)
source "/usr/local/etc/bash_completion.d/git-completion.bash"
source "/usr/local/etc/bash_completion.d/git-prompt.sh"
source "/usr/local/etc/bash_completion.d/password-store"

# Default ruby version
chruby ruby-2.3.1

# z
. `brew --prefix`/etc/profile.d/z.sh

## Aliases
alias pgstart="postgres -D /usr/local/var/postgres"
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ebash='vim ~/.bashrc'
alias sobash='source ~/.bashrc'
alias vimrc='vim ~/.vimrc'
alias gitconfig='vim ~/.gitconfig'
alias tconfig='vim ~/.tmux.conf'
alias hosts='sudo vim /etc/hosts'

alias tmux="tmux -2"
alias tat='tmux new-session -As "$(basename "$PWD" | tr . -)"'
alias tlist="tmux list-sessions"
alias routes='rake routes > routes.txt && mate routes.txt'

alias show_hidden='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide_hidden='defaults write com.apple.finder AppleShowAllFiles NO'

alias mampsql='/Applications/MAMP/Library/bin/mysql -uroot -proot'
alias genpass='openssl rand -base64 15'

# Functions

# Kill a tmux session by name
function tkill() {
  tmux kill-session -t ${1}
  echo "Killed session ${1}"
}

function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "${port}"
}

_bundle_commands=( rake spec rspec cucumber cap watchr rails rackup )

function run_bundler_cmd() {
  if [ -e ./Gemfile ]; then
    echo "bundle exec $@"
    bundle exec $@
  else
    echo "$@"
    $@
  fi
}

for cmd in $_bundle_commands
do
  alias $cmd="run_bundler_cmd $cmd"
done

function rtest () {
  ruby -I"lib:test" $@
}

function restart_ssh_agent() {
  eval `ssh-agent -s`
  ssh-add
}

# gpg-agent
GPG_TTY=$(tty)
export GPG_TTY
