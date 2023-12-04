" plugin name
" Plug 'machakann/vim-highlightedyank'


" for older vim versions
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif


" highlight duration
let g:highlightedyank_highlight_duration = 1000

