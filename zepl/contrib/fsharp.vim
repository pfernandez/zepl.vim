" Description:  Text formatter for F# code.
" File:         zepl/contrib/fsharp.vim
" Help:         :help zepl-fsharp
" Legal:        No rights reserved.  Public domain.

function! zepl#contrib#fsharp#formatter(lines) abort
    let lines = a:lines

    " Remove empty lines from start of code block.
    while !empty(lines)
        if lines[0] =~# '\m^\s*$'
            call remove(lines, 0)
        else | break
        endif
    endwhile

    " Remove empty lines from end of code block.
    let idx = len(lines) - 1
    while idx >= 0
        if lines[idx] =~# '\m^\s*$'
            call remove(lines, idx)
            let idx -= 1
        else | break
        endif
    endwhile

    if !empty(lines)
        " Use common indentation.
        let depth = len(matchstr(lines[0], '\m\C^\s*'))
        let lines = map(lines, 'v:val[' . depth . ':]')
    endif

    if empty(lines)
        return ''
    else
        return join(lines, "\<CR>") . ";;\<CR>"
    endif
endfunction

" EXAMPLE: Configure zepl.vim to use the F# formatter in F# buffers.
"
"     runtime zepl/contrib/fsharp.vim
"     autocmd! FileType fsharp let b:repl_config = {
"                 \   'cmd': 'dotnet fsi',
"                 \   'formatter': function('zepl#contrib#fsharp#formatter')
"                 \ }
