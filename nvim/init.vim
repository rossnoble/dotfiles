" ===============================================
" NEOVIM CONFIGURATION
"
" NeoVim config with COC bindings and plugins.
" ===============================================

" ===============================================
" GENERAL
" ===============================================

syntax on

filetype on
filetype plugin off
filetype indent off
filetype plugin indent on

colorscheme grb256

set guifont=Office\ Code\ Pro\ D:h12

" Indent guides
highlight IndentGuidesOdd  ctermbg=black
highlight IndentGuidesEven ctermbg=black

" Disable background color from theme
highlight Normal ctermbg=NONE

" 80 character highlighting
" highlight ColorColumn ctermbg=88
" call matchadd('ColorColumn', '\%81v', 80)

" Enable syntax highlighting for non standard file types
autocmd BufNewFile,BufRead *.less      set filetype=css
autocmd BufNewFile,BufRead *.jst       set filetype=html
autocmd BufNewFile,BufRead *.ejs       set filetype=html
autocmd BufNewFile,BufRead *.jade      set filetype=html
autocmd BufNewFile,BufRead *.hbs       set filetype=html
autocmd BufNewFile,BufRead *.ftl       set filetype=html
" Causing an error. Will try to re-enable
" autocmd BufNewFile,BufRead *.svg       set filetype=html
autocmd BufNewFile,BufRead Guardfile   set filetype=ruby
autocmd BufNewFile,BufRead *.tsx       set filetype=typescript
autocmd BufNewFile,BufRead *.ts        set filetype=typescript
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
autocmd BufRead,BufNewFile Podfile     set filetype=ruby

" Enable comments in json files. See 'kevinoid/vim-jsonc' plugin below
autocmd BufRead,BufNewFile *.json      set filetype=jsonc

autocmd BufWritePre *.json5 Prettier

" Open NERDTree on open
" autocmd VimEnter * NERDTree
" Focus on editor on open
" autocmd VimEnter * wincmd p

" Enable rescanning of syntax highlighting
" Comes with a performance hit, so consider disabling
" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

autocmd ColorScheme * highlight NonText ctermbg=NONE
autocmd ColorScheme * highlight Normal ctermbg=NONE

highlight SignColumn guibg=NONE ctermbg=NONE
highlight clear SignColumn
highlight SignColumn ctermbg=NONE

" Customize GitGutter sign colors
highlight GitGutterAdd    guifg=#009900 ctermfg=2 ctermbg=NONE
highlight GitGutterChange guifg=#75755D ctermfg=3 ctermbg=NONE
highlight GitGutterDelete guifg=#ff2222 ctermfg=1 ctermbg=NONE

" Customize GitGutter line highlighting colors
highlight GitGutterAddLine    guibg=#161C16 ctermfg=2
highlight GitGutterChangeLine guibg=#171713 ctermfg=3
highlight GitGutterDeleteLine guibg=#331F1F ctermfg=1

highlight CocFloating         ctermbg=black
highlight CocHighlightText    ctermfg=231 ctermbg=60
highlight CocErrorHighlight   ctermfg=231 ctermbg=124
highlight CocWarningHighlight ctermfg=231 ctermbg=99

" ===============================================
" SETTINGS
" -----------------------------------------------
" Core vim features
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
set backspace=indent,eol,start  " Allow backspace to overwrite"
set noshowmode                  " Hide status bar
set encoding=utf-8
set statusline=%F               " Show full file name
set title                       " ???
set mouse=a                     " Enable mouse
set re=0                        " Use new regular expression engine
" set signcolumn=yes            " Keep sign column open always
" set signcolumn=number         " Combine sign column with numbers

" set ruler                     " Always show info at bottom of screen
" set hls                       " Search highlighting
" set cindent                   " Indent curly braces
" set wildmenu
" set nowrap                    " Don't wrap text
" set list                      " Show hidden characters
" set smartindent               " Intelligent indentation
" set fileencoding=utf-8

" Unicode options
if has("multi_byte")
  " set the display encoding
  " (default is "", or "utf-8" in the GUI)
  if &termencoding == ""
      " we're probably not using the GUI
      " note: :set won't allow &-replacement
      " FIXME: This is generating an error on boot
      " let &termencoding = &encoding
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

" ================================================
" KEYBOARD MAPPINGS
" ------------------------------------------------
" map          | Normal, Visual, Select, and Operator-pending modes
" nmap         | Normal mode only
" cmap         | Command-line mode (when typing : commands)
" {c|n}map     | Recursive: if the mapped keys trigger another mapping, that mapping executes too
" nore{c|n}map | Non-recursive: only the literal keys are executed, ignoring other mappings
" ================================================

" Expand quick fix window via F10
noremap <F10> :execute "copen \| resize 40"<cr>
noremap <F9>  :execute "vertical botright copen \| vertical resize 60"<cr>
" Quickly open quickfix menu
noremap <F6> :execute "copen \| resize 40"<cr>
noremap <F7> :execute "cclose"<cr>

" Expand quick fix window via F10
noremap <F10> :execute "copen \| resize 40"<cr>
noremap <F9>  :execute "vertical botright copen \| vertical resize 60"<cr>

" Quickly open quickfix menu
noremap <F6> :execute "copen \| resize 20"<cr>
noremap <F7> :execute "cclose"<cr>

map <C-B><C-B> :NERDTreeToggle<CR>

" Reload all buffers
map <C-Y><C-Y> :bufdo e<CR>

" Reimport vimrc
nmap <C-R><C-V> :so $MYVIMRC<CR>

" Restart COC
nmap <C-I><C-I> :CocRestart<CR>
"
" Restart COC
" nmap <C-R><C-R> :Rg<CR>

