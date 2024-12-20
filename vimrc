" VIMRC CONFIGURATION
" ===================

" GENERAL
" -------

syntax on

filetype on
filetype plugin off
filetype indent off
filetype plugin indent on

if has("gui_macvim")
  colorscheme Black
else
  colorscheme grb256
endif

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

" highlight SignColumn guibg=NONE ctermbg=NONE
highlight clear SignColumn
highlight SignColumn ctermbg=NONE

highlight GitGutterAdd    guifg=#009900 ctermfg=2 ctermbg=NONE
highlight GitGutterChange guifg=#bbbb00 ctermfg=3 ctermbg=NONE
highlight GitGutterDelete guifg=#ff2222 ctermfg=1 ctermbg=NONE

highlight CocFloating         ctermbg=black
highlight CocHighlightText    ctermfg=231 ctermbg=60
highlight CocErrorHighlight   ctermfg=231 ctermbg=124
highlight CocWarningHighlight ctermfg=231 ctermbg=99

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
set nowritebackup   " Remove backup file while editing
set noswapfile      " No swap files
set linebreak       " Break lines
set guioptions-=L   " Remove left scroll bar
set guioptions-=r   " Remove right scroll bar
set laststatus=2    " Always show status line
set backspace=indent,eol,start "Allow backspace to overwrite"
set noshowmode      " Hide status bar
set encoding=utf-8
set statusline=%F   " Show full file name
set title           " ???
set mouse=a         " Enable mouse
if !has('nvim')
  set ttymouse=sgr    " Enable mouse (xterm will not work)
endif
" set signcolumn=yes  " Keep sign column open always
set signcolumn=number " Combine sign column with numbers
" Use new regular expression engine
set re=0 " Use new regular expression engine

" set ruler           " Always show info at bottom of screen
" set hls             " Search highlighting
" set cindent         " Indent curly braces
" set wildmenu
" set nowrap          " Don't wrap text
" set list            " Show hidden characters
" set smartindent     " Intelligent indentation
" set fileencoding=utf-8

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

" Reimport vimrc
nmap <C-R><C-V> :so $MYVIMRC<CR>

" Restart COC
nmap <C-I><C-I> :CocRestart<CR>

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

let g:ctrlp_map = '<C-P>'
let g:ctrlp_cmd = 'CtrlP'

" All file types
" let g:ctrlp_cmd = 'CtrlPMixed'

let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|tmp|build|vendor|coverage|_site|artifacts|ios\/Pods)|(\.(swp|ico|git|svn|DS_Store))$'

" Set root directory
let g:ctrlp_working_path_mode = 'r'

" Open files already open in new tab
" let g:ctrlp_switch_buffer = 'et'
"
" let g:ctrlp_working_path_mode = 'cra'

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
" ---
let g:vim_markdown_folding_disabled = 1

" Syntastic
" ---
let g:statline_syntastic = 0

" Prettier
" ---
" let g:prettier#config#print_width = 80

" Ack.vim
" -------
" nmap <C-M><C-M> :Ack # Different view handling (buggy)
nmap <C-M><C-M> :!ag

" map <leader>a :ag

" Use the_silver_searcher with ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep --path-to-ignore ~/.agignore'
endif

" COC.vim
" https://github.com/neoclide/coc.nvim
let g:coc_global_extensions = ['coc-tsserver']

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Vim Projectionist
" https://github.com/tpope/vim-projectionist

" Jump to test file
nnoremap <Leader>gt :A<CR>

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

" Convery tabs to 2 spaces
command ConvertTabsToSpaces %s/\t/  /g

" PACKAGES
" -----------
" Vim Plug
" https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

"NERDTree sidebar
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Status line tools
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Search and navigation
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-projectionist'

" JavaScript and Typescript support
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'Quramy/vim-js-pretty-template'
" Out of date, maybe
" Plug 'styled-components/vim-styled-components'
Plug 'jparise/vim-graphql'
Plug 'prisma/vim-prisma'
Plug 'tpope/vim-liquid'

" Linting and code formatting
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

Plug 'cormacrelf/vim-colors-github'
Plug 'ap/vim-css-color'

Plug 'vim-scripts/dbext.vim'
Plug 'jvirtanen/vim-hcl', { 'branch': 'main' }
" Prisma file format support
" Plug 'ruanyl/vim-sort-imports'

" Experimental
" Plug 'kana/vim-textobj-user'

" Support for comments in JSON
Plug 'kevinoid/vim-jsonc'

" Markdown support
Plug 'plasticboy/vim-markdown'

call plug#end()
