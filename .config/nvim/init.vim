" vim-plug Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'flazz/vim-colorschemes'
Plug 'neomake/neomake'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'sebastianmarkow/deoplete-rust', { 'for': 'rust' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
"Plug 'tweekmonster/deoplete-clang2', { 'for': ['c', 'cpp', 'objc', 'objcpp'] }
"https://github.com/cyansprite/deoplete-omnisharp
"https://github.com/zchee/deoplete-asm
call plug#end()


" UTF-8 everywhere
setglobal encoding=utf-8
setglobal fileencoding=utf-8


" Basics
syntax on
filetype plugin indent on
set background=dark
colorscheme badwolf
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
"set colorcolumn=80
"set cursorline
"set cursorcolumn
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set number
set completeopt=menu,menuone
set wildignorecase
set mouse=a

"Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_on_insert_enter = 1
let g:deoplete#auto_complete_delay = 0
let g:deoplete#auto_complete_start_length = 1 "XXX: Deprecated


"let g:neomake_c_enabled_makers = ["clang"]
"let g:neomake_cpp_enabled_makers = ["clang"]
"let g:neomake_objc_enabled_makers = ["clang"]
"let g:neomake_objcpp_enabled_makers = ["clang"]
"let g:deoplete#sources#clang#executable = 'clang-3.8'
"let g:deoplete#sources#clang#autofill_neomake = 1
"let g:deoplete#sources#clang#std = {
"    'c': 'c11',
"    'cpp': 'c++1z',
"    'objc': 'c11',
"    'objcpp': 'c++1z',
"}
"let g:deoplete#sources#clang#preproc_max_lines = 50
