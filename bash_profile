source ~/.bashrc
if [ -f ~/.remote_locations ]; then
  source ~/.remote_locations
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

# Enables color for iTerm
export TERM=xterm-color

# Set the default editor to vim
export EDITOR=vim

# Show user@server path (git branch)
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]$(__git_ps1 " (%s)")$ '

# z
. `brew --prefix`/etc/profile.d/z.sh

# Sets up the prompt color (currently a green similar to linux terminal)
source "/usr/local/etc/bash_completion.d/git-completion.bash"
source "/usr/local/etc/bash_completion.d/git-prompt.sh"
source "/usr/local/etc/bash_completion.d/password-store"

# Chruby scripts and config
# http://zaiste.net/2013/04/towards_simplicity_from_rbenv_to_chruby/
source '/usr/local/share/chruby/chruby.sh'
source '/usr/local/share/chruby/auto.sh'
source '/usr/local/share/gem_home/gem_home.sh'

# Default ruby version
#chruby ruby-2.1.7

alias pgstart="postgres -D /usr/local/var/postgres"
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Config file shortcuts
alias ebash='vim ~/.bash_profile'
alias sobash='source ~/.bash_profile'
alias vimrc='vim ~/.vimrc'
alias gitconfig='vim ~/.gitconfig'
alias tmuxconfig='vim ~/.tmux.conf'

# Tmux
alias tmux="tmux -2"
alias tat='tmux new-session -As "$(basename "$PWD" | tr . -)"'
alias tlist="tmux list-sessions"

function tkill() {
  tmux kill-session -t ${1}
  echo "Killed session ${1}"
}

# Development
alias ztest='zeus test'
alias routes='rake routes > routes.txt && mate routes.txt'
alias zroutes='zeus rake routes > routes.txt && mate routes.txt'
alias sasspbox='bundle exec sass --watch --scss --compass app/stylesheets:public/stylesheets'

function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "${port}"
}

bundle_commands=( rake spec rspec cucumber cap watchr rails rackup )

function run_bundler_cmd() {
  if [ -e ./Gemfile ]; then
    echo "bundle exec $@"
    bundle exec $@
  else
    echo "$@"
    $@
  fi
}

function rtest () {
  ruby -I"lib:test" $@
}

for cmd in $bundle_commands
do
  alias $cmd="run_bundler_cmd $cmd"
done

function restart_ssh_agent() {
  eval `ssh-agent -s`
  ssh-add
}

alias hosts='sudo vim /etc/hosts'
alias iossim='open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'
alias mampsql='/Applications/MAMP/Library/bin/mysql -uroot -proot'

# gpg-agent
GPG_TTY=$(tty)
export GPG_TTY
