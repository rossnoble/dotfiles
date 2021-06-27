bindkey -e

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

# Local binaries
export PATH="$HOME/bin:$PATH"

# Homebrew sbins
export PATH="/usr/local/sbin:$PATH"

# Volta for node
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Set the default editor to vim
export EDITOR=vim

# Breathelife secrets
export CONFIG_SECRETS_PATH="$HOME/Code/bliss/.secrets/config.json"

# Prompt with git support
source ~/.dotfiles/lib/zsh-git-prompt/zshrc.sh
PROMPT='%B%m%~%b$(git_super_status) %# '

# GCloud
export CLOUDSDK_PYTHON="$(brew --prefix)/opt/python@3.8/libexec/bin/python"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# Coverage reporters for bliss
export JEST_COVERAGE_REPORTERS=html

# PubSub hostname
export PUBSUB_EMULATOR_HOST=localhost:8085

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.local-sandbox-sa-key.json"

# Git tab completion
autoload -Uz compinit && compinit

# z browzing utility
if [ -f /usr/local/etc/profile.d/z.sh ]; then
  source /usr/local/etc/profile.d/z.sh
fi

## Aliases
alias ag='ag --path-to-ignore ~/.agignore'

alias pgstart="brew services start postgresql"
alias pgstop="brew services stop postgresql"
alias pgrestart="brew services restart postgresql"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ls='ls -lAh'
# alias find='gfind'

# Shortcuts to dotfiles
alias dotfiles='cd ~/.dotfiles'
alias bashrc='vim ~/.bashrc'
alias bash_private='vim ~/.bash_private'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias pryrc='vim ~/.pryrc'
alias agignore='vim ~/.agignore'
alias gitconfig='vim ~/.gitconfig'
alias tmuxconf='vim ~/.tmux.conf'
alias cocsettings='vim ~/.dotfiles/vim/coc-settings.json'

alias sozshrc='source ~/.zshrc'
alias sobashrc='source ~/.bashrc'

alias hosts='sudo vim /etc/hosts'

# Tmux
alias tmux="tmux -2"
alias tat='tmux new-session -As "$(basename "$PWD" | tr . -)"'
alias tlist="tmux list-sessions"

# Destroy a tmux session by name
function tkill() {
  tmux kill-session -t ${1}
  echo "Killed session ${1}"
}

# Toggle hidden files
alias show_hidden='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide_hidden='defaults write com.apple.finder AppleShowAllFiles NO'

alias enable_sleep='sudo pmset disablesleep 0'
alias disable_sleep='sudo pmset disablesleep 1'

# server starts a static file server on the given port
function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "${port}"
}


# The next line updates PATH for the Google Cloud SDK.
# if [ -f /Users/ross/google-cloud-sdk/path.bash.inc ]; then
#   source '/Users/ross/google-cloud-sdk/path.bash.inc'
# fi

# The next line enables shell command completion for gcloud.
# if [ -f /Users/ross/google-cloud-sdk/completion.bash.inc ]; then
#   source '/Users/ross/google-cloud-sdk/completion.bash.inc'
# fi

export YVM_DIR=/Users/ross/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

