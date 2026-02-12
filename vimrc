" ===============================================
" VIMRC CONFIGURATION
"
" Vim only config without plugins. For full-featured NeoVim config, see nvim/init.vim.
" ===============================================

" ===============================================
" GENERAL
" ===============================================

syntax on

filetype on
filetype plugin off
filetype indent off
filetype plugin indent on

colorscheme slate

set guifont=Office\ Code\ Pro\ D:h12

" Indent guides
highlight IndentGuidesOdd  ctermbg=black
highlight IndentGuidesEven ctermbg=black

" Disable background color from theme
highlight Normal ctermbg=NONE

" Enable syntax highlighting for non standard file types
autocmd BufNewFile,BufRead *.less      set filetype=css
autocmd BufNewFile,BufRead *.jst       set filetype=html
autocmd BufNewFile,BufRead *.ejs       set filetype=html
autocmd BufNewFile,BufRead *.jade      set filetype=html
autocmd BufNewFile,BufRead *.hbs       set filetype=html
autocmd BufNewFile,BufRead *.ftl       set filetype=html
autocmd BufNewFile,BufRead Guardfile   set filetype=ruby
autocmd BufNewFile,BufRead *.tsx       set filetype=typescript
autocmd BufNewFile,BufRead *.ts        set filetype=typescript
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
autocmd BufRead,BufNewFile Podfile     set filetype=ruby
autocmd BufRead,BufNewFile *.json      set filetype=json

autocmd ColorScheme * highlight NonText ctermbg=NONE
autocmd ColorScheme * highlight Normal ctermbg=NONE

" ===============================================
" SETTINGS
" ===============================================

set t_Co=256                    " Enable 256-colors
set tabstop=2                   " Tab spacing
set shiftwidth=2                " Indent 2 spaces
set nocp                        " Enable features incompatible with vi
set number                      " Enable line numbers by default
set autoindent                  " Automatically indent
set expandtab                   " Spaces, not tabs
set ignorecase                  " Case insensitive search
set smartcase                   " Allow sensitive search when at least one capital
set nobackup                    " No backup files
set nowritebackup               " Remove backup file while editing
set noswapfile                  " No swap files
set linebreak                   " Break lines
set guioptions-=L               " Remove left scroll bar
set guioptions-=r               " Remove right scroll bar
set laststatus=2                " Always show status line
set backspace=indent,eol,start  " Allow backspace to overwrite
set noshowmode                  " Hide status bar
set encoding=utf-8
set statusline=%F               " Show full file name
set title
set mouse=a                     " Enable mouse
if !has('nvim')
  set ttymouse=sgr              " Enable mouse (xterm will not work)
endif

" Unicode options
if has("multi_byte")
  if &termencoding == ""
      " let &termencoding = &encoding
  endif
  set encoding=utf-8
endif

" Indentation per filetype
autocmd FileType * set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType make set noexpandtab
autocmd FileType php set expandtab
autocmd FileType less set noexpandtab
autocmd FileType jade set noexpandtab
autocmd FileType c set noexpandtab

" Spell check commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

" ================================================
" KEYBOARD MAPPINGS
" ------------------------------------------------
" map          | Normal, Visual, Select, and Operator-pending modes
" nmap         | Normal mode only
" cmap         | Command-line mode (when typing : commands)
" {c|n}map     | Recursive: if the mapped keys trigger another mapping, that mapping executes too
" nore{c|n}map | Non-recursive: only the literal keys are executed, ignoring other mappings
" ================================================

" Quickfix window
noremap <F10> :execute "copen \| resize 40"<cr>
noremap <F9>  :execute "vertical botright copen \| vertical resize 60"<cr>
noremap <F6> :execute "copen \| resize 20"<cr>
noremap <F7> :execute "cclose"<cr>

" Reload all buffers
map <C-Y><C-Y> :bufdo e<CR>

" Reimport vimrc
nmap <C-R><C-V> :so $MYVIMRC<CR>

" Disable line joining command (accidental trigger prevention)
map <S-j> <Nop>

" Toggle line numbers
nmap <C-N><C-N> :set invnumber<CR>

" Switch to alternate buffer
nmap <C-e> :e#<CR>

" Toggle invisible characters
nmap <C-L><C-L> :set list!<CR>

" Command line navigation
cmap <C-b> <left>
cmap <C-f> <right>

" Copy file name to clipboard
nnoremap <Leader>cf :let @+ = expand("%:t")<CR>

" Copy relative path to clipboard
nnoremap <Leader>cp :let @+ = expand("%")<CR>

" Quick vim split resizing
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" Convert 4 spaces to 2 spaces
command Convert4SpacesTo2 %s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g

" Convert tabs to 2 spaces
command ConvertTabsToSpaces %s/\t/  /g
