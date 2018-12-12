" Easily get links to online documentation
" File:         autoload/GOD.vim
" Author:       statox (https://github.com/statox)
" License:      This file is distributed under the MIT License

" Initialization {{{
if exists('g:autoloaded_god_vim') || version < 700
    finish
endif

let g:autoloaded_god_vim = 1
let s:save_cpo = &cpo
set cpo&vim
" }}}
" Functions {{{
" Get a link to the online page of an help tag
function! GOD#GetOnlineDoc(...) abort
    let l:god_close_help_buffer = get(g:, 'god_close_help_buffer', 0)

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
        if l:god_close_help_buffer
            bd
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
    let l:new = join(map(range(0, strlen(a:str)-1), 'a:str[v:val] =~ "[a-zA-Z0-9\-._]" ? a:str[v:val] : printf("%%%02x", char2nr(a:str[v:val]))'), '')
    return l:new
endfun
" }}}
" Reset {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim:fdm=marker:sw=4:
