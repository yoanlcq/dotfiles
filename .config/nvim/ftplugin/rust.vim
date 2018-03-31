set hidden

"let b:neomake_rust_maker='cargo'
autocmd! BufWritePost,BufEnter * Neomake
"let g:neomake_open_list = 2

"Deoplete Racer
let g:rustc_sysroot=fnamemodify(substitute(system("rustc --print sysroot"), '\n\+', '', ''), ':gs?\\?/?')
let g:racer_binary=fnamemodify(substitute(system("which racer"), '\n\+', '', ''), ':gs?\\?/?')
let g:rustc_source_path=g:rustc_sysroot."/lib/rustlib/src/rust/src/"
let g:deoplete#sources#rust#racer_binary=g:racer_binary
let g:deoplete#sources#rust#rust_source_path=g:rustc_source_path
let g:deoplete#sources#rust#show_duplicates=0
let g:deoplete#sources#rust#disable_keymap=1
let g:deoplete#sources#rust#documentation_max_height=20

augroup rust-mapping
    autocmd!
    autocmd filetype rust nmap <buffer> gd <plug>DeopleteRustGoToDefinitionDefault
    autocmd filetype rust nmap <buffer> gt <plug>DeopleteRustGoToDefinitionTab
    autocmd filetype rust nmap <buffer> gs <plug>DeopleteRustGoToDefinitionSplit
    autocmd filetype rust nmap <buffer> gv <plug>DeopleteRustGoToDefinitionVSplit
    autocmd filetype rust nmap <buffer> gh <plug>DeopleteRustShowDocumentation
augroup end

" Personal stuff
command! RustupDoc :!rustup doc
command! -nargs=* -buffer RustEmitIr3       :exec 'RustEmitIR  -C opt-level=3 '.<q-args>
command! -nargs=* -buffer RustEmitAsm3      :exec 'RustEmitAsm -C opt-level=3 '.<q-args>
command! -nargs=* -buffer RustEmitAsmIntel  :exec 'RustEmitAsm -C "llvm-args=-x86-asm-syntax=intel" '.<q-args>
command! -nargs=* -buffer RustEmitAsmIntel3 :exec 'RustEmitAsm -C opt-level=3 -C "llvm-args=-x86-asm-syntax=intel" '.<q-args>

