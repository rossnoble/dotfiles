" VIMRC CONFIGURATION
" ===================
"
" 1. PACKAGES
" -----------
"
" Vim Plug
" https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'Quramy/vim-js-pretty-template'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'preservim/nerdtree'
Plug 'cormacrelf/vim-colors-github'
Plug 'ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'mileszs/ack.vim'

" Experimental
Plug 'kana/vim-textobj-user'
Plug 'fvictorio/vim-textobj-backticks'

call plug#end()

" GENERAL
" -------

" Use the_silver_searchr with Ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Store plugins and colorschemes in .vim
set runtimepath^=~/.vim/bundle/ctrlp.vim
runtime bundle/vim-pathogen/autoload/pathogen.vim

" TODO: Migrate all plugin to Plug
call pathogen#infect()

syntax on

filetype on
filetype plugin off
filetype indent off
filetype plugin indent on

" Show full file name
set statusline=%F
set title

" THEMING
" ----------

colorscheme grb256

if has("gui_macvim")
  colorscheme Black
endif

set guifont=Office\ Code\ Pro\ D:h12

" Indent guides
highlight IndentGuidesOdd  ctermbg=black
highlight IndentGuidesEven ctermbg=black

" Disable background color from theme
highlight Normal ctermbg=none

" 80 character highlighting
highlight ColorColumn ctermbg=darkred
call matchadd('ColorColumn', '\%81v', 100)

" Enable syntax highlighting for non standard file types
au BufNewFile,BufRead *.less set filetype=css
au BufNewFile,BufRead *.jst  set filetype=html
au BufNewFile,BufRead *.ejs  set filetype=html
au BufNewFile,BufRead *.jade set filetype=html
au BufNewFile,BufRead *.hbs  set filetype=html
au BufNewFile,BufRead Guardfile set filetype=ruby
au BufNewFile,BufRead *.tsx set filetype=typescript
au BufNewFile,BufRead *.ts set filetype=typescript
" set filetypes as typescript.tsx
au BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

au ColorScheme * highlight NonText ctermbg=None
au ColorScheme * highlight Normal ctermbg=None


" SETTINGS
" -----------

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
set laststatus=2    " Always show status line
set backspace=indent,eol,start "Allow backspace to overwrite"
set noshowmode      " Hide status bar
set encoding=utf-8
" set fileencoding=utf-8

" Disabled rules
" set ruler           " Always show info at bottom of screen
" set hls             " Search highlighting
" set cindent         " Indent curly braces
" set wildmenu
" set nowrap          " Don't wrap text
" set list            " Show hidden characters
" set smartindent     " Intelligent indentation

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

" Indentation
autocmd FileType * set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType make set noexpandtab
autocmd FileType php set expandtab
autocmd FileType less set noexpandtab
autocmd FileType jade set noexpandtab
autocmd FileType c set noexpandtab
" Typescript syntax highlighting
autocmd FileType typescript JsPreTmpl
autocmd FileType typescript syn clear foldBraces

" Spell check commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

" 4. KEYBOARD MAPPINGS
" --------------------

map <C-B><C-B> :NERDTreeToggle<CR>

" Reload all buffers
map <C-Y><C-Y> :bufdo e<CR>

" Disable line joining command because I do it accidentally
" all the time and never really use it intentionally
map <S-j> <Nop>

nmap <C-N><C-N> :set invnumber<CR>
nmap <C-e> :e#<CR>
nmap <C-L><C-L> :set list!<CR>

cmap <C-b> <left>
cmap <C-f> <right>


" PLUGIN CONFIGURATIONS
" ------------------------

" Ctrl-P
let g:ctrlp_custom_ignore = {
  \ 'dir':  'git\|hg\|node_modules\|coverage\|vendor\|dist\|tmp\|cookbooks\|build\|flow\|_site',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store$']
let g:NERDTreeWinSize=25

" Syntastic
let g:statline_syntastic = 0

" Prettier
let g:prettier#config#print_width = 80

" Use the_silver_searcher with ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" ALE settings
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
