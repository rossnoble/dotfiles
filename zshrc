# CORE ZSH CONFIGS
# -----------------

export DOTFILES_DIR=~/Code/dotfiles

# Simple git branch prompt display
# Source: https://danishpraka.sh/2018/07/06/git-branch-zsh.html
function git_branch() {
  branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ $branch == "" ]]; then
    :
  else
    echo "($branch)"
  fi
}

# Allow command substitution inside the prompt
setopt prompt_subst

PROMPT='%B%F{78}%1~%f:%F{39}$(git_branch)%F{169}$%b %f'

# Color highlighting for terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagacad

# Set the default editor to vim
export EDITOR=vim

# Add homebrew to path. Will not work on M1 which requires /usr/local instead.
# https://nhancv.medium.com/macbook-pro-m1-homebrew-install-error-7170e4816894
# export PATH="/opt/homebrew/bin:$PATH"

# Local binaries
export PATH="/usr/local/sbin:$PATH"

# z browzing utility
local Z_PATH=/opt/homebrew/etc/profile.d/z.sh
[ -r $Z_PATH ] && source $Z_PATH

# Git tab completion
autoload -Uz compinit && compinit

# Init rbenv
eval "$(rbenv init -)"

# UTILITY ALIASES
# -----------------

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ls='ls -lAh'
# alias find='gfind'

# Shortcuts to dotfiles
alias dotfiles="cd ${DOTFILES_DIR}"
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias zshrc_local='vim ~/.zshrc_local'
alias sozshrc='source ~/.zshrc'
alias sozshrc_local='source ~/.zshrc_local'
alias pryrc='vim ~/.pryrc'
alias agignore='vim ~/.agignore'
alias gitconfig='vim ~/.gitconfig'
alias tmuxconf='vim ~/.tmux.conf'
alias cocsettings="vim ${DOTFILES_DIR}/vim/coc-settings.json"
alias hosts='sudo vim /etc/hosts'

# MacOS
alias show_hidden='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide_hidden='defaults write com.apple.finder AppleShowAllFiles NO'
alias enable_sleep='sudo pmset disablesleep 0'
alias disable_sleep='sudo pmset disablesleep 1'

# Silver searcher
alias ag='ag --path-to-ignore ~/.agignore'

# Postgres
alias pgstart="brew services start postgresql"
alias pgstop="brew services stop postgresql"
alias pgrestart="brew services restart postgresql"

# Tmux
alias tmux="tmux -2"
alias tat='tmux new-session -As "$(basename "$PWD" | tr . -)"'
alias tlist="tmux list-sessions"

# Destroy a tmux session by name
function tkill() {
  tmux kill-session -t ${1}
  echo "Killed session ${1}"
}

# Python static files server on the given port
function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "${port}"
}

# LOCAL ZSH CONFIGS
# -----------------

# Uncomment any as needed. Add custom configurations to .zshrc_local
# that are unlikely to be shared between machines (see below) or contain
# private/sensitive data.

# Local zshrc configurations
export ZSHRC_LOCAL_PATH=~/.zshrc_local
[ -r $ZSHRC_LOCAL_PATH ] && source $ZSHRC_LOCAL_PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# MySQL socket location
# export MYSQL_SOCKET='/tmp/mysql.sock'

# Postgres (uncomment if using)
# export PGHOST=localhost
# export PATH="/usr/local/opt/postgresql@10/bin:$PATH"

# Heroku Toolbelt
# export PATH="/usr/local/heroku/bin:$PATH"

# Volta for node
# export VOLTA_HOME="$HOME/.volta"
# export PATH="$VOLTA_HOME/bin:$PATH"

# GCloud SDK
# export CLOUDSDK_PYTHON="$(brew --prefix)/opt/python@3.8/libexec/bin/python"
# source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
# source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
#
# The next line updates PATH for the Google Cloud SDK.
# if [ -f /Users/ross/google-cloud-sdk/path.bash.inc ]; then
#   source '/Users/ross/google-cloud-sdk/path.bash.inc'
# fi

# The next line enables shell command completion for gcloud.
# if [ -f /Users/ross/google-cloud-sdk/completion.bash.inc ]; then
#   source '/Users/ross/google-cloud-sdk/completion.bash.inc'
# fi
