" basics
syn on
set expandtab
set shiftwidth=4
set tabstop=4
set autoindent
set smarttab
set visualbell
set splitbelow
set splitright
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs
set nojoinspaces

" navigate buffers with <C-p> and <C-n>
set hidden
map <c-p> :bp<CR>
map <c-n> :bn<CR>
map <c-x> :bd<CR>

" Search defaults
set hlsearch
set ignorecase
set smartcase
set incsearch
