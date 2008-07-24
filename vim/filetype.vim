" Configure files
au BufNewFile,BufRead *.cfg.unf			setf cfg

au BufNewFile,BufRead *.y.unf			setf yacc

augroup filetypedetect
  au! BufRead,BufNewFile *.spt setfiletype snippet
augroup END