" Disable line joining command because I do it accidentally
" all the time and never really use it intentionally
map <S-j> <Nop>

nmap <C-N><C-N> :set invnumber<CR>
nmap <C-e> :e#<CR>
nmap <C-L><C-L> :set list!<CR>

cmap <C-b> <left>
cmap <C-f> <right>

" Copy file name to clipboard
nnoremap <Leader>cf :let @+ = expand("%:t")<CR>
" Copy relative path to clipboard
nnoremap <Leader>cp :let @+ = expand("%")<CR>

" ================================================
" PLUGIN CONFIGURATIONS
" ================================================

let g:ctrlp_map = '<C-P>'
let g:ctrlp_cmd = 'CtrlP'

" All file types
" let g:ctrlp_cmd = 'CtrlPMixed'
"
" Ignore list
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|tmp|build|vendor|coverage|_site|artifacts|ios\/Pods)|(\.(swp|ico|git|svn|DS_Store))$'

" Set root directory based on current
" let g:ctrlp_working_path_mode = 'cra'
"
" Working path options
" r = Detect root of project (e.g. might search for .git)
" c = Use current file's directory instead of root
" w = Keep root detection but always start from cwd
let g:ctrlp_working_path_mode = 'w'

" Disable root detection entirely (use Vim's cwd)
" let g:ctrlp_working_path_mode = 0

" Show hidden files in list
let g:ctrlp_show_hidden = 1

" Open files already open in new tab
" let g:ctrlp_switch_buffer = 'et'

" Custom search method
" let g:ctrlp_user_command = 'find %s -type f'

" Ignore files in gitignore
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Store plugins and colorschemes in .vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeIgnore=['\.DS_Store$']
let g:NERDTreeWinSize = 40

" Vim-Markdown
let g:vim_markdown_folding_disabled = 1

" COC.vim
" https://github.com/neoclide/coc.nvim
let g:coc_global_extensions = ['coc-tsserver']

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/stylelint')
  let g:coc_global_extensions += ['coc-stylelintplus']
endif

" Vim Projectionist
" https://github.com/tpope/vim-projectionist

let g:projectionist_no_mappings = 1
" Jump to alternate file
nnoremap <leader>a :A<CR>

" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
" function! ShowDocIfNoDiagnostic(timer_id)
"   if (coc#util#has_float() == 0)
"     silent call CocActionAsync('doHover')
"   endif
" endfunction
"
" function! s:show_hover_doc()
"   call timer_start(500, 'ShowDocIfNoDiagnostic')
" endfunction
"
" autocmd CursorHoldI * :call <SID>show_hover_doc()
" autocmd CursorHold * :call <SID>show_hover_doc()

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to
" noticeable delays and poor user experience.
set updatetime=100

" Expand height of bottom nav for more space
set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

let g:airline#extensions#coc#enabled = 1

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction

" Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 OR :call CocAction('runCommand', 'tsserver.organizeImports')

" Use <CR> for confirming import
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Use <c-space> for confirming import
" inoremap <silent><expr> <c-space> coc#refresh()
"
" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" let g:import_sort_auto = 1

" Quick vim split resizing
" https://vim.fandom.com/wiki/Resize_splits_more_quickly
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" Convert 4 spaces to 2 spaces
command Convert4SpacesTo2 %s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g

" Convert tabs to 2 spaces
command ConvertTabsToSpaces %s/\t/  /g

" ================================================
" PLUGIN CONFIGURATIONS
" ------------------------------------------------
" Managed by vim-plug: https://github.com/junegunn/vim-plug
" ================================================

call plug#begin('~/.vim/plugged')

" NERDTree sidebar
Plug 'preservim/nerdtree'                            " https://github.com/preservim/nerdtree

" Status line tools
Plug 'vim-airline/vim-airline'                       " https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes'                " https://github.com/vim-airline/vim-airline-themes

" Language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}      " https://github.com/neoclide/coc.nvim

" File search and navigation
Plug 'jremmen/vim-ripgrep'                           " https://github.com/jremmen/vim-ripgrep
Plug 'ctrlpvim/ctrlp.vim'                            " https://github.com/ctrlpvim/ctrlp.vim
Plug 'tpope/vim-projectionist'                       " https://github.com/tpope/vim-projectionist
Plug 'qpkorr/vim-bufkill'                            " https://github.com/qpkorr/vim-bufkill

" Git tools
Plug 'tpope/vim-fugitive'                            " https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter', {'branch': 'main'}    " https://github.com/airblade/vim-gitgutter

" Language support
Plug 'leafgarland/typescript-vim'                    " https://github.com/leafgarland/typescript-vim
Plug 'peitalin/vim-jsx-typescript'                   " https://github.com/peitalin/vim-jsx-typescript
Plug 'Quramy/vim-js-pretty-template'                 " https://github.com/Quramy/vim-js-pretty-template
Plug 'jparise/vim-graphql'                           " https://github.com/jparise/vim-graphql
Plug 'prisma/vim-prisma'                             " https://github.com/prisma/vim-prisma
Plug 'tpope/vim-liquid'                              " https://github.com/tpope/vim-liquid
Plug 'jvirtanen/vim-hcl' , {'branch': 'main'}        " https://github.com/jvirtanen/vim-hcl
Plug 'plasticboy/vim-markdown'                       " https://github.com/plasticboy/vim-markdown
Plug 'kevinoid/vim-jsonc'                            " https://github.com/kevinoid/vim-jsonc

" Theme support
Plug 'cormacrelf/vim-colors-github'                  " https://github.com/cormacrelf/vim-colors-github
Plug 'ap/vim-css-color'                              " https://github.com/ap/vim-css-color

call plug#end()
