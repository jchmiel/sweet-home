" Maintainer: Jan "johnny" Chmiel
"
" Some tricks taken from amix http://amix.dk/vim/vimrc.html
" and http://bitbucket.org/sjl/dotfiles/src/tip/vim/

source ~/.vimrc.minimal
" Clear colorscheme set in minimal.vimrc
highlight clear

" Startup vundle to manage plugins.
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

let g:gundo_map_move_older = "k"
let g:gundo_map_move_newer = "h"

let g:pyflakes_use_quickfix = 0

let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplSplitToEdge = 1
let g:miniBufExplSplitBelow=0

" Load the  plugins.
Bundle 'Command-T'
Bundle 'Gundo'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'The-NERD-tree'
Bundle 'corntrace/bufexplorer'
Bundle 'ervandew/supertab'
Bundle 'pyflakes.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'wgibbs/vim-irblack'
Bundle 'grep.vim'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'mru.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'maxbrunsfeld/vim-yankstack'

filetype plugin on
filetype indent on

"Add custom plugins
set rtp+=~/.vim/custom.bundle/\*

" Easy Motion plugin.
" Set leader for easymotion plugin.
let g:EasyMotion_leader_key ='\'
" Easy motion sets far too many mappings,
" leave only useful ones with <Space>.
let g:EasyMotion_mapping_k = '<Space>h'
let g:EasyMotion_mapping_j = '<Space>k'
let g:EasyMotion_mapping_f = '<Space>f'
let g:EasyMotion_mapping_F = '<Space>e'
let g:EasyMotion_mapping_w = '<Space>w'
let g:EasyMotion_mapping_W = '<Space>W'

" Command-T plugin.
let g:CommandTAcceptSelectionMap=['<Space>', '<CR>']
let g:CommandTAcceptSelectionSplitMap='<C-w>'
let g:CommandTCancelMap=['<ESC>', '`']
let g:CommandTSelectPrevMap=['<C-TAB>', '<C-p>']
let g:CommandTSelectNextMap=['<TAB>', '<C-n>']
let g:CommandTToggleFocusMap='<C-f>'
let g:CommandTMaxFiles=20000

" CtrlP plugin
let g:ctrlp_map = '<Leader>p'
let g:ctrlp_cmd = 'CtrlP'

" MRU plugin
map <c-m> :MRU<CR>

" As we have minibufexpl C-K, C-H can be used to switch buffers not tabs.
noremap <C-K> :bn<CR>
noremap <C-H> :bp<CR>
noremap <C-c> :bd<CR>

" Leader mappings
" Fast saving.
nmap <Leader>w :w!<cr>
" Fast editing of the .vimrc.
map <Leader>v :e ~/.vimrc<cr>
map <Leader>u :GundoToggle<CR>

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc

set backspace=indent,eol,start
set mouse=a
set confirm                     " Ask for confirmation rather then refuse certain commands
set history=500                 " Keep 500 lines of command line history
set ruler                       " Show the cursor position all the time
set showcmd                     " Display incomplete commands
set scrolloff=3                 " Scrolling margin
set showbreak=>>                " String to put at the start of lines that have been wrapped
set nowrap                      " Don't wrap
set number                      " Line numbers are useful
set showmatch                   " When a bracket is inserted, briefly jump to the matching one
set foldenable                  " Make folding possible
set foldmethod=indent
set foldlevel=99
set splitbelow                  " Create new window below current one
set previewheight=6             " Height of the quickfix window
set title                       " Puts name of edited file into window title (xterm, putty, etc.)

set lazyredraw                  " Don't update screen while executing macros
set laststatus=2                " Always show statusbar

set formatoptions-=l
"set shortmess+=I               " Don't give the intro message when starting VIM

set rulerformat=%l,%c%V%=#%n\ %3p%%         " Content of the ruler string
set switchbuf=useopen           " Method of opening file in quickfix
set shell=/bin/bash

" Backups
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups

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

" F9 switches paste on and off
set pastetoggle=<F9>
set wmh=0
"make + bledy
imap <F1> <c-o>:call SpellLang()<CR>
nmap <F5> :cnext<CR>
imap <F5> <ESC>:cnext<CR>
nmap <F6> :cprevious<CR>
imap <F6> <ESC>:cprevious<CR>
imap <silent> <F7> <c-o>:copen<CR>
map <silent> <F7> :copen<CR>
" F8 uruchamia make w aktualnym katalogu
":command -nargs=* Make make <args> | cwindow 3
:command -nargs=* Make make<args>
map <F8> :Make -j4<CR>

