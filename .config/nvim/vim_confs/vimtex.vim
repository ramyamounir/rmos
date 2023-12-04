" plugin name
" Plug 'lervag/vimtex'

let g:vimtex_view_method = 'zathura'
let g:syntastic_tex_lacheck_quiet_messages = { 'regex': '\Vpossible unwanted space at' }
" let g:vimtex_quickfix_enabled = 0
let g:vimtex_quickfix_mode = 0


augroup WrapLineInTeXFile
    autocmd!
    autocmd FileType tex setlocal wrap linebreak nolist

    autocmd FileType tex noremap  <buffer> <silent> j gj
    autocmd FileType tex noremap  <buffer> <silent> k gk
    autocmd FileType tex noremap  <buffer> <silent> 0 g0
    autocmd FileType tex noremap  <buffer> <silent> $ g$

    autocmd FileType tex noremap  <buffer> <silent> <Up>   gk
    autocmd FileType tex noremap  <buffer> <silent> <Down> gj
    autocmd FileType tex noremap  <buffer> <silent> <Home> g<Home>
    autocmd FileType tex noremap  <buffer> <silent> <End>  g<End>
    autocmd FileType tex inoremap <buffer> <silent> <Up>   <C-o>gk
    autocmd FileType tex inoremap <buffer> <silent> <Down> <C-o>gj
    autocmd FileType tex inoremap <buffer> <silent> <Home> <C-o>g<Home>
    autocmd FileType tex inoremap <buffer> <silent> <End>  <C-o>g<End>   
augroup END



