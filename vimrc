" Maintainer: jan "johnny" chmiel
"
" Some tricks taken from amix http://amix.dk/vim/vimrc.html
" and http://bitbucket.org/sjl/dotfiles/src/tip/vim/

set nocompatible " be iMproved
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" Load the  plugins.
Bundle 'corntrace/bufexplorer'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'The-NERD-tree'
Bundle 'ervandew/supertab'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'

filetype plugin on
filetype indent on

" Set map leader for mappings
let mapleader = ","
let g:mapleader = ","
" Set leader for easymotion plugin.
let g:EasyMotion_leader_key ='<Leader>'
let g:EasyMotion_mapping_k = '<Leader>h'
let g:EasyMotion_mapping_j = '<Leader>k'
map <leader>c <c+_>

" Fast saving.
nmap <leader>w :w!<cr>

" Fast editing of the .vimrc.
map <leader>e :e! ~/.vimrc<cr>
" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc

" Use TABS only and shift by 4 characters
set noexpandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Indentation
set smartindent
set autoindent

" Syntax highlighting and highlight for search
syntax on
set hlsearch
set incsearch

" Show TABS in a special way
set listchars=tab:>-            " show TABS as ">---"
set list                        "show listchars

set backspace=indent,eol,start
set mouse=a
set history=700
set confirm                     " Ask for confirmation rather then refuse certain commands
set history=500                 " Keep 50 lines of command line history
set ruler                       " Show the cursor position all the time
set showcmd                     " Display incomplete commands
set scrolloff=7                 " Scrolling margin
set showbreak=>>                " String to put at the start of lines that have been wrapped
set nowrap                      " Don't wrap
set number                      " Line numbers are useful
set showmatch                   " When a bracket is inserted, briefly jump to the matching one
set foldenable                  " Make folding possible
set splitbelow                  " Create new window below current one
set previewheight=6             " Height of the quickfix window
set title                       " Puts name of edited file into window title (xterm, putty, etc.)

set lazyredraw                  " Don't update screen while executing macros
set laststatus=2                " Always show statusbar

set formatoptions-=l
"set shortmess+=I                " Don't give the intro message when starting VIM

set rulerformat=%l,%c%V%=#%n\ %3p%%         " Content of the ruler string
set switchbuf=useopen,split  " Method of opening file in quickfix
set shell=/bin/bash

" Backups
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups
set noswapfile                    " It's 2011, Vim.


autocmd FileType text setlocal textwidth=80

autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" Man plugin - "K" runs man for word under cursor.
source $VIMRUNTIME/ftplugin/man.vim

" From an idea by Michael Naumann
" In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"  Some other abbreviations
iab  Zdate  <C-R>=strftime("%y%m%d")<CR>
iab  Ztime  <C-R>=strftime("%H:%M:%S")<CR>
iab  Zfilename <C-R>=expand("%:t:r")<CR>
iab  Zfilepath <C-R>=expand("%:p")<CR>

" F11 switches paste on and off
set pastetoggle=<F11>
set wmh=0
map <C-K> <C-W>j<C-W>_
map <C-H> <C-W>k<C-W>_
map <C-C> <C-W>c
"make + bledy
nmap <F5> :cnext<CR>
imap <F5> <ESC>:cnext<CR>
nmap <F6> :cprevious<CR>
imap <F6> <ESC>:cprevious<CR>
map <F7> :call SpellLang()<CR>
imap <F7> <C-o>:call SpellLang()<CR>
" F8 uruchamia make w aktualnym katalogu
":command -nargs=* Make make <args> | cwindow 3
:command -nargs=* Make make<args>
map <F8> :Make -j4<CR>

map  <silent> <F10> :TlistToggle<CR>
imap <silent> <F10> <ESC>:TalistToggle<CR>
" nmap <F12> :call SwitchPaste()<CR>
" imap <F12> <ESC>:call SwitchPaste()<CR>
nmap <F12> :call SwitchMouse()<CR>
imap <F12> <ESC>:call SwitchMouse()<CR>
map <F4> :set nu! <CR>
map <F3> :set hls!<bar>set hls?<CR>
map <silent> <Leader>nt :NERDTreeToggle<CR>

