" Vim syntax file
" Language:	gated.log
" Maintainer:	Daniel Gryniewicz <dang@ghs.com>
" Last change:	2011-02-24

if version < 600
    syntax clear
elseif exists ("b:current_syntax")
    finish
endif

" case off
" syn case ignore

" DML commands
syn keyword dmlcmds applet center chapter copyright end image include indent index list list-numbered literal minitoc mode page sh1 table tag title toc unindent contained
syn region command	start="^\." end="$" contains=dmlcmds oneline
syn region dmlcomment	start="^\.\." end="$" oneline
syn region dmlblockcomment	start="^\.comment" end="^\.uncomment"

" DML text formatting
syn region italics	start="`{" end="`}" 
syn region bold		start="`\[" end="`\]" 
syn region bolditalics	start="`(" end="`)" 
syn region monospace	start="`<" end="`>" 
syn region dmlstring	start="``" end="''" 

" Define the default hightlighting.
    hi link command		Statement
    hi link dmlcomment		Comment
    hi link dmlblockcomment	Comment
    hi link dmlcmds		Type
    hi link dmlstring		String
    hi link italics		MoreMsg
    hi link bold		ModeMsg
    hi link bolditalics		StatusLine
    hi link monospace		Special

let b:current_syntax = "dml"
" vim:ts=8
