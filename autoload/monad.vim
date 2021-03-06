" monad - An implementation of monad in Vim script
" Version: @@VERSION@@
" Copyright (C) 2011 kana <http://whileimautomaton.net/>
" License: So-called MIT/X license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
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
" Misc.  "{{{1

let s:prototype = {}

function! s:prototype.make(name)
  return extend(
  \   {
  \     'type': {
  \       'base': self,
  \       'name': a:name,
  \     },
  \   },
  \   self,
  \   'keep'
  \ )
endfunction

function! s:prototype.bind(a_to_m_b, ...)
  let cont = {}

  if type(a:a_to_m_b) == type(function('function'))
    let cont.a_to_m_b = a:a_to_m_b
  else  " type(a:a_to_m_b) == type('')
    let cont.a_to_m_b = function(a:a_to_m_b)
  endif

  let cont.partial_arguments = a:000

  let cont.inue = function('monad#_bind')

  return self.__bind__(cont)
endfunction

function! monad#_bind(a) dict
  return call(self.a_to_m_b, self.partial_arguments + [a:a])
endfunction

function! s:prototype.__bind__(cont)
  throw 'bind operator is not defined for type: ' . self.type.name
endfunction

function! s:prototype.return(a)
  return extend({'value': a:a}, self, 'keep')
endfunction




" Public  "{{{1

function! monad#create_type_constructor(name)
  return s:prototype.make(a:name)
endfunction




" __END__  "{{{1
" vim: foldmethod=marker
