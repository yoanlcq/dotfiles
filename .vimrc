let g:easytags_include_members = 1
let g:easytags_async = 1
let g:easytags_auto_highlight = 0
let g:easytags_events = ['BufWritePost']

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'ervandew/supertab'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags', { 'for': ['c', 'cpp', 'objc', 'objcpp', 'cuda', 'java', 'javascript'] }
call plug#end()

setglobal encoding=utf-8
setglobal fileencoding=utf-8
syntax on
colorscheme desert
setglobal guifont=Lucida_Console:h9
set backspace=indent,eol,start

set tags+=~/.vim/systags
set tabstop=4
set shiftwidth=4
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
