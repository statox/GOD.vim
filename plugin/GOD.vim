" Easily get links to online documentation
" File:         GOD.vim
" Author:       statox (https://github.com/statox)
" License:      This file is distributed under the MIT License

" Initialization {{{
if exists('loaded_god_vim') || version < 700
    finish
endif

let loaded_god_vim = 1

if exists("g:god_close_help_buffer")
    let s:god_close_help_buffer = 1
else
    let s:god_close_help_buffer = 0
endif
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
    let l:new = ''

    for l:i in range(1, strlen(a:str))
        let l:c = a:str[l:i - 1]

        if l:c =~ '\w'
            let l:new .= l:c
        else
            let l:new .= printf('%%%02x', char2nr(l:c))
        endif
    endfor

    return l:new
endfun
" }}}
" Command {{{
command! -nargs=+ -complete=help GOD call <SID>GetOnlineDoc(<f-args>)
" }}}
" vim:fdm=marker
