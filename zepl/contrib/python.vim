" Description:  Text formatter for Python code.
" File:         zepl/contrib/python.vim
" Help:         :help zepl-python
" Legal:        No rights reserved.  Public domain.

function! zepl#contrib#python#formatter(lines)
    " Remove empty lines.
    let lines = filter(a:lines, {_, val -> val !~# '\m\C^[ \t\n\r\e\b]*$'})

    if !empty(lines)
        " Use common indentation.
        let depth = len(matchstr(lines[0], '\m\C^\s*'))
        let lines = map(lines, 'v:val[' . depth . ':]')

        " Add empty line to end of multi-line code (replaced by <CR> later on).
        if len(lines) > 1
            let lines = add(lines, '')
        endif
    endif

    return join(lines, "\<CR>") . "\<CR>"
endfunction

" EXAMPLE: Configure zepl.vim to use the Python formatter in Python buffers.
"
"     runtime zepl/contrib/python.vim
"     autocmd! FileType python let b:repl_config = {
"                 \   'cmd': 'python',
"                 \   'formatter': function('zepl#contrib#python#formatter')
"                 \ }
