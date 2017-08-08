" QuickFix utilities (should be shared to other languages ?)

let g:my_qf_is_shortened = 0

function! MyRefreshQuickFix()
    if g:my_qf_is_shortened
        call setqflist(g:my_short_qflist)
    else
        call setqflist(g:my_qflist)
    endif
endfunction

function! MyPostQuickFix()
    let g:my_qflist = getqflist()
    let g:my_short_qflist = []
    for i in g:my_qflist
        if i.valid
	    call add(g:my_short_qflist, i)
	endif
    endfor
    call MyRefreshQuickFix()
endfunction

function! MyToggleQuickFix()
    let g:my_qf_is_shortened = !g:my_qf_is_shortened
    call MyRefreshQuickFix()
endfunction

call MyPostQuickFix()


" Current path, and current dir
let b:cpath=expand('%:p')
let b:cdir=expand('%:p:h')

"let $RUST_SRC_PATH='~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/'
let $RUST_SRC_PATH=fnamemodify(system("rustup which rustc"), ':h')."/../lib/rustlib/src/rust/src/"

let g:racer_experimental_completer = 1
let g:SuperTabClosePreviewOnPopupClose = 1
let b:cargopath=findfile('Cargo.toml', b:cpath.';')
let b:projroot=fnamemodify(b:cargopath, ':h')

"TODO needs mappings for :
"- Displaying release-mode LLVM IR in a separate buffer
"- Displaying release-mode ASM (intel syntax) in a separate buffer
"- Running "rustc -Z no-trans" and "cargo check"
"- Better TODO/XXX/whatever management

if filereadable(b:cargopath)
    compiler cargo
    setlocal makeprg=cargo
    "autocmd! BufWritePost <buffer> silent make! clippy | silent redraw! | silent wincmd p
    "autocmd! BufWritePost <buffer> silent make! rustc --features clippy -- -Z no-trans -Z extra-plugins=clippy | silent redraw! | silent wincmd p
    "map <buffer> <silent> <F5> :make run<CR>
    "map <buffer> <silent> <F6> :make test<CR>
    map <buffer> <silent> <F3> :exec 'lcd' b:projroot<CR>:vimgrepa /TODO\\|FIXME\\|XXX\\|PERF\\|WISH\\|NOTE\\|unimplemented!()/ Cargo.toml examples/**/*.rs src/**/*.rs<CR>:lcd -<CR>

else

    let b:projroot=b:cdir
    compiler rustc
    setlocal makeprg=rustc
    "autocmd! BufWritePost <buffer> exec 'silent make! -Z no-trans '.b:projroot.'/*.rs' | silent redraw! | silent wincmd p
    map <buffer> <silent> <F3> :exec 'vimgrepa /TODO\\|FIXME\\|XXX\\|PERF\\|WISH\\|NOTE\\|unimplemented!()/ '.bufname("%")<CR>

endif

autocmd! QuickFixCmdPost <buffer> call MyPostQuickFix() | vertical cwindow 80
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd! InsertLeave <buffer> if pumvisible() == 0|pclose|endif
"Since Vim 7.4
"autocmd CompleteDone * pclose
map <buffer> <silent> gd :call racer#GoToDefinition()<CR>
map <buffer> <silent> gs :split<CR>:call racer#GoToDefinition()<CR>
map <buffer> <silent> gx :vsplit<CR>:call racer#GoToDefinition()<CR>
map <buffer> <silent> gh :call racer#ShowDocumentation()<CR>
map <buffer> <silent> <F2> :call MyToggleQuickFix()<CR>
setlocal completeopt=menu,noinsert
