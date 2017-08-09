" TODO worried about detectindent and editorconfig
" TODO make stuff work on GVim

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
" TODO: use clang_complete instead
"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-easytags', { 'for': ['c', 'cpp', 'objc', 'objcpp', 'cuda', 'java', 'javascript'] }
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


" Completion utilities

" Removes duplicates in a list, preserving order.
" uniq() doesn't cut it because it operates on _adjacent_ duplicates
function! Uniq(list)
    return filter(copy(a:list), 'index(a:list, v:val) == v:key')
endfunction
" Quick fuzzy-matcher for command completion.
" Welp, copy pasta, but works just as well
" NOTE: See :h expr4
function Suggest_CaseSensitive(list, ArgLead)
    let startingwith = copy(a:list)
    let containing = copy(a:list)
    call filter(startingwith, 'v:val =~# "^".a:ArgLead.".*$"')
    call filter(containing,   'v:val =~#     a:ArgLead'      )
    return Uniq(startingwith + containing)
endfunction
function Suggest_CaseInsensitive(list, ArgLead)
    let startingwith = copy(a:list)
    let containing = copy(a:list)
    call filter(startingwith, 'v:val =~? "^".a:ArgLead.".*$"')
    call filter(containing,   'v:val =~?     a:ArgLead'      )
    return Uniq(startingwith + containing)
endfunction



" Tasks GREP: collect Todo-items into QuickFix window

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

function! TasksGrepComplete(ArgLead, CmdLine, CursorPos)
    let tags = ['FIXME', 'BUG', 'TODO', 'XXX', 'HACK', 'NOTE', 'CHANGED', 'IDEA', 'WISH', 'PERF', 'INFO', 'unimplemented!']
    return Suggest_CaseInsensitive(tags, a:ArgLead)
endfunction

command! -nargs=* -complete=customlist,TasksGrepComplete TasksGrep    call TasksGrep   (<f-args>) | vertical cwindow 80
command! -nargs=* -complete=customlist,TasksGrepComplete TasksGrepAdd call TasksGrepAdd(<f-args>) | vertical cwindow 80
abbrev TG TasksGrep
abbrev TGA TasksGrepAdd

" Setup tag highlighting
" Do it