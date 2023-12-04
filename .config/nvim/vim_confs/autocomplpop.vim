" Plugin name
" Plug 'vim-scripts/AutoComplPop'

set complete+=kspell
set completeopt=menuone,longest
set shortmess+=c

" Remaps
inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
inoremap <expr> <up> pumvisible() ? "<C-p>" :"<Up>"
inoremap <expr> <Tab> pumvisible() ? "<C-y>" :"<Tab>"
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"
inoremap <expr> <Left> pumvisible() ? "<C-e>" :"<Left>"
