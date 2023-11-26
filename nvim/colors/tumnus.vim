
set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif

let g:colors_name="tumnus"

hi Normal			ctermfg=247		guifg=#9e9e9e		ctermbg=235		guibg=#262626

hi Comment			ctermfg=60		guifg=#5f5f87
hi String			ctermfg=101		guifg=#87875f
hi Statement		ctermfg=109		guifg=#87afaf
hi Function			ctermfg=67		guifg=#5f87af		cterm=bold	

hi Constant			ctermfg=203		guifg=#ff5f5f
hi Include			ctermfg=109		guifg=#87afaf
hi PreProc			ctermfg=95		guifg=#875f5f

hi Character		ctermfg=210		guifg=#ff8787
hi Number			ctermfg=96		guifg=#875f87
hi Type				ctermfg=109		guifg=#87afaf

hi LineNr			ctermfg=236		guifg=#303030

" \n, \t, %d, %s, etc...
hi Special			ctermfg=95		guifg=#875f5f
hi StorageClass	ctermfg=217		guifg=#ffafaf
hi Exception		ctermfg=167		guifg=#d75f5f

