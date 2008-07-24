"
" My modifications to C syntax

if filereadable('.project.vim')
	source .project.vim
else
	" My default C settings
	set cinoptions={1s,t0
	set tw=100
	set shiftwidth=4
	set tabstop=4
endif

