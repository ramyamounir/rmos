" plugin name
" Plug 'kien/ctrlp.vim'

let g:crtlp_user_command=['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_use_caching = 0
