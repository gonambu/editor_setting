call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'mechatroner/rainbow_csv'
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/jsonc.vim'
if !has('nvim')
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'glidenote/memolist.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'preservim/tagbar'
Plug 'liuchengxu/vista.vim'
Plug 'thinca/vim-quickrun'
Plug 'terryma/vim-expand-region'
Plug 'simeji/winresizer'
Plug 'dhruvasagar/vim-table-mode'
Plug 'plasticboy/vim-markdown'
Plug 'previm/previm'
Plug 'tyru/open-browser.vim'
Plug 'itchyny/calendar.vim'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'dense-analysis/ale'
Plug 'vifm/vifm.vim'
Plug 'gelguy/wilder.nvim'
Plug 'jonsmithers/vim-html-template-literals'
Plug 'zacacollier/vim-javascript-sql', { 'branch': 'add-typescript-support', 'for': ['javascript', 'typescript'] }
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'junegunn/vim-easy-align'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'jsborjesson/vim-uppercase-sql'
Plug 'ryanoasis/vim-devicons'
Plug 'kristijanhusak/defx-icons'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()
filetype plugin indent on

let g:python_host_prog = "~/.pyenv/shims/python"
autocmd StdinReadPre * let s:std_in=1
let mapleader = "\<Space>"
map <Leader> <Plug>(easymotion-prefix)

" calendar--
source ~/.cache/calendar.vim/credentials.vim
let g:calendar_google_calendar = 1
" let g:calendar_google_task = 1
" --calendar

" wilder--
call wilder#enable_cmdline_enter()

set wildcharm=<Tab>
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

" only / and ? is enabled by default
call wilder#set_option('modes', ['/', '?', ':'])
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     [
      \       wilder#check({_, x -> empty(x)}),
      \       wilder#history(),
      \     ],
      \     wilder#cmdline_pipeline(),
      \     wilder#vim_search_pipeline(),
      \   ),
      \ ])
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#substitute_pipeline(),
      \     wilder#cmdline_pipeline(),
      \     wilder#vim_search_pipeline(),
      \   ),
      \ ])
" --wilder

" template literal sql --
let g:javascript_sql_dialect = 'pgsql'
" --template literal sql

" visual-multi--
let g:VM_mouse_mappings = 1
" --visual-multi

" db接続設定 dadbod用
let g:dbs = {
\ 'benefit': 'postgres://forcia:@localhost:5432/benefit',
\ 'relo': 'postgres://forcia:@18.178.50.164:5432/relo',
\ 'relo_life': 'postgres://forcia@localhost:9999/relo_life',
\ 'test_relo': 'postgres://forcia:@testspk-front11:5432/relo',
\ 'test_relo_life': 'postgres://forcia:@testspk-bat12:5432/relo_life',
\ 'renthub_daito': 'postgres://forcia:@18.178.50.164:5432/renthub_daito',
\ 'renthub_token': 'postgres://forcia:@localhost:5432/renthub_token',
\ 'renthub_relo_partners': 'postgres://forcia:@localhost:5432/renthub_relo_partners',
\ 'renthub_lifull': 'postgres://forcia:@18.178.50.164:5432/renthub_lifull',
\ 'relo_rent': 'postgres://forcia:@18.178.50.164:5432/relo_rent',
\ 'building_mapping': 'postgres://forcia@18.178.50.164:5433/building_mapping',
\ }

let g:db_ui_table_helpers = {
\   'postgres': {
\     'Comment': 'SHOW FULL COLUMNS FROM {table}',
\     'Count': 'SELECT COUNT(*) FROM {table}'
\   }
\ }

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline#extentions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 1
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_theme = 'hybrid'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_symbols.branch = ''
nnoremap <silent> <Space><Space>f :GFiles<CR>
nnoremap <silent> <Space><Space>F :Files<CR>
nnoremap <silent> <Space><Space>b :Buffers<CR>
nnoremap <silent> <Space><Space>l :BLines<CR>
nnoremap <silent> <Space><Space>h :History<CR>
nnoremap <silent> <Space><Space>m :Mark<CR>
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>
nnoremap <silent> <Space><Space>t :TagbarToggle<CR>
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-references)
nmap <leader>df <Plug>(coc-definition)
nmap <silent> <leader>v :<C-u>call CocAction('doHover')<cr>
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
autocmd BufRead,BufNewFile *.md  set filetype=markdown
autocmd BufNewFile,BufRead *.sqltmpl  set filetype=sql
autocmd BufNewFile,BufRead *.json  set filetype=jsonc
autocmd FileType yml setlocal sw=2 sts=2 ts=2 et
autocmd FileType yaml setlocal sw=2 sts=2 ts=2 et
au BufRead,BufNewFile template.yaml set ft=cloudformation.yaml
nnoremap <leader>mp :PrevimOpen<CR>
let g:vim_markdown_folding_disabled=1
let g:previm_enable_realtime=1
nmap <Leader>b <Plug>(openbrowser-smart-search)
vmap <Leader>b <Plug>(openbrowser-smart-search)
let g:preview_markdown_vertical = 1

