compiler gcc

" Current path, and current dir
let b:cpath=expand('%:p')
let b:cdir=expand('%:p:h')

let b:makefilepath=findfile('Makefile', b:cpath.';')

if filereadable(b:makefilepath)
    let b:projroot=fnamemodify(b:makefilepath, ':h')
    compiler gcc
    let &makeprg='make -f '.b:makefilepath
    if executable("mingw32-make")
	let &makeprg='mingw32-make -f '.b:makefilepath
    endif
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
    let b:greptasks_files=expand('%:p')
    let b:projroot=b:cdir
    let &makeprg='gcc '.expand('%:p')
    function! GccAsync(args)
	exec 'AsyncRun -post=silent\ wincmd\ p -program=make @ '.a:args
    endfunction
    function! GccComplete(ArgLead, CmdLine, CursorPos)
	let opts = ['-c', '-o', '-m32', '-m64', '-Wall', '-Wextra', '-Werror', '-std=c11', '-stc=c99', 'std=gnu99', '-DNDEBUG', '-S', '-masm=intel', '-march=native']
	let libs = ['-lm', '-lSDL', '-lSDL2']
	"if has("win32")
	    let opts+=['-municode', '-mwindows']
	    let libs+=['-lopengl32', '-lgdi32']
	"else
	    if system("uname") != "Darwin\n"
	        let libs+=['-lGL']
	    endif
	"endif
	return Suggest_CaseSensitive(opts + libs, a:ArgLead)
    endfunction
    "NOTE: For an efficient edit-compile cycle, redo last command by typing ':' and using up-down arrows.

    command! -nargs=* -buffer -complete=customlist,GccComplete GccAsync call GccAsync(<q-args>)
    "NOTE: Shouldn't enable it, but here it is as a reference.
    "autocmd! BufWritePost <buffer> :GccAsync
endif

