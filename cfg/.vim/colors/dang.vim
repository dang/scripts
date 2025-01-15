set background=dark
highlight clear
let g:colors_name = 'dang'

" cterm settings
highlight Normal ctermbg=black ctermfg=lightgrey
highlight NonText ctermfg=lightred
highlight Statement ctermfg=lightblue
highlight Cursor	ctermfg=black		ctermbg=Yellow
highlight Comment	ctermfg=blue
highlight Constant	ctermfg=darkred
highlight Special	ctermfg=darkmagenta
highlight Identifier	ctermfg=darkcyan	cterm=NONE
highlight Statement	ctermfg=yellow
highlight PreProc	ctermfg=magenta
highlight Type		ctermfg=green
highlight Underlined	ctermfg=red
highlight Ignore	ctermfg=white
highlight Visual        ctermfg=black           ctermbg=gray
highlight Error		ctermfg=black		ctermbg=red
highlight Todo		ctermfg=black		ctermbg=yellow
highlight Search	ctermfg=black		ctermbg=blue
highlight DiffAdd	ctermfg=blue		ctermbg=black
highlight DiffChange	ctermfg=darkmagenta	ctermbg=black
highlight DiffDelete	ctermfg=darkcyan	ctermbg=black
highlight DiffText	ctermfg=darkred		ctermbg=black
highlight Folded	ctermfg=grey		ctermbg=darkblue
highlight FoldColumn	ctermfg=darkblue	ctermbg=gray
highlight Pmenu		ctermfg=black	ctermbg=13
highlight PmenuSel	ctermfg=white 	ctermbg=242
"highlight PreProc ctermfg=Red
highlight! link cStorageClass	Statement

" GUI settings
highlight Normal	guifg=#B0B0B0		guibg=#002B36		ctermbg=NONE
highlight Comment	guifg=#62A0EA		guibg=NONE
highlight Constant	guifg=#FF5555		guibg=NONE
highlight Identifier	guifg=#00AAAA		guibg=NONE		gui=NONE
highlight Statement	guifg=#FFFF55		guibg=NONE		gui=NONE
highlight PreProc	guifg=#FF55FF		guibg=NONE
highlight Type		guifg=#55FF55		guibg=NONE
highlight Special	guifg=#9E499E		guibg=NONE
highlight Underlined	guifg=#FF5555		guibg=NONE
highlight Ignore	guifg=#B0B0B0		guibg=NONE
highlight Error		guifg=black		guibg=#B0B0B0
highlight Todo		guifg=black		guibg=#FFFF55
highlight Folded	guifg=#3D3DC4		guibg=#A0A0A0
highlight Visual				guibg=NvimDarkGrey4
"CursorColumn
"CursorLine
"CursorLineNr
"SignColumn
highlight FoldColumn	guifg=#3D3DC4		guibg=#A0A0A0
"ColorColumn
"Conceal
highlight Cursor	guifg=black		guibg=#FFFF55
"lCursor
"CursorIM
"Title
highlight Title		guifg=NvimLightGrey2	guibg=NONE		gui=NONE
"Directory
highlight Search	guifg=black		guibg=#62A0EA
highlight IncSearch							gui=reverse
"NonText
"EndOfBuffer
highlight ErrorMsg	guifg=Red		guibg=NONE
"WarningMsg
"LineNr
highlight MatchParen	guifg=NONE		guibg=DarkCyan		gui=bold
"ModeMsg
"MoreMsg
"Question
"SpecialKey
"VisualNOS
"WildMenu
"QuickFixLine
"SpellBad
"SpellCap
"SpellLocal
"SpellRare
"StatusLine
"StatusLineNC
"VertSplit
"TabLine
"TabLineFill
"TabLineSel
"ToolbarLine
"ToolbarButton
"Pmenu
"PmenuSbar
"PmenuThumb
highlight DiffAdd	guifg=black		guibg=#5555FF
highlight DiffChange	guifg=black		guibg=#9E499E
highlight DiffDelete	guifg=black		guibg=#00AAAA
highlight DiffText	guifg=black		guibg=#BF2323

highlight String	guifg=#C01C28		guibg=NONE
highlight Removed	guifg=#C01C28		guibg=NONE
highlight Added		guifg=#027302		guibg=NONE
highlight Changed	guifg=#AA5500		guibg=NONE
"highlight Function	guifg=NvimLightCyan	guibg=NONE
highlight @property	guifg=#AA5500

highlight! link		@variable		Identifier
highlight! link		Operator		Statement
highlight! link		@lsp.type.property	@property

highlight @lsp.type.parameter	guifg=#208A59
