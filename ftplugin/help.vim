" Easily get links to online documentation
" File:         ftplugin/help.vim
" Author:       statox (https://github.com/statox)
" License:      This file is distributed under the MIT License


if exists("b:did_GOD_ftplugin")
    finish
endif
let b:did_GOD_ftplugin = 1

if get(g:, 'god_disable_copy_doc_mapping', 0) != 1
    vmap <buffer> <silent> <leader>dy <Plug>GODCopyDoc
endif
