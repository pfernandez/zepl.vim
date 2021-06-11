" Description:  Load files into the REPL.
" File:         zepl/contrib/load_file.vim
" Help:         :help zepl-load_files
" Legal:        No rights reserved.  Public domain.

function! zepl#contrib#load_files#load(...) abort
    " The dictionary entry identifying the command to laod a file
    let load_cmd = zepl#config('load_file', '')
    if empty(load_cmd)
      echoerr "Could not load file(s) into REPL.  No value for 'load_file' set in Zepl configuration.  See ':help zepl-load_files' for more details."
    else
      let fns = (a:0 > 0 ? a:000 : [expand('%')])
      let fns = map(copy(fns), 'fnamemodify(expand(v:val), ":p")')
      " let fns = filter(uniq(copy(fns)), 'filereadable(v:val)')
      let cmds = map(copy(fns), 'printf(load_cmd, v:val)')
      call zepl#send(cmds)
    endif
endfunction

command! -nargs=* -complete=file -bar ReplLoadFile :call zepl#contrib#load_files#load(<f-args>)

nnoremap <silent> <Plug>ReplLoadFile :<C-u>ReplLoadFile<CR>

if get(g:, 'zepl_default_maps', 1)
    nmap <silent> gz. <Plug>ReplLoadFile
endif
