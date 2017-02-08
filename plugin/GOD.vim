" Easily get links to online documentation
" File:         GOD.vim
" Author:       statox (https://github.com/statox)
" License:      This file is distributed under the MIT License

" Initialization {{{
if exists('loaded_god_vim') || version < 700
    finish
endif

let loaded_god_vim = 1

let s:god_close_help_buffer = get(g:, 'god_close_help_buffer', 0)
" }}}
" Functions {{{
" Get a link to the online page of an help tag
function! s:GetOnlineDoc(...) abort
    let l:result = ''

    for topic in a:000
        " Open the specified help tag
        execute "help " . topic

        " Forge the link
        let l:file        = expand("%:t")
        let l:tag         = expand('<cword>')
        let l:tagEncoded  = <SID>URLEncode(tag)
        let l:link        = "[`:h ". l:tag ."`](http://vimhelp.appspot.com/". l:file .".html#". l:tagEncoded .")"

        " Optional, close the opened help file
        if s:god_close_help_buffer
            execute "bd"
        endif

        if len(a:000) == 1
            let l:result = l:link
        else
            let l:result = l:result . " - " . l:link . "\n"
        endif
    endfor

    " Put it in the clipboard register
    if has('win32')
        let @* = l:result
    else
        let @+ = l:result
    endif

endfunction

" Encode url
function! s:URLEncode(str) abort
    " Replace each non hex character of the string by its hex representation
    let l:new = join(map(range(0, strlen(a:str)-1), 'a:str[v:val] =~ "\\w" ? a:str[v:val] : printf("%%%02x", char2nr(a:str[v:val]))'), '')
    return l:new
endfun
" }}}
" Command {{{
command! -nargs=+ -complete=help GOD call <SID>GetOnlineDoc(<f-args>)
" }}}
" vim:fdm=marker:sw=4:
