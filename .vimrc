" vim: fdm=marker
" vimrc
"
"  License {{{1
"    Copyright (c) 2015 Janvier Anonical
"
"
"  Vim package manager {{{1
"Setup {{{2
if has('vim_starting')
	set nocompatible	" Vim over Vi
endif

" Filetype detection, plugins, indent, syntax {{{1
if has('autocmd')
	filetype plugin indent on	" turn on filetype detection, plugins and indent
endif

if has('syntax') && !exists('g:syntax_on')
	syntax enable	" turn on syntax highlighting
endif

" Builtin plugins {{{1
" Load matchit.vim, but only if user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif

" Load the main plugin for a nice man viewer
runtime! ftplugin/man.vim

" Other package setup and configuration {{{1

" Pathogen
execute pathogen#infect()

" Syntax highlighting and spelling {{{1
" Ignore colorscheme error if chosen color scheme does not exist
silent! colorscheme gruvbox
set background=dark " dark mode

" gruvbox
if !has('gui_running')
	let g:gruvbox_italic=0
endif

" Multi-byte characters {{{1
set encoding=utf-8

" Terminal settings {{{1
behave xterm
set ttyfast

if &term == "xtermc" || &term == "linux" || &term == "xterm-256color"
	set t_Co=256
endif

if &term == "xterm" || &term =~ "vt"
	if has('terminfo')
		set t_Co=8
		set t_Sf=[3%p1%dm
		set t_Sb=[4%p1%dm
	else
		set t_Co=8
		set t_Sf=[3%%dm
		set t_Sb=[4%%dm
	endif
endif

" Moving around, searching & patterns {{{1
set nostartofline	" keep cursor in the same column for long-range motion commands
set incsearch		" highlight pattern matches as you type
set ignorecase		" ignore case when using a search pattern
set smartcase		" override 'ignorecase' when pattern has uppercase chars

" Displaying text {{{1
"set list		" show list chars
" Define chars to show when showing list chars
"set listchars=tab:,trail:\xb7,extends:\xbb,preceeds:\xab,nbsp:\xa7
set showbreak=←\ \ 		" string to put before wrapped screen lines

set sidescrolloff=15	" min # of columns to keep left/right cursor
set sidescroll=1	" min # of columns to scroll horizontally
set linebreak		" wrap intelligently lines longer than the window
set number	" show line numbers
