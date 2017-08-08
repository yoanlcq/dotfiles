" TODO improve interop with make
compiler gcc
setlocal makeprg=make
autocmd! BufWritePost * silent make! | silent redraw! | silent wincmd p
autocmd QuickFixCmdPost * cwindow