" コメント中の特定の単語を強調表示する
augroup HilightsForce
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('Todo', '\(TODO\|NOTE\|XXX\|HACK\|FIXME\):')
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight Todo guibg=Red guifg=White
augroup END


" ale--
let g:ale_linters = {
\'javascript': ['eslint'],
\'typescript': ['eslint'],
\'typescriptreact': ['eslint'],
\'python': ['flake8'],
\}
let g:ale_fixers = {
\'javascript': ['eslint'],
\'typescript': ['eslint'],
\'typescriptreact': ['eslint'],
\'python': ['black'],
\}
let g:ale_fix_on_save = 1
" let g:ale_python_flake8_options = "--max-line-length 100"
" --ale

" easy-align--
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" --easy-align

autocmd InsertLeave * set nopaste

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

let g:htl_css_templates = 1

" setting
"文字コードをUFT-8に設定
set encoding=utf-8
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" バックスペースの有効化
set backspace=indent,eol,start
set wildmenu

set clipboard=unnamedplus

" スクロール時に画面中央にカーソルを固定
set scrolloff=9999

" set mouse=a
" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
" set cursorline
" 現在の行を強調表示（縦）
" set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" ビープ音を可視化
set visualbell t_vb=
" 括弧入力時の対応する括弧を表示
set showmatch
set matchtime=1
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
nnoremap <silent> <Space>t :tabnew<CR>
nnoremap <silent> <Space>h :tabprevious<CR>
nnoremap <silent> <Space>l :tabnext<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
tnoremap <C-h> <C-w>h
tnoremap <C-l> <C-w>l
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <silent> <Space><Space>l <C-w>:tabnext<CR>
tnoremap <silent> <Space><Space>h <C-w>:tabprevious<CR>
noremap <S-h> ^
noremap <S-l> $
nnoremap + <C-a>
nnoremap - <C-x>
onoremap 9 i(
onoremap [ i[
onoremap { i{
nmap s <Nop>
xmap s <Nop>

" シンタックスハイライトの有効化
syntax enable
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
colorscheme hybrid

" vim-grepper --
nnoremap <leader>g :Grepper -tool git<cr>
nnoremap <leader>G :Grepper -tool rg<cr>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" Optional. The default behaviour should work for most users.
let g:grepper               = {}
let g:grepper.tools         = ['git', 'rg']
let g:grepper.jump          = 1
let g:grepper.next_tool     = '<leader>g'
let g:grepper.simple_prompt = 1
let g:grepper.quickfix      = 0
" for vim-grepper

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
set noexpandtab
" set autoindent
set smartindent


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>

" defx--
autocmd FileType defx call s:defx_my_settings()

function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
   \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('drop', 'pedit')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction

call defx#custom#option('_', {
      \ 'winwidth': 30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 1,
      \ 'buffer_name': 'exlorer',
      \ 'toggle': 1,
      \ 'resume': 1,
      \ 'columns': 'indent:icons:filename:mark',
      \ })

nnoremap <silent> <Leader>n :<C-u> Defx <CR>
" --defx

" treesitter--
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- ensure_installed = {"javascript", "typescript", "go", "bash", "python", "yaml"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
  },
}
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = false
  }
}
EOF
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" --treesitter

" coc-jest --
" Run jest for current project
command! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')
" Run jest for current file
command! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])
" Run jest for current test
nnoremap <leader>te :call CocAction('runCommand', 'jest.singleTest')<CR>
" Init jest in current cwd, require global jest command exists
command! JestInit :call CocAction('runCommand', 'jest.init')
" -- coc-jest

" coc-css --
autocmd FileType scss setl iskeyword+=@-@
" -- coc-css

" autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

let g:vista_default_executive = 'coc'
let g:vista_executive_for = {
  \ 'python': 'ctags'
  \ }
let g:vista_fzf_preview = ['right:50%']


let g:closetag_filetypes = 'html,xhtml,phtml,javascript,typescript'
let g:closetag_regions = {
  \ 'typescript.tsx': 'jsxRegion,tsxRegion,litHtmlRegion',
  \ 'javascript.jsx': 'jsxRegion,litHtmlRegion',
  \ 'javascript':     'litHtmlRegion',
  \ 'typescript':     'litHtmlRegion',
  \ }
