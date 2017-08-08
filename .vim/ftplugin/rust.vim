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
setlocal completeopt=menu,noinsert


"TODO needs mappings (with <localleader>) for :
"- Toggling asynchronous recompile-on-write
"- Displaying release-mode LLVM IR in a separate buffer
"- Displaying release-mode ASM (intel syntax) in a separate buffer
"- Running "rustc -Z no-trans" and "cargo check"
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
    function! CargoCheck()
	silent make! check | silent redraw! | silent wincmd p
    endfunction
    function! CargoCheckFeaturesClippy()
	silent make! check --features clippy | silent redraw! | silent wincmd p
    endfunction
    function! CargoClippy()
	silent make! clippy | silent redraw! | silent wincmd p
    endfunction
    function! CargoTest()
	silent make! test | silent redraw! | silent wincmd p
    endfunction
    function! CargoBench()
	silent make! bench | silent redraw! | silent wincmd p
    endfunction
    function! CargoDoc()
	silent make! doc | silent redraw! | silent wincmd p
    endfunction
    function! CargoBuild()
	silent make! build | silent redraw! | silent wincmd p
    endfunction
    function! CargoBuildRelease()
	silent make! build --release | silent redraw! | silent wincmd p
    endfunction
    function! CargoRun()
	silent make! run | silent redraw! | silent wincmd p
    endfunction
    function! CargoRunRelease()
	silent make! run --release | silent redraw! | silent wincmd p
    endfunction
    command! -buffer CargoCheck call CargoCheck()
    command! -buffer CargoCheckFeaturesClippy call CargoCheckFeaturesClippy()
    command! -buffer CargoClippy call CargoClippy()
    command! -buffer CargoTest call CargoTest()
    command! -buffer CargoBench call CargoBench()
    command! -buffer CargoDoc call CargoDoc()
    command! -buffer CargoBuild call CargoBuild()
    command! -buffer CargoBuildRelease call CargoBuildRelease()
    command! -buffer CargoRun call CargoRun()
    command! -buffer CargoRunRelease call CargoRunRelease()
    " TODO make the above accept any number of extra arguments (e.g --verbose)
    " TODO make these run asynchronously somehow
else
    compiler rustc
    setlocal makeprg=rustc
    let b:greptasks_files=expand('%:p')
    let b:projroot=b:cdir
    function! RustCheck()
	exec 'silent make! -Z no-trans '.expand('%:p').' | silent redraw! | silent wincmd p'
    endfunction

    command! -buffer RustCheck call RustCheck()
    "autocmd! BufWritePost <buffer> exec 'silent make! -Z no-trans '.b:projroot.'/*.rs' | silent redraw! | silent wincmd p
endif

command! RustupDoc :AsyncRun rustup doc
command! -nargs=* -buffer RustEmitAsmIntel :RustEmitAsm -C "llvm-args=-x86-asm-syntax=intel"
command! -nargs=* -buffer RustEmitAsmRelease :RustEmitAsm -C opt-level=3
command! -nargs=* -buffer RustEmitAsmIntelRelease :RustEmitAsm -C opt-level=3 -C "llvm-args=-x86-asm-syntax=intel"
command! -nargs=* -buffer RustEmitAsmRelease :RustEmitAsm -C opt-level=3
command! -nargs=* -buffer RustEmitIRRelease :RustEmitIR -C opt-level=3

" TODO FIXME
function! GrepTasks(list)
	let re=""
	for i in a:list
	    let re.=i."\\|"
    	endfor
	vimgrepadd /re/ b:greptasks_files
endfunction

"TODO: Allow this to be improved with command and custom completion.
map <buffer> <silent> <F3> :exec 'vimgrepadd /TODO\\|FIXME\\|XXX\\|PERF\\|WISH\\|NOTE\\|unimplemented!()/ '.b:greptasks_files<CR>
