
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

command! RustupDoc :AsyncRun rustup doc
command! -nargs=* -buffer RustEmitAsmIntel   :exec 'RustEmitAsm -C "llvm-args=-x86-asm-syntax=intel" '.<q-args>
command! -nargs=* -buffer RustEmitAsmO3      :exec 'RustEmitAsm -C opt-level=3 '.<q-args>
command! -nargs=* -buffer RustEmitAsmIntelO3 :exec 'RustEmitAsm -C opt-level=3 -C "llvm-args=-x86-asm-syntax=intel" '.<q-args>
command! -nargs=* -buffer RustEmitAsmO3      :exec 'RustEmitAsm -C opt-level=3 '.<q-args>
command! -nargs=* -buffer RustEmitIRO3       :exec 'RustEmitIR  -C opt-level=3 '.<q-args>

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
    function! CargoAsync(args)
	exec 'AsyncRun -post=silent\ wincmd\ p -program=make @ '.a:args
    endfunction
    function! CargoSync(args)
	exec 'silent make! '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! CargoComplete(ArgLead, CmdLine, CursorPos)
	let commands = ['build', 'check', 'clean', 'doc', 'new', 'init', 'run', 'test', 'bench', 'update', 'search', 'publish', 'install', 'uninstall', 'rustc', 'clippy']
	let opts = ['-v', '-vv', '--verbose', '-q', '--quiet', '--features', '--release']
	let least = ['rustc --features clippy -- -Z no-trans -Z extra-plugins=clippy']
	return Suggest_CaseSensitive(commands + opts + least, a:ArgLead)
    endfunction

    command! -nargs=* -buffer -complete=customlist,CargoComplete CargoAsync call CargoAsync(<q-args>)
    command! -nargs=* -buffer -complete=customlist,CargoComplete CargoSync call CargoSync(<q-args>)
    abbrev Ca CargoAsync
    abbrev CA CargoAsync
    abbrev CS CargoSync
    "NOTE: Shouldn't enable it, but here it is as a reference.
    "autocmd! BufWritePost <buffer> :CargoAsync check
else
    compiler rustc
    setlocal makeprg=rustc
    let b:greptasks_files=expand('%:p')
    let b:projroot=b:cdir
    function! RustCheckSync(args)
	exec 'silent make! -Z no-trans '.expand('%:p').' '.a:args.' | silent redraw! | silent wincmd p'
    endfunction
    function! RustCheckAsync(args)
	exec 'AsyncRun -post=silent\ wincmd\ p -program=make @ -Z no-trans '.expand('%:p').' '.a:args
    endfunction

    command! -nargs=* -buffer RustCheckSync call RustCheckSync(<q-args>)
    command! -nargs=* -buffer RustCheckAsync call RustCheckAsync(<q-args>)
    "NOTE: Shouldn't enable it, but here it is as a reference.
    "autocmd! BufWritePost <buffer> :RustCheckAsync
endif

