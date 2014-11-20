"
" My modifications to C syntax

" C uses doxygen
UltiSnipsAddFiletypes c.doxygen

if filereadable('.project.vim')
	source .project.vim
else
	" My default C settings
	set cinoptions={1s,t0
	set tw=100
	set shiftwidth=4
	set tabstop=4
endif

