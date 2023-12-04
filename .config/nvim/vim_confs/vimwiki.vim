" Plug names
" Plug 'vimwiki/vimwiki' 
" Plug 'michal-h21/vimwiki-sync'

set autoread
set nocompatible
filetype plugin on

" vimwiki
let g:vimwiki_list = [{'path':'$HOME/notes'}]
" let g:vimwiki_listsyms = '✗◐✓'
let g:vimwiki_listsyms = ' ◐✓'


" remaps
nnoremap <leader>wf :VimwikiTable 
