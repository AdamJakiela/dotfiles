syntax on
set nocompatible
set backspace=indent,eol,start
set number
set showtabline=2
set termguicolors

if executable('tmux') && filereadable(expand('~/.zshrc')) && $TMUX !=# ''
  let g:vim_is_in_tmux = 1
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
else
  let g:vim_is_in_tmux = 0
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:sonokai_style = 'default'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 1
colorscheme gruvbox-material

let mapleader=" "

" tabs
nmap <leader>ne :NERDTree<cr>
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <C-Left> :tabprevious<CR>
noremap <C-Right> :tabnext<CR>

map <F2> :NERDTreeToggle<cr>
map <C-Right> :tabn<cr>
map <C-Left> :tabp<cr>

call plug#begin()
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'  
  Plug 'morhetz/gruvbox'
  Plug 'frazrepo/vim-rainbow'
  Plug 'preservim/nerdcommenter' 
  Plug 'sainnhe/tmuxline.vim'
  Plug 'mileszs/ack.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-commentary'
  Plug 'cohama/lexima.vim'
  Plug 'scrooloose/syntastic'
  Plug 'airblade/vim-gitgutter'
  Plug 'valloric/youcompleteme'
  Plug 'sheerun/vim-polyglot'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'yggdroot/indentline'
  Plug 'flazz/vim-colorschemes'
  Plug 'junegunn/fzf'
  Plug 'ghifarit53/daycula-vim' , {'branch' : 'main'}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'alvan/vim-closetag'
  Plug 'evprkr/galaxian-vim'
  Plug 'itchyny/lightline.vim'
  Plug 'sainnhe/artify.vim'
  Plug 'albertomontesg/lightline-asyncrun' " Integration of https://github.com/skywind3000/asyncrun.vim
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " Git status is provided by coc-git
  Plug 'rmolin88/pomodoro.vim'
  Plug 'ryanoasis/vim-devicons'
  " Plug 'sainnhe/sonokai'
call plug#end()

set encoding=UTF-8
set backspace=indent,eol,start

set ts=2 sw=2 et

let g:indentLine_char = '¦'
let g:indentLine_conceallevel = 2
let g:vim_lightline_artify = 2

"{{{lightline.vim
"{{{functions
function! CocDiagnosticError() abort "{{{
  let info = get(b:, 'coc_diagnostic_info', {})
  return get(info, 'error', 0) ==# 0 ? '' : "\uf00d" . info['error']
endfunction "}}}
function! CocDiagnosticWarning() abort "{{{
  let info = get(b:, 'coc_diagnostic_info', {})
  return get(info, 'warning', 0) ==# 0 ? '' : "\uf529" . info['warning']
endfunction "}}}
function! CocDiagnosticOK() abort "{{{
  let info = get(b:, 'coc_diagnostic_info', {})
  if get(info, 'error', 0) ==# 0 && get(info, 'error', 0) ==# 0
    let msg = "\uf00c"
  else
    let msg = ''
  endif
  return msg
endfunction "}}}
function! CocStatus() abort "{{{
  return get(g:, 'coc_status', '')
endfunction "}}}
function! GitGlobal() abort "{{{
  let git_status = get(g:, 'coc_git_status', '')
  if git_status ==# ''
    if g:vim_lightline_artify ==# 2
      let status = ' ' . artify#convert(fnamemodify(getcwd(), ':t'), 'monospace')
    else
      let status = ' ' . fnamemodify(getcwd(), ':t')
    endif
  else
    if g:vim_lightline_artify ==# 2
      let status = artify#convert(git_status, 'monospace')
    else
      let status = git_status
    endif
  endif
  return status
endfunction "}}}
function! PomodoroStatus() abort "{{{
  if pomo#remaining_time() ==# '0'
    return "\ue001"
  else
    return "\ue003 ".pomo#remaining_time()
  endif
endfunction "}}}
function! DeviconsFiletype() "{{{
  " return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft') : ''
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction "}}}
function! TabNum(n) abort "{{{
  return a:n." \ue0bb"
endfunction "}}}
function! ArtifyActiveTabNum(n) abort "{{{
  return artify#convert(a:n, 'bold')." \ue0bb"
endfunction "}}}
function! ArtifyInactiveTabNum(n) abort "{{{
  return artify#convert(a:n, 'double_struck')." \ue0bb"
endfunction "}}}
function! ArtifyLightlineTabFilename(s) abort "{{{
  if g:vim_lightline_artify ==# 2
    return artify#convert(lightline#tab#filename(a:s), 'monospace')
  else
    return lightline#tab#filename(a:s)
  endif
endfunction "}}}
function! ArtifyLightlineMode() abort "{{{
  if g:vim_lightline_artify ==# 2
    return artify#convert(lightline#mode(), 'monospace')
  else
    return lightline#mode()
  endif
endfunction "}}}
function! ArtifyLinePercent() abort "{{{
  return artify#convert(string((100*line('.'))/line('$')), 'bold')
endfunction "}}}
function! ArtifyLineNum() abort "{{{
  return artify#convert(string(line('.')), 'bold')
endfunction "}}}
function! ArtifyColNum() abort "{{{
  return artify#convert(string(getcurpos()[2]), 'bold')
