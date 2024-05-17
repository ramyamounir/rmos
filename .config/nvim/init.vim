syntax on

set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set scrolloff=8
set signcolumn=yes
set splitbelow splitright
set fillchars+=vert:\
set laststatus=2
set noshowmode
set ttimeoutlen=0
set clipboard=unnamedplus

highlight ColorColumn ctermbg=0 guibg=lightgrey

call plug#begin('~/.config/nvim/plugged')

" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' 
" Plug 'puremourning/vimspector'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'morhetz/gruvbox'
Plug 'kien/ctrlp.vim'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'michaeljsmith/vim-indent-object'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'vimwiki/vimwiki' 
Plug 'michal-h21/vimwiki-sync'
Plug 'tpope/vim-fugitive'
Plug 'lervag/vimtex'
Plug 'github/copilot.vim'
Plug 'mreppen/vim-scholar'
Plug 'fisadev/vim-isort'
Plug 'psf/black', { 'branch': 'main' }


call plug#end()

colorscheme gruvbox
set background=dark
let mapleader = " "

" General remaps
nnoremap Y y$
nnoremap zz :wa<cr>
nnoremap ZZ :wqa<cr>
tnoremap <ESC> <C-\><C-n>

" Cursor block and bar
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"


" source plugin configs
source ~/.config/nvim/vim_confs/coc.vim
" source ~/.config/nvim/vim_confs/snippets.vim
" source ~/.config/nvim/vim_confs/vimspector.vim
source ~/.config/nvim/vim_confs/sandwich.vim
source ~/.config/nvim/vim_confs/highlightedyank.vim
source ~/.config/nvim/vim_confs/lightline.vim
source ~/.config/nvim/vim_confs/sessions.vim
source ~/.config/nvim/vim_confs/ctrlp.vim
source ~/.config/nvim/vim_confs/nerdtree.vim
source ~/.config/nvim/vim_confs/vimwiki.vim
source ~/.config/nvim/vim_confs/fugitive.vim
source ~/.config/nvim/vim_confs/vimtex.vim

" Splits and tabs
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <C-Left> :vertical resize +3<CR>
nnoremap <silent> <C-Right> :vertical resize -3<CR>
nnoremap <silent> <C-Up> :resize +3<CR>
nnoremap <silent> <C-Down> :resize -3<CR>
map <Leader>h gT
map <Leader>l gt
map <Leader>j :q<CR>
map <Leader>k :tabnew<CR>
map <Leader>n <C-w>N<CR>
map <Leader>tt :term<CR>

" Enable isort and black on save
" autocmd BufWritePre *.py execute ':Isort!' | execute ':Black'
" autocmd BufWritePost *.py :!isort %
" autocmd BufWritePre *.py :!isort %
" autocmd BufWritePre *.py :!isort %
autocmd BufWritePre *.py execute  ':Isort' | execute ':Black'

" autocmd BufWritePre *.py execute ':!isort %' | execute ':Black'

