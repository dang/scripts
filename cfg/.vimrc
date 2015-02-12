"
" Generic setup
"

" Don't need to be vi compatible
set nocompatible
" Act like we're in an xterm
behave xterm
" Want status line
set laststatus=2

"
" Mouse/clipboard settings
"
" Save the X clipboard on exit
" Select with the mouse
set selectmode=mouse
" Hide the mouse pointer while typing
set mousehide
" Use the X clipboard for default yanking
set clipboard=autoselect,unnamed,unnamedplus,exclude:cons\|linux
" Use mouse in terminals; this allows selection inside tmux
if !empty($DISPLAY) && executable('xsel')
	if has('mouse')
		set mouse=a
		set selectmode=
	endif
	function SaveXClip()
		let reg = getreg('+')
		if !empty(reg)
			call system("xsel -ip", reg)
			call system("xsel -k")
			call system("cat >> /home/dang/tmp/vimclip.log", getreg('+'))
		endif
	endfunction
	command SaveXClip call SaveXClip()
	autocmd VimLeave * call SaveXClip()
	:nnoremap <silent> <C-z> :SaveXClip<CR><C-z>
endif

"
" Key mappings
"

" This re-indents a single line in command mode according to the current C
" syntax
nmap Q ==gqq
" Turn of highlighting of search with F1 and F2 (in case F1 is mapped to "help"
nmap <F1> :nohlsearch<CR>
nmap <F2> :nohlsearch<CR>
" I accidentally hit F1 when aiming for escape.  Map F1 to escape in insert mode
imap <F1> <esc>
" Append a semicolon
nmap ; A;
" Re-syntax long files
noremap <F12> :syntax sync fromstart<CR>

" Mappings for QWERTY
" Map keys to move between split windows
"nmap H h
"nmap J j
"nmap K k
"nmap L l
" Since I mapped J to move between splits, remap U to join lines
"noremap U J

" Mappings for Colemak
"set langmap=nh,ej,il,uk,fn,ke,si,hu,jf
"set langmap=fe,pr,gt,jy,lu,ui,yo,\;p,rs,sd,tf,dg,nj,ek,il,o\;,kn,FE,PR,GT,JY,LU,UI,YO,:P,RS,SD,TF,DG,NJ,EK,IL,O:,KN
noremap n h
noremap e j
noremap i l
noremap u k
noremap f n
noremap F N
noremap k e
noremap K E
noremap s i
noremap h u
noremap j f
nnoremap N h
nnoremap E j
nnoremap U k
nnoremap I l
nnoremap S I
"nnoremap H U " Leave H jumping to the top of the window
nnoremap <C-E> <C-F>
nnoremap <C-U> <C-B>
vnoremap <C-E> <C-F>
vnoremap <C-U> <C-B>
"nnoremap o :
"nnoremap O :

" For mapping meta-keys on XFCE/Gnome terminal, they send <Esc-x> instead of
" <M-x>.  However, if you actually map <Esc-*>, then vim will wiat for
" timeoutlen after an <Esc> to see if it's a mapping.  This means that
" anything mapped to <M-x> will be triggered by <Esc> <x>, which is bloody
" annoying.  To work around this, set the <Esc-x> to an unused <Fn> key here,
" and then map the <Fn> key later.  Available keys are:
" <F13> to <F37>
" <S-F13> to <S-F37>
" <xF1> to <xF4>
" <S-xF1> to <S-xF4>
set timeout timeoutlen=1000 ttimeoutlen=50
set <F13>=n
set <F14>=e
set <F15>=i
set <F16>=u