map  <silent> <F10> :TlistToggle<CR>
imap <silent> <F10> <ESC>:TalistToggle<CR>
nmap <F12> :call SwitchMouse()<CR>
imap <F12> <ESC>:call SwitchMouse()<CR>
map <F4> :set nu! <CR>
map <F3> :Bgrep 
imap <F3> <ESC>:Bgrep 
map <silent> <Leader>nt :NERDTreeToggle<CR>
imap <Leader>gg <ESC>:Ggrep 
map <Leader>gg :Ggrep 
imap <Leader>gb <ESC>:Bgrep 
map <Leader>gb :Bgrep 
" A 'refactor' mapping. Replace a word under the cursor.
noremap <leader>r :%s/\<<C-R><C-W>\>/
vnoremap <leader>r :s/\<<C-R><C-W>\>/

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

" Custom scripts
vmap <silent> <C-E> :<C-U>'<,'>! cheddar<CR>
map <silent> <Leader>i :%! importer<CR>
" Execute current paragraph or visual block as Vimmish commands...
map <silent> <Leader>e :call DemoCommand(1)<CR>
vmap <silent> <Leader>e :<C-U>call DemoCommand(1)<CR>

highlight link ERROR_COLOR Error

function! DemoCommand (...)
     " Cache current state info...
     let orig_buffer = getline('w0','w$')
     let orig_match  = matcharg(1)
     set nolazyredraw

     " Grab either visual blocj (if a:0) or else current para...
     if a:0
         let @@ = join(getline("'<","'>"), "\n")
     else
         silent normal vipy
     endif

     " Highlight the selection in red to give feedback...
    let matchid = matchadd('ERROR_COLOR','\%V')
    redraw
    sleep 500m

    " Remove continuations and convert shell commands, then execute...
    let command = @@
    let command = substitute(command, '^\s*".\{-}\n', '', 'g')
    let command = substitute(command, '\n\s*\\', ' ', 'g')
    let command = substitute(command, '^\s*>\s', ':! ', '' )
    execute command

    " If the buffer changed, hold the highlighting an extra second...
    if getline('w0','w$') != orig_buffer
        redraw
        sleep 1000m
    endif

    " Remove the highlighting...
    call matchdelete(matchid)
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

" set a colorscheme
set t_Co=256
colorscheme wombat256mod

" file type specifics
au BufRead,BufNewFile *.go set filetype=go
autocmd BufNewFile  *.go	0r ~/.vim/skel/skeleton.go
autocmd BufNewFile  *.py	0r ~/.vim/skel/skeleton.py
autocmd BufNewFile  *.php	0r ~/.vim/skel/skeleton.php
au VimLeave * mksession ~/.vimsession

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

" Add g as default to all :s commands.
set gdefault

" Show tabline with tab number, skip directory
if exists("+guioptions")
  set go-=e
endif
if exists("+showtabline")
  function! MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= '%*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let s .= ' '
      let file = bufname(buflist[winnr - 1])
      let file = fnamemodify(file, ':p:t')
      if file == ''
        let file = '[No Name]'
      endif
      let s .= file
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
  endfunction
  set stal=2
  set tabline=%!MyTabLine()
endif

" Keep number column as small as possible.
set numberwidth=1

" Nice menu for completions above command line.
set wildmenu
nm ,o :e 

"cnoremap <silent> <Esc> <C-F>
"cnoremap <silent> <`> <C-F>

" Map these to something more practical.
noremap '' ``
noremap Y y$
noremap Q @q

" Check periodically if the buffers were changed on disk.
set updatetime=2000
autocmd CursorHold * checktime

" Toggle for quickfix window
command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
  else
    copen
  endif
endfunction

" used to track the quickfix window
augroup QFixToggle
 autocmd!
 autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
 autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END
""""""""""""""""""""""""""""""

" YankStack config
nmap <c-p> <Plug>yankstack_substitute_older_paste
nmap <c-n> <Plug>yankstack_substitute_newer_paste
