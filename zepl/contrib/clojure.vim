" Description:  Text formatter for Clojure code.
" File:         zepl/contrib/clojure.vim
" Author:       Paul Fernandez <paul4nandez@gmail.com>
" Help:         :help zepl-clojure
" Legal:        No rights reserved.  Public domain.

function s:stripLeadingEmptyLines(lines) abort
   while !empty(a:lines)
      if a:lines[0] =~# '\m^\s*$'
         call remove(a:lines, 0)
      else
         break
      endif
   endwhile
   return a:lines
endfunction

function s:stripTrailingEmptyLines(lines) abort
   let idx = len(a:lines) - 1
   while idx >= 0
      if a:lines[idx] =~# '\m^\s*$'
         call remove(a:lines, idx)
         let idx -= 1
      else
         break
      endif
   endwhile
   return a:lines
endfunction

function s:normalizeIndents(lines) abort
   let depth = len(matchstr(a:lines[0], '\m\C^\s*'))
   return map(a:lines, 'v:val[' . depth . ':]')
endfunction

function s:processLine(...) abort
   " Remove trailing newlines.
   let line = trim(a:2, "\r\n", 2)

   " Remove two leading spaces added by the Leiningen repl.
   return substitute(line, '\m^\s\s', '', '')
endfunction

function zepl#contrib#clojure#formatter(lines)
   let lines = s:stripLeadingEmptyLines(a:lines)
   let lines = s:stripTrailingEmptyLines(lines)

   if empty(lines)
      return ''
   endif

   let lines = s:normalizeIndents(lines)
   let lines = map(lines, function("s:processLine"))

   return join(lines, "\<CR>") . "\<CR>"
endfunction

" EXAMPLE: Configure zepl.vim to use the Clojure formatter in Clojure buffers.
" (Replace 'plugins/' with your plugin directory path.)
"
"   runtime plugins/zepl.vim/zepl/contrib/clojure.vim
"   let g:repl_config = {
"   \   'clojure': {
"   \     'cmd': filereadable('deps.edn') ? 'clj' : 'lein repl',
"   \     'formatter': function('zepl#contrib#clojure#formatter')
"   \   }
"   \ }