endfunction "}}}
"}}}
set laststatus=2  " Basic
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox_material'
let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }
let g:lightline#asyncrun#indicator_none = ''
let g:lightline#asyncrun#indicator_run = 'Running...'
if g:vim_lightline_artify == 0
  let g:lightline.active = {
        \ 'left': [ [ 'mode', 'paste' ],
        \           [ 'readonly', 'filename', 'modified', 'fileformat', 'devicons_filetype' ] ],
        \ 'right': [ [ 'lineinfo' ],
        \            [ 'linter_errors', 'linter_warnings', 'linter_ok', 'pomodoro' ],
        \           [ 'asyncrun_status', 'coc_status' ] ]
        \ }
  let g:lightline.inactive = {
        \ 'left': [ [ 'filename' , 'modified', 'fileformat', 'devicons_filetype' ]],
        \ 'right': [ [ 'lineinfo' ] ]
        \ }
  let g:lightline.tabline = {
        \ 'left': [ [ 'vim_logo', 'tabs' ] ],
        \ 'right': [ [ 'git_global' ],
        \ [ 'git_buffer' ] ]
        \ }
  let g:lightline.tab = {
        \ 'active': [ 'tabnum', 'filename', 'modified' ],
        \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }
else
  let g:lightline.active = {
        \ 'left': [ [ 'artify_mode', 'paste' ],
        \           [ 'readonly', 'filename', 'modified', 'fileformat', 'devicons_filetype' ] ],
        \ 'right': [ [ 'artify_lineinfo' ],
        \            [ 'linter_errors', 'linter_warnings', 'linter_ok', 'pomodoro' ],
        \           [ 'asyncrun_status', 'coc_status' ] ]
        \ }
  let g:lightline.inactive = {
        \ 'left': [ [ 'filename' , 'modified', 'fileformat', 'devicons_filetype' ]],
        \ 'right': [ [ 'artify_lineinfo' ] ]
        \ }
  let g:lightline.tabline = {
        \ 'left': [ [ 'vim_logo', 'tabs' ] ],
        \ 'right': [ [ 'git_global' ],
        \ [ 'git_buffer' ] ]
        \ }
  let g:lightline.tab = {
        \ 'active': [ 'artify_activetabnum', 'artify_filename', 'modified' ],
        \ 'inactive': [ 'artify_inactivetabnum', 'filename', 'modified' ] }
endif
let g:lightline.tab_component_function = {
      \ 'artify_activetabnum': 'ArtifyActiveTabNum',
      \ 'artify_inactivetabnum': 'ArtifyInactiveTabNum',
      \ 'artify_filename': 'ArtifyLightlineTabFilename',
      \ 'tabnum': 'TabNum',
      \ 'filename': 'lightline#tab#filename',
      \ 'modified': 'lightline#tab#modified',
      \ 'readonly': 'lightline#tab#readonly'
      \ }
let g:lightline.component = {
      \ 'git_buffer' : '%{get(b:, "coc_git_status", "")}',
      \ 'git_global' : '%{GitGlobal()}',
      \ 'artify_mode': '%{ArtifyLightlineMode()}',
      \ 'artify_lineinfo': "%2{ArtifyLinePercent()}\uf295 %3{ArtifyLineNum()}:%-2{ArtifyColNum()}",
      \ 'bufinfo': '%{bufname("%")}:%{bufnr("%")}',
      \ 'vim_logo': "\ue7c5",
      \ 'pomodoro': '%{PomodoroStatus()}',
      \ 'mode': '%{lightline#mode()}',
      \ 'absolutepath': '%F',
      \ 'relativepath': '%f',
      \ 'filename': '%t',
      \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
      \ 'fileformat': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
      \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
      \ 'modified': '%M',
      \ 'bufnum': '%n',
      \ 'paste': '%{&paste?"PASTE":""}',
      \ 'readonly': '%R',
      \ 'charvalue': '%b',
      \ 'charvaluehex': '%B',
      \ 'percent': '%2p%%',
      \ 'percentwin': '%P',
      \ 'spell': '%{&spell?&spelllang:""}',
      \ 'lineinfo': '%2p%% %3l:%-2v',
      \ 'line': '%l',
      \ 'column': '%c',
      \ 'close': '%999X X ',
      \ 'winnr': '%{winnr()}'
      \ }
let g:lightline.component_function = {
      \ 'devicons_filetype': 'DeviconsFiletype',
      \ 'coc_status': 'CocStatus',
      \ }
let g:lightline.component_expand = {
      \ 'linter_warnings': 'CocDiagnosticWarning',
      \ 'linter_errors': 'CocDiagnosticError',
      \ 'linter_ok': 'CocDiagnosticOK',
      \ 'asyncrun_status': 'lightline#asyncrun#status'
      \ }
let g:lightline.component_type = {
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error'
      \ }
"}}}

let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

let g:closetag_filenames = '*.js,*.jsx,*.html,*.xhtml,*.phtml'

if g:vim_is_in_tmux == 1 && !has('win32')
  let g:tmuxline_preset = {
        \'a'    : '#S',
        \'b'    : '%R',
        \'c'    : [ '#{sysstat_mem} #[fg=blue]#{sysstat_ntemp} #[fg=green]\ufa51#{upload_speed}' ],
        \'win'  : [ '#I', '#W' ],
        \'cwin' : [ '#I', '#W', '#F' ],
        \'x'    : [ "#[fg=green]#{download_speed} \uf6d9 #[fg=blue]#{sysstat_itemp} #{sysstat_cpu}" ],
        \'y'    : [ '%a' ],
        \'z'    : '#H #{prefix_highlight}'
        \}
  let g:tmuxline_separators = {
        \ 'left' : "\ue0bc",
        \ 'left_alt': "\ue0bd",
        \ 'right' : "\ue0ba",
        \ 'right_alt' : "\ue0bd",
        \ 'space' : ' '}
endif

"Nerd tree divider
highlight VertSplit cterm=NONE
