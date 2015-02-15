set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set nobackup		" Dont create backup files
syntax on		" Syntax on
set autoindent		" Autoindent

let vimdir=$HOME."/.local/share/vim/swap"
if !isdirectory(vimdir)
    call mkdir(vimdir, "p")
endif

set dir=~/.local/share/vim/swap
set viminfo+=n~/.local/share/vim/info
"set backupdir=~/.local/share/vim/backup
