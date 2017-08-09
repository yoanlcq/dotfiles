call plug#begin('~/.vim/plugged')
"Plug 'editorconfig/editorconfig-vim'
Plug 'sgur/vim-editorconfig'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'ciaranm/detectindent'
Plug 'skywind3000/asyncrun.vim'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'mattn/webapi-vim'
Plug 'ervandew/supertab'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags', { 'for': ['c', 'cpp', 'objc', 'objcpp', 'cuda', 'java', 'javascript'] }
call plug#end()

" GVim settings
colorscheme desert
setglobal guifont=Lucida_Console:h9
" This fixes wrong backspace behaviour on one of my keyboards
set backspace=indent,eol,start

" UTF-8 everywhere
setglobal encoding=utf-8
setglobal fileencoding=utf-8

syntax on
filetype plugin indent on

set tags+=~/.vim/systags
set omnifunc=syntaxcomplete#Complete
setglobal completeopt=menu,noinsert

let g:SuperTabDefaultCompletionType = "context"

let g:detectindent_preferred_indent = 4 

let g:easytags_include_members = 1
let g:easytags_async = 1
let g:easytags_auto_highlight = 0
let g:easytags_events = ['BufWritePost']

let g:EditorConfig_exclude_patterns = ['fugitive://.*']
