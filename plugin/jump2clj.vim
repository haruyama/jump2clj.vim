" File: jump2clj.vim
" Author: Takeshi Nakata (nakatatakeshi AT gmail DOT com)
"         HARUYAMA Seigo <haruyama@unixuser.org>
" Version: 0.2
" Copyright: Copyright (C) 2002- Takeshi Nakata
"            Copyright (C) 2012- HARUYAMA Seigo
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Original(Jump2pm): https://github.com/nakatakeshi/jump2pm.vim

" -----------------
" Description
" -----------------
"
"   jump to clj file if your cursor is on a namespace string.
"
" -------------------
" Installation and How to use
" -------------------
"
"   You add a NeoBundle setting:
"
"   NeoBundle 'git://github.com/haruyama/jump2clj.vim'
"
"   and add ~/.vim/after/ftplugin/clojure.vim:
"
"   setl includeexpr=jump2clj#jump('gf')
"
" --------------------------------------
" " split window vertically and jump to clj file.
" noremap fg :call jump2clj#jump('vne')<ENTER>
" " jump to clj file in current window
" noremap ff :call jump2clj#jump('e')<ENTER>
" " split window horizontal, and ...
" noremap fd :call jump2clj#jump('sp')<ENTER>
" " open tab, and ...
" noremap fd :call jump2clj#jump('tabe')<ENTER>
" " for visual mode, use jump2clj#jumpv
" vnoremap fg :call jump2clj#jumpv('vne')<ENTER>
" ---------------------------------------
if exists('g:loaded_jump2clj')
  finish
endif
let g:loaded_jump2clj = 1

let s:save_cpo = &cpo
set cpo&vim


let &cpo = s:save_cpo
unlet s:save_cpo
