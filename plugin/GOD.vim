" Easily get links to online documentation
" File:         plugin/GOD.vim
" Author:       statox (https://github.com/statox)
" License:      This file is distributed under the MIT License

" Initialization {{{
if exists('g:loaded_god_vim') || version < 700
    finish
endif

let g:loaded_god_vim = 1
let s:save_cpo = &cpo
set cpo&vim
" }}}
" Command {{{
command! -nargs=+ -complete=help GOD call GOD#GetOnlineDoc(<f-args>)
" }}}
" Reset {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim:fdm=marker:sw=4:
