" VIMRC CONFIGURATION
" -------------------

syntax on
filetype on
filetype plugin off
filetype indent off

" SETTINGS
" --------
set t_Co=256        " Enable 256-colors
set tabstop=2       " Tab spacing
set shiftwidth=2    " Indent 2 spaces
set nocp            " Enable features incompatible with vi
set number          " Enable line numbers by default
set autoindent      " Automatically indent
set expandtab       " Spaces, not tabs
set ignorecase      " Case insensitive search
set smartcase       " Allow sensitive search when at least one capital
set nobackup        " No backup files
set nowritebackup   " Only in case you don't want a backup file while editing
set noswapfile      " No swap files
set linebreak       " Break lines
set guioptions-=L   " Remove left scroll bar
set guioptions-=r   " Remove right scroll bar 
set ruler           " Always show info at bottom of screen
set laststatus=2    " Always show status line
set backspace=indent,eol,start "Allow backspace to overwrite"

"set hls             " Search highlighting
"set cindent         " Indent curly braces
"set wildmenu
"set nowrap          " Don't wrap text
"set list            " Show hidden characters
"set smartindent     " Intelligent indentation

" THEMING
" -------
if has("gui_macvim")
  set fuopt=maxvert,maxhorz" full screen takes entire screen
  colorscheme jellyx
else 
  colorscheme grb256
endif

set guifont=Menlo\ Regular:h12
" Enable syntax highlighting for non standard file types 
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.jst  set filetype=html
au BufNewFile,BufRead *.jade set filetype=html
"au BufNewFile,BufRead *.html set filetype=php

"autocmd ColorScheme * highlight NonText ctermbg=None
"autocmd ColorScheme * highlight Normal ctermbg=None

" INDENTATION
" -----------
autocmd FileType * set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType make set noexpandtab
autocmd FileType php set noexpandtab
autocmd FileType less set noexpandtab
autocmd FileType jade set noexpandtab
autocmd FileType c set noexpandtab

" Indent guides
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey


" KEYBOARD MAPPINGS
" -----------------
map <C-B><C-B> :NERDTreeToggle<CR>
"Reload all buffers
map <C-Y><C-Y> :bufdo e<CR>

nmap <C-N><C-N> :set invnumber<CR>
nmap <C-e> :e#<CR>
nmap <C-L><C-L> :set list!<CR>
imap jj <esc>
cmap <C-b> <left>
cmap <C-f> <right>

" MISC
" ----

"Yankring history file location
"TODO: Do we need really need yankring?
let g:yankring_history_dir = '~/tmp'

" NOTE: What's this for?
fun! MySys()
  return "mac"
endfun

"helptags ~/.vim_runtime/doc

set runtimepath=~/.vim_runtime,~/.vim_runtime/after,\$VIMRUNTIME,~/.vim,~/.vimrc

" Store plugins and colorschemes in .vim
call pathogen#infect()

