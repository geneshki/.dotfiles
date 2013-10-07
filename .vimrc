" turn off compatibility
set nocompatible

" enable vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()


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

" set width of a tab symbol
set tabstop=2
" set number of columns a text is indented with '>>' and '<<'
set shiftwidth=2
" use spaces instead of tabs
set expandtab
" enable smart indent
set smartindent
set autoindent
set nosmarttab

" set textwidth and wrapmargin for battling unwanted wrapping which makes lines long.
set textwidth=0
set wrapmargin=0
" set textwidth=80 this cuts the line before the word that exceeds the Xth
" char as shown in this comment.

" set ColorColumn to designate special columns.
highlight ColorColumn ctermbg=235 guibg=#2c2d27
" set 80th and over 120th columns background.
let &colorcolumn="80,".join(range(120,999),",")

" highlights the current line
set cursorline

" encoding
set encoding=utf-8


"Always show status line
set laststatus=2

" invisible character(tabstops, EOLs) colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Use the same symbols as TextMate for tabstops and EOLs
" as TextMate for tabstops and EOLs
set listchars=eol:¬,tab:>-,trail:~


" custom status line
set statusline=%t, " tail of filename
set statusline+=[%{&fo}], " format options
set statusline+=%= " left right separator
set statusline+=%c, " cursor column
set statusline+=%l/%L " cursor line / total lines

" format options
set fo-=c " no auto-wrapping for comments
set fo-=t " no auto-wrapping for text

" Highlight Trailing Whitespace
highlight SpecialKey ctermfg=DarkGray ctermbg=Black

" Mappings
let mapleader = ";"
" toggle list option
nnoremap <leader>l :set list!<cr>
" switch active window
map <Leader>w <C-w>w
" save while in insert mode with CTRL-S
inoremap <C-s> <esc>:w<cr>
" save with CTRL-S in normal mode
nnoremap <C-s> :w<cr>
" avoid evil esc key
inoremap <C-j> <esc>
