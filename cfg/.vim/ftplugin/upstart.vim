" Vim filetype plugin file
" Language:         upstart configuration file
" Maintainer:       Daniel Gryniewicz <dang@fprintf.net>
" Latest Revision:  2013-11-27

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = "setl com< cms< fo<"

setlocal comments=:# commentstring=#\ %s formatoptions-=t formatoptions+=croql
