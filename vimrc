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
"set ruler           " Always show info at bottom of screen
set laststatus=2    " Always show status line
set backspace=indent,eol,start "Allow backspace to overwrite"
set noshowmode      " Hide status bar
set encoding=utf-8
set fileencoding=utf-8

"set hls             " Search highlighting
"set cindent         " Indent curly braces
"set wildmenu
"set nowrap          " Don't wrap text
"set list            " Show hidden characters
"set smartindent     " Intelligent indentation

" THEMING
" -------
colorscheme grb256

if has("gui_macvim")
  "colorscheme grb256
  colorscheme Black
endif

"set guifont=Menlo\ Regular:h12
set guifont=Office\ Code\ Pro\ D:h12

" unicode support
"if has("multi_byte")
"  if &termencoding == ""
"    let &termencoding = &encoding
"  endif
"  set encoding=utf-8           " better default than latin1
"  setglobal fileencoding=utf-8 " change default file encoding when writing new files
"endif

" Unicode options
if has("multi_byte")
  " set the display encoding
  " (default is "", or "utf-8" in the GUI)
  if &termencoding == ""
      " we're probably not using the GUI
      " note: :set won't allow &-replacement
      let &termencoding = &encoding
  endif
  " set the internal encoding
  set encoding=utf-8

  " &fileencoding (controls how characters in the internal encoding will
  " be written to the file) will be set according to &fileencodings
  " (default: "ucs-bom", "ucs-bom,utf-8,default,latin1" when 'encoding'
  " is set to a Unicode value)
endif " has("multi_byte")

" Enable syntax highlighting for non standard file types
au BufNewFile,BufRead *.less set filetype=css
au BufNewFile,BufRead *.jst  set filetype=html
au BufNewFile,BufRead *.ejs  set filetype=html
au BufNewFile,BufRead *.jade set filetype=html
au BufNewFile,BufRead *.hbs  set filetype=html
au BufNewFile,BufRead Guardfile set filetype=ruby

"autocmd ColorScheme * highlight NonText ctermbg=None
"autocmd ColorScheme * highlight Normal ctermbg=None

" INDENTATION
" -----------
autocmd FileType * set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType make set noexpandtab
autocmd FileType php set expandtab
autocmd FileType less set noexpandtab
autocmd FileType jade set noexpandtab
autocmd FileType c set noexpandtab

" Spell check commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

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
"imap jj <esc>
cmap <C-b> <left>
cmap <C-f> <right>

" CTRL-P SETTINGS
let g:ctrlp_custom_ignore = {
  \ 'dir':  'git\|hg\|node_modules\|coverage\|vendor\|tmp\|doc\|cookbooks',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }

" MISC
" ----

:let g:NERDTreeWinSize=25

"Yankring history file location
"TODO: Do we need really need yankring?
let g:yankring_history_dir = '~/tmp'

" NOTE: What's this for?
fun! MySys()
  return "mac"
endfun

"helptags ~/.vim_runtime/doc

set runtimepath=~/.vim_runtime,~/.vim_runtime/after,\$VIMRUNTIME,~/.vim,~/.vimrc,~/.vim/bundle/ctrlp.vim

" Store plugins and colorschemes in .vim
call pathogen#infect()

"Vundle config
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()

"Bundle 'gmarik/Vundle.vim'

"call vundle#end()
"filetype plugin indent on

" 80 character highlighting
highlight ColorColumn ctermbg=darkred
call matchadd('ColorColumn', '\%81v', 100)
