" vim: fdm=marker
" vimrc
"
" About {{{1
" Maintainer:
" 	Janvier Anonical - janvierja
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

" Ignore colorscheme error if chosen color scheme does not exist
silent! colorscheme gruvbox
set background=dark " dark mode

" gruvbox
if !has('gui_running')
    let g:gruvbox_italic=0
endif

if exists('+colorcolumn')
    set colorcolumn=120
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
set list		" show list chars
" Define chars to show when showing list chars
if &listchars ==# 'eol:$'
    let &listchars = "tab:\xb8 ,trail:\xb7,extends:\xbb,precedes:\xab,nbsp:\xa7"
    if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
        let &listchars = "tab:\u02db ,trail:\u2026,extends:\u00bb,precedes:\u00ab,nbsp:\u26ad"
    endif
endif

set showbreak=←\ \ 		" string to put before wrapped screen lines

set sidescrolloff=15	" min # of columns to keep left/right cursor
set sidescroll=1	    " min # of columns to scroll horizontally
set linebreak		    " wrap intelligently lines longer than the window
set number	            " show line numbers

" Multiple windows {{{1
set laststatus=2	    " show a status line, even when there's only one window
set hidden		        " allow switching away from current buffer w/o writing
set switchbuf=usetab	" jump to 1st open window which contains specified buffer, even if the buffer is in another tab.
                        " TODO: add 'split' if you want to split the window for a quickfix error window
set helpheight=30	    " set window height when opening vim help windows


" Messages and info {{{1
set showcmd		        " in status bar, show incomplete commands as they are
set noshowmode		    " don't display the current mode. This info is already shown in the Airline status bar
set ruler
set confirm

" Selecting text {{{1
set clipboard=unnamed	" Yank to the system clipboard by default

" Editing text {{{1
set backspace=indent,eol,start  " backspace over everything

if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j 	    " delete comment char on second line when joining two commented lines
endif
set showmatch  			        " when inserting a bracket, briefly jump to its match
set nojoinspaces	  	        " Use only one space after '.' when joining lines, instead of two
set completeopt+=longest 	    " better omni-complete menu
set nrformats-=octal            " don't treat numbers with leading zeros as octal when incrementing/decrementing

" Tabs and indenting {{{1
set tabstop=4             " tab = 4 spaces
set shiftwidth=4          " autoindent indents 4 spaces
set smarttab              " <TAB> in front of line inserts 'shiftwidth' blanks
set shiftround            " round to 'shiftwidth' for "<<" and ">>"
set expandtab

"  Folding {{{1
if has('folding')
  set nofoldenable 		         " When opening files, all folds open by default
  set foldtext=NeatFoldText()  " Use a custom foldtext function
endif

"  Diff mode {{{1
set diffopt+=vertical       " start diff mode with vertical splits by default

"  Mapping {{{1
" Don't use Ex mode, use Q for formatting
map Q gq

