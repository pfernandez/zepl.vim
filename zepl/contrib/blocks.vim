" Description:  Send a block to the REPL.
" File:         zepl/contrib/blocks.vim
" Help:         :help zepl-blocks
" Legal:        No rights reserved.  Public domain.

" FIXME: end delimiter not found when cursor isn't at the start of the delimiter.
" FIXME: start delimiter not found when cursor is just before the start of the delimiter.
" TODO:  option to let end delimiter also be the end of the file?
" TODO:  skip rules?

function! zepl#contrib#blocks#send_block(...) abort
    let conf = 'block_delims'
    let block_delims = zepl#config(conf, get(g:, 'zepl_'.conf, []))

    if len(block_delims) != 2
        echohl ErrorMsg
        echomsg "No (or invalid) block delimiters set.  See ':help zepl-blocks' for info on configuring this."
        echohl NONE
    else
        let start_delim = block_delims[0]
        let end_delim = block_delims[1]

        let start_line = search(start_delim, 'cbnW')
        let end_line = searchpair(start_delim, '', end_delim, 'cnW')

        if end_line == 0
            echohl WarningMsg
            echo 'No block found under cursor'
            echohl NONE
        else
            let block = getline(start_line, end_line)
            return zepl#send(block)
        endif
    endif
endfunction

command! -nargs=0 -bar ReplSendBlock :call zepl#contrib#blocks#send_block(<f-args>)

nnoremap <silent> <Plug>ReplSendBlock :<C-u>ReplSendBlock<CR>

if get(g:, 'zepl_default_maps', 1)
    nmap <silent> gz<CR> <Plug>ReplSendBlock
endif
