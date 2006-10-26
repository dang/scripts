set nocompatible
"set columns=80
behave xterm
set selectmode=mouse
map Q Igqq
" I keep hitting <F1> and screwing up my window.
map <F1> :nohlsearch<CR>
map <F2> :nohlsearch<CR>
imap <F1> <esc>
set incsearch
set wrapscan
set viminfo=\'50,\"50,h,r/tmp,r~/gated.log,r/var/tmp/gated.log
set autoindent
set noexpandtab
set backspace=2
"set guioptions+=T
set visualbell t_vb=
"set lines=72
set scrolloff=4

"" Dan's cinoptions
"set cinoptions={1s,t0
"set tw=89
"set shiftwidth=4
"set tabstop=4
"
"" Syllables's cinoptions
"set cinoptions=t0
"set tw=100
"set tw=89
"set shiftwidth=8
"set tabstop=8
"
" Works cinoptions
set cinoptions=:0,+.5s,(.5s,u0,U1,t0,M1
set tw=80
set shiftwidth=8
set tabstop=8

set wildmode=longest,list,full
set autowrite
"set splitbelow
set splitright
"set formatoptions=tcoq
command Reload checktime
command Cvsblame exe "!cvsblame " . expand("%") . " " . line(".")
" Movement
map H h
map J j
map K k
map L l
noremap U J

"function InsertTabWrapper()
"	let col = col('.') - 1
"	if !col || getline('.')[col - 1] !~ '\k'
"		return "\<tab>"
"	else
"		return "\<c-p>"
"	endif
"endfunction
"inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" setup cscope
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=0
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
	    cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
    	cs add $CSCOPE_DB
	endif
	set csverb
	map <C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>
	function Csre()
		if filereadable('.#maketags.dfg')
			silent !sh .\#maketags.dfg
		else
			silent !maketags
		endif
		set nocsverb
		cs kill 0
		cs add cscope.out
		set csverb
	endfunction
	command Csre call Csre()
endif
map <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

"Spelling 
function Spell()
	setlocal spell spelllang=en_us
	setlocal spell spellcapcheck=
endfunction
command Spell call Spell()

" C Code macros
ab #i #include

" Coding functions
function Dsplit()
	vsplit
	split
endfunction
command Dsplit call Dsplit()

filetype plugin on
autocmd BufNewFile,BufRead *.c    set cindent
autocmd BufNewFile,BufRead *.cc   set cindent
autocmd BufNewFile,BufRead *.cpp   set cindent
autocmd BufNewFile,BufRead *.cxx  set cindent
autocmd BufNewFile,BufRead *.h    set cindent
autocmd BufNewFile,BufRead *.java set cindent
"autocmd BufNewFile,BufRead *.java set cinoptions= cindent ts=3 sw=3
autocmd BufNewFile,BufRead *akefile*    set noexpandtab
autocmd BufNewFile,BufRead *.py   set ts=4 sw=4 expandtab
autocmd BufNewFile,BufRead *.y.unf set cindent
autocmd BufNewFile,BufRead *.auto.unf set formatoptions-=t ts=4 tw=0
autocmd BufNewFile,BufRead *.cfg.unf set formatoptions-=t ts=4 tw=0
autocmd BufNewFile,BufRead *.auto set formatoptions-=t tw=0
autocmd BufNewFile,BufRead *.cfg set formatoptions-=t ts=4 tw=0
autocmd BufNewFile,BufRead *.map set formatoptions-=t  ts=8
autocmd BufNewFile,BufRead *.pl   set nocst
autocmd BufNewFile,BufRead *.pm   set nocst
autocmd BufNewFile,BufRead *.perl   set nocst
autocmd BufNewFile,BufRead *.ksh  set tw=0
autocmd BufNewFile,BufRead *.conf  set tw=0
autocmd BufNewFile,BufRead distbuild  set tw=0
autocmd BufNewFile,BufRead *.doxygen setfiletype doxygen
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_numbers = 1
  let c_comment_types = 1
  let c_comment_strings = 1
  "unlet! c_comment_types
  "unlet! c_comment_strings
  let c_comment_date_time = 1
  let c_warn_nested_comments=1
  let c_minlines=100
  "let c_space_errors=1
  let c_gnu=1
  let c_ansi_typedefs=1
  let c_ansi_constants=1
  let c_posix=1
  let c_C99=1
  let c_syntax_for_h=1
  let c_no_names=1
  let c_no_octal=1
  let yacc_uses_cpp=1
  unlet! c_cpp_comments "Must come after C99

  " Doxygen highlighting
  "let g:doxygen_enhanced_color = 1
  let doxygen_javadoc_autobrief = 1
  let doxygen_end_punctuation = '[.\n]'

  " Switch on syntax highlighting.
  syntax on

  " Switch on search pattern highlighting.
  set hlsearch

  " Hide the mouse pointer while typing
  set mousehide

  "set background=dark
  set background=dark
  hi clear
  if exists("syntax_on")
     syntax reset
  endif

  " Colors:	00 = black
  " 		01 = red
  "		02 = green
  "		03 = yellow
  "		04 = blue
  "		05 = purple
  "		06 = cyan
  "		07 = white
  "		08 = grey
  "highlight Normal ctermbg=black ctermfg=lightgrey
  "highlight NonText ctermfg=lightred
  "highlight Statement ctermfg=lightblue 
  highlight Cursor	ctermfg=black		ctermbg=Yellow
  highlight Comment	ctermfg=blue
  highlight Constant	ctermfg=darkred
  highlight Special	ctermfg=darkmagenta
  highlight Identifier	ctermfg=darkcyan
  highlight Statement	ctermfg=yellow 
  highlight PreProc	ctermfg=magenta 
  highlight Type	ctermfg=green 
  highlight Underlined	ctermfg=red 
  highlight Ignore	ctermfg=white 
  highlight Error	ctermfg=black		ctermbg=red
  highlight Todo	ctermfg=black		ctermbg=yellow
  highlight Search	ctermfg=black		ctermbg=blue
  highlight DiffAdd	ctermfg=black		ctermbg=blue
  highlight DiffChange	ctermfg=black		ctermbg=darkmagenta
  highlight DiffDelete	ctermfg=black		ctermbg=darkcyan
  highlight DiffText	ctermfg=black		ctermbg=darkred
  highlight Folded	ctermfg=darkblue	ctermbg=gray
  highlight FoldColumn	ctermfg=darkblue	ctermbg=gray

  "highlight PreProc ctermfg=Red

augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

endif
