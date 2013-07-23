" enable vim-pathogen
runtime bundle/vim-pathogen-master/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()


"execute pathogen#infect()
" enabling syntax highlighting with default coloring
syntax on
" enable loading the plugin files and the indentation for specific file types.
filetype plugin indent on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

"set 256 color terminal
set t_Co=256

" Set color scheme:
colorscheme distinguished

" set line numbers on
set number 
