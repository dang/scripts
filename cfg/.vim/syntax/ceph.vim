" Vim syntax file
" Language:               Configuration File (ini file) for Ceph configuration
" Version:                1.0
" Original Author:        Daniel Gryniewicz <dang@cohortfs.com>
" Current Maintainer:     Daniel Gryniewicz <dang@cohortfs.com>
" Homepage:               http://github.com/dang/
" Last Change:            2014 Nov 17


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" shut case off
syn case ignore

syn match  cephNumber   "\<\d\+\>"
syn match  cephNumber   "\<\d*\.\d\+\>"
syn match  cephNumber   "\<\d\+e[+-]\=\d\+\>"
syn match  cephLabel    "^.\{-}="
syn region cephHeader   start="^\s*\[" end="\]"
syn match  cephComment  "\s*[#;].*$"
syn match  cephID       "\$\w\+\>"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ceph_syntax_inits")
  if version < 508
    let did_ceph_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cephNumber   Number
  HiLink cephHeader   Special
  HiLink cephLabel    Type
  HiLink cephID       Identifier
  HiLink cephComment  Comment

  delcommand HiLink
endif

let b:current_syntax = "ceph"

" vim: sts=2 sw=2 et
