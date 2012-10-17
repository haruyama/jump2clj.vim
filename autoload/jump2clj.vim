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
let s:save_cpo = &cpo
set cpo&vim

function! jump2clj#jump(cmd)
  return s:jump_with_clj_path(a:cmd, expand("<cfile>"))
endfunction

function! jump2clj#jumpv(cmd)
  return s:jump_with_clj_path(a:cmd, getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1])
endfunction

function! s:jump_with_clj_path(cmd, string)

  let l:wrapscan_flag = &wrapscan
  let l:cur_lib_path  = s:get_current_lib_path()

  let l:clj_path = substitute(a:string,'/.*$','','')
  let l:clj_path = substitute(l:clj_path,'\.','/','g')
  let l:function = ''
  if a:string =~ '/'
    let l:function = substitute(a:string,'^.*/','','')
  endif

  let l:clj_path = substitute(l:clj_path,'$','.clj','')

  let l:path = &path
  if l:cur_lib_path != ['']
    let l:path = l:path . ',' . join(l:cur_lib_path, ',')
  endif

  let l:path_arr = split(l:path, ',')

  for l:a_path in l:path_arr
    if filereadable(l:a_path . '/' . l:clj_path)
      if a:cmd == 'gf'
        return l:a_path . '/' . l:clj_path
      else
        exe a:cmd . " " . l:a_path . '/' . l:clj_path
        if l:function != ''
          " move to head of file
          exe ":1"
          try
            " throw E385 if not found when search / cmd executed
            :set nowrapscan
            exe "/defn\s\+" . l:function
          catch/E385/
          endtry
        call s:set_wrapscan_if_on(l:wrapscan_flag)
        endif
        return
      endif
    endif
  endfor
endfunction

function! s:set_wrapscan_if_on(flag)
  if a:flag == 1
    :set wrapscan
  endif
endfunction

function! s:get_current_lib_path()
  " get full file path of current opened file
  let l:cur_file      = expand("%:p")
  if exists("g:jump2clj_search_lib_dir")
    let s:search_lib_dir = g:jump2clj_search_lib_dir
  else
    let s:search_lib_dir = [ 'src' , 'test' ]
  endif

  while 1
    if l:cur_file == ''
      return
    endif
    for l:search_lib in s:search_lib_dir
      let l:cur_file = substitute(substitute(l:cur_file,'/[^(/)]*$','','g'),'$','/' . l:search_lib ,'g')
      if isdirectory(l:cur_file)
        return [l:cur_file]
      endif
    endfor
    let l:cur_file = substitute(l:cur_file,'/[^(/)]*$','','g')
  endwhile
  return ['']
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
