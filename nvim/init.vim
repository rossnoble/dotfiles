" Add vim configs to runtime
set runtimepath^=~/.vim runtimepath+=~/.vim/after
" set runtimepath^=~/.vim
let &packpath = &runtimepath
source ~/.vimrc
