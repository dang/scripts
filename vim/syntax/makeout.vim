syn match file	'\v(\.|\.\.|/)*([[:alnum:]_/\.]*)(\.c|\.h)([[:alnum:]])@!'
syn match wwarning 'warning:'
syn match errorr '\v(Error \d|error:)'
syn match sstring  '‘.\{-}’'
syn match sdefine	'-D[[:alnum:]_]*'


hi def link sdefine PreProc
hi def link file Directory
hi def wwarning ctermfg=220
hi def errorr ctermfg=196
hi def link sstring String
