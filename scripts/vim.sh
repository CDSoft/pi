#!/bin/bash

########################################################################
# Post Install (pi): lightweigth Debian « distribution »
#
# Copyright (C) 2015, 2016 Christophe Delord
# http://www.cdsoft.fr/pi
#
# This file is part of Post Install (PI)
#
# PI is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PI is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with PI.  If not, see <http://www.gnu.org/licenses/>.
########################################################################

configure_vim()
{
    title "Vim configuration"

    cat <<\EOF > /home/$USERNAME/.vimrc
" Vim configuration

" Startup {{{
set nocompatible " use vim power
set loadplugins
filetype plugin on
filetype indent on
filetype on
" }}}

" File encryption {{{
set cm=blowfish2
" }}}

" File types {{{
au BufRead,BufNewFile *.md,*.i set filetype=markdown
autocmd Filetype markdown setlocal spell
autocmd Filetype markdown set spelllang=en,fr

au BufRead,BufNewFile *.pl set filetype=prolog
" }}}

" Keyboard {{{
let mapleader = "²"
let g:mapleader = "²"
" }}}

" Automatic layout {{{
set autoindent
set backspace=indent,eol,start
set expandtab
set shiftround " round indent to multiple of shiftwidth
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
" }}}

" Selection {{{
"set clipboard=autoselect
"set mouse=a
" }}}

" Search {{{
set hlsearch
" set ignorecase
set incsearch
set infercase " when ignorecase, the completion also modifies the case
set magic
set showmatch
" set smartcase
" }}}

" Display {{{
syntax enable
set background=light
colorscheme zellner
set antialias
" show the current line and column in the current window
"au WinLeave * set nocursorline nocursorcolumn
"au WinEnter * set cursorline cursorcolumn
set noequalalways " do not resize other windows when splitting
"set foldcolumn=3
"set foldenable
"set foldmethod=syntax
set guifont=Monospace\ 8
set guioptions+=a " autoselect
set guioptions-=m " no menu bar
set guioptions+=t " tearoff menu items
set guioptions-=T " no tool bar
set guioptions+=r " right-hand scrollbar
set guioptions+=L " left-hand scrollbar is vertical split
set guioptions+=b " bottom scrollbar
set laststatus=2
set number
set numberwidth=4
set ruler
set showcmd
set suffixes+=.pyc
set visualbell
set wildignore=*.o,*~,*.pyc,*.bak
set wildmenu
set wildmode=full
set nowrap
" }}}

" Netrw {{{
let g:netrw_liststyle= 4 " tree style
" }}}

" Directories {{{
set autochdir " the current directory is the directory of the current file
set browsedir=buffer " browse the directory of the buffer
" }}}

" Files {{{
set nobomb " add a BOM when writing a UTF-8 file
set encoding=utf-8
set fileencoding=utf-8
set fsync
" }}}

" Make {{{
set makeprg=make " '%' '#' : current and alternate file name
" }}}

" Vimgrep {{{

" Search the word under the cursor in all files
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j ../**" <Bar> cw<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction


function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" }}}

" HTML export {{{
let g:html_number_lines = 0
" }}}

" vim: set ts=4 sw=4 foldmethod=marker :
EOF
    chown $USERNAME:$USERNAME /home/$USERNAME/.vimrc
    mkdir -p /home/$USERNAME/.vim
    if $FORCE
    then
        wget http://cdsoft.fr/todo/todo.tgz -O /tmp/todo.tgz && tar xzf /tmp/todo.tgz -C /home/$USERNAME/.vim/
        wget http://cdsoft.fr/pwd/pwd.tgz -O /tmp/pwd.tgz && tar xzf /tmp/pwd.tgz -C /home/$USERNAME/.vim/
    fi

}

configure_vim
