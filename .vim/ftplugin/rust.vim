" QuickFix utilities (TODO should be shared to other languages ?)
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

command! RustupDoc :AsyncRun rustup doc
command! -nargs=* -buffer RustEmitAsmIntel   :exec 'RustEmitAsm -C "llvm-args=-x86-asm-syntax=intel" '.<q-args>
command! -nargs=* -buffer RustEmitAsmO3      :exec 'RustEmitAsm -C opt-level=3 '.<q-args>
command! -nargs=* -buffer RustEmitAsmIntelO3 :exec 'RustEmitAsm -C opt-level=3 -C "llvm-args=-x86-asm-syntax=intel" '.<q-args>
command! -nargs=* -buffer RustEmitAsmO3      :exec 'RustEmitAsm -C opt-level=3 '.<q-args>
command! -nargs=* -buffer RustEmitIRO3       :exec 'RustEmitIR  -C opt-level=3 '.<q-args>

"TODO needs mappings (with <localleader>) for :
"- Toggling asynchronous recompile-on-write

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
	let commands = ['build', 'check', 'clean', 'doc', 'new', 'init', 'run', 'test', 'bench', 'update', 'search', 'publish', 'install', 'uninstall', 'rustc', 'rustc --features clippy -- -Z no-trans -Z extra-plugins=clippy' ]
	let opts = ['-v', '-vv', '--verbose', '-q', '--quiet', '--features', '--release']
	call filter(commands, 'v:val =~# "^".a:ArgLead.".*$"')
	call filter(opts, 'v:val =~# "^".a:ArgLead.".*$"')
	return commands + opts
    endfunction

    command! -nargs=* -buffer -complete=customlist,CargoComplete CargoAsync call CargoAsync(<q-args>)
    command! -nargs=* -buffer -complete=customlist,CargoComplete CargoSync call CargoSync(<q-args>)
    abbrev Ca CargoAsync
    abbrev CA CargoAsync
    abbrev CS CargoSync
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

