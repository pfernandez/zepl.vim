" Description:  Send a block to the REPL.
" File:         zepl/contrib/blocks.vim
" Help:         :help zepl-blocks
" Legal:        No rights reserved.  Public domain.

function! zepl#contrib#blocks#send_block() abort
    let conf = 'block_delims'
    let block_delims = zepl#config(conf, get(g:, 'zepl_'.conf, []))

    if len(block_delims) != 2
        echohl ErrorMsg
        echomsg "No (or invalid) block delimiters set.  See ':help zepl-blocks' for info on configuring this."
        echohl NONE
    else
        let [start_delim, end_delim] = block_delims

        let startpos = searchpairpos(start_delim, '', end_delim, 'zcbnW')
        let endpos = searchpos(end_delim, 'zcnW')

        " No start position detected, try again.
        if endpos[0] && !startpos[0]
            let startpos = searchpos(start_delim, 'cnW')
            let endpos = searchpos(end_delim, 'znW')
        endif

        " No end position was detected, try again.
        if startpos[0] && !endpos[0]
            let endpos = searchpos(end_delim, 'cbnW')
        endif

        if (!endpos[0] || !startpos[0]) || (endpos[0] == startpos[0] && startpos[1] > endpos[1])
            echohl WarningMsg
            echo 'No block found under cursor'
            echohl NONE
        else
            let block = getline(startpos[0], endpos[0])

            " Trim block to correct column positions.
            if !empty(block)
                if endpos[1] == 1
                    call remove(block, -1)
                else
                    let block[-1] = block[-1][:endpos[1] - 1]
                endif

                let block[0] = block[0][startpos[1] - 1:]

                if empty(block[0])
                    call remove(block, 0)
                endif
            endif

            return zepl#send(block)
        endif
    endif
endfunction

command! -nargs=0 -bar ReplSendBlock :call zepl#contrib#blocks#send_block()

nnoremap <silent> <Plug>ReplSendBlock :<C-u>ReplSendBlock<CR>

if get(g:, 'zepl_default_maps', 1)
    nmap <silent> gz<CR> <Plug>ReplSendBlock
endif
