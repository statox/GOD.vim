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
function! GOD#GetOnlineDoc(platform, ...) abort
    let l:god_close_help_buffer = get(g:, 'god_close_help_buffer', 0)

    let l:result = ''

    for topic in a:000
        " Open the specified help tag
        execute "help " . topic

        " Forge the link for the right platform
        if (a:platform == 'neovimio')
            let l:link = <SID>ForgeLinkNeovimIO(topic)
        elseif (a:platform == 'vimhelp')
            let l:link = <SID>ForgeLinkVimHelp(topic)
        else
            echoe "Unknown platform " . a:platform . " Can not generate help link"
            return
        endif

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

function! s:ForgeLinkNeovimIO(topic)
    " Forge the link
    let l:file        = substitute(expand("%:t"), '\.txt', '', '')
    let l:tag         = expand('<cword>')
    let l:tagEncoded  = <SID>URLEncode(tag)
    let l:link        = "[`:h ". l:tag ."`](https://neovim.io/doc/user/". l:file .".html#". l:tagEncoded .")"

    return l:link
endfunction

function! s:ForgeLinkVimHelp(topic)
    " Forge the link
    let l:file        = expand("%:t")
    let l:tag         = expand('<cword>')
    let l:tagEncoded  = <SID>URLEncode(tag)
    let l:tagEncodedS = substitute(l:tagEncoded, '%3a', '%3A', 'g') " Hack to fix help topics with : (like :substitute)
    let l:link        = "[`:h ". l:tag ."`](http://vimhelp.appspot.com/". l:file . ".html#". l:tagEncodedS .")"

    return l:link
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
