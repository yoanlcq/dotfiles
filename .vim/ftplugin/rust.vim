" QuickFix utilities (should be shared to other languages ?)
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

command! QuickFixRefresh call QuickFixRefresh()
command! QuickFixPost call QuickFixPost()
command! QuickFixToggle call QuickFixToggle()

" Current path, and current dir
let b:cpath=expand('%:p')
let b:cdir=expand('%:p:h')

let g:rustc_sysroot=fnamemodify(substitute(system("rustc --print sysroot"), '\n\+', '', ''), ':gs?\\?/?')
let $RUST_SRC_PATH=g:rustc_sysroot."/lib/rustlib/src/rust/src/"

set hidden
let g:racer_cmd="racer"
let g:racer_experimental_completer=1
let g:SuperTabClosePreviewOnPopupClose=1
let b:cargopath=findfile('Cargo.toml', b:cpath.';')
let b:projroot=fnamemodify(b:cargopath, ':h')

"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd! InsertLeave <buffer> if pumvisible() == 0|pclose|endif
"Since Vim 7.4
"autocmd CompleteDone * pclose
command! RacerGoToDefinition call racer#GoToDefinition()
command! RacerShowDocumentation call racer#ShowDocumentation()
map <buffer> <silent> gd :call racer#GoToDefinition()<CR>
map <buffer> <silent> gs :split<CR>:call racer#GoToDefinition()<CR>
map <buffer> <silent> gx :vsplit<CR>:call racer#GoToDefinition()<CR>
map <buffer> <silent> gh :call racer#ShowDocumentation()<CR>
map <buffer> <silent> <F2> :call QuickFixToggle()<CR>


"TODO needs mappings (with <localleader>) for :
"- Toggling asynchronous recompile-on-write
"- Better TODO/XXX/whatever management

if filereadable(b:cargopath)
    compiler cargo
    setlocal makeprg=cargo
    let b:greptasks_files=b:projroot."/Cargo.toml ".b:projroot."/src/**/*.rs "

    if isdirectory(b:projroot."/examples")
	let b:greptasks_files.=b:projroot."/examples/**/*.rs "
    endif
    if isdirectory(b:projroot."/tests")
	let b:greptasks_files.=b:projroot."/tests/**/*.rs "
    endif
    "autocmd! BufWritePost <buffer> silent make! clippy | silent redraw! | silent wincmd p
    "autocmd! BufWritePost <buffer> silent make! rustc --features clippy -- -Z no-trans -Z extra-plugins=clippy | silent redraw! | silent wincmd p
    function! CargoCheck(args)
	exec 'silent make! check '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoCheckFeaturesClippy(args)
	exec 'silent make! rustc --features clippy '.a:args.' -- -Z no-trans -Z extra-plugins=clippy | silent redraw! | silent wincmd p'
    endfunction
    function! CargoClippy(args)
	exec 'silent make! clippy '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoTest(args)
	exec 'silent make! test '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoBench(args)
	exec 'silent make! bench '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoDoc(args)
	exec 'silent make! doc '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoBuild(args)
	exec 'silent make! build '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoBuildRelease(args)
	exec 'silent make! build --release '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoRun(args)
	exec 'silent make! run '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoRunRelease(args)
	exec 'silent make! run --release '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    command! -nargs=* -buffer CargoCheck call CargoCheck(<q-args>)
    command! -nargs=* -buffer CargoCheckFeaturesClippy call CargoCheckFeaturesClippy(<q-args>)
    command! -nargs=* -buffer CargoClippy call CargoClippy(<q-args>)
    command! -nargs=* -buffer CargoTest call CargoTest(<q-args>)
    command! -nargs=* -buffer CargoBench call CargoBench(<q-args>)
    command! -nargs=* -buffer CargoDoc call CargoDoc(<q-args>)
    command! -nargs=* -buffer CargoBuild call CargoBuild(<q-args>)
    command! -nargs=* -buffer CargoBuildRelease call CargoBuildRelease(<q-args>)
    command! -nargs=* -buffer CargoRun call CargoRun(<q-args>)
    command! -nargs=* -buffer CargoRunRelease call CargoRunRelease(<q-args>)
    abbrev CC CargoCheck
    abbrev Cc CargoCheck
    " TODO make these run asynchronously somehow
else
    compiler rustc
    setlocal makeprg=rustc
    let b:greptasks_files=expand('%:p')
    let b:projroot=b:cdir
    function! RustCheck(args)
	exec 'silent make! -Z no-trans '.expand('%:p').' '.a:args.' | silent redraw! | silent wincmd p'
    endfunction

    command! -nargs=* -buffer RustCheck call RustCheck(<q-args>)
    "autocmd! BufWritePost <buffer> exec 'silent make! -Z no-trans '.b:projroot.'/*.rs' | silent redraw! | silent wincmd p
endif

command! RustupDoc :AsyncRun rustup doc
command! -nargs=* -buffer RustEmitAsmIntel   :exec 'RustEmitAsm -C "llvm-args=-x86-asm-syntax=intel" '.<q-args>
command! -nargs=* -buffer RustEmitAsmO3      :exec 'RustEmitAsm -C opt-level=3 '.<q-args>
command! -nargs=* -buffer RustEmitAsmIntelO3 :exec 'RustEmitAsm -C opt-level=3 -C "llvm-args=-x86-asm-syntax=intel" '.<q-args>
command! -nargs=* -buffer RustEmitAsmO3      :exec 'RustEmitAsm -C opt-level=3 '.<q-args>
command! -nargs=* -buffer RustEmitIRO3       :exec 'RustEmitIR  -C opt-level=3 '.<q-args>

"TODO: Allow this to be improved with command and custom completion.
map <buffer> <silent> <F3> :exec 'vimgrepadd /TODO\\|FIXME\\|XXX\\|PERF\\|WISH\\|NOTE\\|unimplemented!()/ '.b:greptasks_files<CR>
