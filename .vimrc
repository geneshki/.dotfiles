" enable vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()


"execute pathogen#infect()
" enabling syntax highlighting with default coloring
syntax on

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on
" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

"set 256 color terminal
set t_Co=256

" Set color scheme:
" colorscheme distinguished
colorscheme wombat256
" colorscheme BlackSea

" set line numbers on
set number 
