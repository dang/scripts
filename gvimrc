set guioptions-=T
set columns=80
set tw=78
set guifont=Bitstream\ Vera\ Sans\ Mono\ 7

if version >= 500

  highlight Comment	guifg=#6060cc
  highlight Constant	guifg=#c00000
  highlight Special	guifg=#c000c0
  highlight Identifier	guifg=#00c0c0
  highlight Statement	guifg=#cccc00 
  highlight PreProc	guifg=#cc40cc 
  highlight Type	guifg=#00cc00 
  highlight Underlined	guifg=#cc6060 
  highlight Ignore	guifg=white 
  highlight Error	guifg=black		guibg=#cc6060
  highlight Todo	guifg=black		guibg=#cccc00
  highlight Search	guifg=black		guibg=#6060cc
  highlight DiffAdd	guifg=black		guibg=#6060cc
  highlight DiffChange	guifg=black		guibg=#c000c0
  highlight DiffDelete	guifg=black		guibg=#00c0c0
  highlight DiffText	guifg=black		guibg=#c00000
  highlight Folded	guifg=#00b2ee	guibg=#808080
  highlight FoldColumn	guifg=#00b2ee	guibg=#808080
  highlight Normal guibg=black guifg=#808080
  highlight Cursor guibg=Green guifg=NONE
  highlight NonText guibg=#808080 guifg=#cc6060
endif
