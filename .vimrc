" TODO worried about detectindent and editorconfig
" TODO make stuff work on GVim

call plug#begin('~/.vim/plugged')
" Editor setup utilities
"Plug 'editorconfig/editorconfig-vim'
"Plug 'sgur/vim-editorconfig'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-dispatch'
"Plug 'ciaranm/detectindent'
Plug 'ervandew/supertab'
Plug 'skywind3000/asyncrun.vim'
Plug 'mattn/webapi-vim'
" Rust
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
" Wren (wren.io)
Plug 'lluchs/vim-wren'
" TODO: use clang_complete instead
"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-easytags', { 'for': ['c', 'cpp', 'objc', 'objcpp', 'cuda', 'java', 'javascript'] }
"Plug 'OmniSharp/omnisharp-vim'
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
"NOTE: Rust style, already enforced by rust.vim, but good for any other format
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
"set list
"set listchars=tab:>-

set tags+=~/.vim/systags
set omnifunc=syntaxcomplete#Complete
setglobal completeopt=menu,noinsert
set nocompatible
set incsearch
set hlsearch
set lazyredraw
set wildmenu
set scrolloff=2
set number
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
set colorcolumn=80

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
" Do it for all file types anyway. Why not plain text and the like, after all?
autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|unimplemented!\)')
autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|WISH\|PERF\)')

"autocmd FileType * :DetectIndent
autocmd QuickFixCmdPost * vertical copen 80

" QuickFix utilities. Useful for shortening the QuickFix list on Rust
" projects, and restoring it, at will.

let g:qf_is_shortened=0

function! QuickFixRefresh()
    if g:qf_is_shortened
        call setqflist(g:short_qflist)
    else
        call setqflist(g:qflist)
    endif
endfunction

function! QuickFixPost()
    let g:qflist=getqflist()
    let g:short_qflist=[]
    for i in g:qflist
        if i.valid
	    call add(g:short_qflist, i)
	endif
    endfor
    call QuickFixRefresh()
endfunction

function! QuickFixToggle()
    let g:qf_is_shortened=!g:qf_is_shortened
    call QuickFixRefresh()
endfunction

call QuickFixPost()
autocmd! QuickFixCmdPost <buffer> call QuickFixPost() | vertical cwindow 80
" To prevent QuickFix from stealing focus
" https://github.com/fatih/vim-go/issues/1073
"autocmd Syntax qf wincmd p

command! QuickFixRefresh call QuickFixRefresh()
command! QuickFixPost call QuickFixPost()
command! QuickFixToggle call QuickFixToggle()

