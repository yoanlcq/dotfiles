# dotfiles

# Vim 8 setup

Contains my Vim setup, mainly targeted at Rust and C projects. TODO: roughly document the workflow

What follows are notes to myself.

"Fresh install" checklist:
- `vim +PlugInstall`
- `cargo install racer`
- `rustup component add rust-src`

On Windows, in a normal windows prompt :
```batch
cd C:\Users\You
mklink /j .vim git/dotfiles/.vim
mklink /j vimfiles .vim
mklink .vimrc git/dotfiles/.vimrc
mklink _vimrc .vimrc
```
`~/.vim` and `~/.vimrc` are for Git BASH's Vim.
`~/vimfiles` and `~/_vimrc` are for GVim.

On \*nix:
```bash
cd
ln -s .vim git/dotfiles/.vim
ln -s .vimrc git/dotfiles/.vimrc
```