" Leader is a comma
let mapleader=","

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Clear highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Syntax highlighting and spelling {{{1
map <leader>ss :setlocal spell!<cr>

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" For vim-fugitive
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>


"  Reading and writing files {{{1
set autoread			    " Automatically re-read files changed outside of Vim
set ffs=unix,dos,mac        " Use Unix as the standard

"  The swap file {{{1
" ----------------------------------------------------------------------------

" Set swap file, backup and undo directories to sensible locations
" Taken from https://github.com/tpope/vim-sensible
" The trailing double '//' on the filenames cause Vim to create undo, backup, and swap filenames using the full path
" to the file, substituting '%' for '/', e.g. '%Users%bob%foo.txt'

let s:dir = has('win32') ? '$APPDATA/Vim' : match(system('uname'), "Darwin") > -1 ? '~/Library/Vim' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'

if isdirectory(expand(s:dir))
  if &directory =~# '^\.,'
    let &directory = expand(s:dir) . '/swap//,' . &directory
  endif
  if &backupdir =~# '^\.,'
    let &backupdir = expand(s:dir) . '/backup//,' . &backupdir
  endif
  if exists('+undodir') && &undodir =~# '^\.\%(,\|$\)'
    let &undodir = expand(s:dir) . '/undo//,' . &undodir
  endif
endif

if exists('+undofile')
  set undofile
endif

"  Command line editing {{{1
set history=200    " Save more commands in history
                   " See Practical Vim, by Drew Neil, pg 68

set wildmode=list:longest,full

" File tab completion ignores these file patterns
" Mac files/dirs
if match(system('uname'), "Darwin") > -1
  set wildignore+=.CFUserTextEncoding,
        \*/.Trash/*,
        \*/Applications/*,
        \*/Library/*,
        \*/Movies/*,
        \*/Music/*,
        \*/Pictures/*,
        \.DS_Store
endif

" ignore binary files
set wildignore+=*.exe,*.png,*.jpg,*.gif,*.doc,*.mov,*.xls,*.msi
" Vim files
set wildignore+=*.sw?,*.bak,tags
" Chef
set wildignore+=*/.chef/checksums/*

set wildmenu

" Add guard around 'wildignorecase' to prevent terminal vim error
if exists('&wildignorecase')
  set wildignorecase
endif

"  Executing external commands {{{1
if has("win32") || has("gui_win32")
  if executable("PowerShell")
    " Set PowerShell as the shell for running external ! commands
    " http://stackoverflow.com/questions/7605917/system-with-powershell-in-vim
    set shell=PowerShell
    set shellcmdflag=-ExecutionPolicy\ RemoteSigned\ -Command
    set shellquote=\"
    " shellxquote must be a literal space character.
    set shellxquote=
  endif
endif

"  Running make and jumping to errors {{{1
if executable('grep')
  set grepprg=grep\ --line-number\ -rIH\ --exclude-dir=tmp\ --exclude-dir=.git\ --exclude=tags\ $*\ /dev/null
endif

"  Various {{{1
set gdefault              " For :substitute, use the /g flag by default

" Don't save global options. These should be set in vimrc
" Idea from tpope/vim-sensible
set sessionoptions-=options

" Autocmds {{{1

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
" Remember info about open buffers on close
set viminfo^=%

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
" From https://github.com/thoughtbot/dotfiles/blob/master/vimrc
autocmd BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

func! RemoveTrailingSpaces()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWritePost * call MakeScriptExecutable()
autocmd BufWrite * call RemoveTrailingSpaces()

" Number of spaces that a pre-existing tab is equal to.
" For the amount of space used for a new tab use shiftwidth.
autocmd BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=8

" Settings for Shell scripts,C/C++, C#, and Java
autocmd FileType cc,cpp,c,cs,java set shiftwidth=4 expandtab cindent cinoptions=:.5s,g.5s,i.5s formatoptions-=c formatoptions-=o formatoptions-=r
autocmd FileType sh set shiftwidth=4 expandtab
autocmd FileType python set shiftwidth=4 expandtab
autocmd FileType perl set shiftwidth=4 expandtab

autocmd BufRead,BufNewFile *.gradle set shiftwidth=4 noexpandtab syntax=groovy
autocmd BufRead,BufNewFile Makefile*,*.mk set noexpandtab

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

au BufNewFile * set fileformat=unix

" Returns true if paste mode is enabled
function! HasPaste()
  if &paste
    return '**PASTE MODE**  '
  en
  return ''
endfunction

" If it is a shebang script change file mode to make it executable.
function MakeScriptExecutable()
  if getline(1) =~ "^#!"
    !chmod +x %
  endif
endfunction

" Check perl syntax; if it is a shebang script change file mode to make it executable.
function SavePerl()
  let ext = expand("%:e")
  if ext == "pl"
    !perl -Wc %
    if getline(1) =~ "^#!"
      !chmod +x %
    endif
  endif
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
