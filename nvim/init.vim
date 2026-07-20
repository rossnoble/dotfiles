" ===============================================
" NEOVIM CONFIGURATION
"
" NeoVim config with COC bindings and plugins.
" ===============================================

" ===============================================
" PERFORMANCE PROFILING
"
" Uncomment these lines to profile startup time:
" 1. Uncomment the lines below
" 2. Restart NeoVim
" 3. Run :q to exit
" 4. View the profile.log file in your config directory
" 5. Look for slow functions and plugins
"
" To profile specific operations:
" :profile start profile.log
" :profile func *
" :profile file *
" ... do operations ...
" :profile stop
" ===============================================
" profile start ~/.config/nvim/profile.log
" profile func *
" profile file *

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

" PERFORMANCE: Disabled expensive syntax rescanning
" This causes 500ms-2s lag on every buffer switch in large files
" Tree-sitter (configured below) handles syntax highlighting more efficiently
" If syntax breaks, manually run: :syntax sync fromstart
" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
" autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
" autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

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

" Split border color
highlight WinSeparator guifg=#444444 guibg=NONE

" ===============================================
" SETTINGS
"
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
" DISABLED: This was loading all buffers including hidden ones, causing 100+ buffer issues
" map <C-Y><C-Y> :bufdo e<CR>

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

" -----------------------------
" NERDTree
"
" https://github.com/preservim/nerdtree
" -----------------------------
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

" ------------------------------------------------
" Vim Projectionist
"
" https://github.com/tpope/vim-projectionist
" ------------------------------------------------

let g:projectionist_no_mappings = 1
" Jump to alternate file
nnoremap <leader>a :A<CR>

" ------------------------------------------------
" Vim Test
"
" https://github.com/vim-test/vim-test
" ------------------------------------------------
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>


" ------------------------------------------------
" COC
"
" https://github.com/neoclide/coc.nvim
" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
" ------------------------------------------------

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
" Also important for Coc performance
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to
" noticeable delays and poor user experience.
" PERFORMANCE: Reduced from 100ms to 300ms for better performance in large files
" 100ms was too aggressive and caused lag with diagnostics in monorepos
set updatetime=300

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

" ================================================
" PLUGIN CONFIGURATIONS
"
" Managed by vim-plug: https://github.com/junegunn/vim-plug
" ================================================

call plug#begin('~/.vim/plugged')

" PERFORMANCE: Lazy loading configuration for faster startup times
" Plugins marked with 'on' or 'for' only load when needed

" NERDTree sidebar - load on command only
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }  " https://github.com/preservim/nerdtree

" Status line tools - always needed
Plug 'vim-airline/vim-airline'                       " https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes'                " https://github.com/vim-airline/vim-airline-themes

" Language server - always needed for LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}      " https://github.com/neoclide/coc.nvim

" File search and navigation - always needed
Plug 'jremmen/vim-ripgrep'                           " https://github.com/jremmen/vim-ripgrep
Plug 'tpope/vim-projectionist'                       " https://github.com/tpope/vim-projectionist
Plug 'qpkorr/vim-bufkill'                            " https://github.com/qpkorr/vim-bufkill

" Telescope fuzzy search and dependencies - always needed
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Tree-sitter for fast incremental syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Testing - load on command
Plug 'vim-test/vim-test'                             " https://github.com/vim-test/vim-test

" Git tools
Plug 'tpope/vim-fugitive', { 'on': ['Git', 'Gstatus', 'Gblame', 'Glog', 'Gdiffsplit'] }  " https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter', {'branch': 'main'}    " https://github.com/airblade/vim-gitgutter (needed for sign column)

" Language support - lazy load by filetype for faster startup
Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescriptreact'] }     " https://github.com/leafgarland/typescript-vim
Plug 'peitalin/vim-jsx-typescript', { 'for': ['typescript', 'typescriptreact'] }    " https://github.com/peitalin/vim-jsx-typescript
Plug 'Quramy/vim-js-pretty-template', { 'for': ['typescript', 'javascript'] }       " https://github.com/Quramy/vim-js-pretty-template
Plug 'jparise/vim-graphql', { 'for': 'graphql' }                                    " https://github.com/jparise/vim-graphql
Plug 'prisma/vim-prisma', { 'for': 'prisma' }                                       " https://github.com/prisma/vim-prisma
Plug 'tpope/vim-liquid', { 'for': 'liquid' }                                        " https://github.com/tpope/vim-liquid
Plug 'jvirtanen/vim-hcl', { 'for': 'hcl', 'branch': 'main' }                        " https://github.com/jvirtanen/vim-hcl
Plug 'preservim/vim-markdown', { 'for': 'markdown' }                                " https://github.com/preservim/vim-markdown
Plug 'kevinoid/vim-jsonc'                                                           " https://github.com/kevinoid/vim-jsonc (needed for json comments)
Plug 'NoahTheDuke/vim-just', { 'for': 'just' }

" Theme support
Plug 'cormacrelf/vim-colors-github'                  " https://github.com/cormacrelf/vim-colors-github
Plug 'ap/vim-css-color'                              " https://github.com/ap/vim-css-color

call plug#end()

" ------------------------------------------------
" TELESCOPE CONFIGURATION
"
" https://github.com/nvim-telescope/telescope.nvim
"
" This needs to be placed AFTER plug#begin
" ------------------------------------------------

lua << EOF
local ok, telescope = pcall(require, 'telescope')
if ok then
  telescope.setup{
    defaults = {
      path_display = { "truncate" },
      file_ignore_patterns = {
        "node_modules", "%.git/", "%.yarn/", "dist", "build",
        "coverage", "vendor", "%.DS_Store", "target",
        "tmp", "artifacts", "ios/Pods", "_site"
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }
    }
  }
  pcall(telescope.load_extension, 'fzf')
end
EOF

" ------------------------------------------------
" TREE-SITTER CONFIGURATION
"
" Fast incremental syntax highlighting
" Replaces expensive :syntax sync fromstart
" https://github.com/nvim-treesitter/nvim-treesitter
" ------------------------------------------------

lua << EOF
local ok_ts, treesitter = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
  treesitter.setup {
    -- Install parsers for these languages
    ensure_installed = {
      "typescript", "tsx", "javascript", "json", "jsonc",
      "html", "css", "graphql", "markdown", "markdown_inline",
      "lua", "vim", "vimdoc", "bash", "yaml"
    },
    
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    
    highlight = {
      enable = true,
      -- Disable vim's regex highlighting for better performance
      additional_vim_regex_highlighting = false,
    },
    
    -- Incremental selection based on treesitter
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    
    -- Indentation based on treesitter (can conflict with some filetypes)
    indent = {
      enable = false,
    },
  }
end
EOF

" Telescope keybindings (replaces CtrlP)
nnoremap <C-P> <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" ================================================
" PERFORMANCE MONITORING COMMANDS
" ================================================

" Check plugin load times
command! PlugProfile :profile start /tmp/profile.log | profile func * | profile file * | PlugStatus

" Display CoC performance info
command! CocPerf :CocCommand workspace.showOutput

" Show startup time breakdown
command! StartupTime :echo 'Use :StartupTime from command line: nvim --startuptime startup.log'

" Manually trigger syntax resync (only if tree-sitter breaks)
command! SyntaxResync :syntax sync fromstart

" Check tree-sitter status
command! TSStatus :TSModuleInfo

" Show current buffer size (to check if exceeding maxFileSize)
command! BufferSize :echo 'Lines: ' . line('$') . ' | Size: ' . (line2byte(line('$')+1)/1024) . 'KB'
