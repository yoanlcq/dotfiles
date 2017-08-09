compiler gcc

" Current path, and current dir
let b:cpath=expand('%:p')
let b:cdir=expand('%:p:h')

let b:makefilepath=findfile('Makefile', b:cpath.';')
let b:projroot=fnamemodify(b:makefilepath, ':h')

" TODO emit ASM
" TODO does it work with mingw32-make ?
" TODO does it when Makefile isn't in cwd ?
" TODO does it work when we update variables by hand ?

if filereadable(b:makefilepath)
    compiler gcc
    setlocal makeprg=make
    let b:greptasks_files=b:makefilepath

    if isdirectory(b:projroot."/src")
	let b:greptasks_files.=b:projroot."/src/**/*.c "
    endif
    if isdirectory(b:projroot."/code")
	let b:greptasks_files.=b:projroot."/code/**/*.c "
    endif
    if isdirectory(b:projroot."/include")
	let b:greptasks_files.=b:projroot."/include/**/*.h "
    endif
    if isdirectory(b:projroot."/inc")
	let b:greptasks_files.=b:projroot."/inc/**/*.h "
    endif

    function! MakeAsync(args)
	exec 'AsyncRun -post=silent\ wincmd\ p -program=make @ '.a:args
    endfunction

    command! -nargs=* -buffer MakeAsync call MakeAsync(<q-args>)
    abbrev Ma MakeAsync
    "NOTE: Shouldn't enable it, but here it is as a reference.
    "autocmd! BufWritePost <buffer> :MakeAsync
else
    let b:cflags = '-Wall -Wextra -std=gnu11 -g'
    let b:ldlibs = ['m']
    let b:greptasks_files=expand('%:p')
    let b:projroot=b:cdir
    function! GccLdFlags()
	let flags = copy(b:ldlibs)
	call map(flags, '"-l".v:val')
	call join(flags)
	return flags
    endfunction
    let &makeprg='gcc '.b:cflags.' '.expand('%:p').' '.GccLdFlags()
    function! GccAsync(args)
	exec 'AsyncRun -post=silent\ wincmd\ p -program=make @ '.a:args
    endfunction
    function! GccComplete(ArgLead, CmdLine, CursorPos)
	let opts = ['-c', '-o', '-m32', '-m64', '-Wall', '-Wextra', '-Werror', '-std=c11', '-stc=c99', 'std=gnu99', '-DNDEBUG', '-municode', '-mwindows']
	return Suggest_CaseSensitive(opts, a:ArgLead)
    endfunction

    command! -nargs=* -buffer -complete=customlist,GccComplete GccAsync call GccAsync(<q-args>)
    "NOTE: Shouldn't enable it, but here it is as a reference.
    "autocmd! BufWritePost <buffer> :GccAsync
endif

