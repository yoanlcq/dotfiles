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


" Tasks GREP

function! TasksGrepGetFiles()
    if exists('b:tasksgrep_files')
	return b:tasksgrep_files
    else
	return expand('%:p')
    endif
endfunction

function! TasksGrepGrep(grep, list)
    exec 'try | '.a:grep.' /'.join(a:list, '\|').'/j '.TasksGrepGetFiles().' | catch /^Vim\%((\a\+)\)\=:E480/ | echom "No matching task has been found." | endtry'
endfunction

function! TasksGrep(...)
    return TasksGrepGrep('vimgrep', a:000)
endfunction

function! TasksGrepAdd(...)
    return TasksGrepGrep('vimgrepadd', a:000)
endfunction

"NOTE: See :h expr4
function! TasksGrepComplete(ArgLead, CmdLine, CursorPos)
    let tags = ['FIXME', 'BUG', 'TODO', 'XXX', 'HACK', 'NOTE', 'CHANGED', 'IDEA', 'WISH', 'PERF', 'INFO', 'unimplemented!']
    call filter(tags, 'v:val =~? a:ArgLead')
    return tags
endfunction

command! -nargs=* -complete=customlist,TasksGrepComplete TasksGrep    call TasksGrep   (<f-args>) | vertical cwindow 80
command! -nargs=* -complete=customlist,TasksGrepComplete TasksGrepAdd call TasksGrepAdd(<f-args>) | vertical cwindow 80
abbrev TG TasksGrep
abbrev TGA TasksGrepAdd

autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|unimplemented!\)')
autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|WISH\|PERF\)')