" function used to switch mouse on and off
function! SwitchMouse()
 if &mouse == "a"
  set mouse=
  echo "Mouse OFF"
 else
  set mouse=a
  echo "Mouse ON"
 endif
endfunction

" auto H headers guarding in new files
function! s:insert_gates()
    let gatename = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g") . "__"
    execute "normal i#ifndef " . gatename
    execute "normal o#define " . gatename . "   "
    execute "normal 2o"
    execute "normal Go#endif /* " . gatename . " */"
    normal kk
endfunction
autocmd  BufNewFile *.{h,hpp} call <SID>insert_gates() 

" appropiate MAN pages
" if we are in C/C++ file set browsed man sections to useful for programmist,
" if we are in SH/CSH file - set sections to useful for script-writter
autocmd FileType c,cpp  let $MANSECT="2:3:7:4"
autocmd FileType sh,csh let $MANSECT="1:5:8:4"

set tags+=~/.vim/systags
set dictionary+=~/.vim/dictionary/tex_dict

" taken from Damien Conway, after OSCON2008 presentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap v <C-V>
nnoremap <C-V> v

" Make BS/DEL work as expected in visual modes
vmap <BS> x

" Execute current paragraph or visual block as Vimmish commands...
vmap <silent> <C-E> :<C-U>'<,'>! cheddar<CR>
" map <C-M> :%! headache<CR>
map <silent> =e :call DemoCommand()<CR>
vmap <silent> =e :<C-U>call DemoCommand(1)<CR>

highlight WHITE_ON_RED    ctermfg=white  ctermbg=red

function! DemoCommand (...)
     " Cache current state info...
     let orig_buffer = getline('w0','w$')
     let orig_match  = matcharg(1)

     " Grab either visual blocj (if a:0) or else current para...
     if a:0
         let @@ = join(getline("'<","'>"), "\n")
     else
         silent normal vipy
     endif

     " Highlight the selected text using match #1...
     "match WHITE_ON_RED /\%V/
     redraw
     sleep 500m

     " Join up \-continued lines...
     execute substitute(@@, '\n\s*\\', ' ', 'g')

     " Redraw if screen got messed up...
     if getline('w0','w$') != orig_buffer
         redraw
         sleep 1000m
     endif

endfunction

function! CommasToBullets()
perl <<END_PERL
  ($line) = $curwin->Cursor;
  $curbuf->Append($line, map "\t* $_",
    map { /^\s*(.*?)\s*$/ ? $1 : $_ }
    split /,\s*/,
    $curbuf->Get($line));
  $curbuf->Delete($line);
END_PERL
endfunction

nmap =b :call CommasToBullets()<CR><CR>

" </DCONWAY-OSCON2008>

" set a colorscheme
set t_Co=256
colorscheme wombat256mod

" file type specifics
au BufRead,BufNewFile *.go set filetype=go
autocmd BufNewFile  *.go	0r ~/.vim/skel/skeleton.go
autocmd BufNewFile  *.py	0r ~/.vim/skel/skeleton.py
autocmd BufNewFile  *.php	0r ~/.vim/skel/skeleton.php

" For colemak keyboard
noremap h k
noremap j h
noremap k j
vmap <BS> <Left>

" Map arrows to window movements
imap <Left> <C-W><Left>
imap <Right> <C-W><Right>
imap <Down> <C-W><Down>
imap <Up> <C-W><Up>
nmap <Left> <C-W><Left>
nmap <Right> <C-W><Right>
nmap <Down> <C-W><Down>
nmap <Up> <C-W><Up>

" A spell checker
let g:myLangList = [ "nospell", "en_us" ]

function! SpellLang()
  if !exists( "b:myLang" )
    let b:myLang=0
  endif

  let b:myLang = b:myLang + 1
  if b:myLang >= len(g:myLangList) | let b:myLang = 0 | endif

  if b:myLang == 0 | set nospell | endif
  if b:myLang == 1 | setlocal spell spelllang=en_us | endif

  echo "language:" g:myLangList[b:myLang]
endf

"set statusline=%<%f%=%r%y%m\ %c\ %{fugitive#statusline()}\ %10(%l/%L%)
