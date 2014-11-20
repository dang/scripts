" Vim syntax file
" Language:	Vala
" Maintainer:	Emmanuele Bassi <ebassi@gnome.org>
" Last Change:	2008-08-05
" Filenames:	*.vala *.vapi
"
" REFERENCES:
" [1] http://live.gnome.org/Vala

if exists("b:current_syntax")
    finish
endif

let s:vala_cpo_save = &cpo
set cpo&vim


" type
syn keyword valaType			bool byte char decimal double float int int8 int16 int32 int64 long object sbyte short string uchar uint uint8 uint16 uint32 uint64 ulong ushort void
" storage
syn keyword valaStorage			class delegate enum errordomain interface namespace struct var
" repeat / condition / label
syn keyword valaRepeat			break continue do for foreach goto return while
syn keyword valaConditional		else if switch
syn keyword valaLabel			case default
" there's no :: operator in C#
syn match valaOperatorError		display +::+
" user labels (see [1] 8.6 Statements)
syn match   valaLabel			display +^\s*\I\i*\s*:\([^:]\)\@=+
" modifier
syn keyword valaModifier		abstract const dynamic extern internal override private protected public readonly sealed signal static virtual volatile weak
" constant
syn keyword valaConstant		false null true
" exception
syn keyword valaException		try catch finally throw

" TODO:
syn keyword valaUnspecifiedStatement	as base construct checked fixed get in is lock new operator out params ref set sizeof stackalloc this typeof unchecked unsafe using
" TODO:
"syn keyword valaUnsupportedStatement	
" TODO:
syn keyword valaUnspecifiedKeyword	explicit implicit


" Contextual Keywords
syn match valaContextualStatement	/\<yield[[:space:]\n]\+\(return\|break\)/me=s+5
syn match valaContextualStatement	/\<partial[[:space:]\n]\+\(class\|struct\|interface\)/me=s+7
syn match valaContextualStatement	/\<\(construct\|prepares\|ensures\)[[:space:]\n]*/me=s+9
syn match valaContextualStatement	/\<where\>[^:]\+:/me=s+5

" Comments
"
" PROVIDES: @valaCommentHook
"
" TODO: include strings ?
"
syn keyword valaTodo		contained TODO FIXME XXX NOTE
syn region  valaComment		start="/\*"  end="\*/" contains=@valaCommentHook,valaTodo,@Spell
syn match   valaComment		"//.*$" contains=@valaCommentHook,valaTodo,@Spell

" [1] 9.5 Pre-processing directives
syn region	valaPreCondit
    \ start="^\s*#\s*\(define\|undef\|if\|elif\|else\|endif\|line\|error\|warning\)"
    \ skip="\\$" end="$" contains=valaComment keepend
syn region	valaRegion matchgroup=valaPreCondit start="^\s*#\s*region.*$"
    \ end="^\s*#\s*endregion" transparent fold contains=TOP

syn region      valaDecorator
    \ start="^\s*\[" end="\]$" contains=valaComment,valaString keepend


" Strings and constants
syn match   valaSpecialError	        contained "\\."
syn match   valaSpecialCharError	contained "[^']"
" [1] 9.4.4.4 Character literals
syn match   valaSpecialChar	contained +\\["\\'0abfnrtvx]+
" unicode characters
syn match   valaUnicodeNumber	        +\\\(u\x\{4}\|U\x\{8}\)+ contained contains=valaUnicodeSpecifier
syn match   valaUnicodeSpecifier	+\\[uU]+ contained
syn region  valaVerbatimString	start=+@"+ end=+"+ end=+$+ skip=+""+ contains=valaVerbatimSpec,@Spell
syn match   valaVerbatimSpec	+@"+he=s+1 contained
syn region  valaString		start=+"+  end=+"+ end=+$+ contains=valaSpecialChar,valaSpecialError,valaUnicodeNumber,@Spell
syn match   valaCharacter		"'[^']*'" contains=valaSpecialChar,valaSpecialCharError
syn match   valaCharacter		"'\\''" contains=valaSpecialChar
syn match   valaCharacter		"'[^\\]'"
syn match   valaNumber		"\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match   valaNumber		"\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match   valaNumber		"\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
syn match   valaNumber		"\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

" The default highlighting.
hi def link valaType			Type
hi def link valaStorage			StorageClass
hi def link valaRepeat			Repeat
hi def link valaConditional		Conditional
hi def link valaLabel			Label
hi def link valaModifier		StorageClass
hi def link valaConstant		Constant
hi def link valaException		Exception
hi def link valaUnspecifiedStatement	Statement
hi def link valaUnsupportedStatement	Statement
hi def link valaUnspecifiedKeyword	Keyword
hi def link valaContextualStatement	Statement
hi def link valaOperatorError		Error

hi def link valaTodo			Todo
hi def link valaComment			Comment

hi def link valaSpecialError		Error
hi def link valaSpecialCharError	Error
hi def link valaString			String
hi def link valaVerbatimString		String
hi def link valaVerbatimSpec		SpecialChar
hi def link valaPreCondit		PreCondit
hi def link valaDecorator               PreCondit
hi def link valaCharacter		Character
hi def link valaSpecialChar		SpecialChar
hi def link valaNumber			Number
hi def link valaUnicodeNumber		SpecialChar
hi def link valaUnicodeSpecifier	SpecialChar

let b:current_syntax = "vala"

let &cpo = s:vala_cpo_save
unlet s:vala_cpo_save

" vim: ts=8
