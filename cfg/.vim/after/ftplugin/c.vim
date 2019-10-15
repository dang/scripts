"
" My modifications to C syntax

" C uses doxygen
"UltiSnipsAddFiletypes c.doxygen

let wsconf=$GTWS_WSPATH."/.project.vim"

if filereadable('.project.vim')
	source .project.vim
elseif filereadable(wsconf)
	exec 'source ' . wsconf
else
	" My default C settings
	set cinoptions={1s,t0
	set tw=100
	set shiftwidth=4
	set tabstop=4
endif

