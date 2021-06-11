" Description:  Send characters to the REPL and easily focus it.
" File:         zepl/contrib/control_characters.vim
" Help:         :help zepl-control_characters
" Legal:        No rights reserved.  Public domain.
"
function! s:jump_also_to_tab() abort
  let swb = &switchbuf
  set switchbuf+=usetab
  call zepl#jump()
  let &switchbuf=swb
endfunction
command! -nargs=0 ReplFocus call s:jump_also_to_tab()
nnoremap <silent> <Plug>ReplFocus :<C-u>ReplFocus<CR>

function! s:send_key() abort
  " Get a single key
  let key = getchar()
  " If the key wasn't escape, send it to the REPL
  if key !=# 27
    call zepl#send(nr2char(key), 1)
  endif
endfunction
command! -nargs=0 ReplSendKey call s:send_key()
nnoremap <silent> <Plug>ReplSendKey :<C-u>ReplSendKey<CR>

if get(g:, 'zepl_default_maps', 1)
  nmap <silent> gzc <Plug>ReplSendKey
  nmap <silent> gz<TAB> <Plug>ReplFocus
endif
