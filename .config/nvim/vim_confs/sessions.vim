" plugin name
" Plug 'xolox/vim-session'



"Sessions remaps
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1
nnoremap <Leader>so :OpenSession 
nnoremap <Leader>ss :SaveSession 
nnoremap <Leader>sd :DeleteSession<CR>
nnoremap <Leader>sc :CloseSession<CR>