" tmux remappings
if &term == "screen-256color"
	set <C-Left>=[D
	set <C-Right>=[C
	"set <C-Up>=[A
	"set <C-Down>=[B
endif
" Number-pad enter
set <F37>=OM

"
" Behavior settings
"

" While typing a search, jump to matches
set incsearch
" Wrap searches around the end of the file
set wrapscan
" Don't include gated.log files in viminfo
set viminfo=\'50,\"50,h,r/tmp,r~/gated.log,r/var/tmp/gated.log,r.git/COMMIT_EDITMSG
" Auto indent
set autoindent
" Keep tabs as tabs
set noexpandtab
" Backspace across lines
set backspace=2
"set guioptions+=T
" Don't let visualbell flash my screen
set visualbell t_vb=
"set lines=72
" When scrolling, leave 4 lines of overlap
set scrolloff=4
" Set completion modes
set wildmode=longest,list,full
set wildignore=*.o,*.lo,*.pyc
set wildignorecase
" Automatically write changes with tagging to a new file
set autowrite
" Put vertical splits to the right of the current window
"set splitright
" Put horizontal splits below the current window
set splitbelow
" Make visual-/ search rather than extend the visual
:vmap / y/<C-R>"<CR>

" Colors, baby
set t_Co=256

" I want sh files to be highlighted bash
let g:is_bash=1

"
" Settings for EnhancedCommentify
"

" Set it so \x comments, and \X uncomments
"let g:EnhCommentifyTraditionalMode="No"
"let g:EnhCommentifyFirstLineMode='no'
"let g:EnhCommentifyUserBindings='no'
"let g:EnhCommentifyUserMode='yes'
" langmap broke the key bindings somehow.  Manually add them.
"nnoremap <Leader>c :call EnhancedCommentify('', 'comment')<CR>e
"nnoremap <Leader>C :call EnhancedCommentify('', 'decomment')<CR>e
"vnoremap <Leader>c :call EnhancedCommentify('', 'comment')<CR>e
"vnoremap <Leader>C :call EnhancedCommentify('', 'decomment')<CR>e
"nnoremap <Leader>x :call EnhancedCommentify('', 'comment')<CR>
"nnoremap <Leader>X :call EnhancedCommentify('', 'decomment')<CR>
"let g:EnhCommentifyBindInNormal='no'
"let g:EnhCommentifyBindInVisual='no'

"
" Settings for NERDCommenter
"

let g:NERDCreateDefaultMappings='0'
let g:NERDRemoveExtraSpaces='1'
let g:NERDCompactSexyComs='1'
nnoremap <Leader>c  :call NERDComment('n', "comment")<cr>
vnoremap <Leader>c  :call NERDComment('x', "comment")<cr>
nnoremap <Leader>C  :call NERDComment('n', "uncomment")<cr>
vnoremap <Leader>C  :call NERDComment('x', "uncomment")<cr>

"
" Settings for dwm
"

" Number pad mappings
"nmap <C-Left> <Plug>DWMSplit
"nmap <C-Right> <Plug>DWMClose
"nmap <C-Up> <Plug>DWMGrowMaster
"nmap <C-Down> <Plug>DWMShrinkMaster
"nmap <C-PageDown> <Plug>DWMRotateCounterclockwise
"nmap <C-PageUp> <Plug>DWMRotateClockwise
"nmap <C-Space> <Plug>DWMFocus
"nmap <F37> <Plug>DWMTag

" Number pad mappings for inside tmux XXX convert to <Fn> mappings
"nmap [D <Plug>DWMSplit
"nmap [C <Plug>DWMClose
"nmap [A <Plug>DWMGrowMaster
"nmap [B <Plug>DWMShrinkMaster
"nmap [E <Plug>DWMResetMaster

" Normal keyboard mappings: <M-n>, <M-i>, <M-u>
nmap <F13> <Plug>DWMSplit
nmap <F14> <Plug>DWMFocus
nmap <F15> <Plug>DWMClose
nmap <F16> <Plug>DWMTag

"
" Cindent options
"

"" Don't set these anymore.  Put them in .project.vim in the same directory as
"" cscope files
"" Dan's cinoptions
"set cinoptions={1s,t0
"set tw=100
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
" Gated cinoptions
"set cinoptions=:0,+.5s,(.5s,u0,U1,t0,M1
"set tw=80
"set shiftwidth=8
"set tabstop=8

"
" Special commands
"

" Check to see if a file has changed from under us
command Reload checktime
" Blame in svn for the current line
command Vcsblame exe "!vcsblame --line "  . line(".") . " " . expand("%")
"command Vcsblame exe "!tig blame " . expand("%") . " +"  . line(".")
" Check when a symbol was added to git
map <Leader>1 :!git log --reverse -p -S <cword> %<cr>
nmap ) :tn<cr>
nmap ( :tp<cr>

"
" cscope settings
"
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
	function Csrebuild()
		silent !maketags -r
		set nocsverb
		cs kill 0
		cs add cscope.out
		set csverb
		redraw!
	endfunction
	" Rebuild and reload the cscope database
	command Csrebuild call Csrebuild()
	function Csload()
		set nocsverb
		cs kill 0
		cs add cscope.out
		set csverb
		redraw!
	endfunction
	" Reload the existing database (if cscope crashes)
	command Csload call Csload()
	function Csglobal()
		set nocsverb
		let fname = $HOME . "/.vim/csglobals"
		if filereadable(fname)
			for line in readfile(fname)
				let dspc = stridx(line, " ")
				let dfile = strpart(line, 0, dspc)
				let dpath = strpart(line, dspc + 1)
				echo '"' . dfile . '"'
				echo '"' . dpath . '"'
				if filereadable(dfile)
					execute "cs add " . dfile . " " . dpath
				endif
			endfor
		endif
		set csverb
		redraw!
	endfunction
	" Rebuild and reload the cscope database
	command Csglobal call Csglobal()
endif
map <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

"
" Spell checking
"
function Spell()
	setlocal spell spelllang=en_us
	setlocal spell spellcapcheck=
endfunction
command Spell call Spell()

"
" C Code macros
"

" If you type #i<space> then it completes to #include
ab #i #include

"
" Delete timestamps from kernel logs
" ^[[:alpha:]]\{3} [[:digit:]]\{1,2} [[:digit:]]\{1,2}:[[:digit:]]\{2}:[[:digit:]]\{2}
function KernLogCleanup()
	%s#^[[:alpha:]]\{3} [[:digit:]]\{1,2} [[:digit:]]\{1,2}:[[:digit:]]\{2}:[[:digit:]]\{2} \f\{-} kernel: \[.\{-}\] ##g
endfunction
command KernLogCleanup call KernLogCleanup()

" Pathogen
"To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" Gundo requires at least vim 7.3
if !has('python')
	call add(g:pathogen_disabled, 'ultisnips')
endif
call pathogen#infect()

"
" Filetype plugins.  These are file-type specific settings.
"
filetype plugin on
filetype plugin indent on
autocmd BufNewFile,BufRead *.{c,h,php} set formatoptions+=cqj
autocmd BufNewFile,BufRead *.cpp  set formatoptions+=cqj
autocmd BufNewFile,BufRead *.cxx  set formatoptions+=cqj
autocmd BufNewFile,BufRead *.hpp  set formatoptions+=cqj
autocmd BufNewFile,BufRead *akefile*    set noexpandtab
autocmd BufNewFile,BufRead *.auto.unf set formatoptions-=t ts=4 tw=0
autocmd BufNewFile,BufRead *.cfg.unf set formatoptions-=t ts=4 tw=0
autocmd BufNewFile,BufRead *.auto set formatoptions-=t tw=0
autocmd BufNewFile,BufRead *.cfg set formatoptions-=t ts=4 tw=0
autocmd BufNewFile,BufRead *.map set formatoptions-=t  ts=8
autocmd BufNewFile,BufRead *.pl   set nocst formatoptions-=r formatoptions+=cqj
autocmd BufNewFile,BufRead *.pm   set nocst formatoptions-=r formatoptions+=cqj
autocmd BufNewFile,BufRead *.perl   set nocst formatoptions-=r formatoptions+=cqj
autocmd BufNewFile,BufRead *.ksh  set tw=0
autocmd BufNewFile,BufRead *.conf  set tw=0
autocmd BufNewFile,BufRead distbuild  set tw=0
autocmd BufNewFile,BufRead *.doxygen setfiletype doxygen
autocmd BufNewFile,BufRead *.stderr setfiletype gcc
autocmd BufNewFile,BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufNewFile,BufRead *.vala            setfiletype vala
autocmd BufNewFile,BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufNewFile,BufRead *.vapi            setfiletype vala
autocmd BufNewFile,BufRead *.i setfiletype swig
autocmd BufNewFile,BufRead *.swg set filetype=swig 
autocmd BufNewFile,BufRead rfc*.txt set filetype=rfc
autocmd BufNewFile,BufRead gated*log set filetype=gated
autocmd BufNewFile,BufRead gated*log.* set filetype=gated
autocmd BufNewFile,BufRead gated-trace set filetype=gated
autocmd BufNewFile,BufRead *gated_log* set filetype=gated
autocmd BufNewFile,BufRead *.dml set filetype=dml
autocmd BufNewFile,BufRead *.pde setlocal ft=arduino
autocmd BufNewFile,BufRead *.ftl set filetype=xhtml
autocmd BufNewFile,BufRead ceph.conf set filetype=ceph

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"
" Settings for C syntax highlighting (see .vim/doc/std_c.txt)
"

" Highlight things inside comment strings
let c_comment_numbers = 1
let c_comment_types = 1
let c_comment_strings = 1
let c_comment_date_time = 1
let c_warn_nested_comments=1
" Look backward 100 lines for syntax stuff
let c_minlines=100
" Highlight space errors (space before tab, extra whitespace on the end of a
" line, etc.)
"let c_space_errors=1
" GNU isms aren't errors
let c_gnu=1
" ANSI settings
let c_ansi_typedefs=1
let c_ansi_constants=1
" Highlight POSIX specific things
let c_posix=1
" Highlight C99 specific things
let c_C99=1
" Highlight headers as C not C++
let c_syntax_for_h=1
" Don't highlight non-reserved functions/keywords
let c_no_names=1
" Highlight octal as errors
let c_no_octal=1
" Highlight yacc as C++, not C
let yacc_uses_cpp=1
" Highlight C++ style comments as errors
unlet! c_cpp_comments "Must come after C99

"
" Doxygen highlighting 
"

" Turn it on
let g:load_doxygen_syntax=1
"let g:doxygen_enhanced_color = 1
" Use highlight autobrief (first line is @brief, even without the tag)
let doxygen_javadoc_autobrief = 1
" Things end a period or newline
let doxygen_end_punctuation = '[.\n]'

"
" Syntax Highlighting
"

" Switch on syntax highlighting.
syntax on

" Switch on search pattern highlighting.
set hlsearch

" Use light-on-dark coloring
set background=dark
" Clear existing highlighting
hi clear
if exists("syntax_on")
" Reset syntax highlighing
	syntax reset
endif

" Actual color settings for terminals (gvim color schemes in .vim/colors/)
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
highlight Identifier	ctermfg=darkcyan	cterm=NONE
highlight Statement	ctermfg=yellow 
highlight PreProc	ctermfg=magenta 
highlight Type		ctermfg=green 
highlight Underlined	ctermfg=red 
highlight Ignore	ctermfg=white 
highlight Error		ctermfg=black		ctermbg=red
highlight Todo		ctermfg=black		ctermbg=yellow
highlight Search	ctermfg=black		ctermbg=blue
highlight DiffAdd	ctermfg=black		ctermbg=blue
highlight DiffChange	ctermfg=black		ctermbg=darkmagenta
highlight DiffDelete	ctermfg=black		ctermbg=darkcyan
highlight DiffText	ctermfg=black		ctermbg=darkred
highlight Folded	ctermfg=grey		ctermbg=darkblue
highlight FoldColumn	ctermfg=darkblue	ctermbg=gray
highlight Pmenu		ctermfg=black	ctermbg=13
highlight PmenuSel	ctermfg=white 	ctermbg=242
"highlight PreProc ctermfg=Red

"
" Automatically read gzipped files
"
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

"
" Automatically read bzipped files
"
augroup bzip2
" Remove all bzip2 autocommands
au!

" Enable editing of bzipped files
"	  read:	set binary mode before reading the file
"		uncompress text in buffer after reading
"	 write:	compress file after writing
"	append:	uncompress file, append, compress file
autocmd BufReadPre,FileReadPre	*.bz2 set bin
autocmd BufReadPost,FileReadPost	*.bz2 let ch_save = &ch|set ch=2
autocmd BufReadPost,FileReadPost	*.bz2 '[,']!bunzip2
autocmd BufReadPost,FileReadPost	*.bz2 set nobin
autocmd BufReadPost,FileReadPost	*.bz2 let &ch = ch_save|unlet ch_save
autocmd BufReadPost,FileReadPost	*.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

autocmd BufWritePost,FileWritePost	*.bz2 !mv <afile> <afile>:r
autocmd BufWritePost,FileWritePost	*.bz2 !bzip2 <afile>:r

autocmd FileAppendPre			*.bz2 !bunzip2 <afile>
autocmd FileAppendPre			*.bz2 !mv <afile>:r <afile>
autocmd FileAppendPost		*.bz2 !mv <afile> <afile>:r
autocmd FileAppendPost		*.bz2 !bzip2 <afile>:r
augroup END

" Needs to be after syntax is turned on
"autocmd! Syntax vala source $VIM/vim71/syntax/cs.vim

"
"Snippits - see .vim/doc/snipMate.txt
"
let g:snips_author = 'Daniel Gryniewicz'
"
" UltiSnips
"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Automatically update copyright notice with current year
autocmd BufWritePre *.[ch]
  \ if &modified |
  \   exe "g#\\cCOPYRIGHT \\(".strftime("%Y")."\\)\\@![0-9]\\{4\\}\\(-".strftime("%Y")."\\)\\@!#s#\\([0-9]\\{4\\}\\)\\(-[0-9]\\{4\\}\\)\\?#\\1-".strftime("%Y") |
  \ endif

"
" Python-mode
"

" I don't like folding
let g:pymode_folding = 0

" These extra options are redundant, wrong, or annoying
let g:pymode_options = 0

" Don't lint on the fly
let g:pymode_lint_onfly = 0

" Make rope use current directory
let g:pymode_rope_guess_project = 0

" Rope omni completion crashes
let g:pymode_rope_vim_completion = 0

" mccabe's complexity warning hits *way* to soon
let g:pymode_lint_mccabe_complexity = 10

" No side bar with EE or WW.  Makes windows too small
let g:pymode_lint_signs = 0

"
" Tagbar
"

" Open tagbar and jump to it
"nnoremap <silent> <F9> :TagbarOpen fj<CR>
" Toggle Tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

" Adjust width
let g:tagbar_width = 28

"
" Screen
"

" Use tmux, not screen
let g:ScreenImpl = 'Tmux'

"
" Syntastic
"

" Syntastic status line
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

" Automatically check when file opened
"let g:syntastic_check_on_open=1
" Jump to first error
"let g:syntastic_auto_jump=1
" Auto-open error list
let g:syntastic_auto_loc_list=1
" 10 lines is too big
let g:syntastic_loc_list_height=5

" netrw - directory browsing (and remote file access)
let g:netrw_dirhistmax  = 0
