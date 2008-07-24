"  Usage:
"
"   These maps all work during insert mode while editing a C
"   or C++ program.  Use either the shorthand or longhand maps
"   below, and the associated construct will be expanded to
"   include parentheses, curly braces, and the cursor will be
"   moved to a convenient location, still in insert mode, for
"   further editing.
"
"   Shorthand  Longhand
"   Map        Map
"   ---------  --------
"   i`         if`
"   e`         else`
"   ei`        elif`
"   f`         for`
"   w`         while`
"   s`         switch`
"   c`         case`
"   d`         default`
"              do`
"   E`         Edbg`    (see http://www.erols.com/astronaut/dbg)
"   R`         Rdbg`    (see http://www.erols.com/astronaut/dbg)
"   D`         Dprintf` (see http://www.erols.com/astronaut/dbg)
"
"   Caveat: these maps will not work if "set paste" is on
"
" Installation:
"
"  ${HOME}/.vim/ftplugin/c/    -and-   ${HOME}/.vim/ftplugin/cpp/
" (or make suitable links) and put "filetype plugin on" in your <.vimrc>.
"
" =======================================================================

" prevent re-load
if exists("g:loaded_dfg")
  finish
endif
let g:loaded_dfg= 1
source $VIMRUNTIME/ftplugin/c.vim

setlocal fo+=t

" ---------------------------------------------------------------------
" Only done once
"syn keyword cTodo COMBAK
"syn match cTodo "^[- ]*COMBAK[- ]*$" 
"syn keyword cOperator +
"syn keyword cOperator -
"syn keyword cOperator *
"syn keyword cOperator /
"syn keyword cOperator =
"syn keyword cOperator +=
"syn keyword cOperator -=
"syn keyword cOperator *=
"syn keyword cOperator /=
set isk+=#

" ---------------------------------------------------------------------
" Functions:

" backquote calls CStubs function
inoremap <Plug>UseCStubs <Esc>:call <SID>CStubs()<CR>a

" ---------------------------------------------------------------------

" CStubs: this function changes the backquote into
"               text based on what the preceding word was
imap <unique> ` <Plug>UseCStubs
function! <SID>CStubs()
 let wrd=expand("<cWORD>")

 if     wrd == "if"
  exe "norm! bdWaif ()\<CR>{\<CR>}\<Esc>$kkF("
 elseif wrd == "i"
  exe "norm! xaif ()\<CR>{\<CR>}\<Esc>$kkF("

 elseif wrd =~ 'els\%[e]'
  exe "norm! bdWaelse\<CR>{\<CR>}\<Esc>O \<c-h>\<Esc>"
 elseif wrd == "e"
  exe "norm! xaelse {\<CR>}\<Esc>O \<c-h>\<Esc>"

 elseif wrd =~ 'eli\%[f]'
  exe "norm! bdWaelse if ()\<CR>{\<CR>}\<Esc>$kF("
 elseif wrd == "ei"
  exe "norm! bdWaelse if ()\<CR>{\<CR>}\<Esc>$kF("

 elseif wrd =~ 'for\='
  exe "norm! bdWafor()\<CR>{\<CR>}\<Esc>$kF("
 elseif wrd == "f"
  exe "norm! xafor()\<CR>{\<CR>}\<Esc>$kF("

 elseif wrd =~ 'wh\%[ile]'
  exe "norm! bdWawhile ()\<CR>{\<CR>}\<Esc>$kF("
 elseif wrd == "w"
  exe "norm! xawhile ()\<CR>{\<CR>}\<Esc>$kF("

 elseif wrd =~ 'sw\%[itch]'
  exe "norm! bdWaswitch ()\<CR>{\<CR>}\<Esc>$kF("
 elseif wrd == "s"
  exe "norm! xaswitch ()\<CR>{\<CR>}\<Esc>$kF("

 elseif wrd =~ 'ca\%[se]'
  exe "norm! bdWacase :\<CR>break;\<Esc>khf:h"
 elseif wrd == "c"
  exe "norm! xacase :\<CR>break;\<Esc>khf:h"

 elseif wrd =~ 'de\%[fault]'
  exe "norm! bdWadefault :\<CR>break;\<Esc>O \<c-h>\<Esc>"
 elseif wrd == "d"
  exe "norm! xadefault :\<CR>break;\<Esc>O \<c-h>\<Esc>"

 elseif wrd == "do"
  exe "norm! bdWado {\<CR>} while ();\<Esc>O \<c-h>\<Esc>"

 elseif wrd =~ 'Ed\%[bg]'
  exe "norm! bdWaEdbg((\"\<Esc>ma[[?)\<CR>%BdwP`apa()\"));\<Esc>F("
 elseif wrd == "E"
  exe "norm! xaEdbg((\"\<Esc>ma[[?)\<CR>%BdwP`apa()\"));\<Esc>F("

 elseif wrd =~ 'Rd\%[bg]'
  exe "norm! bdWaRdbg((\"\<Esc>ma[[?)\<CR>%BdwP`apa\"));\<Esc>F\"h"
 elseif wrd == "R"
  exe "norm! xaRdbg((\"\<Esc>ma[[?)\<CR>%BdwP`apa\"));\<Esc>F\"h"

 elseif wrd =~ 'os\%[pf3_log_err]'
  exe "norm! bdWaospf3_log_err((\"DFG %s\", __FUNCTION__));\<Esc>Bbb"

 elseif wrd =~ '/\*\*'
  exe "norm!  a\<CR>@brief DFG\<CR>\<CR>DFG\<CR>\<CR>@param DFG\<CR>@return DFG\<CR>/\<Esc>7k/DFG\<CR>D"

 else
  exe "norm! a`\<Esc>"
 endif
endfunction

" ---------------------------------------------------------------------
